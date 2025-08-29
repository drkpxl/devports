#!/usr/bin/env bash
#
# devports installer
# 
# Install devports system-wide or locally
#

set -euo pipefail

PROGRAM_NAME="devports"
RAW_URL="https://raw.githubusercontent.com/drkpxl/devports/main"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}" >&2
}

show_help() {
    cat << EOF
$PROGRAM_NAME installer

USAGE:
    $0 [OPTIONS]

OPTIONS:
    -h, --help         Show this help message
    -l, --local        Install to ~/.local/bin (default)
    -s, --system       Install system-wide to /usr/local/bin (requires sudo)
    -u, --uninstall    Uninstall $PROGRAM_NAME
    -f, --force        Force installation (overwrite existing)

EXAMPLES:
    $0                 # Install locally to ~/.local/bin
    $0 --system        # Install system-wide
    $0 --uninstall     # Remove installation

EOF
}

check_dependencies() {
    local missing=()
    
    command -v curl >/dev/null 2>&1 || command -v wget >/dev/null 2>&1 || missing+=("curl or wget")
    command -v lsof >/dev/null 2>&1 || missing+=("lsof")
    command -v awk >/dev/null 2>&1 || missing+=("awk")
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        print_error "Missing required dependencies: ${missing[*]}"
        echo
        echo "On macOS:"
        echo "  (lsof is pre-installed)"
        echo
        echo "On Ubuntu/Debian:"
        echo "  sudo apt-get update && sudo apt-get install lsof gawk curl"
        echo
        echo "On CentOS/RHEL:"
        echo "  sudo yum install lsof gawk curl"
        exit 1
    fi
}

download_file() {
    local url="$1"
    local output="$2"
    
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" -o "$output"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$url" -O "$output"
    else
        print_error "Neither curl nor wget found"
        exit 1
    fi
}

install_devports() {
    local install_dir="$1"
    local force_install="${2:-false}"
    local install_path="$install_dir/$PROGRAM_NAME"
    local temp_file
    temp_file="$(mktemp)"
    
    print_info "Installing $PROGRAM_NAME to $install_dir"
    
    # Create install directory if it doesn't exist
    mkdir -p "$install_dir"
    
    # Download the script
    print_info "Downloading $PROGRAM_NAME..."
    if [[ -f "./devports" ]]; then
        # Installing from local copy
        cp "./devports" "$temp_file"
    else
        # Download from GitHub
        download_file "$RAW_URL/devports" "$temp_file"
    fi
    
    # Verify download
    if [[ ! -s "$temp_file" ]]; then
        print_error "Failed to download $PROGRAM_NAME"
        rm -f "$temp_file"
        exit 1
    fi
    
    # Install
    if [[ -f "$install_path" && "$force_install" != "true" ]]; then
        print_warning "$PROGRAM_NAME already exists at $install_path"
        if [[ -t 0 ]]; then
            # Interactive terminal
            printf "Overwrite? [y/N] "
            read -r response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
                print_info "Installation cancelled"
                rm -f "$temp_file"
                exit 0
            fi
        else
            # Being piped, default to yes
            print_info "Overwriting existing installation (use --force to skip this prompt)"
        fi
    fi
    
    mv "$temp_file" "$install_path"
    chmod +x "$install_path"
    
    print_success "$PROGRAM_NAME installed to $install_path"
    
    # Check if install directory is in PATH
    if [[ ":$PATH:" != *":$install_dir:"* ]]; then
        print_warning "$install_dir is not in your PATH"
        echo
        
        # Try to add to PATH automatically
        local shell_rc=""
        if [[ -n "$ZSH_VERSION" ]]; then
            shell_rc="$HOME/.zshrc"
        elif [[ -n "$BASH_VERSION" ]]; then
            shell_rc="$HOME/.bashrc"
        fi
        
        if [[ -n "$shell_rc" ]]; then
            if [[ -w "$shell_rc" ]]; then
                echo "Adding $install_dir to PATH in $shell_rc..."
                echo "export PATH=\"$install_dir:\$PATH\"" >> "$shell_rc"
                print_success "PATH updated! Restart your terminal or run: source $shell_rc"
            elif [[ ! -f "$shell_rc" ]]; then
                echo "Creating $shell_rc and adding PATH..."
                echo "export PATH=\"$install_dir:\$PATH\"" > "$shell_rc"
                print_success "PATH configured! Restart your terminal to use $PROGRAM_NAME"
            else
                echo "Cannot write to $shell_rc (permission denied)"
                echo "Run this command to fix:"
                echo "  sudo chown $USER:staff $shell_rc"
                echo "Then rerun the installer, or add manually:"
                echo "  export PATH=\"$install_dir:\$PATH\""
            fi
            echo
            print_success "Then run: $PROGRAM_NAME --help"
        else
            echo "To use $PROGRAM_NAME, add this to your shell profile:"
            echo "  export PATH=\"$install_dir:\$PATH\""
            echo
            echo "Or run directly with full path:"
            echo "  $install_path --help"
            echo
        fi
    else
        print_success "Installation complete! Run '$PROGRAM_NAME --help' to get started."
    fi
}

uninstall_devports() {
    local locations=(
        "$HOME/.local/bin/$PROGRAM_NAME"
        "/usr/local/bin/$PROGRAM_NAME"
        "/usr/bin/$PROGRAM_NAME"
    )
    
    local found=false
    for location in "${locations[@]}"; do
        if [[ -f "$location" ]]; then
            print_info "Removing $location"
            if [[ "$location" == "/usr/local/bin/$PROGRAM_NAME" || "$location" == "/usr/bin/$PROGRAM_NAME" ]]; then
                sudo rm -f "$location"
            else
                rm -f "$location"
            fi
            found=true
        fi
    done
    
    if [[ "$found" == "true" ]]; then
        print_success "$PROGRAM_NAME uninstalled successfully"
    else
        print_warning "$PROGRAM_NAME not found in common installation locations"
    fi
}

main() {
    # Default to /usr/local/bin if writable, otherwise ~/.local/bin
    local INSTALL_DIR="$HOME/.local/bin"
    if [[ -w "/usr/local/bin" ]]; then
        INSTALL_DIR="/usr/local/bin"
    fi
    
    local SYSTEM_INSTALL=false
    local UNINSTALL=false
    local FORCE=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -l|--local)
                INSTALL_DIR="$HOME/.local/bin"
                SYSTEM_INSTALL=false
                shift
                ;;
            -s|--system)
                INSTALL_DIR="/usr/local/bin"
                SYSTEM_INSTALL=true
                shift
                ;;
            -u|--uninstall)
                UNINSTALL=true
                shift
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information."
                exit 1
                ;;
        esac
    done
    
    print_info "🚀 $PROGRAM_NAME installer"
    echo
    
    if [[ "$UNINSTALL" == "true" ]]; then
        uninstall_devports
        exit 0
    fi
    
    check_dependencies
    
    if [[ "$SYSTEM_INSTALL" == "true" ]]; then
        if [[ $EUID -ne 0 && -z "${SUDO_USER:-}" ]]; then
            print_info "System installation requires sudo privileges"
            exec sudo "$0" "$@"
        fi
    fi
    
    install_devports "$INSTALL_DIR" "$FORCE"
}

# Only run main if script is executed directly
if [[ "${BASH_SOURCE:-$0}" == "${0}" ]]; then
    main "$@"
fi