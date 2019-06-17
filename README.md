# .config

To set up a fresh machine, format an installation partition `/dev/sdXn` and run

    mount /dev/sdXn /mnt
    nix-shell -p git --run "git clone https://github.com/fricklerhandwerk/.config"
    .config/install <machine>

After rebooting a user logging in should have its `home-manager` configuration active as specified in the `home-config` option.
