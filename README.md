# AG Quota Monitor 🚀

A native, lightweight macOS menu bar application designed to monitor your local **Google Antigravity** token quotas (Gemini and Claude/GPT) in real-time.

<p align="center">
  <img src="assets/icon_bttf.png" width="160" alt="AG Quota App Icon" />
</p>

---

## Features

- **Real-Time Monitoring**: Queries your local Antigravity Language Server every 30 seconds to fetch up-to-date rolling weekly and 5-hour token quotas.
- **Attributed Bold Displays**: Custom-drawn menu bar graphics highlighting model names.
- **Highly Configurable**: Toggles for Gemini, Claude/GPT, refresh timestamps, and timeframe labels.
- **Autostart Support**: Toggle automatic launch on system login directly from the app menu.
- **Zero Credentials Required**: Discovers local server ports and CSRF session tokens securely via local process scans (`ps` and `lsof`) entirely offline. No passwords or API keys are ever requested or stored.

---

## Interface Preview

### Menu Bar Display Modes

You can toggle between a compact percentages-only layout and a full layout showing timeframes and reset dates/timestamps.

#### Compact Mode (Timeframe & Show Refresh disabled)
<p align="center">
  <img src="assets/statusbar_compact.png" alt="AG Quota Compact Mode" />
</p>

#### Full Info Mode (Timeframe & Show Refresh enabled)
<p align="center">
  <img src="assets/statusbar_full.png" alt="AG Quota Full Info Mode" />
</p>

### Dropdown Menu Options
<p align="center">
  <img src="assets/menu_dropdown.png" alt="AG Quota Dropdown Menu" />
</p>

### Help & Configuration Dialog
<p align="center">
  <img src="assets/screenshot.png" width="700" alt="AG Quota Help Window" />
</p>

---

## Configurable Options in the Dropdown Menu:

- **Gemini**: Toggle showing/hiding Gemini quota statistics.
- **Claude/GPT**: Toggle showing/hiding Claude/GPT quota statistics.
- **Show Refresh**: Toggle the reset timestamp suffix (e.g. `(18 Juni)` or `(17:50)`) inside the menu bar.
- **Timeframe**: Toggle showing/hiding explicit time frame prefixes (`Week - ` and `Five Hour - `) to save menu bar space.
- **Autostart with System**: Toggle registering the app with macOS `SMAppService` to autostart at login.
- **How?**: Opens the custom-designed, styled two-column dialog explaining the internal mechanisms.

---

## Installation & Distribution

You can download the application directly from the repository root:
- **[Download AGQuota.dmg (Recommended)](AGQuota.dmg)** — Double-click the disk image and drag the app to your `/Applications` folder.

Alternatively, you can get the package from the **[Latest GitHub Releases](https://github.com/oliverottner/AG_Quota/releases/latest)**.

---

## License & Credits

- Developed by **Oliver Ottner** ([www.iservice.at](https://www.iservice.at)).
- This project is open-source software licensed under the copyleft **[GNU General Public License v3 (GPLv3)](LICENSE)**.
- Made with ❤️ in Europe.
