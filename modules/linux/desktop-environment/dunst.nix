{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        geometry = "300x5-0+28";
        transparency = 30;
        frame_width = 3;
        frame_color = "#7F7F7F";
        separator_height = 3;
        separator_color = "frame";
        font = "Ubuntu 12";
        padding = 10;
        horizontal_padding = 10;
        markup = "full";
        format = "%a\n%s\n%bfoobar";
        dmenu = "${pkgs.dmenu}/bin/dmenu";
        browser = "${pkgs.qutebrowser}/bin/qutebrowser";
        mouse_left_click = "do_action";
        mouse_right_click = "close_current";
        mouse_middle_click = "close_all";
      };

      shortcuts = {
        # NOTE: it is camel case `BackSpace` for some reason
        close = "mod4+BackSpace";
        close_all = "mod4+mod1+BackSpace";
        history = "mod4+shift+BackSpace";
        context = "mod4+grave";
      };

      urgency_low = {
        background = "#000000";
        foreground = "#7F7F7F";
        timeout = 10;
      };
      urgency_normal = {
        background = "#000000";
        foreground = "#FFFFFF";
        timeout = 15;
      };
      urgency_critical = {
        background = "#F00000";
        foreground = "#FFFFFF";
        timeout = 30;
      };
    };
  };
}
