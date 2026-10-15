# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.0.0] - 2026-10-15

First release of the printed filament scale for the Sovol SH02 dryer: CAD, printable parts and ESPHome firmware.

### Features

- Report filament remaining in grams and percent to Home Assistant, counting down from the spools that were loaded
- Sum two 5 kg load cells in the firmware for a 10 kg working capacity and a stable two-point support
- Calibrate from Home Assistant with three buttons: empty platform, known mass, dryer with full spools
- Keep zero, gain and spool capture across reboots and OTA updates, with no startup tare
- Reject captures while the reading moves, and drop missing, stale or saturated samples
- Four printed parts in print orientation: base, top and two click-in board caps, held together by eight M3 × 20 screws
- Parametric OpenSCAD source with assertions for every screw length and clearance
- Diagnostic sensors for raw counts, per-cell counts, noise range, saved calibration, chip temperature and Wi-Fi signal

### Testing

- Run the readings test, the mesh checks and ESPHome config validation on pull requests and pushes to main and develop
- Compile the ESP32-C3 firmware in CI with ESPHome 2026.9.1

### Documentation & Links

- Repository: https://github.com/fabianwimberger/esp32-sovol-sh02-scale
- Build guide: [docs/build.md](https://github.com/fabianwimberger/esp32-sovol-sh02-scale/blob/main/docs/build.md)
- Design notes: [docs/design.md](https://github.com/fabianwimberger/esp32-sovol-sh02-scale/blob/main/docs/design.md)
