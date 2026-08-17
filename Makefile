TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Velvet2

Velvet2_FILES = src/Tweak.x src/UIColor+Velvet.m src/Velvet2PrefsManager.m src/ColorDetection.m src/Velvet2Colorizer.m src/Velvet2WidgetStyler.m
Velvet2_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

# Standard rootless has a fixed /var/jb bootstrap. Do not inherit the
# RootHide-only @loader_path/.jbroot rpaths from newer shared Theos modules.
ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
_THEOS_INTERNAL_LDFLAGS := $(subst -rpath '@loader_path/.jbroot/Library/Frameworks',,$(_THEOS_INTERNAL_LDFLAGS))
_THEOS_INTERNAL_LDFLAGS := $(subst -rpath '@loader_path/.jbroot/usr/lib',,$(_THEOS_INTERNAL_LDFLAGS))
endif

SUBPROJECTS += preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
