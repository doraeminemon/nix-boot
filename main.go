package main

import (
	"fmt"
	"net/http"
	"os"
	"os/exec"
	"sync"
	"time"

	"github.com/charmbracelet/huh"
)

func checkURLs(urls []string) map[string]bool {
	results := make(map[string]bool)
	var mu sync.Mutex
	var wg sync.WaitGroup

	client := &http.Client{Timeout: 5 * time.Second}

	for _, url := range urls {
		wg.Add(1)
		go func(u string) {
			defer wg.Done()

			resp, err := client.Get(u)
			success := err == nil && resp.StatusCode >= 200 && resp.StatusCode < 400
			if err == nil {
				resp.Body.Close()
			}

			// Lock the map before writing to ensure thread safety
			mu.Lock()
			results[u] = success
			mu.Unlock()
		}(url)
	}

	wg.Wait()
	return results
}

func testingConnectivity() map[string]bool {
	urls := []string{
		"https://cache.nixos.org",
		"https://nixos.org",
		"https://channels.nixos.org",
		"https://releases.nixos.org",
		"https://install.determinate.systems",
		"https://github.com",
		"https://raw.githubusercontent.com",
		"https://tarballs.nixos.org",
		"https://nodejs.org",
		"https://proxy.golang.org",
		"https://deno.land",
	}
	return checkURLs(urls)
}

func form() {
	var email string
	var installNix bool

	// 1. Get User Input
	form := huh.NewForm(
		huh.NewGroup(
			huh.NewInput().
				Title("Enter your email for the SSH key").
				Value(&email),
			huh.NewConfirm().
				Title("Install Nix Package Manager?").
				Value(&installNix),
		),
	)
	form.Run()
}

func generatingSSHKey(email string) {
	// Generate SSH Key
	cmd := exec.Command("ssh-keygen", "-t", "rsa", "-C", email, "-N", "", "-f", os.Getenv("HOME")+"/.ssh/id_rsa")
	if err := cmd.Run(); err != nil {
		fmt.Printf("❌ SSH Key gen failed: %v\n", err)
	}
}

func main() {
	// input unix user name, user's real name, email
	testingConnectivity()
	// boot.sh ( install basic dependencies )
	// nix.sh
	// mise.sh ( installing programming languages )
	// change shell
	// install-nfdl
	// running hw-probe
	// generating ssh-key
	// configuring vscode

	// 2. Run Commands
	fmt.Println("🚀 Starting setup...")
}
