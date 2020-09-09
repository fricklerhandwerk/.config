{ pkgs, ... }:
with pkgs;
let
  script = writeScriptBin "fix-time-machine" (builtins.readFile ./fix-time-machine.sh);
  fix-time-machine = script.overrideAttrs (old: {
    buildInputs = [ makeWrapper ];
    fixupPhase = ''
      patchShebangs $out/bin
      wrapProgram $out/bin/fix-time-machine \
        --prefix PATH : "${stdenv.lib.makeBinPath [ ripgrep gnused ]}"
    '';
  });
in
{
  home.packages = [ fix-time-machine ];
}
