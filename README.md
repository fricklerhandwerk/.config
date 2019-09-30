# .config

To set up a fresh machine, create an installation image on a system running `nix` and copy it to a USB stick:

    ./build-image
    > /nix/store/.../nixos-iso
    sudo dd if=/nix/store/.../nixos-iso/iso/nixos.iso of=/dev/sdX

Boot from USB, format an installation partition [1] `/dev/sdXn` and run

    mount /dev/sdXn /mnt
    nix-shell -p git --run "git clone https://github.com/fricklerhandwerk/.config"
    .config/install <machine>

After rebooting a user logging in should have its `home-manager` configuration active as specified in the `home-config` option.

[1]: Gentoo has a very extensive [manual](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks#Default:_Using_parted_to_partition_the_disk) to partitioning and formatting. I prefer their GPT partition layout over that from the [NixOS manual](https://nixos.org/nixos/manual/index.html#sec-installation-partitioning) as it allows easy switching of configurations both bootable on BIOS and UEFI systems.

# goals

Primary objective is to fully replace my macOS installations and the occasional Ubuntu with a fully reproducible NixOS.

## PRs

- nixpkgs: user-actkbd (fix pulseaudio)
- nixos-hardware: add declarative option to README

## home config

- pin nixpkgs version
- slimmer interface to home-config (extend `user.users`)
- continuous backup to network storage (and retrieval)
- mail
- lock all logged-in sessions for a user on lid close
  - `phsylock` for terminal, `xsecurelock` for X
- iPhone backup/sync

## machine config

- hardware-configuration under version control
- pin nixpkgs version
- hard disk partitioning/formatting as part of installation script
- add system closure to installation image (reduce time to first boot)
- include `home-manager` packages in installation image (reduce time to first login)
- include secrets in installation image
- full machine image from configuration (`dd` to target disk and run)
- separate repositories for machine and user config
- notify on low battery
- hibernate on critical battery
- hibernate after suspend
- encrypted system partition
- add home server to machine pool
- add remote server to machine pool
- manage machines with NixOps

## nice to have

- custom xmobar icon pattern for battery status
- restart xmobar on wakeup
- custom greeter
- switch user on lock screen
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
