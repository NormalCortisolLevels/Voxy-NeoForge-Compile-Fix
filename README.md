# Voxy NeoForge 1.21.1

> **Unofficial NeoForge port** of the Voxy Level-of-Detail (LOD) mod.

## Special Thanks

**All credit for Voxy goes to [MCRcortex](https://github.com/MCRcortex)**, the original author and creator of this incredible LOD rendering mod.

- **Original Repository:** [MCRcortex/voxy](https://github.com/MCRcortex/voxy)
- **Original Author:** [MCRcortex](https://github.com/MCRcortex)

This repository is a community port to NeoForge 1.21.1, created because the original author has indicated they will not be backporting to this version. We are deeply grateful for MCRcortex's work on Voxy.

## License Notice

The original Voxy mod is licensed under **All Rights Reserved** by MCRcortex. This port is provided for personal use. Please respect the original author's licensing terms.

---

## About

**Voxy** is a Level-of-Detail (LOD) rendering mod for Minecraft that extends your view distance far beyond vanilla limits by rendering distant terrain at lower detail levels. 

This fork specifically addresses build-time errors and mapping conflicts found in the original port.

## Why This Port?

You might wonder: "Why not just use the Fabric version with [Sinytra Connector](https://github.com/Sinytra/Connector)?"

| Aspect | Native NeoForge Port (this repo) | Sinytra Connector |
|--------|----------------------------------|-------------------|
| **Performance** | No translation overhead | Runtime translation layer |
| **Mod Integration** | Native NeoForge API calls | Fabric API emulation via FFAPI |
| **Maintenance** | Fixed 1.21.1 mapping errors | General translation layer |
| **Stability** | Tested against NeoForge directly | May have edge cases from translation |
| **Dependencies** | Forgified Fabric API | Connector + Forgified Fabric API |

**Bottom line:** For a performance-critical LOD mod like Voxy, eliminating the translation layer overhead is worthwhile. If you prioritize simplicity and don't mind potential overhead, Sinytra Connector is a valid alternative.

## Status

**Alpha** - Functional with known limitations.

### Working Features
- LOD terrain rendering beyond vanilla render distance
- Smooth transitions between LOD and vanilla chunks
- Fog integration (disabled at LOD boundaries)
- Block model baking for all render types (solid, cutout, translucent)
- Delayed chunk unloading to prevent pop-out effects
- **Fixed:** Corrected build logic to resolve "class not found" and mapping errors.

### Current Limitations
- Requires Sodium 0.6.13+ (NeoForge version)
- Some optional integrations not yet ported (Iris, Nvidium, Vivecraft)
- Debug screen integration disabled (MC 1.21.1 API changes)

## Requirements

### Required Dependencies

| Dependency | Version | Link |
|------------|---------|------|
| Minecraft | 1.21.1 | - |
| NeoForge | 21.1.x | [NeoForge](https://neoforged.net/) |
| Sodium | mc1.21.1-0.6.13-neoforge | [Modrinth](https://modrinth.com/mod/sodium/version/mc1.21.1-0.6.13-neoforge) |
| Forgified Fabric API | 0.116.7+2.2.0+1.21.1 | [Modrinth](https://modrinth.com/mod/forgified-fabric-api/version/0.116.7+2.2.0+1.21.1) |

### Recommended Dependencies

| Dependency | Purpose | Link |
|------------|---------|------|
| Reese's Sodium Options | Better settings UI for Sodium + Voxy config access | [Modrinth](https://modrinth.com/mod/reeses-sodium-options) |
| Lithium | General performance improvements | [Modrinth](https://modrinth.com/mod/lithium) |

## Installation

> **Note:** Due to Voxy's ARR (All Rights Reserved) license, compiled JARs are not distributed. You must build from source.

1. Install NeoForge for Minecraft 1.21.1
2. Install required dependencies (see above)
3. Build Voxy from source (see below)
4. Place the built JAR in your `mods` folder

## Building from Source

### Windows (Recommended)
1. Download this repository as a **ZIP** and extract it.
2. Run **`VoxyBuilder.bat`**.
3. Follow the prompts to compile. Use the **Deployment** menu to move the JAR to your mods folder.

### Command Line (Requires Git)
If you don't have Git, you can download it from [git-scm.com](https://git-scm.com/).
```bash
git clone https://github.com/NormalCortisolLevels/voxy-neoforge.git
cd voxy-neoforge
./gradlew build
```
The built JAR will be in build/libs/.

## Contributing
For development guidelines, see CLAUDE.md.

## Project Structure
src/: Java source code and assets.

VoxyBuilder.bat: Automated build script for Windows.

scripts/: Build validation tools used in CI.

## Legal
NOT AN OFFICIAL MINECRAFT PRODUCT. NOT APPROVED BY OR ASSOCIATED WITH MOJANG OR MICROSOFT.

## Links
Original Voxy: https://modrinth.com/mod/voxy

Original Repo: https://github.com/j-shelfwood/voxy-neoforge

This Fork: https://github.com/NormalCortisolLevels/voxy-neoforge (fixes compile issues causde by deprecated gradlew processes and pythonencoding utf-8 error)

Sinytra Connector (alternative): modrith: https://modrinth.com/mod/connector
