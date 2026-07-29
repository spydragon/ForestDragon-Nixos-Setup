{ self, inputs, ... }: {

  flake.nixosModules.myWaybar = {pkgs, lib, ... }: {
    programs.waybar = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myWaybar;
    };

    systemd.user.services.waybar = {
      enable = false;
    };

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };

  perSystem = { pkgs, lib, self', ... }: {

    packages.myWaybar = inputs.wrapper-modules.wrappers.waybar.wrap {
      inherit pkgs;
      settings = {
        layer = "top";
        position = "left";
        # height = ;
	    width = 40;

        modules-left = [
          "group/power"
          "custom/playpause"
          "custom/wallpaper"
          "niri/workspaces"
        ];

        modules-center = [
          "niri/window"
        ];

        modules-right = [
          "network"
          "group/apps"
          "group/stats"
          "clock"
        ];

        clock = {
          # timezone = "America/New_York";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%m\n%d\n%y}";
          format = "{:%H\n%M}";
          interval = 60;
        };

        bluetooth = {
          format = "";
          rotation = 90;
        };

        pulseaudio = {
          # scroll-step = 1; # %; can be a float
          format = "{volume}\n{icon}";
          format-bluetooth = "{volume}\n{icon}";
          format-bluetooth-muted = "MUT\n{icon}";
          format-muted = "MUT\n󰝟";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = " ";
            hands-free = "";
            headset = " ";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          tooltip = false;
          justify = "center";
          reverse-scrolling = true;
        };

        "pulseaudio/slider" = {
          min = 0;
          max = 100;
          orientation = "vertical";
        };

        "group/audio" = {
          modules = [
            "pulseaudio"
            "pulseaudio/slider"
          ];
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = true;
          };
        };

        backlight = {
          format = "{percent}\n{icon}";
          format-icons = ["" "" "" "" "" "" "" "" ""];
          tooltip = false;
          justify = "center";
          reverse-scrolling = true;
        }
        ;
        "custom/brightness" = {
          exec = "smart-dimmer get-value";
          return-type = "json";
          signal = 8;
          justify = "center";
          format = "{text}\n{icon}";
          format-icons = ["" "" "" "" "" "" "" "" ""];
          on-scroll-up = "${lib.getExe self'.packages.smartDimmer} +0.05";
          on-scroll-down = "${lib.getExe self'.packages.smartDimmer} -0.05";
        };

        "backlight/slider" = {
          min = 0;
          max = 100;
          orientation = "vertical";
        };

        "group/brightness" = {
          modules = [
            "custom/brightness"
            # "backlight/slider"
          ];
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = true;
          };
        };

        battery = {
          states = {
            # good = 95;
            warning = 20;
            critical = 15;
          };
	      events = {
	        on-discharging-warning = "${lib.getExe pkgs.libnotify} -u normal 'Battery Low' 'Battery is at 20%'";
	        on-discharging-critical = "${lib.getExe pkgs.libnotify} -u critical 'Battery Critical' 'Plug in now!'";
	        on-charging-100 = "${lib.getExe pkgs.libnotify} -u normal 'Battery Full' 'Fully charged.'";
	      };
          format = "{capacity}\n{icon}";
          format-full = "{capacity}\n{icon}";
          format-charging = "{capacity}\n";
          format-plugged = "{capacity}\n";
          # format-alt = "{time} {icon}";
          tooltip-format = "{power} W, {timeTo}";
          # format-good = ""; # An empty format will hide the module
          # format-full = "";
          format-icons = ["" "" "" "" ""];
          justify = "center";
        };

        "group/stats" = {
          modules = [
            "battery"
            "group/audio"
            "group/brightness"
          ];
          orientation = "inherit";
          drawer = {
            transition-duration = 750;
            transition-left-to-right = false;
          };
        };
    
        "niri/window" = {
          tooltip = false;
          format = "{}";
          rotate = 90;
          rewrite = {
            "^null$" = "Desktop";
          };
        };

        "custom/appmenu" = {
          format = "󰀻";
          on-click = "${lib.getExe pkgs.niri} msg action toggle-overview";
          tooltip = false;
        };

        "wlr/taskbar" = {
          format = "{icon}";
          on-click = "activate";
          on-click-right = "close";
        };

        "group/apps" = {
          modules = [
            "custom/appmenu"
            "wlr/taskbar"
          ];
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = false;
          };
        };

        network = {
          # interface = "wlp2*"; # (Optional) To force the use of this interface
          format-wifi = "";
          format-ethernet = "{ipaddr}/{cidr} 󰈁";
          # tooltip-format = "{ifname} via {gwaddr} ";
          tooltip-format = "{essid}: {ipaddr}";
          format-linked = "{ifname} (No IP) 󱎔";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}: {essid}";
	  on-click-right = "{lib.getExe pkgs.impala}";
          rotate = 90;
        };

        "group/power" = {
          modules = [
            "custom/powerbutton"
            "custom/reboot"
            "custom/suspend"
	        "custom/hibernate"
            "custom/lock"
            "idle_inhibitor"
            "user"
          ];
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
          };
        };

        "custom/powerbutton" = {
          format = "⏻";
          on-click = "poweroff";
          tooltip-format = "Power Off";
        };

        "custom/reboot" = {
          format = "󰜉";
          on-click = "reboot";
          tooltip-format = "Reboot";
        };

        "custom/suspend" = {
          format = "";
          on-click = "systemctl suspend-then-hibernate";
          tooltip-format = "Suspend";
        };

	    "custom/hibernate" = {
	      format = "󱄅";
	      on-click = "systemctl hibernate";
	      tooltip-format = "Hibernate";
	      rotate = 90;
	    };

        "custom/lock" = {
          format = "󰍁";
          on-click = "${lib.getExe pkgs.swaylock}";
          tooltip-format = "Lock";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          on-click = "pkill -f ${lib.getExe self'.packages.mySwayidle} || ${lib.getExe self'.packages.mySwayidle}";
          tooltip-format = "Inhibit Idle";
        };

        user = {
          format = "{work_H}:{work_M}:{work_S} ↑";
          interval = 60;
          rotate = 90;
        };

        "custom/playpause" = {
          format = "󰐎";
          on-click = "${lib.getExe pkgs.playerctl} play-pause";
          tooltip = false;
        };

        "custom/wallpaper" = {
          format = "󰸉";
          on-click = "qs ipc call panelWindow toggleWallpaperSwitcher";
          tooltip = false;
        };
      };
      "style.css".content = /* css */ ''
	@define-color gruv-blue         rgba(69, 133, 136, 0.8);
	@define-color gruv-green        rgba(104, 157, 106, 0.8);
	@define-color gruv-magenta      rgba(177, 98, 134, 0.8);
	@define-color gruv-red          rgba(204, 36, 29, 0.8);
	@define-color gruv-orange       rgba(214, 93, 14, 0.8);
	@define-color gruv-yellow       rgba(215, 153, 33, 0.8);
	@define-color gruv-lime         rgba(184, 187, 38, 0.8);
	@define-color gruv-beige        rgba(235, 219, 178, 0.8);
	@define-color gruv-grey         rgba(168, 153, 132, 0.8);
	@define-color gruv-lightblue    rgba( 105, 191, 198, 0.8);

	@define-color background-blue   rgba(13, 17, 23, 0.8);
	@define-color text-white        rgba(255, 255, 255, 0.9);

	@define-color hover-black       rgba(0, 0, 0, 0.3);
	@define-color mute-black        rgba(0, 0, 0, 0.6);

	* {
	  font-family: 'DaddyTimeMono Nerd Font Propo';
	  font-size: 13px;
	  /*border-radius: 0px;*/
	  transition: 0.5s ease-out;
	}

	window#waybar {
	  background-color: @background-blue;
	  color: @text-white;
	  transition-property: background-color;
	  transition: 1s ease-in-out;
	  border-radius: 0px 5px 5px 0px;
	}

	window#waybar.empty {
	  /*opacity: 0.0;*/
	  background-color: @hover-black;
	  transition-duration: 0.5s;
	  border-radius: 0px 20px 20px 0px;
	}

	button {
	  border: none;
	  border-radius: 0;
	}

	button:hover {
	  background: inherit;
	  box-shadow: inset 2px 0px @gruv-beige;
	}

	#custom-powerbutton,
	#custom-reboot,
	#custom-suspend,
	#custom-hibernate,
	#custom-lock,
	#custom-idlekiller,
	#custom-playpause,
	#custom-wallpaper,
    #custom-brightness,
	#user,
	button,
	#window, 
	#network,
	#custom-appmenu,
	#backlight,
	#backlight-slider,
	#pulseaudio,
	#pulseaudio-slider,
	#battery,
	#clock { 
	  padding: 10px 0px;
	  color: @text-white;
	  background: transparent;
	}

	#window {
	  margin: 20px 0px;
	}

	window#waybar.empty #window {
	  opacity: 0;
	}

	#clock {
	  box-shadow: inset 2px 0 @gruv-blue;
	}

	#clock:hover {
	  color: @gruv-blue;
	  background-color: @hover-black;
	}

	window#waybar.empty #clock {
	  border-radius: 0 0 20px 0;
	}

	#pulseaudio,
	#pulseaudio-slider {
	  box-shadow: inset 2px 0px @gruv-magenta;
	}

	#pulseaudio.muted:hover,
	#pulseaudio:hover {
	  color: @gruv-magenta;
	  transition-duration: .5s;
	  background-color: @hover-black;
	}

	#pulseaudio.muted {
	  background-color: @mute-black;
	  color: @text-white;
	}

	#pulseaudio-slider slider {
	  min-height: 0px;
	  min-width: 0px;
	  opacity: 0;
	  background-image: none;
	  border: none;
	  box-shadow: none;
	}

	#pulseaudio-slider trough {
	  min-height: 60px;
	  min-width: 10px;
	  border-radius: 5px;
	  background: @hover-black;
	}

	#pulseaudio-slider highlight {
	  min-width: 10px;
	  border-radius: 5px;
	  background: @text-white;
	}

	#pulseaudio-slider:hover highlight {
	  background: @gruv-magenta;
	}

    #custom-brightness:hover,
	#backlight:hover {
	  color: @gruv-orange;
	  background-color: @hover-black;
	}

    #custom-brightness,
	#backlight,
	#backlight-slider {
	  box-shadow: inset 2px 0px @gruv-orange;
	}

	#backlight-slider slider {
	  min-height: 0px;
	  min-width: 0px;
	  opacity: 0;
	  background-image: none;
	  border: none;
	  box-shadow: none;
	}

	#backlight-slider trough {
	  min-height: 60px;
	  min-width: 10px;
	  border-radius: 5px;
	  background-color: @hover-black;
	}

	#backlight-slider highlight {
	  min-width: 10px;
	  border-radius: 5px;
	  background-color: @text-white;
	}

	#backlight-slider:hover highlight {
	  background: @gruv-orange;
	}

	#battery:hover, 
	#battery.charging:hover, 
	#battery.plugged:hover {
	  color: @gruv-green;
	  transition-duration: .5s;
	  background-color: @hover-black;
	}

	#battery,
	#battery.charging,
	#battery.plugged {
	  box-shadow: inset 2px 0px @gruv-green;
	}

	#window:hover {
	  color: @gruv-orange;
	  background-color: @hover-black;
	}

	#window {
	  box-shadow: inset 2px 0px @gruv-orange;
	}

	#taskbar button {
	  padding: 5px 0;
	}

	#taskbar button.active {
	  background: @mute-black;
	  box-shadow: inset 2px 0px @gruv-lime;
	}

	#custom-appmenu:hover {
	  color: @gruv-yellow;
	  background-color: @hover-black;
	}

	#custom-appmenu {
	  box-shadow: inset 2px 0px @gruv-yellow;
	}

	#custom-powerbutton:hover {
	  color: @gruv-red;
	  background-color: @hover-black;
	}

	#custom-powerbutton {
	  box-shadow: inset 2px 0px @gruv-red;
	}

	window#waybar.empty #custom-powerbutton {
	  border-radius: 0 20px 0 0;
	}

	#custom-reboot:hover {
	  color: @gruv-yellow;
	  background-color: @hover-black;
	}

	#custom-reboot {
	  box-shadow: inset 2px 0px @gruv-yellow;
	}

	#custom-suspend:hover {
	  color: @gruv-grey;
	  background-color: @hover-black;
	}

	#custom-suspend {
	  box-shadow: inset 2px 0px @gruv-grey;
	}

	#custom-hibernate:hover {
	  color: @gruv-lightblue;
	  background-color: @hover-black;
	}

	#custom-hibernate {
	  box-shadow: inset 2px 0px @gruv-lightblue;
	}

	#custom-lock:hover {
	  color: @gruv-blue;
	  background-color: @hover-black;
	}

	#custom-lock {
	  box-shadow: inset 2px 0px @gruv-blue;
	}

	#custom-idlekiller:hover {
	  color: @gruv-magenta;
	  background-color: @hover-black;
	}

	#custom-idlekiller {
	  box-shadow: inset 2px 0px @gruv-magenta;
	}

	#user:hover {
	  color: @gruv-green;
	  background-color: @hover-black;
	}

	#user {
	  box-shadow: inset 2px 0px @gruv-green;
	}

	#taskbar,
	#workspaces {
	  background: transparent;
	  border-radius: 0px;
	  margin: 10px 0px;
	}

	#workspaces button {
	  padding: 7px 0px;
	  background-color: transparent;
	  color: @text-white;
	  border-radius: 0px;
	  transition: 0.2s ease-in-out;
	  font-size: 15px;
	}

	#workspaces button.active {
	  background-color: @mute-black;
	  border-radius: 0px;
	  font-weight: 900;
	}

	#workspaces button.active:hover {
	  color: @gruv-lime;
	}

	#workspaces button:hover {
	  background: @hover-black;
	}

	#workspaces button.focused {
	  background-color: rgba(0, 0, 0, 0.3);
	  box-shadow: inset 2px 0px @gruv-lime;
	}

	#workspaces button.urgent {
	  background-color: @gruv-red;
	  border-radius: 10px;
	}

	#custom-playpause:hover {
	  color: @gruv-yellow;
	  background-color: @hover-black;
	}

	#custom-playpause {
	  box-shadow: inset 2px 0px @gruv-yellow;
	}

	#network.disconnected {
	  background-color: @gruv-red;
	}

	#custom-wallpaper:hover {
	  color: @gruv-blue;
	  background-color: @hover-black;
	}

	#custom-wallpaper {
	  box-shadow: inset 2px 0px @gruv-blue;
	}
      '';
    };
  };

}
