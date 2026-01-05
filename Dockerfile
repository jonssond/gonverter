FROM golang:1.23-alpine AS builder

WORKDIR /app

# Install dependencies
RUN apk add --no-cache git

# Copy go mod files
COPY go.mod ./

# Copy source code
COPY main.go ./

# Build the application
RUN go build -o gonverter main.go

# Final stage
FROM alpine:latest

# Install yt-dlp and its dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    ffmpeg \
    && pip3 install --break-system-packages --no-cache-dir yt-dlp

# Copy the built binary from builder
COPY --from=builder /app/gonverter /usr/local/bin/gonverter

# Create a directory for downloads
WORKDIR /downloads

ENTRYPOINT ["gonverter"]
CMD ["--help"]