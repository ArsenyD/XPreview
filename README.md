# XPreview

Beautiful Quick Look previews for Xcode-adjacent files.

XPreview is a small macOS app that adds Quick Look previews for files developers constantly inspect but macOS usually renders poorly: Swift playgrounds, property lists, and entitlement files (and more to come!).

Select a supported file in Finder, press `Space`, and get a readable preview instead of a raw blob.

## Supported Files

| File | Preview |
| --- | --- |
| `.playground` | Browse playground pages, sources, resources, images, and metadata. |
| `.plist` | Inspect keys, types, and values in an expandable outline. |
| `.entitlements` | Read entitlement files as structured property lists. |

## Highlights

- Finder-native Quick Look extension.
- Playground navigation with page/source/resource sections.
- Swift source highlighting powered by `swift-syntax`.
- Structured plist and entitlement browsing.

## Install

1. Download the most recent version of `XPreview` from the releases page.
2. Launch the app.
3. Open `System Settings > General > Login Items & Extensions`.
4. Make sure `XPreview Quick Look Extension` is turned on.
5. Select a supported file in Finder and press `Space`.
