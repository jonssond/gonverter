# Gonverter 🎵

A simple YouTube to MP3 converter built with Go and Docker. No need to install yt-dlp or any dependencies manually!

## Prerequisites

- Docker installed on your system ([Get Docker](https://docs.docker.com/get-docker/))
- Git (to clone the repository)

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

   This will:
   - Build the Docker image with yt-dlp pre-installed
   - Install the `gvt` command to `~/.local/bin/`
   - Set up everything you need

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

- The `gvt` command is a wrapper script that runs your Go application inside a Docker container
- The Docker container includes yt-dlp, ffmpeg, and all necessary dependencies
- Your files are saved directly to your local filesystem (no need to copy from container)
- Configuration is persisted in `~/.gonverter-config`

## Uninstall

1. Remove the symlink:
   ```bash
   rm ~/.local/bin/gvt
   ```

2. Remove the Docker image:
   ```bash
   docker rmi gonverter:latest
   ```

3. Delete the repository folder

## Development

To rebuild after making changes:
```bash
docker build -t gonverter:latest .
```

## Troubleshooting

**"Docker is not installed" error:**
- Install Docker from https://docs.docker.com/get-docker/

**Permission denied:**
- Make sure the install script is executable: `chmod +x install.sh`

**Command not found after installation:**
- Make sure `~/.local/bin` is in your PATH (see installation step 3)

## License

MIT
