# devports

Interactive CLI tool for viewing and killing development server processes.

## What it does

`devports` shows you all the development servers running on your machine (node, python, rails, etc.) in a clean, interactive interface. You can easily kill processes by index, PID, or port number.

## Installation

### Quick Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/stevenhubert/devports/main/install.sh | bash
```

### Download from Releases

Visit the [releases page](https://github.com/stevenhubert/devports/releases) to download the latest version:

```bash
# Download and extract the latest release
wget https://github.com/stevenhubert/devports/releases/latest/download/devports-1.0.0.tar.gz
tar -xzf devports-1.0.0.tar.gz
cd devports-1.0.0
make install-local
```

### Build from Source

```bash
git clone https://github.com/stevenhubert/devports.git
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

- **Enter** - Exit
- **k** - Kill selected processes (SIGTERM)
- **K** - Force kill selected processes (SIGKILL) 
- **r** - Refresh process list
- **f** - Change filter pattern

When killing processes, you can specify:
- Index numbers: `1 3` (kill processes 1 and 3)
- PIDs directly: `12345`
- Port numbers: `:3000` or `3000`

## Examples

```bash
$ devports
🚀 devports v1.0.0 - Development Server Manager
==================================================

 #  CMD          PID    ADDRESS
-----------------------------------------
 1  node         1234   *:3000
 2  python3      5678   127.0.0.1:8000
 3  ruby         9012   *:4000

Filter: node|python|uvicorn|gunicorn|ruby|rails|php|java|gradle|mvn|go|deno|bun|pnpm|vite|next|nuxt|webpack|rollup|parcel

Actions: [Enter]=exit  k=kill  K=force-kill  r=refresh  f=set filter
> k
Select targets to kill (indices, PIDs, or ports like :3000 3001).
Examples: 1 3  :3000  40520
Selection: :3000
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
curl -fsSL https://raw.githubusercontent.com/stevenhubert/devports/main/install.sh | bash
```

## Development

### Building from Source

```bash
git clone https://github.com/stevenhubert/devports.git
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