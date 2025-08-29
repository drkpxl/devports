# Changelog

All notable changes to devports will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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