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
         "$ROOT/usr/share/doc/wirefox"

# --- payload -------------------------------------------------------------
install -m 0755 wirefox                       "$ROOT/usr/bin/wirefox"
install -m 0644 data/nl.voxfox.Wirefox.desktop "$ROOT/usr/share/applications/"
install -m 0644 data/nl.voxfox.Wirefox.svg     "$ROOT/usr/share/icons/hicolor/scalable/apps/"

# --- docs ----------------------------------------------------------------
cat > "$ROOT/usr/share/doc/wirefox/copyright" <<EOF
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: wirefox
Source: https://github.com/voxfox/wirefox

Files: *
Copyright: $(date +%Y) Daniël Vos
License: GPL-3.0-or-later
 On Debian systems, the complete text of the GNU General Public
 License version 3 can be found in "/usr/share/common-licenses/GPL-3".
EOF

sed 's/^## /wirefox /' CHANGELOG.md | gzip -9n \
  > "$ROOT/usr/share/doc/wirefox/changelog.gz"

# --- control -------------------------------------------------------------
SIZE=$(du -sk --exclude=DEBIAN "$ROOT" | cut -f1)
cat > "$ROOT/DEBIAN/control" <<EOF
Package: wirefox
Version: ${VERSION}-1
Section: net
Priority: optional
Architecture: all
Depends: python3, python3-gi, gir1.2-gtk-4.0, gir1.2-adw-1, network-manager
Installed-Size: ${SIZE}
Maintainer: Daniël Vos <info@voxfox.nl>
Homepage: https://github.com/voxfox/wirefox
Description: simple rootless WireGuard GUI (GTK4)
 Wirefox is a lightweight GTK4/libadwaita desktop client for managing
 WireGuard tunnels through NetworkManager. Because all privileged
 operations go through NetworkManager and polkit, no root rights are
 required to activate, deactivate or edit tunnels.
 .
 Features: one-switch tunnel control, built-in config editor, config
 import, live traffic statistics.
EOF

dpkg-deb --root-owner-group --build "$ROOT" "dist/${PKG}.deb"
echo
echo "Built: dist/${PKG}.deb"
dpkg-deb --info "dist/${PKG}.deb" | sed -n '1,12p'
