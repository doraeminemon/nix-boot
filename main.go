package main

import (
	"fmt"
	"os"
	"os/exec"

	"github.com/charmbracelet/huh"
)

func main() {
	// input unix user name, user's real name, email
	// testing-connectivity.sh -> rewrite into golang code
	// boot.sh ( install basic dependencies )
	// nix.sh
	// mise.sh ( installing programming languages )
	// change shell
	// install-nfdl
	// running hw-probe
	// generating ssh-key
	// configuring vscode
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

	// 2. Run Commands
	fmt.Println("🚀 Starting setup...")

	// Generate SSH Key
	cmd := exec.Command("ssh-keygen", "-t", "ed25519", "-C", email, "-N", "", "-f", os.Getenv("HOME")+"/.ssh/id_ed25519")
	if err := cmd.Run(); err != nil {
		fmt.Printf("❌ SSH Key gen failed: %v\n", err)
	}

	if installNix {
		// Run the Nix multi-user install script
		fmt.Println("📦 Installing Nix...")
		// ... execution logic here
	}
}
