
logger = require "lapis.logging"
lapis_config = require "lapis.config"

import Router from require "lapis.router"

import insert from table

json = require "cjson"

unpack = unpack or table.unpack

local capture_errors, capture_errors_json, respond_to

MISSING_ROUTE_NAME_ERORR = "Attempted to load action `true` for route with no name, a name must be provided to require the action"

run_before_filter = (filter, r) ->
  _write = r.write
  written = false
  r.write = (...) ->
    written = true
    _write ...

  filter r
  r.write = nil
  written

load_action = (prefix, action, route_name) ->
  if action == true
    assert route_name, MISSING_ROUTE_NAME_ERORR

    require "#{prefix}.#{route_name}"
  elseif type(action) == "string"
    require "#{prefix}.#{action}"
  else
    action

class Application
  Request: require "lapis.request"
  layout: require "lapis.views.layout"
  error_page: require "lapis.views.error"

  views_prefix: "views"
  actions_prefix: "actions"
  flows_prefix: "flows"

  -- find action for named route in this application
  @find_action: (name, resolve=true) =>
    @_named_route_cache or= {}
    route = @_named_route_cache[name]

    -- update the cache
    unless route
      for app_route in pairs @__base
        if type(app_route) == "table"
          app_route_name = next app_route
          @_named_route_cache[app_route_name] = app_route
          route = app_route if app_route_name == name

    action = route and @[route]

    if resolve
      action = load_action @actions_prefix, action, name

    action, route

  new: =>
    @build_router!

  enable: (feature) =>
    fn = require "lapis.features.#{feature}"
    if type(fn) == "function"
      fn @

  match: (route_name, path, handler) =>
    if handler == nil
      handler = path
      path = route_name
      route_name = nil

    @ordered_routes or= {}
    key = if route_name
      tuple = @ordered_routes[route_name]
      if old_path = tuple and tuple[next(tuple)]
        if old_path != path
          error "named route mismatch (#{old_path} != #{path})"

      if tuple
        tuple
      else
        tuple = {[route_name]: path}
        @ordered_routes[route_name] = tuple
        tuple
    else
      path

    unless @[key]
      insert @ordered_routes, key

    @[key] = handler

    @router = nil
    handler

  for meth in *{"get", "post", "delete", "put"}
    upper_meth = meth\upper!
    @__base[meth] = (route_name, path, handler) =>
      if handler == nil
        handler = path
        path = route_name
        route_name = nil

      @responders or= {}
      existing = @responders[route_name or path]

      if type(handler) != "function"
        -- NOTE: this works slightly differently, as it loads the action
        -- immediately instead of lazily, how it happens in wrap_handler. This
        -- is okay for now as we'll likely be overhauling this interface
        handler = load_action @actions_prefix, handler, route_name

      tbl = { [upper_meth]: handler }

      if existing
        setmetatable tbl, __index: (key) =>
          existing if key\match "%u"

      responder = respond_to tbl
      @responders[route_name or path] = responder
      @match route_name, path, responder

  build_router: =>
    @router = Router!
    @router.default_route = => false

    add_route = (path, handler) ->
      t = type path
      if t == "table" or t == "string" and path\match "^/"
        @router\add_route path, @wrap_handler handler

    add_routes = (cls) ->
      for path, handler in pairs cls.__base
        add_route path, handler

      if ordered = @ordered_routes
        for path in *ordered
          add_route path, @[path]
      else
        for path, handler in pairs @
          add_route path, handler

      if parent = cls.__parent
        add_routes parent

    add_routes @@

  -- this performs the initialization of an action (called handler in this
  -- file)
  -- the wrapped action is stored in the router so it can be returned directly
  -- when the router is matched
  wrap_handler: (handler) =>
    (params, path, name, r) ->
      support = r.__class.support

      with r
        .route_name = name

        support.add_params r, r.req.params_get, "GET"
        support.add_params r, r.req.params_post, "POST"
        support.add_params r, params, "url_params"

        if @before_filters
          for filter in *@before_filters
            return r if run_before_filter filter, r

        if type(handler) != "function"
          handler = load_action @actions_prefix, handler, name

        \write handler r

  render_request: (r) =>
    r.__class.support.render r
    logger.request r

  render_error_request: (r, err, trace) =>
    config = lapis_config.get!
    r\write @.handle_error r, err, trace

    if config._name == "test"
      r.options.headers or= {}

      param_dump = logger.flatten_params r.original_request.url_params

      error_payload = {
        summary: "[#{r.original_request.req.method}] #{r.original_request.req.request_uri} #{param_dump}"
        :err, :trace
      }

      import to_json from require "lapis.util"
      r.options.headers["X-Lapis-Error"] = to_json error_payload

    r.__class.support.render r
    logger.request r


  dispatch: (req, res) =>
    local err, trace, r

    capture_error = (_err) ->
      err = _err
      trace = debug.traceback "", 2

    raw_request = ->
      r = @.Request @, req, res

      unless @router\resolve req.parsed_url.path, r
        -- run default route if nothing matched
        handler = @wrap_handler @default_route
        handler {}, nil, "default_route", r

      @render_request r

    success = xpcall raw_request, capture_error

    unless success
      -- create a new request to handle the rendering the error
      error_request = @.Request @, req, res
      error_request.original_request = r
      @render_error_request error_request, err, trace

    success, r

  @before_filter: (...) =>
    @__base.before_filter @__base, ...

  before_filter: (fn) =>
    unless rawget @, "before_filters"
      @before_filters = {}

    insert @before_filters, fn

  -- copies all actions into this application, preserves before filters
  -- other app can just be a plain table, doesn't have to be another application
  -- @include other_app, path: "/hello", name: "hello_"
  @include: (other_app, opts, into=@__base) =>
    if type(other_app) == "string"
      other_app = require other_app

    path_prefix = opts and opts.path or other_app.path
    name_prefix = opts and opts.name or other_app.name

    for path, action in pairs other_app.__base
      t = type path
      -- named action
      if t == "table"
        if path_prefix
          name = next path
          path[name] = path_prefix .. path[name]

        if name_prefix
          name = next path
          path[name_prefix .. name] = path[name]
          path[name] = nil
      -- route only action
      elseif t == "string" and path\match "^/"
        if path_prefix
          path = path_prefix .. path
      -- other field in class, ignore
      else
        continue

      if name_prefix
        -- normalize and adjust lazy loaded actions
        if type(action) == "string"
          action = name_prefix .. action
        elseif action == true
          assert type(path) == "table", "include: #{MISSING_ROUTE_NAME_ERORR}"
          action = next(path) -- the route name is the only key in the table

      if before_filters = other_app.before_filters
        fn = action
        action = (r) ->
          for filter in *before_filters
            return if run_before_filter filter, r

          load_action(r.app.actions_prefix, fn, r.route_name) r

      into[path] = action

  -- Callbacks
  -- run with Request as self, instead of application

  default_route: =>
    -- strip trailing /
    if @req.parsed_url.path\match "./$"
      stripped = @req.parsed_url.path\match "^(.+)/+$"
      -- TODO: if the path starts with // here then build URL will treat it as
      -- an absolute URL and redirect off domain
      redirect_to: @build_url(stripped, query: @req.parsed_url.query), status: 301
    else
      @app.handle_404 @

  handle_404: =>
    error "Failed to find route: #{@req.cmd_url}"

  handle_error: (err, trace) =>
    @status = 500
    @err = err
    @trace = trace

    {
      status: 500
      layout: false
      render: @app.error_page
    }

  cookie_attributes: (name, value) =>
    "Path=/; HttpOnly"

