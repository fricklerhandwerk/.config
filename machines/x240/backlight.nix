{ config, pkgs,  ... }:
{
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = let step = "85"; light = "${pkgs.light}/bin/light -r"; in [
      { keys = [224]; events = ["key"]; command = "${light} -U ${step}"; }
      { keys = [225]; events = ["key"];
        command = "${pkgs.writeScript "brightness-up" ''
          if [[ $(${light} -G) -eq "0" ]]; then
            ${light} -S 1
          else
            ${light} -A ${step}
          fi
        ''}";
      }
    ];
  };
}
