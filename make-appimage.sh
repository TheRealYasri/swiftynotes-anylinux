#!/bin/sh
set -eu

# Setup
export VERSION=$(grep 'version:' source/snap/snapcraft.yaml | head -n 1 | cut -d'"' -f2 | tr -d ' ')
echo "X-AppImage-Version=$VERSION" > ./appinfo
sudo cp /usr/libexec/swifty-notes/swiftynotes /usr/bin/swiftynotes
sudo cp -r /usr/libexec/swifty-notes/swifty-notes-gtk_SwiftyNotes.resources /usr/bin/
sudo mkdir -p /usr/share/hunspell/
export ADD_HOOKS="self-updater.hook"
export OUTPATH="$(pwd)/dist"
mkdir -p "$OUTPATH"
export ICON=/usr/share/icons/hicolor/scalable/apps/me.spaceinbox.swiftynotes.svg
export DESKTOP=/usr/share/applications/me.spaceinbox.swiftynotes.desktop

# Deploy dependencies
quick-sharun \
    --exec "swiftynotes" \
    /usr/bin/swiftynotes \
    /usr/bin/swifty-notes-gtk_SwiftyNotes.resources \
    /usr/lib/libspelling-1.so \
    /usr/lib/libgtk-4.so \
    /usr/lib/libadwaita-1.so \
    /usr/lib/libgtksourceview-5.so \
    /usr/lib/libenchant-2.so \
    /usr/lib/libhunspell-1.7.so \
    /usr/share/hunspell/ \
    /usr/lib/libxml2.so.2 \
    /usr/lib/libncursesw.so.6

# Turn AppDir into AppImage
quick-sharun --make-appimage --version "$VERSION" --output "$OUTPATH"

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test "$OUTPATH"/*.AppImage
