local site_config = {}
site_config.LUAROCKS_PREFIX=[[/usr]]
site_config.LUA_INCDIR=[[/builder/shared-workdir/build/sdk/staging_dir/hostpkg/include]]
site_config.LUA_LIBDIR=[[/builder/shared-workdir/build/sdk/staging_dir/hostpkg/lib]]
site_config.LUA_BINDIR=[[/builder/shared-workdir/build/sdk/staging_dir/hostpkg/bin]]
site_config.LUAROCKS_SYSCONFDIR=[[/etc]]
site_config.LUAROCKS_ROCKS_TREE=[[/usr]]
site_config.LUAROCKS_ROCKS_SUBDIR=[[/lib/luarocks/rocks]]
site_config.LUA_DIR_SET=true
site_config.LUAROCKS_UNAME_S=[[Linux]]
site_config.LUAROCKS_UNAME_M=[[x86_64]]
site_config.LUAROCKS_DOWNLOADER=[[curl]]
site_config.LUAROCKS_MD5CHECKER=[[md5sum]]
site_config.LUAROCKS_EXTERNAL_DEPS_SUBDIRS={ bin="bin", lib={ "lib", [[lib/x86_64-linux-gnu]] }, include="include" }
site_config.LUAROCKS_RUNTIME_EXTERNAL_DEPS_SUBDIRS={ bin="bin", lib={ "lib", [[lib/x86_64-linux-gnu]] }, include="include" }
return site_config
