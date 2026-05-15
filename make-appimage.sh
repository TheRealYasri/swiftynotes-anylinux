#!/bin/sh
set -eu

# Setup
export VERSION=$(grep 'version:' source/snap/snapcraft.yaml | head -n 1 | cut -d'"' -f2 | tr -d ' ')
echo "X-AppImage-Version=$VERSION" > ./appinfo

export ADD_HOOKS="self-updater.hook"
export ICON=/usr/share/icons/hicolor/scalable/apps/me.spaceinbox.swiftynotes.svg
export DESKTOP=/usr/share/applications/me.spaceinbox.swiftynotes.desktop

# List files directly from the system for bundling
quick-sharun \
    /usr/bin/swiftynotes \
    /usr/libexec/swifty-notes/swiftynotes \
    /usr/libexec/swifty-notes/swifty-notes-gtk_SwiftyNotes.resources \
    /usr/share/hunspell/ \
    /usr/lib/libspelling-1.so \
    /usr/lib/libgtk-4.so \
    /usr/lib/libadwaita-1.so \
    /usr/lib/libgtksourceview-5.so \
    /usr/lib/libenchant-2.so \
    /usr/lib/libhunspell-1.7.so \
    /usr/lib/libxml2.so.2 \
    /usr/lib/libncursesw.so.6

# Turn AppDir into AppImage and output to the current directory
quick-sharun --make-appimage --version "$VERSION" --output "."

# Test the app for 12 seconds
quick-sharun --test ./*.AppImage
