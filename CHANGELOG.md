# Changelog

All notable changes to Wirefox are documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/), versioning follows [SemVer](https://semver.org/).

## 0.1.1 (2026-06-13)

### Added
- Initial release 🦊
- GTK4/libadwaita interface with per-tunnel on/off switch
- Rootless operation via NetworkManager and polkit
- Built-in config editor with Ctrl+S and automatic re-import
- Import single `.conf` or bulk-import from a `.zip` archive
- New-tunnel template
- Live IP address, RX/TX traffic and last handshake time
- DNS-leak warning badge
- Dutch (nl) translation via gettext

## 0.1.2 (2026-06-14)

### Changed
- Toggle knop vervangt de Gtk.Switch sleepbalk — één klik start of stopt de tunnel
- Knop toont "Start" (groen) of "Stop" (rood) afhankelijk van de status

### Fixed
- Tunnel herverbindt automatisch na standby / slaapstand (autoconnect via NetworkManager)
