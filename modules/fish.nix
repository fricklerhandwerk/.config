{ config, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      gl = "git log";
      gsh = "git show";
      gst = "git status";
      gd = "git diff";
      gdc = "git diff --cached";
      ga = "git add";
      gc = "git commit";
      gr = "git rebase";
      gri = "git rebase -i";
      grc = "git rebase --continue";
      gra = "git rebase --abort";
      gm = "git mergetool";
      gpl = "git pull";
      gpr = "git pull --rebase";
      gf = "git fetch";
      gfr = "git fetch; and git rebase";
      gp = "git push";
      gco = "git checkout";
    };
  };
}
