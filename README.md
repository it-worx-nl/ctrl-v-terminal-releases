<div align="center">

# Ctrl-V Terminal

**A tabbed SSH + VNC client for Windows — built for the age of terminal AI.**

Paste an image straight into a remote terminal with `Ctrl+V`, and its path lands
at your cursor so tools like Claude Code can read it instantly.

[![Latest release](https://img.shields.io/github/v/release/zohlandt/ctrl-v-terminal-releases?label=latest&color=2d6a4f)](https://github.com/zohlandt/ctrl-v-terminal-releases/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/zohlandt/ctrl-v-terminal-releases/total?color=2d6a4f)](https://github.com/zohlandt/ctrl-v-terminal-releases/releases)
![Platform](https://img.shields.io/badge/platform-Windows-0078d6)

[**⬇ Download the latest version**](https://github.com/zohlandt/ctrl-v-terminal-releases/releases/latest) &nbsp;·&nbsp; [**Website**](https://ctrl-v-terminal.appgrid.eu)

</div>

---

## What is it?

Ctrl-V Terminal is a modern, tabbed terminal in the spirit of the classic
enhanced X-terminals — but with a headline trick: **copy an image, focus a
terminal, press `Ctrl+V`, and the image is uploaded to the remote host over
SFTP with its path typed at the cursor.** That makes it effortless to hand
screenshots to AI coding tools (like Claude Code) running on a remote machine.

On top of that it's a fully featured SSH client, an SFTP file browser, and a
VNC remote-desktop viewer — all in one tabbed window.

## Download

Grab the newest build from the [**Releases**](https://github.com/zohlandt/ctrl-v-terminal-releases/releases/latest) page:

| File | Use it when |
|------|-------------|
| **`Ctrl-V-Terminal-Setup-<version>.exe`** | Normal install (per-machine, into Program Files). Recommended. |
| **`Ctrl-V-Terminal-<version>.exe`** | Portable — run it without installing. |

> **First-run note:** the installer isn't code-signed yet, so Windows SmartScreen
> may show a warning. Click **More info → Run anyway**. A code-signed release is
> planned to remove this step.

**Requirements:** Windows 10 or 11 (64-bit).

## Free vs. full version

Ctrl-V Terminal is **free to use** for up to **3 saved sessions**, with every
feature enabled. Need more? Unlock the **full version** for unlimited sessions
and all future 1.x updates — right from **Help → Unlock the full version** in
the app, or via the [website](https://ctrl-v-terminal.appgrid.eu). One purchase
covers up to 3 of your devices.

## Features

**Terminal (SSH)**
- Tabbed terminals with a fast, stable renderer for full-screen TUIs.
- **Image-paste over SFTP** — the headline feature.
- **Persistent sessions (tmux)** — work survives disconnects and resumes from
  another PC.
- **Tear-off tabs** into separate windows; rename tabs; find-in-terminal;
  clickable links; font zoom; configurable keep-alive.
- Password or private-key auth (PuTTY `.ppk` supported).

**File browser (SFTP)**
- Browse, upload, download, rename and delete remote files.
- **Drag a remote file straight to your Windows desktop.**

**VNC (remote desktop)**
- A VNC session type alongside SSH: direct, Apple/ARD auth (macOS Screen
  Sharing), or **tunnelled over SSH**. View-only mode and clipboard sync.

**Sessions & convenience**
- Sessions sidebar with folders, duplicate, and **import from PuTTY**.
- **Encrypted, passphrase-protected export/import** to move sessions between PCs.
- Live host status bar (CPU / memory / network / uptime / disk).
- Searchable color schemes, remembered window size, and a playful idle
  screensaver.

## Updating

The app **checks for updates automatically** and via **Help → Check for
updates…**. When a new version is found you can install it right away (the app
restarts) or **defer it until you next close the app**.

## Support & links

- 🌐 Website: **https://ctrl-v-terminal.appgrid.eu**
- 📦 All downloads & release notes: the [Releases](https://github.com/zohlandt/ctrl-v-terminal-releases/releases) page here.

---

<div align="center">

*This repository hosts the official downloads and release notes only.
The application source is private.*

© IT WORX

</div>
