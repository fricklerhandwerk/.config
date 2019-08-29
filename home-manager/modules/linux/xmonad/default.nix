{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dmenu
    haskellPackages.yeganesh
    haskellPackages.xmobar
    kitty
  ];
  xdg.configFile."xmobar/xmobarrc".source = pkgs.writeText "tint2rc" ''
    Config { font = "xft:UbuntuMono:size=10"
       , additionalFonts = []
       , alpha = 255
       , position = Top
       , allDesktops = True
       , overrideRedirect = True
       , commands = [ Run DynNetwork ["-t", "<dev>: <tx> KB/s up | <rx> KB/s down",
                                          "--normal","green","--high","red"] 10
                    , Run MultiCpu ["-t", "CPU: <total>% <autobar>",
                               "--normal","green","--high","red"] 10
                    , Run CpuFreq ["-t","<cpu0> GHz 10" ] 10
                    , Run Memory ["-t","Mem: <usedratio>%"] 10
                    , Run DiskU [("/", "<used>/<size> used")] [] 10
                    , Run DiskIO [("/", "<write> write <read> read")] [] 10
                    , Run Swap [] 10
                    , Run Alsa "default" "Master" []
                    , Run Com "uname" ["-s","-r"] "" 36000
                    , Run Date "%a %Y-%M-%d %H:%M" "date" 20
                    , Run BatteryN ["BAT0"] ["-t", "BAT0: <left>% <timeleft>"] 20 "bat0"
                    , Run BatteryN ["BAT1"] ["-t", "BAT1: <left>% <timeleft>"] 20 "bat1"
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%multicpu% %cpufreq% | %memory% | %swap% | %disku% | %diskio% | %dynnetwork% }\
                    \{ %alsa:default:Master% | %bat0% | %bat1% | <fc=#ee9a00>%date%</fc>"
       }
  '';
  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./config.hs;
    };
  };
}
