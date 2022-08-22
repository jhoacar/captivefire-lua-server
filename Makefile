# Project: Captivefire - Lua
# Makefile created by Jhoan Carrero

##########################################################
### CONFIGURATION 
VERSION		:= 0.0.1
PACKAGE 	:= package/captivefire-$(VERSION).ipk
PKG_FOLDER	:= ipk
PKG_CONTROL	:= $(PKG_FOLDER)/control
PKG_DATA 	:= $(PKG_FOLDER)/data

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
	mkdir -p $(PKG_DATA)/app/public
	mkdir -p $(PKG_DATA)/etc/crontabs
	mkdir -p $(PKG_DATA)/root/.ssh
	mkdir -p $(PKG_DATA)/usr/bin
endef

define CopyPkgInfo
	
	cp docker/etc/config/uhttpd $(PKG_DATA)/app
	cp docker/etc/banner $(PKG_DATA)/app
	
	cp $(PKG_CONTROL)/postinst $(PKG_DATA)/app/rc.local

	cp docker/etc/crontabs/* $(PKG_DATA)/etc/crontabs
	
	cp docker/root/ssh/*.pub $(PKG_DATA)/root/.ssh
	
	cp docker/usr/bin/* $(PKG_DATA)/usr/bin

	cp -r lua_modules $(PKG_DATA)/app
	cp -r src $(PKG_DATA)/app
	cp public/index.lua $(PKG_DATA)/app/public
endef

define BuildPackage
	cd $(PKG_CONTROL) && tar --numeric-owner --group=0 --owner=0 -czf ../control.tar.gz ./*
	
	cd $(PKG_DATA) && tar --numeric-owner --group=0 --owner=0 -czf ../data.tar.gz ./*
	
	cd $(PKG_FOLDER) && echo 2.0 > debian-binary
	
	cd $(PKG_FOLDER) && tar --numeric-owner --group=0 --owner=0 -czf ../$(PACKAGE) ./debian-binary ./control.tar.gz ./data.tar.gz
endef

define ClearPkg
	rm -rf $(PACKAGE)
endef

define ClearPkgFiles
	rm -rf  $(PKG_DATA) $(PKG_FOLDER)/control.tar.gz $(PKG_FOLDER)/data.tar.gz $(PKG_FOLDER)/debian-binary
endef
