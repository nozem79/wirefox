# Contributing to Wirefox

Thanks for your interest! Wirefox aims to stay a **single-file, zero-pip** application.

## Guidelines

- Keep dependencies limited to Debian/Ubuntu system packages.
- Run `python3 -m py_compile wirefox` before committing.
- One feature per pull request, please.
- Bug reports: include your distro version and the output of `nmcli -v`.

## Adding a translation

1. Copy `po/wirefox.pot` to `po/<lang>.po` (e.g. `po/de.po` for German).
2. Fill in the `msgstr` fields.
3. Test with `msgfmt po/<lang>.po -o /tmp/wirefox.mo`.
4. Submit a pull request — translations are always welcome!

## Building locally

```bash
sudo apt install python3-gi gir1.2-gtk-4.0 gir1.2-adw-1 \
    network-manager gir1.2-ayatanaappindicator3-0.1 wireguard-tools gettext
./build-deb.sh
```
