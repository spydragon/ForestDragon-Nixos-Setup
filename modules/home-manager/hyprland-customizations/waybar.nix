{ ... }:

{
  programs.waybar = {
    enable = true;

    style = /* css */ ''
      * {
        /* `otf-font-awesome` is required to be installed for icons */
        font-family: "Noto Sans CJK KR Regular";
        /*font-family: "D2CodingLigature Nerd Mono";*/
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
        /*    background-color: rgba(43, 48, 59, 0.5); */
        /*    border-bottom: 3px solid rgba(100, 114, 125, 0.5); */
        color: #ffffff;
        transition-property: background-color;
        transition-duration: .5s;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #waybar.empty #window {
        background-color: transparent;
      }

      #workspaces {
      }

      #window {
        margin: 2px;
        padding-left: 8px;
        padding-right: 8px;
        background-color: rgba(0,0,0,0.3);
        font-size:14px;
        font-weight: bold;
      }

      button {
        /* Use box-shadow instead of border so the text isn't offset */
        box-shadow: inset 0 -3px transparent;
        /* Avoid rounded borders under each button name */
        border: none;
        border-radius: 0;
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      button:hover {
        background: inherit;
        border-top: 2px solid #c9545d;
      }

      #workspaces button {
        padding: 0 4px;
        /*    background-color: rgba(0,0,0,0.3); */
      }

      #workspaces button:hover {
      }

      #workspaces button.focused {
        /*    box-shadow: inset 0 -2px #c9545d; */
        background-color: rgba(0,0,0,0.3);
        color:#c9545d;
        border-top: 2px solid #c9545d;
      }

      #workspaces button.active {
        /*    box-shadow: inset 0 -2px #c9545d; */
        background-color: rgba(0,0,0,0.3);
        color:#c9545d;
        border-top: 2px solid #c9545d;
      }

      #workspaces button.urgent {
        background-color: #eb4d4b;
      }

      #mode {
        background-color: #64727D;
        border-bottom: 3px solid #ffffff;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd {
        margin: 2px;
        padding-left: 4px;
        padding-right: 4px;
        background-color: rgba(0,0,0,0.3);
        color: #ffffff;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
      }

      #clock {
        font-size:14px;
        font-weight: bold;
      }

      #battery icon {
        color: red;
      }

      #battery.charging, #battery.plugged {
        color: #ffffff;
        background-color: #26A65B;
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: #000000;
        }
      }

      #battery.warning:not(.charging) {
        background-color: #f53c3c;
        color: #ffffff;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #battery.critical:not(.charging) {
        background-color: #f53c3c;
        color: #ffffff;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      label:focus {
        background-color: #000000;
      }

      #network.disconnected {
        background-color: #f53c3c;
      }

      #temperature.critical {
        background-color: #eb4d4b;
      }

      #idle_inhibitor.activated {
        background-color: #ecf0f1;
        color: #2d3436;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #eb4d4b;
      }

      /*

      window#waybar.solo {
      background-color: #FFFFFF;
      }

      window#waybar.termite {
      background-color: #3F3F3F;
      }

      window#waybar.chromium {
      background-color: #000000;
      border: none;
      }

      */

      #custom-mediaplayer
      {
        font-size: 16px;
        border-radius: 2%;
      }
      @import "../../nixos/modules/home-manager/hyprland-customizations/waybar-mediaplayer/style.css";
    '';

    settings = {
      mainbar = {
        # layer = "top"; # Waybar at top layer
        # position = "bottom"; # Waybar position (top|bottom|left|right)
        height = 24; # Waybar height (to be removed for auto height)
        # width = 1280; # Waybar width
        # spacing = 4; # Gaps between modules (4px)
        # Choose the order of the modules
        modules-left = ["hyprland/workspaces" "hyprland/submap" "sway/scratchpad" "image" "custom/mediaplayer"];
        modules-center = ["sway/window"];
        # modules-right = ["mpd" "idle_inhibitor" "pulseaudio" "network" "cpu" "memory" "temperature" "backlight" "keyboard-state" "battery" "battery#bat2" "clock" "tray"];
        modules-right = [/*"mpd" */"idle_inhibitor" "temperature" "cpu" "memory" "network" "pulseaudio" "backlight" "keyboard-state" "battery" "battery#bat2" "tray" "clock"];
        # Modules configuration
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          warp-on-scroll = false;
          format = "{name}"; # : {icon}
          # format-icons = {
          #   "1" = "";
          #   "2" = "";
          #   "3" = "";
          #   "4" = "";
          #   "5" = "";
          #   urgent = "";
          #   focused = "";
          #   default = "";
          # };
        };
        keyboard-state = {
          numlock = true;
          capslock = true;
          format = "{name} {icon} ";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        "hyprland/submap" = {
          format = "<span style=\"italic\">{}</span>";
        };
        "sway/scratchpad" = {
          format = "{icon} {count}";
          show-empty = false;
          format-icons = ["" ""];
          tooltip = true;
          tooltip-format = "{app}: {title}";
        };
        # mpd = {
        #   # format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
        #   format = "  {title} - {artist} {stateIcon} [{elapsedTime:%M:%S}/{totalTime:%M:%S}] {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}[{songPosition}/{queueLength}] [{volume}%]";
        #   format-disconnected = " Disconnected";
        #   format-stopped = " {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped";
        #   unknown-tag = "N/A";
        #   interval = 2;
        #   consume-icons = {
        #     on = " ";
        #   };
        #   random-icons = {
        #     # off = "<span color=\"#f53c3c\"></span> ";
        #     on = " ";
        #   };
        #   repeat-icons = {
        #     on = " ";
        #   };
        #   "single-icons" = {
        #     on = "1 ";
        #   };
        #   state-icons = {
        #     paused = "";
        #     playing = "";
        #   };
        #   tooltip-format = "MPD (connected)";
        #   tooltip-format-disconnected = "MPD (disconnected)";
        #   on-click = "mpc toggle";
        #   on-click-right = "foot -a ncmpcpp ncmpcpp";
        #   on-scroll-up = "mpc volume +2";
        #   on-scroll-down = "mpc volume -2";

        # };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        tray = {
          # icon-size = 21;
          spacing = 10;
          reverse-direction = true;
        };
        clock = {
          # timezone = "America/Boise";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          # format-alt = "{:%Y-%m-%d}";
          format = "{:L%a %R}";
          # format = "{:%Y-%m-%d %H:%M}";
        };
        cpu = {
          format = "  {usage}%";
          # tooltip = false;
        };
        memory = {
          format = " {}%";
        };
        temperature = {
          thermal-zone = 2;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format-critical = "{icon} {temperatureC}°C";
          format = "{icon} {temperatureC}°C";
          format-icons = [""  ""  ""];
        };
        backlight = {
          # device = "acpi_video1";
          format = "{icon} {percent}%";
          
          # these characters belong to the font "PragmataPro Liga Regular"
          format-icons = [""  ""  ""  ""  ""  ""  ""  ""  ""];
        };
        battery = {
          states = {
            # good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "  {capacity}%";
          format-plugged = "  {capacity}%";
          format-alt = "{icon}  {time}";
          # format-good = ""; # An empty format will hide the module
          # format-full = "";
          format-icons = [""  ""  ""  ""  ""];
        };
        "battery#bat2" = {
          bat = "BAT2";
        };
        network = {
          # interface = "wlp2*"; # (Optional) To force the use of this interface
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = " {ifname}";
          tooltip-format = " {ifname} via {gwaddr}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "Disconnected ⚠ {ifname}";
          format-alt = " {ifname}: {ipaddr}/{cidr}";
        };
        pulseaudio = {
          scroll-step = 5; # %, can be a float
          format = "{icon}  {volume}% {format_source}";
          format-bluetooth = " {icon} {volume}% {format_source}";
          format-bluetooth-muted = "  {icon} {format_source}";
          format-muted = "  {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            # headphone = "";
            # hands-free = "";
            # headset = "";
            # phone = "";
            # portable = "";
            # car = "";
            default = [""  ""  ""];
          };
          on-click = "pavucontrol";
          on-click-right = "foot -a pw-top pw-top";
        };
        image = {
          path = "/tmp/waybar-mediaplayer-art";
          size = 24;
          signal = 4;
          on-click = "feh --auto-zoom --borderless --title 'feh-float' /tmp/waybar-mediaplayer-art";
        };

        "custom/mediaplayer" = {
            exec = "$HOME/nixos/modules/home-manager/hyprland-customizations/waybar-mediaplayer/waybar-mediaplayer-script monitor";
            return-type = "json";
            format = "{}";
            on-click = "$HOME/nixos/modules/home-manager/hyprland-customizations/waybar-mediaplayer/waybar-mediaplayer-script play-pause";
            on-scroll-up = "$HOME/nixos/modules/home-manager/hyprland-customizations/waybar-mediaplayer/waybar-mediaplayer-script next";
            on-scroll-down = "$HOME/nixos/modules/home-manager/hyprland-customizations/waybar-mediaplayer/waybar-mediaplayer-script previous";
            min-length = 20;
            max-length = 20;
        };

      };
    };
  };
}