TARGET := iphone:clang:15.6:15.0
INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Velvet2

Velvet2_FILES = $(wildcard *.m CustomCells/*.m ../src/Velvet2PrefsManager.m ../src/UIColor+Velvet.m ../src/ColorDetection.m ../src/Velvet2Colorizer.m)
Velvet2_FRAMEWORKS = UIKit
Velvet2_PRIVATE_FRAMEWORKS = Preferences
Velvet2_INSTALL_PATH = /Library/PreferenceBundles
Velvet2_CFLAGS = -fobjc-arc -DPACKAGE_VERSION='@"$(THEOS_PACKAGE_BASE_VERSION)"'

include $(THEOS_MAKE_PATH)/bundle.mk

# Keep standard rootless rpaths fixed at /var/jb; RootHide owns randomized
# @loader_path/.jbroot dependencies in its separate build scheme.
ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
_THEOS_INTERNAL_LDFLAGS := $(subst -rpath '@loader_path/.jbroot/Library/Frameworks',,$(_THEOS_INTERNAL_LDFLAGS))
_THEOS_INTERNAL_LDFLAGS := $(subst -rpath '@loader_path/.jbroot/usr/lib',,$(_THEOS_INTERNAL_LDFLAGS))
endif
