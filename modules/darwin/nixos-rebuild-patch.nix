with import <nixpkgs/nixos> {};
config.system.build.nixos-rebuild.overrideAttrs (old: {
  postInstall = ''
    # 1. pretend we're on Linux such that evaluation of
    #    configuration expression is not blocked by assertions.
    #    see: <https://github.com/NixOS/nixops/issues/1033>
    # 2. do not put the newly built Linux `nix` into `$PATH`, since we're on
    #    Darwin and are already using the target configuration's version
    substituteInPlace $out/bin/nixos-rebuild \
      --replace "extraBuildFlags=()" "extraBuildFlags=(--argstr system x86_64-linux)" \
      --replace 'PATH="$tmpDir/nix/bin:$PATH"' ""
    # filter `--argstr` parameters back out before passing to remote `nix-store`
    pattern="# We don't want this in buildArgs"
    # WTF `sed`?! line break is mandatory for `i` command to work
    sed -i "0,/$pattern/{/$pattern/i --argstr) shift 2;;
    }" $out/bin/nixos-rebuild
  '';
})
