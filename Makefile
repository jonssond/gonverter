.PHONY: build install uninstall clean help

INSTALL_DIR := $(HOME)/.local/bin

help: ## Show this help message
    @echo "Gonverter - YouTube to MP3 Converter"
    @echo ""
    @echo "Available commands:"
    @grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build the Go binary
    @echo "Building gonverter..."
    @go build -o gonverter main.go
    @echo "✓ Build complete!"

install: build ## Build and install gvt command
    @echo "Installing gvt command..."
    @mkdir -p $(INSTALL_DIR)
    @cp gonverter $(INSTALL_DIR)/gvt
    @chmod +x $(INSTALL_DIR)/gvt
    @echo "✓ Installation complete!"
    @echo ""
    @echo "Usage examples:"
    @echo "  gvt -output ~/Music"
    @echo "  gvt -url \"https://youtube.com/watch?v=...\""
    @echo ""
    @if ! echo "$$PATH" | grep -q "$(INSTALL_DIR)"; then \
        echo "⚠️  Add $(INSTALL_DIR) to your PATH:"; \
        echo "  export PATH=\"\$$PATH:$(INSTALL_DIR)\""; \
    fi

uninstall: ## Remove gvt command
    @echo "Uninstalling gvt..."
    @rm -f $(INSTALL_DIR)/gvt
    @echo "✓ Uninstall complete!"

clean: ## Remove built binary
    @rm -f gonverter
    @echo "✓ Clean complete!"

rebuild: clean build ## Clean and rebuild