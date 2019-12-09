# .config

On a machine with `nix` run

  ./install <machine>

to set up its respective home-manager configuration.

# goals

Primary objective is to configure all my userspace software through `home-manager` on both NixOS and macOS - replacing `homebrew`.

## PRs

- git-remote-gcrypt: fail loudly on any error in `gitception_get`
- home-manager: add systemd mount/automount

## to do

- pin nixpkgs version
- continuous backup to network storage (and retrieval)
- mail
- lock all logged-in sessions for a user on lid close
  - `phsylock` for terminal, `xsecurelock` for `X`
- iPhone backup/sync
- export `osxkeychain` passwords to `pass`

## nice to have

- custom xmobar icon pattern for battery status
- restart xmobar on wakeup
- custom greeter
- switch user on lock screen
- create minimal blog
- create minimal game with graphics (try godot engine)

## ideas for contributions

- darwin packages: vlc, tor-browser-bundle-bin, qutebrowser, wineWow
- home-manager: kitty, iterm2
- nixpkgs: bump iterm2

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
