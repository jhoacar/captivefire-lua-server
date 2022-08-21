# Project: Captivefire - Lua
# Makefile created by Jhoan Carrero

##########################################################
### CONFIGURATION 
VERSION		:= 0.0.2
APP 		:= bin/captivefire.luac
SRC 		:= src
COMPILER 	:= luac

PACKAGE 	:= package/captivefire-$(VERSION).ipk
PKG_FOLDER	:= ipk
PKG_CONTROL	:= $(PKG_FOLDER)/control
PKG_DATA 	:= $(PKG_FOLDER)/data

###########################################################

ifeq ($(OS),Windows_NT) #WINDOWS ...
##########################################################
### SHELL SCRIPT WINDOWS
SEARCH_FILES 	:= dir /s/b
SEARCH_DIRS  	:= dir $(SRC) /ad /b /s
MKDIR 		 	:= mkdir
##########################################################
else #LINUX ...
##########################################################
### SHELL SCRIPT LINUX
SEARCH_FILES 	:= find $(SRC)/ -type f -iname
SEARCH_DIRS  	:= find $(SRC)/ -type d
MKDIR 		 	:= mkdir -p
##########################################################
endif

#########################################################
### EXTRACTION OF PROJECT FILES IN PRIORITY ORDER
MAIN			:= fixer subapp app kernel
ALL_FOLDERS		:= util services controllers routes
MAIN_FILES 		:= $(foreach FILE,$(MAIN),$(shell $(SEARCH_FILES) $(FILE).lua))
MAIN_ROUTE_FILE := $(shell $(subst $(SRC),$(SRC)/routes,$(SEARCH_FILES)) init.lua)
ALL_LUA_FILES 	:= $(foreach DIRECTORY,$(ALL_FOLDERS),$(shell $(subst $(SRC),$(SRC)/$(DIRECTORY),$(SEARCH_FILES)) *.lua ! -name 'init.lua'))



########################################################
### BUILD PROCESS
.PHONY: build
build:
	$(COMPILER) -o $(APP) $(ALL_LUA_FILES) $(MAIN_ROUTE_FILE) $(MAIN_FILES)
########################################################

########################################################
### CREATING IPK PACKAGE
.PHONY: package
package:
	$(info Creating package $(PACKAGE))
	$(call PreparePkgFolders)
	$(call CopyPkgInfo)
	$(call ClearPkg)
	$(call BuildPackage)
	$(call ClearPkgFiles)

define PreparePkgFolders
	sed -i -E 's/Version: (.+)*/Version: $(VERSION)/' $(PKG_CONTROL)/control 
	chmod 666 $(PKG_CONTROL)/control
	mkdir -p $(PKG_DATA)/app/bin $(PKG_DATA)/app/public
	mkdir -p $(PKG_DATA)/etc/crontabs
	mkdir -p $(PKG_DATA)/root/.ssh
endef

define CopyPkgInfo
	cp docker/etc/config/uhttpd $(PKG_DATA)/app
	cp docker/etc/crontabs/root $(PKG_DATA)/etc/crontabs
	cp docker/root/ssh/id_rsa_captivefire.pub $(PKG_DATA)/root/.ssh

	cp -r lua_modules $(PKG_DATA)/app
	cp bin/captivefire.luac $(PKG_DATA)/app/bin
	cp public/index.lua $(PKG_DATA)/app/public
	cp restart.services.sh $(PKG_DATA)/app
endef

define BuildPackage
	cd $(PKG_CONTROL) && tar --numeric-owner --group=0 --owner=0 -czf ../control.tar.gz ./*
	
	cd $(PKG_DATA) && tar --numeric-owner --group=0 --owner=0 -czf ../data.tar.gz ./
	
	cd $(PKG_FOLDER) && echo 2.0 > debian-binary
	
	tar --numeric-owner --group=0 --owner=0 -czf $(PACKAGE) $(PKG_FOLDER)/debian-binary $(PKG_FOLDER)/control.tar.gz $(PKG_FOLDER)/data.tar.gz
endef

define ClearPkg
	rm -rf $(PACKAGE)
endef

define ClearPkgFiles
	rm -rf  $(PKG_DATA) $(PKG_FOLDER)/control.tar.gz $(PKG_FOLDER)/data.tar.gz $(PKG_FOLDER)/debian-binary
endef

########################################################
### SHOW INFO
.PHONY: info
info:
	$(info $(MAIN_FILES) $(MAIN_ROUTE_FILE) $(ALL_LUA_FILES))
########################################################