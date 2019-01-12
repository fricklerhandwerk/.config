# .config

To set up a fresh machine, mount the installation partition under `/mnt`, run `nixos-generate-config --root /mnt`, and get `configuration.nix` from this repo in place

    # git archive --remote=git://github.com/fricklerhandwerk/.config.git HEAD configuration.nix | tar -xO /mnt/etc/nixos/configuration.nix

After `nixos-install`, log in as the regular user and instatiate the environment with

    $ home-manager switch

# goals

eventually it should be possible to bootstrap a machine with one command, by running a somewhat simple script from a well known URL such as

    bash <(curl -s https://mydomain.com/bootstrap)

that script should copy `/etc/nixos/configuration.nix` from the repository, which on build should fetch and instantiate `home-manager` configuration for specified users. after that, the user is responsible to do `home-manager switch`.

the simplest stupid approach may be to fetch machine configuration from a machine-specific repo on installation

    # nixos-generate-config --root /mnt
    # git archive --remote=git://github.com/my/machine HEAD configuration.nix | tar -xC /mnt/etc/
    # nixos-install

and get user configuration from a user-specific repo once the user is available

    $ git clone git://github.com/my/.config .config
    $ home-manager switch

this lacks the elegant modular approach of [^1], where machine configuration can be specified over some baseline, but cleanly separates machine and user concerns. unfortunately this is very far away from one single command.

# prior art

[^1] has an intriguing single-user concept for configuration management: system configuration contains a script to run `home-manager`, where `home.nix` is not user- but machine-specific. this elegantly solves the problem how to reference `home.nix` from `configuration.nix` by wrapping it in a nix expression which uses hard coded absolute paths to the respective files.

[^1]: https://github.com/dustinlacewell/dotfiles/

