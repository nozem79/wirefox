#!/bin/bash
# build-deb.sh — build the Wirefox Debian package
set -euo pipefail
cd "$(dirname "$0")"

VERSION=$(grep -m1 '^VERSION' wirefox | cut -d'"' -f2)
PKG="wirefox_${VERSION}-1_all"
ROOT="dist/${PKG}"

rm -rf "dist"
mkdir -p "$ROOT/DEBIAN" \
         "$ROOT/usr/bin" \
         "$ROOT/usr/share/applications" \
         "$ROOT/usr/share/icons/hicolor/scalable/apps" \
         "$ROOT/usr/share/doc/wirefox" \
         "$ROOT/usr/share/locale/nl/LC_MESSAGES"

# --- payload -------------------------------------------------------------
install -m 0755 wirefox                        "$ROOT/usr/bin/wirefox"
install -m 0644 data/nl.voxfox.Wirefox.desktop "$ROOT/usr/share/applications/"
install -m 0644 data/nl.voxfox.Wirefox.svg     "$ROOT/usr/share/icons/hicolor/scalable/apps/"
for s in 64 128 256 512; do
  mkdir -p "$ROOT/usr/share/icons/hicolor/${s}x${s}/apps"
  install -m 0644 "data/png/wirefox-icon-${s}.png" \
    "$ROOT/usr/share/icons/hicolor/${s}x${s}/apps/nl.voxfox.Wirefox.png"
done

# --- translations --------------------------------------------------------
# compile .po to .mo (requires gettext), fall back to pre-compiled .mo
if command -v msgfmt &>/dev/null; then
  msgfmt po/nl.po -o "$ROOT/usr/share/locale/nl/LC_MESSAGES/wirefox.mo"
elif [ -f po/nl/LC_MESSAGES/wirefox.mo ]; then
  install -m 0644 po/nl/LC_MESSAGES/wirefox.mo \
    "$ROOT/usr/share/locale/nl/LC_MESSAGES/wirefox.mo"
else
  echo "Warning: msgfmt not found and no pre-compiled .mo — skipping translation"
fi

# --- docs ----------------------------------------------------------------
cat > "$ROOT/usr/share/doc/wirefox/copyright" << COPY
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: wirefox
Source: https://github.com/nozem79/wirefox

Files: *
Copyright: $(date +%Y) Daniël Vos
License: GPL-3.0-or-later
 On Debian systems, the complete text of the GNU General Public
 License version 3 can be found in "/usr/share/common-licenses/GPL-3".
COPY

sed 's/^## /wirefox /' CHANGELOG.md | gzip -9n \
  > "$ROOT/usr/share/doc/wirefox/changelog.gz"

# --- control -------------------------------------------------------------
SIZE=$(du -sk --exclude=DEBIAN "$ROOT" | cut -f1)
cat > "$ROOT/DEBIAN/control" << CTRL
Package: wirefox
Version: ${VERSION}-1
Section: net
Priority: optional
Architecture: all
Depends: python3, python3-gi, gir1.2-gtk-4.0, gir1.2-adw-1, network-manager
Recommends: wireguard-tools
Installed-Size: ${SIZE}
Maintainer: Daniël Vos <info@voxfox.nl>
Homepage: https://github.com/nozem79/wirefox
Description: simple WireGuard GUI for Ubuntu and Debian based systems
 Wirefox is a lightweight GTK4/libadwaita desktop client for managing
 WireGuard tunnels through NetworkManager. No root rights required.
 .
 Features: one-click tunnel control, built-in config editor,
 bulk .zip import, live traffic and handshake time, DNS-leak warning,
 Dutch translation.
CTRL

dpkg-deb --root-owner-group --build "$ROOT" "dist/${PKG}.deb"
echo
echo "Built: dist/${PKG}.deb"
dpkg-deb --info "dist/${PKG}.deb" | sed -n '1,14p'
