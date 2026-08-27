# Chocolatey package — ctrl-v-terminal

Package source for the Chocolatey Community Repository (CCR) listing of Ctrl-V Terminal.
The package does **not** embed the installer; it downloads the official signed release asset
from `it-worx-nl/ctrl-v-terminal-releases` and verifies it with a SHA256 checksum.

## Files

| File | Purpose |
| --- | --- |
| `ctrl-v-terminal.nuspec` | Package metadata (id, version, urls, description, tags) |
| `tools/chocolateyinstall.ps1` | Downloads the NSIS installer and runs it with `/S` |
| `tools/chocolateyuninstall.ps1` | Finds the uninstall registry key and runs the NSIS uninstaller with `/S` |
| `publish.ps1` | Windows-side driver: pack, test install, test uninstall, optional push |
| `github-workflow-chocolatey.yml` | The same run as a GitHub Actions job on a windows runner |

`publish.ps1` is not part of the package: the nuspec only ships `tools\**`.

Both `.ps1` files must stay UTF-8 **with BOM**; PowerShell needs the BOM to read them as UTF-8,
and the docs make that a requirement. The nuspec is UTF-8 with the XML declaration, BOM optional.

## The API key

The push credential comes from <https://community.chocolatey.org/account> (log in as `itworx`,
reveal the API key). It is a secret: never commit it, and do not paste it into a terminal that
records scrollback.

Store it in exactly one of these places, depending on the route you use:

* **GitHub Actions** (route A): repository secret `CHOCO_API_KEY` in the public releases repo.
  ```bash
  gh secret set CHOCO_API_KEY --repo it-worx-nl/ctrl-v-terminal-releases
  # paste the key at the prompt; it is never echoed
  ```
* **Local Windows machine** (route B): stored once in `chocolatey.config`, elevated.
  ```powershell
  choco apikey add --source https://push.chocolatey.org/ --key <key>
  ```

## Releasing a new version

1. Publish the app release first (`npm run release:bot`).
2. Sync this folder to that release, from the private source repo:
   ```bash
   npm run choco:sync            # latest release
   npm run choco:sync -- --tag v1.3.0
   ```
   That rewrites `<version>`, `<releaseNotes>`, `$url64` and `$checksum64`.
3. Copy this folder to `it-worx-nl/ctrl-v-terminal-releases` as `chocolatey/`, and
   `github-workflow-chocolatey.yml` to `.github/workflows/chocolatey.yml` there. That repo is the
   target of `packageSourceUrl`, which moderators do click, and it is where route A runs.
4. Pack, test and push. Packing and testing cannot happen on Linux, so pick a route:

   **Route A - GitHub Actions (no Windows machine needed).** Run the `chocolatey` workflow from the
   Actions tab of the releases repo, or:
   ```bash
   gh workflow run chocolatey --repo it-worx-nl/ctrl-v-terminal-releases            # pack + test only
   gh workflow run chocolatey --repo it-worx-nl/ctrl-v-terminal-releases -f push=true
   ```
   Windows runners are free on a public repo, ship with Chocolatey CLI and run elevated.

   **Route B - a Windows machine or VM**, elevated PowerShell:
   ```powershell
   cd chocolatey
   .\publish.ps1            # pack + test install + test uninstall
   .\publish.ps1 -Push      # the same, then push
   ```

The installer is built with `multiLanguageInstaller` and `displayLanguageSelector`, so it has a
language dialog, which under `/S` would hang the verifier forever. It does not: MUI wraps the
dialog in `${unless} ${Silent}` (see `MUI_LANGDLL_DISPLAY` in NSIS's `Contrib/Modern UI 2/
Localization.nsh`), so a silent install skips it and `$LANGUAGE` falls back to the system
language, which `build/installer.nsh` then writes to the registry as usual. The test install
still matters as the same check the verifier performs, on a machine you control.

## Moderation

Every push goes through: package validator (metadata) → package verifier (installs and uninstalls
in a clean VM, runs VirusTotal) → human moderator. Expect days to weeks for the first version;
later versions of an approved package go faster, and after a few clean submissions you can be
granted trusted-package status, which skips human review.

Things that commonly hold a submission up here:

* **Unsigned installer.** The verifier runs the installer through VirusTotal, and unsigned Electron
  installers pick up false positives. The installer is not code-signed yet; the private source repo
  has the details in `SIGNING.md`.
* **`requireLicenseAcceptance` is `true`** because the app ships under a proprietary EULA,
  published at <https://ctrl-v-terminal.appgrid.eu/terms/>.
* **Trademark tags.** `mobaxterm-alternative` is deliberately *not* in the tag list; comparisons
  belong in prose, not in tags.
* **Commercial software must be declared.** The description states plainly that this is commercial
  software with a non-expiring free tier and what the key unlocks. Leaving that out is a rejection
  reason for trial/commercial packages.

## Checked against the docs

* Package id `ctrl-v-terminal` is free on the community repository (`/packages/ctrl-v-terminal`
  returns 404) and follows the naming guideline: lowercase, spaces replaced by hyphens, no dots.
* `<title>Ctrl-V Terminal</title>` matches the official spelling of the application.
* Icon guideline: `iconUrl` is the 256x256 app icon (PNG, transparent) served from our own site,
  which we control. The docs prefer a static CDN pinned to a tag or commit; once this folder plus
  the icon live in the public releases repo, switch to
  `https://cdn.jsdelivr.net/gh/it-worx-nl/ctrl-v-terminal-releases@<commit>/chocolatey/icon.png`.
* Version follows the app version exactly. Only if a *package* fix is needed for an already
  approved version do you add a fourth segment, e.g. `1.2.0.20260827`.
* The project also ships a portable exe, and the docs suggest a product with both an installer and
  a portable build becomes three packages (`ctrl-v-terminal.install`, `ctrl-v-terminal.portable`
  and a `ctrl-v-terminal` metapackage). That is a guideline, not a requirement, and we deliberately
  ship the single installer package. If the portable build is ever added, it arrives as new ids
  next to this one rather than as a rename of it.
