# NAF Studio - Minecraft Modpack

[![Minecraft](https://img.shields.io/badge/Minecraft-1.21.11-brightgreen.svg)](https://minecraft.net/)
[![Mod Loader](https://img.shields.io/badge/Loader-Fabric-lightgrey.svg)](https://fabricmc.net/)
[![Modrinth](https://img.shields.io/badge/Modrinth-naf--minecraft--modpack-00AF5C.svg)](https://modrinth.com/modpack/naf-minecraft-modpack)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Optimized client-side Fabric modpack for the NAF Studio Minecraft community. Built with performance optimizations, visual refinements, and seamless cross-platform integration for the [NAF Minecraft Server](https://github.com/naf-studio/minecraft-server).

Official Modrinth Page: [https://modrinth.com/modpack/naf-minecraft-modpack](https://modrinth.com/modpack/naf-minecraft-modpack)

---

## 1. Architectural Overview & System Design

```text
minecraft-modpack/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── workflows/
│   └── pull_request_template.md
├── overrides/
│   ├── config/
│   └── options.txt
├── .editorconfig
├── .gitattributes
├── .gitignore
├── CONTRIBUTING.md
├── LICENSE
├── export.ps1
├── export.sh
├── modrinth.index.json
├── setup.ps1
├── setup.sh
└── README.md
```

### Engineering Decisions & Standards

- Eliminates binary bloat by storing mod dependencies declaratively in standard `modrinth.index.json` (Specification Format 1).
- Houses client-side configurations under `overrides/`, allowing clean version-controlled adjustments without tracking JAR binaries.
- Provides cross-platform packaging scripts (`export.ps1` for Windows, `export.sh` for Linux) producing compliant `.mrpack` and `.zip` archives.
- Provides developer bootstrapping scripts (`setup.ps1`, `setup.sh`) that fetch all 48 mods and resource packs from the Modrinth CDN into a local `.minecraft/` folder for testing.
- Automates distribution builds via GitHub Actions release workflow on version tags.

---

## 2. Installation Guide

### Option A: Modrinth App (Recommended)

1. Open the [Modrinth App](https://modrinth.com/app).
2. Search for **NAF Minecraft Modpack** or visit [modrinth.com/modpack/naf-minecraft-modpack](https://modrinth.com/modpack/naf-minecraft-modpack).
3. Click **Install** and select the latest 1.21.11 release.

### Option B: Prism Launcher

1. In [Prism Launcher](https://prismlauncher.org/), click **Add Instance**.
2. Select **Modrinth** in the left sidebar and search for `naf-minecraft-modpack`.
3. Alternatively, download the `.mrpack` file from the [Releases](https://github.com/naf-studio/minecraft-modpack/releases) page and choose **Import from zip**.

---

## 3. Developer & Operator Guide

### Exporting Distribution Archives

To package the modpack into `.mrpack` and `.zip` files:

On Linux:

```bash
chmod +x export.sh
./export.sh
```

On Windows (PowerShell):

```powershell
.\export.ps1
```

The script generates `NAF-Minecraft-Modpack-1.21.11.mrpack` and `NAF-Minecraft-Modpack-1.21.11.zip` ready for manual upload to Modrinth or distribution.

### Local Development Instance Setup

To download all declared mods and resource packs for local testing:

On Linux:

```bash
chmod +x setup.sh
./setup.sh
```

On Windows (PowerShell):

```powershell
.\setup.ps1
```

---

## 4. Contributing

Contributions must follow the standards outlined in [CONTRIBUTING.md](CONTRIBUTING.md).

---

## 5. License

This project is licensed under the [MIT License](LICENSE). Copyright &copy; 2024 [naipret](https://github.com/naipret).
