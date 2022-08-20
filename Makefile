# Project: Captivefire - Lua
# Makefile created by Jhoan Carrero

##########################################################
### CONFIGURATION 
APP 		:= build/captivefire.luac
SRC 		:= src
COMPILER 	:= luac
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
### SHOW INFO
.PHONY: info
info:
	$(info $(MAIN_FILES) $(MAIN_ROUTE_FILE) $(ALL_LUA_FILES))
########################################################