# Changelog

All notable changes to Wirefox are documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/), versioning follows [SemVer](https://semver.org/).

## 0.1.0 (2026-06-12)

### Added
- Initial release 🦊
- GTK4/libadwaita interface with per-tunnel on/off switch
- Rootless operation via NetworkManager (nmcli) and polkit
- Built-in config editor with Ctrl+S save and automatic re-import
- Import of existing wg-quick style `.conf` files
- New-tunnel template
- Live IP address and RX/TX traffic from sysfs
- Debian packaging (`build-deb.sh`)
