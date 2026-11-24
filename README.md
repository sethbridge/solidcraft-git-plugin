# SolidCraft Git Integration Plugin

A WASM plugin for SolidCraft that enables automatic git commits with smart, change-aware commit messages.

## Features

- 💾 **Auto-commit on save** - Automatically commits designs to git
- 🤖 **Smart commit messages** - Analyzes design changes and generates meaningful messages
- 🚀 **Optional push** - Push to remote after committing
- ⌨️ **Keyboard shortcut** - `Ctrl+Alt+G` to manually commit
- 🔍 **Change detection** - Tracks parameter, body, and feature changes

## Installation

### Prerequisites
- Rust 1.70+ (for building)
- `wasm-pack` for WASM compilation
- SolidCraft 0.48.1+

### Build from Source

```bash
# Install wasm-pack if needed
cargo install wasm-pack

# Build the plugin
cd C:\Users\sethb\solidcraft-git-plugin
wasm-pack build --target web --release

# Package for SolidCraft
# Copy the manifest and WASM to a folder named after the plugin ID
mkdir -p dist/solidcraft-git
cp manifest.json dist/solidcraft-git/
cp pkg/solidcraft_git_plugin_bg.wasm dist/solidcraft-git/index.wasm

# Zip for distribution
powershell -Command "Compress-Archive -Path dist/solidcraft-git -DestinationPath solidcraft-git.zip"

# Install in SolidCraft
solidcraft-cli plugin install solidcraft-git.zip
```

## Configuration

1. In SolidCraft, open **Preferences → Plugins**
2. Find **SolidCraft Git Integration**
3. Click **Configure** and set:
   - **Repository Path**: Path to your git repository (e.g., `C:\Users\sethb\maldivian-triple-frame`)
   - **Auto-commit**: Enable automatic commits on save
   - **Push**: Enable automatic push to origin

## Usage

### Automatic Commits
Once configured with auto-commit enabled:
1. Save your design in SolidCraft (`Ctrl+S`)
2. The plugin analyzes changes
3. Generates a commit message
4. Commits and optionally pushes

### Manual Commits
1. Press `Ctrl+Alt+G` or use **File → Commit to Git**
2. Review the detected changes
3. Edit commit message if needed
4. Click **Commit**

## Smart Commit Messages

The plugin automatically detects and reports:

- **Parameter changes**: "Updated 'paint_w', 'frame_depth'"
- **Body modifications**: "Increased 'Center' volume by 15,000 mm³"
- **Features added/removed**: "Added 2 feature(s)"
- **Design rename**: "Renamed design to 'NewName'"

Example output:
```
Updated 'paint_w'

- Increased 'Center' volume by 15,000 mm³
- Added 1 feature(s)
- Updated 'frame_depth'
```

## Permissions

The plugin requires:
- **Execute**: `git` command for commits and pushes
- **File access**: Read/write to configured repository folder
- **UI**: Menu items and dialogs for user interaction

## Development

### Project Structure
```
solidcraft-git-plugin/
├── manifest.json       # Plugin configuration
├── Cargo.toml          # Rust dependencies
├── src/
│   └── lib.rs          # Plugin implementation
└── tests/
    └── plugin.json     # Test cases
```

### Building
```bash
# Debug build
wasm-pack build --target web

# Release (optimized)
wasm-pack build --target web --release

# Check for errors
solidcraft-cli plugin check .
```

### Testing
```bash
# Run test cases
solidcraft-cli plugin test .

# Check specific case
solidcraft-cli plugin test . --require-cases
```

## Limitations

- Maximum 64 MB memory usage
- 30 second timeout per operation
- Requires git to be installed and in PATH
- Repository must be initialized with git

## Troubleshooting

**"Repository not found"**
- Verify the path exists and is a valid git repository
- Check permissions on the folder

**"Git command failed"**
- Ensure git is installed: `git --version`
- Verify git is in your PATH
- Check repository has a remote configured: `git remote -v`

**"Plugin won't load"**
- Run `solidcraft-cli plugin check .` to see errors
- Check manifest.json syntax
- Ensure WASM file is properly built

## License

MIT

## Author

SolidCraft Community
