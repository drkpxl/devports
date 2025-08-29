# devports

Interactive CLI tool for viewing and killing development server processes.

## What it does

`devports` shows you all the development servers running on your machine (node, python, rails, etc.) in a clean, interactive interface. You can easily kill processes by index, PID, or port number.

## Installation

### Homebrew (Recommended)

```bash
brew install stevenhubert/tap/devports
```

### Manual Installation

```bash
curl -fsSL https://raw.githubusercontent.com/stevenhubert/devports/main/install.sh | bash
```

Or download and run locally:

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

## Building from Source

```bash
git clone https://github.com/stevenhubert/devports.git
cd devports
make check    # Verify dependencies and syntax
make test     # Run basic tests
make install-local  # Install to ~/.local/bin
```

## License

MIT License - see [LICENSE](LICENSE) file for details.