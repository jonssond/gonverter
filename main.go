package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

const configFile = ".gonverter-config"

func getConfigPath() string {
	home, err := os.UserHomeDir()
	if err != nil {
		log.Fatal("Failed to get home directory: ", err)
	}
	return filepath.Join(home, configFile)
}

func loadOutputDir() string {
	configPath := getConfigPath()
	data, err := os.ReadFile(configPath)
	if err != nil {
		return ""
	}
	return strings.TrimSpace(string(data))
}

func saveOutputDir(dir string) error {
	configPath := getConfigPath()
	return os.WriteFile(configPath, []byte(dir), 0644)
}

func main() {
	fmt.Println("Welcome to Gonverter!")

	url := flag.String("url", "", "YouTube video URL")
	output := flag.String("output", "", "Output directory")

	flag.Parse()

	if *output != "" && *url == "" {
		if err := saveOutputDir(*output); err != nil {
			log.Fatal("Failed to save output directory:", err)
		}
		fmt.Println("Output directory configured: ", *output)
		return
	}

	if *url == "" {
		fmt.Println("Error: -url flag is required")
		fmt.Println("Usage: gvt -url \"https://youtube.com/...\"")
		fmt.Println("To configure output: gvt -output ./my-music")
		os.Exit(1)
	}

	outputDir := *output
	if outputDir == "" {
		outputDir = loadOutputDir()
		if outputDir == "" {
			outputDir = "./Downloads"
			fmt.Println("No output directory configured. Using default:", outputDir)
		} else {
			fmt.Println("Using saved output directory:", outputDir)
		}
	} else {
		if err := saveOutputDir(outputDir); err != nil {
			log.Println("Warning: Failed to save output directory:", err)
		}
	}

	fmt.Println("URL: ", *url)
	fmt.Println("Output: ", *output)

	cmd := exec.Command("yt-dlp",
		"-x",
		"--audio-format", "mp3",
		"-o", outputDir+"/%(title)s.%(ext)s",
		*url)

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	fmt.Println("Downloading and converting to .mp3...")
	if err := cmd.Run(); err != nil {
		log.Fatal("Failed to download/convert", err)
	}

	fmt.Println("Done!")
}
