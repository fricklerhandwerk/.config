# .config

To set up a fresh machine, format an installation partition `/dev/sdXn` and run

    mount /dev/sdXn /mnt
    nix-shell -p git --run "git clone https://github.com/fricklerhandwerk/.config"
    .config/install <machine>

After rebooting a user logging in should have its `home-manager` configuration active as specified in the `home-config` option.

# goals

Primary objective is to fully replace my macOS installations and the occasional Ubuntu with a fully reproducible NixOS.

## PRs

- nixpkgs: user-actkbd (fix pulseaudio)
- nixos-hardware: add declarative option to README
- nixos: fix NetworkManager rename on 18.09 (backport from `staging`)

## home config

- separate entry points for different machines/machine types (e.g. server, laptop, workstation)
- add gpg secrets automatically
- slimmer interface to home-config (extend `user.users`)
- `ssh-add` at startup
- vim config
- git config
- continuous backup to network storage (and retrieval)
- status bar
- mail
- lock all logged-in sessions for a user on lid close
  - `phsylock` for terminal, `xsecurelock` for X
- terminal font scaling key commands

## machine config

- do not install `home-manager` for users (just run activation script)
- wait for `network-online` on 19.03
- hardware-configuration under version control
- hard disk formatting as part of installation script
- add system closure to installation image (reduce time to first boot)
- include `home-manager` packages in installation image (reduce time to first login)
- include secrets in installation image
- full machine image from configuration (`dd` to target disk and run)
- separate repositories for machine and user config
- notify on low battery
- hibernate on critical battery
- hibernate after suspend
- encrypted system partition
- add workstation to machine pool
- add home server to machine pool
- add remote server to machine pool
- manage machines with NixOps
- limit systemd service shutdown wait time
- limit grub screen wait time

## nice to have

- color theme for uxterm
- custom greeter
- switch user on lock screen
- create minimal python package
- create minimal blog
- create minimal game with graphics (try godot engine)

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
