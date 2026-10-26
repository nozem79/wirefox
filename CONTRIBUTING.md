# Contributing to Wirefox

Thanks for your interest! Wirefox aims to stay a **single-file, zero-pip** application.

## Guidelines

- Keep dependencies limited to distro system packages (Debian/Ubuntu and Fedora).
- Run `python3 -m py_compile wirefox` before committing.
- Never poll NetworkManager from the periodic refresh — read `/sys/class/net`
  instead. `nmcli` belongs in user actions only.
- Callbacks passed to `GLib.idle_add` must return `False`, otherwise they
  run again and again.
- Never assign to `_` — it is the translation function.
- One feature per pull request, please.
- Bug reports: include your distro version and the output of `nmcli -v`.

## Adding a translation

1. Copy `po/wirefox.pot` to `po/<lang>.po` (e.g. `po/de.po` for German).
2. Fill in the `msgstr` fields.
3. Test with `msgfmt --check po/<lang>.po -o /dev/null`.
4. Submit a pull request — translations are always welcome!

The build scripts pick up every `po/*.po` file automatically.

After changing user-visible strings in the code, refresh the template:

```bash
xgettext --language=Python --keyword=_ --from-code=UTF-8 -o po/wirefox.pot wirefox
msgmerge --update --backup=none po/nl.po po/wirefox.pot
```

## Building locally

```bash
# Ubuntu / Debian
sudo apt install python3-gi gir1.2-gtk-4.0 gir1.2-adw-1 \
    network-manager wireguard-tools gettext dpkg-dev rpm
# Fedora
sudo dnf install python3-gobject gtk4 libadwaita \
    NetworkManager wireguard-tools gettext rpm-build

./build-deb.sh
./build-rpm.sh
```
