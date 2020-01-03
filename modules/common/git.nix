{ pkgs, ... }:
let
  diff = "${pkgs.gitAndTools.diff-so-fancy}/bin/diff-so-fancy";
  less = "less --tabs=2 -RFX";
in
{
  programs.git = {
    enable = true;
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
  ];
}
