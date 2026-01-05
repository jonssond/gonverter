#!/bin/bash

set -e

echo "Installing Gonverter..."

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to install dependencies on different systems
install_dependencies() {
    echo ""
    echo "Installing dependencies..."
    
    if command_exists apt-get; then
        # Debian/Ubuntu
        sudo apt-get update
        sudo apt-get install -y python3 python3-pip ffmpeg
        pip3 install --user yt-dlp
    elif command_exists dnf; then
        # Fedora
        sudo dnf install -y python3 python3-pip ffmpeg
        pip3 install --user yt-dlp
    elif command_exists yum; then
        # CentOS/RHEL
        sudo yum install -y python3 python3-pip ffmpeg
        pip3 install --user yt-dlp
    elif command_exists pacman; then
        # Arch Linux
        sudo pacman -S --noconfirm python python-pip ffmpeg
        pip3 install --user yt-dlp
    elif command_exists brew; then
        # macOS
        brew install python3 ffmpeg
        pip3 install yt-dlp
    else
        echo "Error: Could not detect package manager."
        echo "Please install manually:"
        echo "  - Python 3"
        echo "  - ffmpeg"
        echo "  - yt-dlp (pip3 install yt-dlp)"
        exit 1
    fi
}

# Check for dependencies
MISSING_DEPS=()

if ! command_exists python3; then
    MISSING_DEPS+=("python3")
fi

if ! command_exists ffmpeg; then
    MISSING_DEPS+=("ffmpeg")
fi

if ! command_exists yt-dlp; then
    MISSING_DEPS+=("yt-dlp")
fi

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo ""
    echo "Missing dependencies: ${MISSING_DEPS[*]}"
    echo ""
    read -p "Would you like to install them now? (y/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_dependencies
        echo "✓ Dependencies installed!"
    else
        echo ""
        echo "Installation cancelled. Please install the following manually:"
        for dep in "${MISSING_DEPS[@]}"; do
            echo "  - $dep"
        done
        exit 1
    fi
fi

# Check for Go
if ! command_exists go; then
    echo "Error: Go is not installed."
    echo "Please install Go from: https://golang.org/dl/"
    exit 1
fi

# Build the application
echo ""
echo "Building gonverter..."
cd "$SCRIPT_DIR"
go build -o gonverter main.go

if [ $? -ne 0 ]; then
    echo "Error: Failed to build gonverter"
    exit 1
fi

# Determine installation directory
INSTALL_DIR="${1:-$HOME/.local/bin}"

# Create installation directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Copy the binary
cp "$SCRIPT_DIR/gonverter" "$INSTALL_DIR/gvt"
chmod +x "$INSTALL_DIR/gvt"

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