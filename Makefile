# Makefile for devports
# 
# Simple installation and management for the devports CLI tool

PROGRAM_NAME = devports
VERSION = 1.0.0
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
LOCAL_BINDIR = $(HOME)/.local/bin

# Default target
.PHONY: all
all: help

# Show help
.PHONY: help
help:
	@echo "devports v$(VERSION) - Development Server Process Manager"
	@echo ""
	@echo "Available targets:"
	@echo "  help           Show this help message"
	@echo "  test           Run basic tests"
	@echo "  install        Install system-wide to $(BINDIR) (requires sudo)"
	@echo "  install-local  Install locally to $(LOCAL_BINDIR)"
	@echo "  uninstall      Remove system installation"
	@echo "  uninstall-local Remove local installation"
	@echo "  clean          Clean temporary files"
	@echo "  check          Check dependencies and script syntax"
	@echo ""
	@echo "Quick install:"
	@echo "  make install-local   # Recommended for personal use"
	@echo "  sudo make install    # System-wide installation"

# Check dependencies and syntax
.PHONY: check
check:
	@echo "Checking dependencies..."
	@command -v lsof >/dev/null 2>&1 || (echo "❌ lsof not found" && exit 1)
	@command -v awk >/dev/null 2>&1 || (echo "❌ awk not found" && exit 1)
	@echo "✅ Dependencies OK"
	@echo "Checking script syntax..."
	@bash -n $(PROGRAM_NAME) || (echo "❌ Syntax error in $(PROGRAM_NAME)" && exit 1)
	@bash -n install.sh || (echo "❌ Syntax error in install.sh" && exit 1)
	@echo "✅ Syntax OK"

# Basic tests
.PHONY: test
test: check
	@echo "Running basic tests..."
	@./$(PROGRAM_NAME) --version >/dev/null || (echo "❌ Version test failed" && exit 1)
	@./$(PROGRAM_NAME) --help >/dev/null || (echo "❌ Help test failed" && exit 1)
	@echo "✅ Basic tests passed"

# Install system-wide
.PHONY: install
install: check
	@echo "Installing $(PROGRAM_NAME) to $(BINDIR)..."
	@mkdir -p $(BINDIR)
	@install -m 755 $(PROGRAM_NAME) $(BINDIR)/$(PROGRAM_NAME)
	@echo "✅ $(PROGRAM_NAME) installed to $(BINDIR)/$(PROGRAM_NAME)"
	@echo ""
	@echo "You can now run: $(PROGRAM_NAME)"

# Install locally
.PHONY: install-local
install-local: check
	@echo "Installing $(PROGRAM_NAME) to $(LOCAL_BINDIR)..."
	@mkdir -p $(LOCAL_BINDIR)
	@install -m 755 $(PROGRAM_NAME) $(LOCAL_BINDIR)/$(PROGRAM_NAME)
	@echo "✅ $(PROGRAM_NAME) installed to $(LOCAL_BINDIR)/$(PROGRAM_NAME)"
	@echo ""
	@if echo "$$PATH" | grep -q "$(LOCAL_BINDIR)"; then \
		echo "You can now run: $(PROGRAM_NAME)"; \
	else \
		echo "⚠️  $(LOCAL_BINDIR) is not in your PATH"; \
		echo "Add this to your shell profile (~/.bashrc, ~/.zshrc, etc.):"; \
		echo "  export PATH=\"$(LOCAL_BINDIR):\$$PATH\""; \
	fi

# Uninstall system installation
.PHONY: uninstall
uninstall:
	@echo "Removing $(PROGRAM_NAME) from $(BINDIR)..."
	@rm -f $(BINDIR)/$(PROGRAM_NAME)
	@echo "✅ $(PROGRAM_NAME) removed from $(BINDIR)"

# Uninstall local installation
.PHONY: uninstall-local
uninstall-local:
	@echo "Removing $(PROGRAM_NAME) from $(LOCAL_BINDIR)..."
	@rm -f $(LOCAL_BINDIR)/$(PROGRAM_NAME)
	@echo "✅ $(PROGRAM_NAME) removed from $(LOCAL_BINDIR)"

# Clean temporary files
.PHONY: clean
clean:
	@echo "Cleaning temporary files..."
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@find . -name ".DS_Store" -delete 2>/dev/null || true
	@echo "✅ Cleaned"

# Development helpers
.PHONY: dev-test
dev-test:
	@echo "Running development test..."
	@./$(PROGRAM_NAME) --version
	@echo "Test with common filter..."
	@timeout 2s ./$(PROGRAM_NAME) || echo "✅ Interactive test completed (timeout expected)"

.PHONY: lint
lint:
	@if command -v shellcheck >/dev/null 2>&1; then \
		echo "Running shellcheck..."; \
		shellcheck $(PROGRAM_NAME) install.sh || true; \
	else \
		echo "⚠️  shellcheck not found - install for better linting"; \
	fi

# Version bumping (for maintainers)
.PHONY: version
version:
	@echo "Current version: $(VERSION)"
	@grep -n "VERSION=" $(PROGRAM_NAME) | head -1