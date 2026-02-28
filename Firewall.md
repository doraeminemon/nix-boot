| Domain / URL                | Header 2                                            | Header 3    |
| --------------------------- | --------------------------------------------------- | ----------- |
| cache.nixos.org             | **Critical:** Official Nix Binary Cache (S3-backed) | HTTPS (443) |
| nixos.org                   | Main Project Website & Documentation                | HTTPS (443) |
| channels.nixos.org          | Package channel & versioning metadata               | HTTPS (443) |
| install.determinate.systems | Modern Nix Installer Endpoint                       | HTTPS (443) |
| github.com                  | Source code for Flakes and Community Apps           | HTTPS (443) |
| raw\.githubusercontent.com  | Direct script/plugin downloads (Fisher, etc.)       | HTTPS (443) |
| tarballs.nixos.org          | Fallback mirror for source dependencies             | HTTPS (443) |

Nix is **cryptographically secure**. Every package downloaded from `cache.nixos.org` is verified against a public key using **SHA-256** hashes. Even if the connection were intercepted, Nix would refuse to install a package if the hash didn't match the official definition.