respond_to = do
  default_head = -> layout: false -- render nothing
  on_invalid_method = => error "don't know how to respond to #{@req.method}"

  (tbl) ->
    tbl.HEAD = default_head if tbl.HEAD == nil

    out = =>
      fn = tbl[@req.method]
      if fn
        if before = tbl.before
          return if run_before_filter before, @
        fn @
      else
        (tbl.on_invalid_method or on_invalid_method) @

    if error_response = tbl.on_error
      out = capture_errors out, error_response

    out

default_error_response = -> { render: true }
capture_errors = (fn, error_response=default_error_response) ->
  if type(fn) == "table"
    error_response = fn.on_error or error_response
    fn = fn[1]

  (...) =>
    co = coroutine.create fn
    out = { coroutine.resume co, @ }
    while true
      unless out[1] -- error
        error debug.traceback co, out[2]

      -- { status, "error", error_msgs }
      if coroutine.status(co) == "suspended"
        if out[2] == "error"
          @errors = out[3]
          return error_response @
        else -- proxy to someone else
          out = { coroutine.resume co, coroutine.yield unpack out, 2 }
      else
        return unpack out, 2

capture_errors_json = (fn) ->
  capture_errors fn, => {
    json: { errors: @errors }
  }

yield_error = (msg) ->
  coroutine.yield "error", {msg}

assert_error = (thing, msg, ...) ->
  yield_error msg unless thing
  -- assert in case the enclosing function can't capture yeilded error, so we trigger hard failure
  assert thing, msg, ...

json_params = (fn) ->
  (...) =>
    if content_type = @req.headers["content-type"]
      -- Header often ends with ;UTF-8
      if string.find content_type\lower!, "application/json", nil, true
        body = @req\read_body_as_string!
        success, obj_or_err = pcall -> json.decode body
        if success
          @@support.add_params @, obj_or_err, "json"

    fn @, ...

{
  Request: Application.Request

  :Application, :respond_to
  :capture_errors, :capture_errors_json
  :json_params, :assert_error, :yield_error
}

