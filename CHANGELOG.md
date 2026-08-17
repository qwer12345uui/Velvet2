# Changelog

## Unreleased — Notifica widget-surface migration for iOS 15+

This change introduces an opt-in widget-surface styling module inspired by the widget customization goals of Notifica. The implementation is a new iOS 15+ adaptation; it does not copy Notifica’s iOS 11/12 widget view hooks or its global widget-extension hooks.

### Added

| Area | Change | User-visible effect |
| --- | --- | --- |
| Widget style | Added a **Widgets** section to Velvet2 preferences with a disabled-by-default `Enable Widgets` switch. | Existing installations retain their previous appearance until widgets are explicitly enabled. |
| Widget configuration | Added a dedicated Widget Style page that reuses Velvet2’s appearance, background, border, glow, line and corner-radius controls. | Widgets can use their own override profile without changing notification settings. |
| Runtime scope | Added scoped hooks for `WGWidgetPlatterView`, `WGWidgetHostingView`, `_WGWidgetHostingView`, and `WGWidgetContainerView`; each is initialized only if the class exists at runtime. | Unrecognized iOS versions or host classes fall back to the system UI instead of applying a broad hook. |
| Safety boundary | Added a non-interactive, idempotent overlay and no global `UIView`, `UILabel`, `UIButton`, or widget-extension hooks. | The migration avoids cross-surface styling side effects that could destabilize SpringBoard. |
| Licensing | Added `THIRD_PARTY_NOTICES.md` to credit the Notifica feature inspiration under MIT terms. | Source attribution remains auditable. |

### Changed

| Area | Change | Reason and impact |
| --- | --- | --- |
| iOS build target | Updated the preferences build SDK from iPhoneOS 14.5 to iPhoneOS 15.6 while retaining a deployment target of iOS 15.0. | The prior SDK was absent from the reproducible build environment; this change preserves the requested minimum iOS version. |
| Standard rootless packaging | Kept Theos `THEOS_PACKAGE_SCHEME=rootless` and corrected the preference bundle install path to a single `/var/jb/Library/PreferenceBundles` prefix. | Fixes the discovered invalid `/var/jb/var/jb` double prefix. |
| RootHide path API | Replaced the legacy `ROOT_PATH("/usr/bin/sbreload")` call with a scheme-aware wrapper that calls `jbroot()` when compiled for RootHide. | Avoids fixed bootstrap paths in a randomized RootHide environment while retaining standard rootless support. |
| Linker paths | Removed RootHide-only `@loader_path/.jbroot` rpaths from the standard rootless build; retained RootHide’s required `@loader_path/.jbroot` binary dependencies only in the RootHide package. | Keeps the two bootstrap schemes distinct. |

### Deliberately not migrated

The following Notifica behavior is excluded until it can be verified against an iOS 15+ class dump and hardware test matrix: forced icon/title-background hiding, ModernXI header displacement, global widget content recoloring, and widget-extension process hooks. These exclusions are intentional safeguards against content layout corruption, SpringBoard restart loops and safe-mode failures.

### Verification status

Both Theos production builds and static DEB audits pass. The package is **not release-verified**: installation, load, uninstall and SpringBoard stability tests have not yet been performed on a dedicated iOS 15.0 RootHide device and an independent standard rootless iOS 15+ environment. Do not mark this release as publishable until those tests pass.
