TARGET = iphone:clang:latest:16.0
ARCHS = arm64 arm64e
THEOS_PACKAGE_SCHEME ?= rootless
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NoChevron
NoChevron_FILES = Tweak.x
NoChevron_CFLAGS = -fobjc-arc
NoChevron_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
