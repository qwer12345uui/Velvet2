# iOS 15+ Device Verification Checklist

> **Release gate:** This package must remain **unverified** until every applicable step below is completed on hardware. A successful GitHub build or static DEB audit does not prove SpringBoard runtime compatibility.

## RootHide iOS 15.0 test device

Install only `Velvet2-NotificaWidgets-roothide-ios15.deb` on a dedicated RootHide device. Do not install the standard rootless package on the same test environment.

| Step | Expected result | Record |
| --- | --- | --- |
| Capture device state | Record iOS version, bootstrap, injector, package manager and existing Velvet2 installation state. | Screenshot or terminal log. |
| Install package | Package manager resolves dependencies and completes without post-install errors. | Installation log. |
| Respring | SpringBoard returns without safe mode, crash loop or extended black screen. | Crash/restart log. |
| Open Preferences | Velvet2 loads; a Widgets section is visible; the feature switch defaults to off. | Screenshot. |
| Enable Widgets | Widget Style page opens; background, border, glow, line and corner settings are editable. | Screenshot. |
| Render widgets | Test small/medium/large WidgetKit widgets in Today View and Home Screen where applicable. | Before/after screenshots. |
| Functionality | Widget taps, links, scrolling and editing mode remain functional. | Test notes. |
| Disable Widgets | Existing system widget appearance returns without respring loop. | Screenshot and log. |
| Uninstall | Remove the package, respring, confirm no orphaned preference bundle/tweak injection and no safe mode. | Uninstall log. |

## Independent standard rootless iOS 15+ environment

Install only `Velvet2-NotificaWidgets-rootless-ios15.deb` on a separate standard rootless environment. Repeat the same installation, settings, rendering, interaction, disable and uninstall checks.

Additional rootless checks:

1. Confirm that installed payload paths are under `/var/jb/Library/...` exactly once.
2. Confirm the preferences bundle resolves from `/var/jb/Library/PreferenceBundles/Velvet2.bundle`.
3. Confirm the standard rootless build does not request or rely on RootHide randomized bootstrap paths.

## Failure handling

If SpringBoard enters safe mode, capture the crash log before uninstalling. If an expected widget class is absent, the module should remain inactive and the system UI should render normally; record the class and iOS build number for a targeted compatibility update. Do not mark a package **publishable** after a failed, incomplete or unavailable hardware test.
