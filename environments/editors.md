---
title: "Remote IDEs"
---

> Non-VS Code support is currently in beta.

Coder Enterprise offers full support for a wide range of editors, including
VSCode and the JetBrains suite. These editors are run in the remote environment
and rendered directly in the browser. The support for multi editors is bundled
with a window management system to give the application the look and feel of a
native app.

## Enable JetBrains Support

Click your avatar to open a menu. Select **Feature Preview** to open the feature
preview modal where you can enable JetBrains support.

![Enable JetBrains Support](../assets/enable-jetbrains-support.png)

Coder Enterprise launches remote IDEs in their own windows; be sure to set your
browser to allow pop-up windows so that you can use your IDE.

> If you need a valid license to run your IDE locally, you'll also need one to
> run it in Coder.

## Optimizing Displays: Zoom vs. Font Sizing

Remote IDEs display as they would locally with pixel-for-pixel rendering.

Since remote IDEs run within a browser window, you can use the browser's default
controls for zooming in/out. For example, if you're using Chrome on a
Windows-based machine, you can zoom in by pressing **Ctrl** and **+**, zoom out
by pressing **Ctrl** and **-**, and reset the screen to normal by pressing
**Ctrl** and **0**.

If you're using a high-resolution DPI display, changing the display and font
preferences within the IDE instead of the browser may improve your experience
and reduce blurriness.

## Known Issues

- Window dragging behavior can misalign with mouse movements
- Popover dialogs do not always appear in the correct location
- Popup windows are missing titles and window controls
- Some theme-based plugins can cause the IDE to render incorrectly
- Some minor rendering artifacts occur during regular usage

> If you're working with an IDE currently unsupported by Coder, consider setting
> up either
> [one-way](https://help.coder.com/hc/en-us/articles/360055767234-One-way-File-Sync)
> or [two-way](https://help.coder.com/hc/en-us/articles/360058001313) sync to
> leverage Coder's compute abilities.
>
> Coder also supports the use of any CLI editors with both the > environment
> terminal and the Coder CLI.

