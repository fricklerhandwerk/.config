# .config

## installation

on a machine with [`nix`](https://nixos.org/download.html) run

    ./install <machine>

to set up its respective `home-manager` configuration.

## design ideas

high-level goal is a portable user environment configuration that works across NixOS/Linux and macOS/Darwin and can be bootstrapped with one command. it does not depend on system properties and does not require `root` access.

- `./machines` contains entry points for each machine, which import configuration `./profiles` and define machine-specific values. 

- `./profiles` vary over the kernel (`common`, `darwin`, `linux`) and additional features such as `graphical` (only Linux) or `crypto`.

- `./modules` currently only has one entry [`machine.nix`](https://github.com/fricklerhandwerk/.config/blob/master/modules/machine.nix). this is a little hack to wire up the `home-manager` wrapper in a given environment to automatically use the right configuration for that machine. It requires adding a `machine = ./.` to each entry point `./machines/<machine>/default.nix`.

- `./overlays` define package customizations and combine them in a global [overlay](https://nixos.org/manual/nixpkgs/stable/#chap-overlays).

code reuse is achieved only through `imports`. tradeoff reasoning was to avoid the complexity of implementing [`home-manager` modules](https://rycee.gitlab.io/home-manager/index.html#ch-writing-modules) for every profile, and to minimize custom glue code and indrections to keep readability high. ideally the intention should be obvious from directory structure and explicit import relations. downside is duplication in directory names and more manual interaction for wiring everything up, which is both acceptable for currently few machines. thus most of the code is actual configuration and has very little functional overhead.

## ideas for the future

- merge NixOS system and `home-manager` user environment configuration repositories

  the advantage is to have everything in one place, and being able to pin `nixpkgs` for system and user configuration at the same time.

  originally it was that way, but I split out the system configuration, as it was the easiest boundary for separating

  1. system and user configuration
  2. publicly visible educational configuration and private information about other users.

  pinning did not happen to be a big problem so far: upgrading the NixOS release required manually re-building the user environment with a matching version of `home-manager`.

  managing part of the configuration parameters privately will add complexity and indirection! if the public part is not supposed to reveal the private part's structure, there needs to be a generic import of an opaque directory (e.g. `./private`), which in itself may be a `git` [submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) pointing to an [encrypted](https://github.com/spwhitton/git-remote-gcrypt) repository. that submodule needs to figure out on its own which features are required for the current machine. using the module system is unavoidable in this case.

- user environment: detect machine automatically

  that would reduce boilerplate a little bit and remove the need to pass a parameter to the `./install` script.

## prior art

- well-documented, cross-platform setup:

  https://github.com/rummik/nixos-config/

  interesting idea: automatically pick configuration [based on hostname](https://github.com/rummik/nixos-config/blob/55023e003095a1affb26906c56ffb883803af354/nix/hostname.nix)

- this served as the main reference on how to use NixOS and `home-manager`:

  https://github.com/dustinlacewell/dotfiles

- interesting thoughts on how to word `git` commit messages:

  https://github.com/yrashk/nix-config

  https://github.com/yrashk/nix-home

- ideas on a mouse-free life and general computer interface minimalism:

  https://github.com/noctuid/dotfiles

- arguments against minimalism:

  http://xahlee.info/linux/why_tiling_window_manager_sucks.html

- an attempt at full hands-off deployment [before flakes](https://github.com/balsoft/nixos-config/tree/e5d5ef5cb9ee26d9c6a8d56ea0b8f7884b33644a), nowadays an intricate but well-maintained setup:

  https://github.com/balsoft/nixos-config

- high-level ideas on how to design a `nix` configuration:

  https://www.reddit.com/r/NixOS/comments/9aa08b/whats_your_configurationnix_like/e4xuwak/

- pulling NixOps deployment secrets from `pass`:

  https://elvishjerricco.github.io/2018/06/24/secure-declarative-key-management.html

- installer image for encrypted partition:

  https://github.com/techhazard/nixos-iso
