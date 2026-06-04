<p align="center">
  <picture>
    <img alt="YourPass" src="assets/images/app_logo_dark.png" width="220">
  </picture>
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.11+-02569B?logo=flutter&logoColor=white">
  <img alt="Dart" src="https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart&logoColor=white">
  <img alt="Platform" src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-6DB33F">
  <img alt="Status" src="https://img.shields.io/badge/Status-Development-yellow">
  <img alt="PRs Welcome" src="https://img.shields.io/badge/PRs-welcome-brightgreen">
</p>

---

YourPass is a **privacy first** and **offline password manager** built for privacy. All your credentials are encrypted with AES-256-GCM using a key derived from your master password via Argon2id, and stored locally on your device — no cloud sync, no telemetry, no internet required.

---

## Features

- **Argon2id key derivation** — Your vault key is derived from your master password using Argon2id, making brute-force attacks infeasible.
- **AES-256-GCM encryption** — All credentials are encrypted with AES-256-GCM before touching disk.
- **Vault creation & unlock flow** — Set up a master password with an optional hint, then unlock with each session.
- **Fully offline** — Your credentials never leave your device. No accounts, no servers, no subscription.
- **Search & categorize** — Filter by category (Web, App, Other) or search by title and username.
- **One-tap copy** — Tap to copy usernames and passwords. A quick confirmation lets you know it worked.
- **Light & dark mode** — Seamlessly follows your system theme out of the box.
- **Add, view, edit, delete** — Full CRUD for all your credentials.

---

## Screenshots

### Dark mode

<p align="center">
  <img alt="Screenshot 1" src="screenshots/1_dark.jpg" width="200">
  <img alt="Screenshot 2" src="screenshots/2_dark.jpg" width="200">
  <img alt="Screenshot 3" src="screenshots/3_dark.jpg" width="200">
  <img alt="Screenshot 4" src="screenshots/4_dark.jpg" width="200">
  <img alt="Screenshot 5" src="screenshots/5_dark.jpg" width="200">
</p>

### Light mode

<p align="center">
  <img alt="Screenshot 1" src="screenshots/1_light.jpg" width="200">
  <img alt="Screenshot 2" src="screenshots/2_light.jpg" width="200">
  <img alt="Screenshot 3" src="screenshots/3_light.jpg" width="200">
  <img alt="Screenshot 4" src="screenshots/4_light.jpg" width="200">
  <img alt="Screenshot 5" src="screenshots/5_light.jpg" width="200">
</p>

---

## Building from source

```bash
git clone https://github.com/Arvind-Sabarinathan/yourpass.git
cd yourpass
flutter pub get
flutter run
```

Requirements: Flutter SDK 3.11.5 or later.

---

## Privacy

YourPass collects **no data**. There is no analytics SDK, no crash reporter, no network calls. It is designed to work completely offline — you can even use it on a device in airplane mode.

---

## Contributing

Contributions are welcome and appreciated.

1. Fork the repository
2. Create a branch for your feature (`git checkout -b feature/amazing-idea`)
3. Commit your changes
4. Open a pull request

Found a bug or have an idea? [Open an issue](https://github.com/Arvind-Sabarinathan/yourpass/issues).
