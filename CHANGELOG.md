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

## 0.1.3 (2026-06-16)

### Fixed
- Tunnel herstarte automatisch na standby ook als de gebruiker hem handmatig
  had uitgeschakeld. Autoconnect wordt nu alleen ingeschakeld als de gebruiker
  op Start klikt, en uitgeschakeld als de gebruiker op Stop klikt.

## 0.1.4 (2026-06-16)

### Fixed
- Hoog CPU-gebruik door NetworkManager (nmcli draaide elke 4 seconden)
  - Twee timers: snelle timer (8s) leest alleen sysfs voor verkeer,
    trage timer (30s) doet de volledige nmcli status-check
  - Handshake refresh verhoogd van 4s naar 30s
  - nmcli wordt niet meer aangeroepen als er geen actieve tunnels zijn

## 0.1.5 (2026-06-16)

### Fixed
- CPU-gebruik verder verlaagd: snelle timer (8s) doet nu nul nmcli-aanroepen
  — IP en interfacenaam worden gecached door de trage timer (30s)
- Sysfs-lezingen (RX/TX) kosten vrijwel geen CPU

## 0.1.6 (2026-06-16)

### Fixed
- Hoog CPU-gebruik: alle achtergrond-threads en dubbele timers verwijderd
- Eén simpele timer van 20 seconden voor de volledige UI-refresh
- Handshake-polling (wg show) verwijderd — dit veroorzaakte continue CPU-last

## 0.1.7 (2026-06-19)

### Fixed
- Verdere CPU-optimalisatie: knoplabel, CSS-class en subtitel worden nu
  alleen bijgewerkt als de waarde daadwerkelijk verandert (voorkomt onnodige
  hertekening door libadwaita)
- `.pill` CSS-class verwijderd van de toggle-knop

## 0.1.8 (2026-06-19)

### Fixed
- **Wirefox bleef op de achtergrond draaien na het sluiten van het venster.**
  De refresh-timer hield de GLib main loop in leven, waardoor het proces
  (en zijn periodieke nmcli-aanroepen) bleef draaien tot je het handmatig
  killde. Het venster sluiten stopt nu de timer en beëindigt de app netjes.
- Dode code van eerdere timer-experimenten opgeruimd.

## 0.1.9 (2026-07-22)

### Fixed
- **VPN startte automatisch op na een herstart.** Sinds 0.1.3 zette Wirefox
  `connection.autoconnect=yes` om de tunnel na standby te laten herstellen,
  maar NetworkManager gebruikt diezelfde vlag om de tunnel bij het opstarten
  te activeren. Tunnels starten nu uitsluitend handmatig.
- Bij het starten van Wirefox wordt `autoconnect` eenmalig uitgezet op alle
  bestaande WireGuard-verbindingen, zodat tunnels die door een oudere versie
  zijn ingesteld ook niet meer vanzelf opkomen.

## 0.2.0 (2026-07-22)

### Fixed
- **Hoog CPU-gebruik van NetworkManager zolang Wirefox openstond.**
  De periodieke verversing riep `nmcli connection show` aan, dat élk
  opgeslagen verbindingsprofiel over D-Bus ophaalt inclusief een
  polkit-controle per profiel. Op systemen met veel opgeslagen netwerken
  kostte dat NetworkManager veel werk, elke 20 seconden opnieuw.

### Changed
- De periodieke verversing praat niet meer met NetworkManager. De status van
  een tunnel wordt afgeleid uit `/sys/class/net/`, het IP-adres via `ip addr`
  (netlink) en gecachet zolang de tunnel actief is. `nmcli` draait nu alleen
  nog bij het starten, stoppen, importeren of verwijderen van een tunnel.
- Verversingsinterval terug naar 5 seconden — de UI reageert sneller en kost
  vrijwel geen CPU meer.
