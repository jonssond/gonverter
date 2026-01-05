# Gonverter 🎵

A simple YouTube to MP3 converter built with Go.

## Prerequisites

- Go 1.23 or higher ([Get Go](https://golang.org/dl/))
- The installer will check and optionally install:
  - Python 3
  - ffmpeg
  - yt-dlp

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/jonssond/gonverter.git
   cd gonverter
   ```

2. **Run the installer:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

   The installer will:
   - Check for required dependencies (Python 3, ffmpeg, yt-dlp)
   - Offer to install missing dependencies automatically
   - Build and install the `gvt` command to `~/.local/bin/`

3. **Add to PATH (if needed):**
   
   If the installer warns that `~/.local/bin` is not in your PATH, add this line to your `~/.bashrc` or `~/.zshrc`:
   ```bash
   export PATH="$PATH:$HOME/.local/bin"
   ```
   
   Then reload your shell:
   ```bash
   source ~/.bashrc  # or ~/.zshrc
   ```

## Usage

### Set a default output directory
```bash
gvt -output ~/Music
```

### Download and convert a video
```bash
gvt -url "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
```

### Specify output directory for a single download
```bash
gvt -output ~/Downloads -url "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
```

## How It Works

- The `gvt` command is a compiled Go binary that calls `yt-dlp`
- Downloads are saved directly to your specified directory
- Configuration is persisted in `~/.gonverter-config`

## Manual Dependency Installation

If automatic installation fails, install these manually:

### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install python3 python3-pip ffmpeg
pip3 install --user yt-dlp
```

### Fedora
```bash
sudo dnf install python3 python3-pip ffmpeg
pip3 install --user yt-dlp
```

### Arch Linux
```bash
sudo pacman -S python python-pip ffmpeg
pip3 install --user yt-dlp
```

### macOS
```bash
brew install python3 ffmpeg
pip3 install yt-dlp
```

## Uninstall

```bash
rm ~/.local/bin/gvt
```

## Troubleshooting

**"go: command not found":**
- Install Go from https://golang.org/dl/

**"yt-dlp: command not found" after installation:**
- Make sure `~/.local/bin` is in your PATH
- Try: `pip3 install --user yt-dlp`

**Permission denied:**
- Make sure the install script is executable: `chmod +x install.sh`