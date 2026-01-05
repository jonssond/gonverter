.PHONY: build install uninstall clean help

IMAGE_NAME := gonverter:latest
INSTALL_DIR := $(HOME)/.local/bin

help: ## Show this help message
	@echo "Gonverter - YouTube to MP3 Converter"
	@echo ""
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build the Docker image
	@echo "Building Docker image..."
	@docker build -t $(IMAGE_NAME) .
	@echo "✓ Build complete!"

install: build ## Build and install gvt command
	@echo "Installing gvt command..."
	@chmod +x gvt
	@mkdir -p $(INSTALL_DIR)
	@ln -sf $(PWD)/gvt $(INSTALL_DIR)/gvt
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

uninstall: ## Remove gvt command and Docker image
	@echo "Uninstalling gvt..."
	@rm -f $(INSTALL_DIR)/gvt
	@docker rmi $(IMAGE_NAME) 2>/dev/null || true
	@echo "✓ Uninstall complete!"

clean: ## Remove Docker image only
	@docker rmi $(IMAGE_NAME) 2>/dev/null || true
	@echo "✓ Docker image removed!"

rebuild: clean build ## Clean and rebuild the Docker image