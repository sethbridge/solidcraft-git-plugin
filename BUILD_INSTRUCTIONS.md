# SolidCraft Git Plugin - Build Instructions

## Status: ✅ Manifest is Valid

Your plugin's `plugin.json` has been successfully validated by SolidCraft! 

```
Entry: solidcraft-git.commit (command; fields: message)
Capabilities: commands@0.2
Permissions: file command group
```

## What's Needed

The only remaining step is to **build a WASM component**. SolidCraft requires:
- A WebAssembly Core module (`.wasm`)
- Wrapped as a WebAssembly Component

## Build Process

### Step 1: Install Rust
```powershell
# Download from https://rustup.rs/
# Or use winget:
winget install Rustlang.Rust.MSVC
```

### Step 2: Build the Plugin

```powershell
cd C:\Users\sethb\solidcraft-git-plugin

# Install wasm-pack
cargo install wasm-pack

# Build WASM module
wasm-pack build --target web --release

# Install wasm-tools
cargo install wasm-tools

# Convert module to component
wasm-tools component new pkg/solidcraft_git_plugin_bg.wasm -o dist/solidcraft-git/index.wasm
```

### Step 3: Verify

```powershell
C:\"Program Files"\SolidCraft\solidcraft-cli.exe plugin check dist\solidcraft-git
```

Should show:
```
✓ solidcraft-git 0.1.0 (command plugin): no problems
Entry: solidcraft-git.commit (command; fields: message)
```

### Step 4: Package & Install

```powershell
# Create zip
Compress-Archive -Path dist\solidcraft-git\* -DestinationPath solidcraft-git-plugin.zip -Force

# Install in SolidCraft
# File → Preferences → Plugins → Install Plugin
# Select solidcraft-git-plugin.zip
# Grant "file" permission
# Click Install
```

## Plugin Details

**ID**: `solidcraft-git`
**Entry**: `commit`
**Parameters**: 
- `message` (required): Git commit message

**Capabilities**: `commands@0.2`
**Permissions**: file command group

## What It Does (When Built)

1. User clicks "Commit" in SolidCraft
2. Plugin receives commit message
3. Calls `file.save` to persist design
4. Runs git commit with message
5. Returns status to SolidCraft

## Full Rust Source

Located in: `src/lib.rs`

The plugin:
- Analyzes SolidCraft design changes
- Generates smart commit messages  
- Automatically commits to git
- Tracks parameters, bodies, features

## Next Steps

**Without Rust installed:**
- Request Rust installation first
- Then follow the build steps above

**With Rust already installed:**
```powershell
cd C:\Users\sethb\solidcraft-git-plugin
wasm-pack build --target web --release  # 2-3 minutes
cargo install wasm-tools  # First time only
wasm-tools component new pkg/solidcraft_git_plugin_bg.wasm -o dist/solidcraft-git/index.wasm
```

That's it! You'll have a working SolidCraft git plugin ready to install. 🚀
