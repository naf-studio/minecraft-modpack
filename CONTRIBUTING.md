# Contributing Guidelines

Thank you for contributing to the NAF Minecraft Modpack. To maintain high stability, performance, and compatibility, please review the following engineering guidelines.

---

## 1. Modpack Philosophy & Architecture

- We focus on performance enhancements, visual optimizations, and quality-of-life adjustments compatible with vanilla and Paper/Leaf servers.
- Never commit `.jar` or `.zip` files to the repository. All mods and resource packs must be declared through `modrinth.index.json` with verified Modrinth CDN URLs and SHA hashes.
- Client-side configs belong in `overrides/config/`, and launcher settings belong in `overrides/options.txt`.

---

## 2. Proposing Mod Additions or Updates

When submitting a Pull Request to add or update a mod:

1. Verify that the mod is hosted on [Modrinth](https://modrinth.com/).
2. Verify that the mod supports the current Minecraft version (`1.21.11`) and Fabric Loader.
3. Ensure no client-server desynchronization or anti-cheat conflicts are introduced.
4. Update `modrinth.index.json` with the new version hash, download URL, and file size.
5. Run `./export.sh` or `.\export.ps1` to verify clean archive packaging.

---

## 3. Git Discipline & Commit Guidelines

- Atomic Commits: Each commit must represent a single, self-contained change.
- Conventional Commits: Format commit messages using conventional types:
  - `feat`: New mod or feature added.
  - `fix`: Configuration fix or mod conflict resolved.
  - `chore`: Dependency updates, tooling, or repository housekeeping.
  - `docs`: Documentation updates.
- Sign-off: Author identity must match your verified GitHub committer email.

---

## 4. Reporting Issues

If you encounter crashes, render glitches, or mod conflicts:

1. Search existing issues before creating a new report.
2. Provide standard Minecraft crash logs or `latest.log`.
3. Specify your operating system, graphics driver, and Java runtime version.
