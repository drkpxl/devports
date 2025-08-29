# devports

Interactive CLI tool for viewing and killing development server processes with enhanced TUI features and direct number selection.

## What it does

`devports` shows you all the development servers running on your machine (node, python, rails, etc.) in a beautiful, color-coded interface with real-time CPU/memory stats. Kill processes instantly by typing just their number - no more multi-step commands!

## Installation

### Quick Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/drkpxl/devports/main/install.sh | bash
```

### Download from Releases

Visit the [releases page](https://github.com/drkpxl/devports/releases) to download the latest version:

```bash
# Download and extract the latest release
wget https://github.com/drkpxl/devports/releases/latest/download/devports-1.2.0.tar.gz
tar -xzf devports-1.2.0.tar.gz
cd devports-1.2.0
make install-local
```

### Build from Source

```bash
git clone https://github.com/drkpxl/devports.git
cd devports
make install-local
```

## Usage

```bash
# Show common dev servers (node, python, rails, etc.)
devports

# Show all listening processes
devports all

# Show only node processes
devports node

# Show rails or ruby processes
devports "rails|ruby"

# Check for updates
devports --check-updates

# Update to latest version
devports --update
```

### Interactive Commands

#### 🚀 Quick Kill (New in v1.2.0)
- **1-9** - Kill processes directly by number (fastest method!)
- **1,3,5** - Kill multiple processes at once  
- **2-4** - Kill range of processes

#### Advanced Commands
- **k** - Kill menu with advanced options (PIDs, ports)
- **K** - Force kill menu (SIGKILL)
- **r** - Refresh process list
- **f** - Change filter pattern
- **s** - Change sort order (port, pid, name, cpu, memory)
- **t** - Toggle extended info display (CPU/Memory/Uptime)
- **a** - Auto-refresh mode
- **h** - Show help
- **Enter** - Exit

#### Advanced Kill Options (k command)
- PIDs directly: `12345`
- Port numbers: `:3000` or `3000`
- Complex selections: `k 1,3 :8080 12345`

## Examples

### Enhanced Interface (v1.2.0)

```bash
$ devports
🚀 devports v1.2.0 - Development Server Manager
═══════════════════════════════════════════════════

  #  PROCESS         PID      PORT   ADDRESS     CPU%   MEM%   UPTIME
─────────────────────────────────────────────────────────────────────
  1  node            12345    3000   *:3000      1.2%   2.1%   2h 15m
  2  python          67890    8080   *:8080      0.8%   1.5%   5h 30m
  3  ruby            54321    4567   *:4567      2.1%   1.8%   45m

Filter: node|python|rails | Sort: port | Extended

Actions: 1-9=kill  k=kill menu  r=refresh  [Enter]=exit
> 2              ← Just type the number!
Kill python (PID: 67890) on port 8080? [y/N] y
✔ Killed process 67890
```

### Quick Kill Examples

```bash
# Kill process #1
> 1

# Kill multiple processes
> 1,3,5

# Kill range of processes  
> 2-4

# Advanced kill by port
> k :3000

# Force kill by PID
> K 12345
```

### Configuration Options

```bash
# Show extended process info (default: true)
export DEVPORTS_EXTENDED=true

# Default sort order (port, pid, name, cpu, memory) 
export DEVPORTS_SORT=port

# Auto-refresh interval in seconds
export DEVPORTS_REFRESH=3
```

## Requirements

- `lsof` - for listing open files/ports
- `awk` - for text processing  
- `bash` 4.0+ or compatible shell

These are standard on macOS and most Linux distributions.

## Updating

DevPorts includes built-in update functionality:

### Check for Updates
```bash
devports --check-updates
```

### Update to Latest Version
```bash
devports --update
```

The update command will:
- Check for the latest version on GitHub
- Download the new version
- Create a backup of your current installation
- Replace the old version with the new one
- Verify the installation

### Manual Update
If the built-in updater doesn't work, you can always reinstall:

```bash
# Reinstall using the install script
curl -fsSL https://raw.githubusercontent.com/drkpxl/devports/main/install.sh | bash
```

## Development

### Building from Source

```bash
git clone https://github.com/drkpxl/devports.git
cd devports
make check    # Verify dependencies and syntax
make test     # Run basic tests
make install-local  # Install to ~/.local/bin
```

### Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and test them: `make test`
4. Commit your changes: `git commit -am 'Add some feature'`
5. Push to the branch: `git push origin feature-name`
6. Submit a pull request

### Releasing

Releases are automated via GitHub Actions. To create a new release:

1. Update the version in both `devports` script and `Makefile`
2. Update the `CHANGELOG.md` with the new version
3. Commit changes: `git commit -am 'Bump version to x.x.x'`
4. Create and push a tag: `git tag -a vx.x.x -m 'Release vx.x.x' && git push origin vx.x.x`

The GitHub Action will automatically create the release with archives and update the install script.

## License

MIT License - see [LICENSE](LICENSE) file for details.