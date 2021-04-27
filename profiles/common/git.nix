{ pkgs, ... }:
let
  diff = "${pkgs.gitAndTools.diff-so-fancy}/bin/diff-so-fancy";
  less = "less --tabs=2 -RFX";
in
{
  programs.git = {
    enable = true;
    package = with pkgs; symlinkJoin {
      name = "git";
      paths = [ gitMinimal ];
      buildInputs = [ makeWrapper ];
      # make `git-remote-gcrypt` and therefore `gpg` aware of the calling
      # `tty`.  this is needed because `git` runs its remote-helpers without
      # `tty` hooked up. while this is not a problem in an `xsession` where
      # `$DISPLAY` is set and we get a graphical prompt, `gpg` fails to pick up
      # the password from `pinentry-curses` in an actual console without that
      # variable set correctly.
      # this took a whole day to find out and finally fix.
      # NOTE: this should not be an overlay, otherwise all kinds of stuff that
      # depends on `git` (such as `wine`) will have to be rebuilt.
      postBuild = ''
        wrapProgram $out/bin/git --run "export GPG_TTY=\$(tty)"
      '';
    };
    userName = "fricklerhandwerk";
    userEmail = "valentin@fricklerhandwerk.de";
    extraConfig = {
      core = {
        pager = "${diff} | ${less}";
      };
      pager = {
        log = "${diff} | ${less}";
        show = "${diff} | ${less}";
        diff = "${diff} | ${less}";
      };
      push = {
        default = "matching";
      };
      pull = {
        rebase = true;
      };
      merge = {
        tool = "nvim";
        ff = false;
      };
      "mergetool \"nvim\"".cmd = "nvim -f -c \"Gdiff\" \"$MERGED\"";
    };
    ignores = [ ".DS_Store" ];
  };
  home.packages = with pkgs; [
    gitAndTools.hub
    gitAndTools.gitRemoteGcrypt
    unstable.gitAndTools.git-filter-repo
  ];
}
