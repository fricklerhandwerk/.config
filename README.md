# .config

To set up a fresh machine, mount the installation partition under `/mnt`, run `nixos-generate-config --root /mnt`, and get `configuration.nix` from this repo in place

    # git archive --remote=git://github.com/fricklerhandwerk/.config.git HEAD configuration.nix | tar -xO /mnt/etc/nixos/configuration.nix

After `nixos-install`, a user logging in should have its `home-manager` configuration active as specified in `configuration.nix`

subsequent system rebuilds must only activate the global `home-manager` configuration for a user if and only if none existed at build time.
