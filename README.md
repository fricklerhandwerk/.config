# .config

To set up a fresh machine, mount the installation partition under `/mnt`, run `nixos-generate-config --root /mnt`, then

    nix-shell -p git --run "git clone https://github.com/fricklerhandwerk/.config"
    NIXOS_CONFIG=$(pwd)/.config/machines/<machine>/default.nix nixos-install

After rebooting a user logging in should have its `home-manager` configuration active as specified in the `home-config` option.
