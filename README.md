# .config

To set up a fresh machine, format an installation partition `/dev/sdXn` and run

    mount /dev/sdXn /mnt
    nix-shell -p git --run "git clone https://github.com/fricklerhandwerk/.config"
    .config/install <machine>

After rebooting a user logging in should have its `home-manager` configuration active as specified in the `home-config` option.

# prior art

so far served as the main reference on how to use nixos and home-manager:
https://github.com/dustinlacewell/dotfiles

also with interesting thoughts on git commit messages:
https://github.com/yrashk/nix-config
https://github.com/yrashk/nix-home

ideas on a mouse-free life and general computer interface minimalism:
https://github.com/noctuid/dotfiles

arguments against minimalism:
http://xahlee.info/linux/why_tiling_window_manager_sucks.html

trying to do full hands-off deployment:
https://github.com/balsoft/nixos-config

https://elvishjerricco.github.io/2018/06/24/secure-declarative-key-management.html
https://www.reddit.com/r/NixOS/comments/9aa08b/whats_your_configurationnix_like/e4xuwak/

installer image for encrypted partition:
https://github.com/techhazard/nixos-iso
