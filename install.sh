#!/bin/bash

set -e

echo "Installing Gonverter..."

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed."
    echo "Please install Docker first: https://docs.docker.com/get-docker/"
    exit 1
fi

# Build the Docker image
echo "Building Docker image..."
docker build -t gonverter:latest "$SCRIPT_DIR"

if [ $? -ne 0 ]; then
    echo "Error: Failed to build Docker image"
    exit 1
fi

# Make the wrapper script executable
chmod +x "$SCRIPT_DIR/gvt"

# Determine installation directory
INSTALL_DIR="${1:-$HOME/.local/bin}"

# Create installation directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Create symlink or copy the wrapper script
if [ -L "$INSTALL_DIR/gvt" ]; then
    rm "$INSTALL_DIR/gvt"
fi

ln -sf "$SCRIPT_DIR/gvt" "$INSTALL_DIR/gvt"

echo ""
echo "✓ Gonverter installed successfully!"
echo ""
echo "Installation location: $INSTALL_DIR/gvt"
echo ""

# Check if the installation directory is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "⚠️  Warning: $INSTALL_DIR is not in your PATH"
    echo ""
    echo "Add this line to your ~/.bashrc or ~/.zshrc:"
    echo "  export PATH=\"\$PATH:$INSTALL_DIR\""
    echo ""
    echo "Then run: source ~/.bashrc (or ~/.zshrc)"
else
    echo "You can now use the 'gvt' command!"
fi

echo ""
echo "Usage examples:"
echo "  gvt -output ~/Music          # Set default output directory"
echo "  gvt -url \"https://youtube.com/watch?v=...\"  # Download video"