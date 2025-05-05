{ ... }:

{

  services.hypridle = {
    enable = true;
    
    settings = {
      general = {
        # avoid starting multiple hyprlock instances.
        # lock before suspend.
        # to avoid having to press a key twice to turn on the display.
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
      };

      listener = [
        {
          # 2.5min.
          # set monitor backlight to minimum, avoid 0 on OLED monitor.
          # monitor backlight restore.
          timeout = 150;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }

        # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
        { 
          # 2.5min.
          # turn off keyboard backlight.
          # turn on keyboard backlight.
          timeout = 150;
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
          on-resume = "brightnessctl -rd rgb:kbd_backlight";
        }

        {
          # 5min
          # lock screen when timeout has passed
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }

        {
          # 5.5min
          # screen off when timeout has passed
          # screen on when activity is detected after timeout has fired.
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
        }

        {
          # 30min
          # suspend pc
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
          };
  };
}