# Wirefox 🦊

**A simple, rootless WireGuard GUI for Debian and Ubuntu.**

Wirefox is a lightweight GTK4/libadwaita desktop client for managing
WireGuard tunnels. It uses **NetworkManager** as its backend, which means
no root rights are needed: activating or deactivating a tunnel goes
through polkit, just like any other network connection on your desktop.

![screenshot placeholder](data/screenshot.png)

## Features

- 🔌 Activate / deactivate tunnels with a single switch — no sudo, no terminal
- 📝 Built-in config editor (plain `wg-quick` style `.conf` syntax, Ctrl+S to save)
- 📥 Import existing `.conf` files
- ➕ Create new tunnels from a sensible template
- 📊 Live IP address and RX/TX traffic per active tunnel
- 🧹 Single file, no pip dependencies — only system packages

## How it stays rootless

| Task | Mechanism | Root needed |
|---|---|---|
| Tunnel up/down | `nmcli connection up/down` via NetworkManager + polkit | No |
| Config storage & editing | `~/.config/wirefox/*.conf` (mode 600) | No |
| Traffic statistics | `/sys/class/net/<if>/statistics/` | No |

On systems with stricter polkit policies (e.g. remote sessions),
NetworkManager may show a graphical authentication prompt instead.

## Installation

### From the .deb package

```bash
sudo apt install ./wirefox_0.1.0-1_all.deb
```

This pulls in all dependencies automatically. Wirefox then appears in
your application menu.

### From source

```bash
sudo apt install python3-gi gir1.2-gtk-4.0 gir1.2-adw-1 network-manager
git clone https://github.com/voxfox/wirefox.git
cd wirefox
./wirefox
```

Requires Ubuntu 22.04+ or Debian 12+ (for libadwaita).

## Usage

1. Start **Wirefox** from your application menu.
2. Click **Import** (folder icon) and select your WireGuard `.conf` file,
   or click **New** (document icon) to write one from the template.
3. Flip the switch to connect. Done.

Configs are stored in `~/.config/wirefox/`. Editing a config while the
tunnel is active will automatically re-import it into NetworkManager and
reconnect.

## Building the .deb yourself

```bash
./build-deb.sh
```

The package is written to `dist/wirefox_<version>-1_all.deb`.

## Why "Wirefox"?

Wirefox is part of the [VoxFox](https://voxfox.nl) family of tools —
*vos* is Dutch for fox. 🦊

## License

GPL-3.0-or-later. See [LICENSE](LICENSE).
