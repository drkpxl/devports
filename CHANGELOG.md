# Changelog

All notable changes to devports will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Changed

### Fixed

## [1.2.0] - 2025-08-29

### 🚀 Major Features Added

#### Direct Number Kill Commands
- **One-input kill**: Type just `2` to kill process #2 (instead of `k` → `2` → `y`)
- **Range support**: Kill multiple processes with `2-4` or `1,3,5`
- **Instant workflow**: Reduced 3-step process to 1 step for maximum efficiency

#### Enhanced TUI Interface
- **Beautiful colors**: Color-coded process types (Node=green, Python=blue, etc.)
- **Real-time stats**: CPU usage, memory usage, and uptime for each process
- **Smart port colors**: Port ranges color-coded (3000s=green, 8000s=blue, 4000s=yellow)
- **Improved formatting**: Clean table layout with proper alignment

#### Advanced Features
- **Multiple sort options**: Sort by port, PID, name, CPU usage, or memory usage (`s` command)
- **Toggle display modes**: Switch between basic and extended info (`t` command)  
- **Auto-refresh mode**: Continuous monitoring with `a` command
- **Enhanced help system**: Built-in help with `h` command
- **Better uptime display**: Human-readable format (e.g., "2d 18h 45m")

#### Configuration Options
- **Environment variables**: `DEVPORTS_EXTENDED`, `DEVPORTS_SORT`, `DEVPORTS_REFRESH`
- **Customizable defaults**: Set preferred sort order and display mode
- **Configurable refresh interval**: Adjust auto-refresh timing

### Changed
- **Simplified UI prompts**: Clear action indicators (`1-9=kill` vs previous complex syntax)
- **Enhanced status display**: Real-time filter, sort, and mode indicators
- **Improved confirmation dialogs**: More detailed process information before kill
- **Better error handling**: More informative error messages and fallbacks

### Fixed
- **macOS compatibility**: Fixed process stats collection for macOS `ps` command
- **Input parsing**: Resolved issues with direct number input recognition
- **Index mapping**: Fixed sorted display index resolution for accurate process targeting
- **Array handling**: Improved bash strict mode compatibility for empty arrays
- **Memory safety**: Enhanced error handling for edge cases

### Technical Improvements
- **Better architecture**: Separated concerns with helper functions
- **Enhanced parsing**: Robust selection parsing with range and comma support
- **Improved stability**: Fixed crash issues with bash strict mode
- **Code organization**: Cleaner function structure and better maintainability

## [1.1.0] - 2025-08-29

### Added
- GitHub Actions workflow for automated releases
- GitHub Actions workflow for automated testing on PRs
- Enhanced README with multiple installation options
- Contributing guidelines and release process documentation
- Built-in update checker (`--check-updates`)
- Built-in updater (`--update`)  
- Automatic update notification on startup (non-blocking)
- Version bump helper script (`bump-version.sh`)
- Comprehensive update documentation

## [1.0.0] - 2025-08-29

### Added
- Initial release of devports
- Interactive CLI for viewing and killing development server processes
- Support for filtering by process name or pattern
- Kill processes by index, PID, or port number
- Built-in help and version commands
- Local and system-wide installation options
- Makefile for easy building and installation
- Automatic installer script

### Features
- Shows common development servers by default (node, python, rails, etc.)
- Real-time process list refresh
- Confirmation prompts before killing processes
- Support for both SIGTERM and SIGKILL signals
- Cross-platform compatibility (macOS and Linux)
- Dependency checking and validation