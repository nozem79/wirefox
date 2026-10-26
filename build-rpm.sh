#!/bin/bash
# build-rpm.sh — build the Wirefox RPM package (Fedora and other RPM distros)
#
# Needs rpmbuild and msgfmt:
#   Fedora:        sudo dnf install rpm-build gettext
#   Debian/Ubuntu: sudo apt install rpm gettext
#
# Wirefox is pure Python, so the package is noarch and can be built on any
# distro that has rpmbuild.
set -euo pipefail
cd "$(dirname "$0")"
SRC="$(pwd)"

for tool in rpmbuild msgfmt; do
  command -v "$tool" >/dev/null || {
    echo "$tool not found — Fedora: sudo dnf install rpm-build gettext," \
         "Debian/Ubuntu: sudo apt install rpm gettext" >&2
    exit 1
  }
done

VERSION=$(grep -m1 '^VERSION' wirefox | cut -d'"' -f2)
TOP="$SRC/dist/rpmbuild"

# every po/<lang>.po becomes a %lang()-tagged .mo in the package
MO_INSTALL=""
MO_FILES=""
for po in po/*.po; do
  lang=$(basename "$po" .po)
  dir="%{buildroot}%{_datadir}/locale/$lang/LC_MESSAGES"
  MO_INSTALL+="mkdir -p $dir"$'\n'"msgfmt --check -o $dir/wirefox.mo $SRC/$po"$'\n'
  MO_FILES+="%lang($lang) %{_datadir}/locale/$lang/LC_MESSAGES/wirefox.mo"$'\n'
done

# only clean our own output, so build-deb.sh results survive
rm -rf "$TOP" "$SRC"/dist/wirefox-*.rpm
mkdir -p "$TOP"/{BUILD,RPMS,SOURCES,SPECS,BUILDROOT}

SPEC="$TOP/SPECS/wirefox.spec"
cat > "$SPEC" << SPEC_EOF
Name:           wirefox
Version:        ${VERSION}
Release:        1%{?dist}
Summary:        Simple WireGuard GUI for Linux

License:        GPL-3.0-or-later
URL:            https://github.com/nozem79/wirefox
BuildArch:      noarch

Requires:       python3
Requires:       python3-gobject
Requires:       gtk4 >= 4.10
Requires:       libadwaita >= 1.5
Requires:       NetworkManager
Requires:       iproute
Recommends:     wireguard-tools

%description
Wirefox is a lightweight GTK4/libadwaita desktop client for managing
WireGuard tunnels through NetworkManager. Because all privileged
operations go through NetworkManager and polkit, no root rights are
required to activate, deactivate or edit tunnels.

Features: one-click tunnel control, built-in config editor,
bulk .zip import, live traffic, DNS-leak warning, Dutch translation.

%install
rm -rf %{buildroot}
install -D -m 0755 ${SRC}/wirefox %{buildroot}%{_bindir}/wirefox
# Fedora policy: no /usr/bin/env in shebangs of packaged scripts
sed -i '1s|^#!/usr/bin/env python3|#!/usr/bin/python3|' %{buildroot}%{_bindir}/wirefox
install -D -m 0644 ${SRC}/data/nl.voxfox.Wirefox.desktop %{buildroot}%{_datadir}/applications/nl.voxfox.Wirefox.desktop
install -D -m 0644 ${SRC}/data/nl.voxfox.Wirefox.svg %{buildroot}%{_datadir}/icons/hicolor/scalable/apps/nl.voxfox.Wirefox.svg
for s in 64 128 256 512; do
  install -D -m 0644 ${SRC}/data/png/wirefox-icon-\${s}.png \\
    %{buildroot}%{_datadir}/icons/hicolor/\${s}x\${s}/apps/nl.voxfox.Wirefox.png
done
${MO_INSTALL}
install -D -m 0644 ${SRC}/LICENSE %{buildroot}%{_datadir}/licenses/wirefox/LICENSE

%files
%license %{_datadir}/licenses/wirefox/LICENSE
%{_bindir}/wirefox
%{_datadir}/applications/nl.voxfox.Wirefox.desktop
%{_datadir}/icons/hicolor/scalable/apps/nl.voxfox.Wirefox.svg
%{_datadir}/icons/hicolor/*/apps/nl.voxfox.Wirefox.png
${MO_FILES}

%post
/bin/touch --no-create %{_datadir}/icons/hicolor &>/dev/null || :

%postun
if [ \$1 -eq 0 ] ; then
  /bin/touch --no-create %{_datadir}/icons/hicolor &>/dev/null || :
  /usr/bin/gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
fi

%posttrans
/usr/bin/gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :

%changelog
* $(LC_ALL=C date '+%a %b %d %Y') Daniël Vos <info@voxfox.nl> - ${VERSION}-1
- See CHANGELOG.md in the source repository
SPEC_EOF

rpmbuild --quiet --define "_topdir $TOP" -bb "$SPEC"

OUT=$(find "$TOP/RPMS" -name 'wirefox-*.rpm' | head -1)
cp "$OUT" "$SRC/dist/"
rm -rf "$TOP"
echo
echo "Built: dist/$(basename "$OUT")"
rpm -qpi "$SRC/dist/$(basename "$OUT")" | sed -n '1,8p'
