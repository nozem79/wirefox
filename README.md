# Wirefox 🦊

**A simple, WireGuard GUI for Ubuntu and Debian based systems.**

Wirefox is a lightweight GTK4/libadwaita desktop client for managing
WireGuard tunnels through NetworkManager.

<p align="center"><img src="data/png/wirefox-logo.png" alt="Wirefox logo" width="520"></p>

## Features

- 🔌 Activate / deactivate tunnels with a single switch
- 📝 Built-in config editor (Ctrl+S to save)
- 📥 Import a single `.conf` or a `.zip` bundle of multiple configs
- ➕ Create new tunnels from a built-in template
- 📊 Live IP address, RX/TX traffic and last handshake time
- ⚠️ DNS-leak warning when `AllowedIPs = 0.0.0.0/0` is set without `DNS =`
- 🇳🇱 Dutch translation included

## Installation

### From the .deb package (recommended)

```bash
sudo apt install ./wirefox_0.1.1-1_all.deb
```

### From source

```bash
sudo apt install python3-gi gir1.2-gtk-4.0 gir1.2-adw-1 \
    network-manager wireguard-tools
git clone https://github.com/nozem79/wirefox.git
cd wirefox
./wirefox
```

Requires Ubuntu 22.04+ or Debian 12+.

## Usage

1. Start **Wirefox** from your application menu.
2. Click **Import** and select your WireGuard `.conf` file,
   or click **New** to write one from the template.
3. Flip the switch to connect. Done.

Configs are stored in `~/.config/wirefox/`. Editing a config while the
tunnel is active will automatically re-import it into NetworkManager and
reconnect.

## Building the .deb yourself

```bash
./build-deb.sh
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Translations are especially welcome —
the `.pot` template lives in `po/wirefox.pot`.

## Why "Wirefox"?

Because I couldn't find a simple and working WireGuard GUI, so I built it myself. 🦊

## License

GPL-3.0-or-later. See [LICENSE](LICENSE).
