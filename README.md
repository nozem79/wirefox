# Wirefox 🦊

**A simple WireGuard GUI for Linux — Ubuntu, Debian and Fedora.**

Wirefox is a lightweight GTK4/libadwaita desktop client for managing
WireGuard tunnels through NetworkManager. No root rights needed.

<p align="center"><img src="data/png/wirefox-logo.png" alt="Wirefox logo" width="520"></p>

## Features

- 🔌 Start / stop a tunnel with one click
- 📝 Built-in config editor (Ctrl+S to save)
- 📥 Import a single `.conf` or a `.zip` bundle of multiple configs
- ➕ Create new tunnels from a built-in template
- 📊 Live IP address and RX/TX traffic
- ⚠️ DNS-leak warning when `AllowedIPs = 0.0.0.0/0` is set without `DNS =`
- 🔒 Tunnels only start when you click Start — never automatically at boot
- 🇳🇱 Dutch translation included

## Requirements

GTK 4.10 and libadwaita 1.5 or newer:
Ubuntu 24.04+, Debian 13+, Fedora 40+ (or another distro with these versions).

## Installation

Download the package for your distro from the
[latest release](https://github.com/nozem79/wirefox/releases/latest).

### Ubuntu / Debian

```bash
sudo apt install ./wirefox_*_all.deb
```

### Fedora

```bash
sudo dnf install ./wirefox-*.noarch.rpm
```

### From source

```bash
# Ubuntu / Debian
sudo apt install python3-gi gir1.2-gtk-4.0 gir1.2-adw-1 network-manager wireguard-tools
# Fedora
sudo dnf install python3-gobject gtk4 libadwaita NetworkManager wireguard-tools

git clone https://github.com/nozem79/wirefox.git
cd wirefox
./wirefox
```

## Usage

1. Start **Wirefox** from your application menu.
2. Click **Import** and select your WireGuard `.conf` file,
   or click **New** to write one from the template.
3. Click **Start** to connect, **Stop** to disconnect.

Configs are stored in `~/.config/wirefox/` (readable only by you).
Editing a config while the tunnel is active re-imports it into
NetworkManager and reconnects.

## Building the packages yourself

```bash
./build-deb.sh   # needs: dpkg-dev gettext
./build-rpm.sh   # needs: rpm-build gettext (Fedora) or rpm gettext (Debian/Ubuntu)
```

The packages end up in `dist/`. Pushing a tag like `v0.2.1` makes GitHub
Actions build both packages, test-install them on Ubuntu and Fedora, and
attach them to a release.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Translations are especially welcome —
the `.pot` template lives in `po/wirefox.pot`.

## Why "Wirefox"?

Because I couldn't find a simple and working WireGuard GUI, so I built it myself. 🦊

## License

GPL-3.0-or-later. See [LICENSE](LICENSE).
