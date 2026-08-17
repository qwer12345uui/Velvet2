# Third-Party Notices

## Notifica

This migration adds a constrained widget-surface styling feature inspired by the widget customization capabilities of **Notifica** (NepetaDev/Notifica, MIT License, 2019).

The original Notifica implementation targets iOS 11/12 and uses `WGWidgetPlatterView`, legacy MaterialKit classes, Nepeta color utilities, and broad hooks in widget extension processes. Those implementation details were **not** copied into this project because they are not a safe compatibility target for iOS 15+ WidgetKit hosts.

Velvet2’s implementation is a new, iOS 15+ constrained adaptation that reuses Velvet2’s own preference and colorizer infrastructure. It only enables explicit runtime-scoped host hooks, does not hook generic UIKit classes, and is disabled by default.

- Source: https://github.com/qwer12345uui/Notifica
- License: MIT

## Velvet2

This project remains subject to its existing MIT License and copyright notice.
