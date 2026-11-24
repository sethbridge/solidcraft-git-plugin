# SolidCraft Git Plugin - Installation Guide

## Quick Start

### Prerequisites
- **SolidCraft 0.48.1+** (latest version recommended)
- **Git** installed and in PATH: `git --version`
- **Rust 1.70+** (optional - only if building from source)

### Installation Methods

#### Method 1: Install Pre-built Plugin (Easiest)

1. Download `solidcraft-git-plugin.zip` from releases

2. Install via SolidCraft CLI:
   ```powershell
   solidcraft-cli plugin install solidcraft-git-plugin.zip
   ```

3. Grant permissions when prompted:
   - ✓ File Operations (read/write)
   - ✓ Execute: git
   - ✓ UI access

4. Configure in SolidCraft:
   - Open **Preferences → Plugins**
   - Find **SolidCraft Git Integration**
   - Click **Configure** and set:
     - Repository Path: `C:\Users\sethb\maldivian-triple-frame`
     - Auto-commit: ✓ Enabled
     - Push: ✓ Enabled

#### Method 2: Build from Source

```powershell
# 1. Install wasm-pack (one time)
cargo install wasm-pack

# 2. Navigate to plugin directory
cd C:\Users\sethb\solidcraft-git-plugin

# 3. Run build script
.\build.ps1

# 4. Install from built package
solidcraft-cli plugin install solidcraft-git-plugin.zip
```

#### Method 3: Manual Installation

```powershell
# 1. Build WASM
wasm-pack build --target web --release

# 2. Create plugin directory
mkdir -p dist\solidcraft-git

# 3. Copy files
Copy-Item manifest.json dist\solidcraft-git\
Copy-Item pkg\solidcraft_git_plugin_bg.wasm dist\solidcraft-git\index.wasm

# 4. Zip it
Compress-Archive -Path dist\solidcraft-git\* -DestinationPath solidcraft-git-plugin.zip

# 5. Install
solidcraft-cli plugin install solidcraft-git-plugin.zip
```

## Configuration

After installation, configure the plugin:

### Via SolidCraft UI
1. **Preferences** → **Plugins**
2. **SolidCraft Git Integration** → **Configure**
3. Set options:
   | Option | Value | Description |
   |--------|-------|-------------|
   | Repository Path | `C:\path\to\repo` | Path to your git repo |
   | Auto-commit | On/Off | Auto-commit on save |
   | Auto-push | On/Off | Automatically push to origin |

### Via Command Line
```powershell
# Check plugin configuration
solidcraft-cli plugin grants

# Update permissions if needed
solidcraft-cli plugin install --folder read,write C:\Users\sethb\maldivian-triple-frame
```

## Verification

### Check Installation
```powershell
# List installed plugins
solidcraft-cli commands | Select-String "git-commit"

# Validate plugin
solidcraft-cli plugin check C:\Users\sethb\solidcraft-git-plugin
```

### Test the Plugin
1. Open a design in SolidCraft
2. Make a small change (e.g., adjust a parameter)
3. Press **Ctrl+S** to save
4. Check your git repository:
   ```bash
   cd C:\Users\sethb\maldivian-triple-frame
   git log --oneline -5
   ```

   Should show a new commit like:
   ```
   a1b2c3d Updated 'parameter_name'
   ```

## First Run

### Initial Setup
1. **Configure repository path**
   - Preferences → Plugins → Configure
   - Set to your repository folder

2. **Test manual commit**
   - Modify your design
   - Press **Ctrl+Alt+G** (or File → Commit to Git)
   - Review changes
   - Click **Commit**

3. **Enable auto-commit** (optional)
   - Preferences → Plugins → Configure
   - Enable "Auto-commit on save"
   - Next save will auto-commit

### Example Workflow

```
1. Open design: maldivian_tripleframe.sc
2. Adjust parameter: paint_w = 320mm
3. Press Ctrl+S (save)
4. Plugin detects change and commits:
   
   "Updated 'paint_w'"
   
5. Check git log:
   git log --oneline -1
   > a1b2c3d Updated 'paint_w'
```

## Troubleshooting

### "Plugin installation failed"
```powershell
# Check manifest syntax
Get-Content manifest.json | ConvertFrom-Json

# Validate plugin
solidcraft-cli plugin check .
```

### "Git command failed"
- Verify git is installed: `git --version`
- Add git to PATH if needed
- Test git directly:
  ```bash
  cd C:\Users\sethb\maldivian-triple-frame
  git status
  ```

### "Nothing to commit"
- Ensure your design file was actually modified
- Check repository has uncommitted changes:
  ```bash
  git status
  ```

### "Permission denied"
- Grant plugin permissions:
  ```powershell
  solidcraft-cli plugin grants
  ```
- Add folder to approved list in Preferences

### Plugin doesn't appear in menu
1. Restart SolidCraft
2. Check Preferences → Plugins → installed
3. Run `solidcraft-cli plugin check .` for errors

## Uninstallation

```powershell
# List installed plugins
solidcraft-cli commands | Select-String "solidcraft-git"

# Remove from Preferences → Plugins → Remove
# Or restart SolidCraft to reload
```

## Advanced Configuration

### Keyboard Shortcut

To change the commit shortcut (default: Ctrl+Alt+G):

1. Edit `manifest.json`:
   ```json
   "ui": {
     "menu": [{
       "shortcut": "ctrl+shift+c"
     }]
   }
   ```

2. Rebuild and reinstall

### Custom Commit Message Format

Modify `src/lib.rs` `generate_commit_message()` function to customize format.

### Disable Auto-push

To commit without pushing:
1. Preferences → Plugins → Configure
2. Toggle "Auto-push" OFF

Then push manually:
```bash
git push origin main
```

## Support

For issues or questions:
1. Run `solidcraft-cli plugin check .` for diagnostics
2. Check SolidCraft logs: `%APPDATA%\SolidCraft\logs`
3. Verify git repository status: `git status`

## See Also

- [SolidCraft Plugin Documentation](https://docs.solidcraft.app/plugins)
- [Git Integration Guide](../README.md)
- [Keyboard Shortcuts](SHORTCUTS.md)
