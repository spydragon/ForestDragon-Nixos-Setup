{ self, inputs, ... }: {

  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
    environment.systemPackages = [
      pkgs.hyprpicker
    ];
  };

  perSystem = { pkgs, lib, self', ... }: { 
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        input = {
	  keyboard = {
	    xkb = {
	      layout = "us";
	    };
	    numlock = _: { };
	  };
	  touchpad = {
	    tap = _: {};
	  };
	};
	# outputs."eDP-1" = {
        #   mode = "1920x1080@120.030";
	#   scale = 2;
	#   transform = "normal";
	#   position = { x = 1280; y = 0; };
	# };
    outputs."eDP-1" = {
      mode = "2560x1600@60.002";

      variable-refresh-rate = _: {
        props = {
          on-demand = true;
        };
      };
    };
	layout = {
	  gaps = 16;
	  center-focused-column = "never";
	  preset-column-widths = [
	    { proportion = 1.0 / 3.0; }
	    { proportion = 1.0 / 2.0; }
	    { proportion = 2.0 / 3.0; }
	  ];
	  default-column-width = { proportion = 0.5; };
	  focus-ring = {
	    width = 4;
	    active-color = "#7fc8ff";
	    inactive-color = "#505050";
	  };
	  border = {
	    off = _: { };
	    width = 4;
	    active-color = "#ffc87f";
	    inactive-color = "#505050";
	    urgent-color = "#9b0000";
	  };
	  shadow = {
	    softness = 30;
	    spread = 5;
	    offset = _: {
	      props = { x = 0; y = 5; };
	    };
	    color = "#0007";
	  };
	};
	gestures = {
	  hot-corners = {
	    off = _: {};
	  };
	};
	spawn-at-startup = [
	  "${lib.getExe pkgs.swaybg} -m fill -i ~/wallpaper.png"
	  "${lib.getExe self'.packages.myMako}"
	  "${lib.getExe self'.packages.myWaybar}"
	  "${lib.getExe self'.packages.mySwayidle}"
      "${lib.getExe pkgs.wl-gammarelay-rs}"
	];
	spawn-sh-at-startup = [
	  "${lib.getExe pkgs.mpvpaper} ALL ~/Wallpapers/EotE_Wallpaper_2K.mp4 --auto-pause -o \"loop-file=inf panscan=1.0\""
	];
	xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

	screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
	window-rules = [
	  {
	    matches = [ { app-id = "^org.wezfurlong.wezterm$"; } ];
	    default-column-width = _: {};
	  }
	  {
	    matches = [
	      { 
	        app-id = "firefox$";
            title = "^Picture-in-Picture$";
	      }
	    ];
	    open-floating = true;
	  }
      {
        matches = [
          {
            app-id = "steam_app_[0-9]+$";
          }
        ];
        variable-refresh-rate = true;
      }
	  # {
	  #   matches = [
	  #     { app-id = "^org.keepassxc.KeePassXC$"; }
	  #     { app-id = "^org.gnome.World.Secrets$"; }
	  #   ];
	  #   block-out-from = "screen-capture";
	  # }
	  # {
	  #   geometry-corner-radius = 12;
	  #   clip-to-geometry = true;
	  # }
	];
	binds = {
	  "Mod+B" = {
	    spawn = "killall -SIGUSR2 ${lib.getExe self'.packages.myWaybar}";
	  };
	  "Mod+Shift+Slash" = {
	    show-hotkey-overlay = _: { };
	  };
	  "Mod+T" = _: {
	    props.hotkey-overlay-title = "Open a Terminal: alacritty";
	    content.spawn = "${lib.getExe self'.packages.myAlacritty}";
	  };
	  "Mod+D" = _: {
	    props.hotkey-overlay-title = "Run an Aplication: fuzzel";
	    content.spawn = "${lib.getExe self'.packages.myFuzzel}";
	  };
	  "Super+Alt+L" = _: {
	    props.hotkey-overlay-title = "Lock the Screen: swaylock";
	    content.spawn = "${lib.getExe self'.packages.mySwaylock}";
	  };
	  "Super+Alt+S" = _: {
	    props = {
	      allow-when-locked = true;
	      hotkey-overlay-title = null;
	    };
	    content.spawn-sh = "pkill orca || exec orca";
	  };
	  "XF86AudioRaiseVolume" = _: {
	    props.allow-when-locked = true;
	    content.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && [ \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \'$2 > 1.0 {print 1}\')\" = \"1\" ] && wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0";
	  };
	  "XF86AudioLowerVolume" = _: {
	    props.allow-when-locked = true;
	    content.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
	  };
	  "XF86AudioMute" = _: {
	    props.allow-when-locked = true;
	    content.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
	  };
	  "Ctrl+XF86AudioRaiseVolume" = _: {
	    props.allow-when-locked = true;
	    content.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+ && [ \"$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk \'$2 > 1.0 {print 1}\')\" = \"1\" ] && wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1.0";
	  };
	  "Ctrl+XF86AudioLowerVolume" = _: {
	    props.allow-when-locked = true;
	    content.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
	  };
	  "Ctrl+XF86AudioMute" = _: {
	    props.allow-when-locked = true;
	    content.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
	  };
	  "XF86AudioMicMute" = _: {
	    props.allow-when-locked = true;
	    content.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
	  };
	  "XF86AudioPlay" = _: {
	    props.allow-when-locked = true;
	    content.spawn-sh = "${lib.getExe pkgs.playerctl} play-pause";
	  };
	  "XF86AudioStop" = _: {
	    props.allow-when-locked = true;
	    content.spawn-sh = "${lib.getExe pkgs.playerctl} stop";
	  };
	  "XF86AudioPrev" = _: {
	    props.allow-when-locked = true;
	    content.spawn-sh = "${lib.getExe pkgs.playerctl} previous";
	  };
	  "XF86AudioNext" = _: {
	    props.allow-when-locked = true;
	    content.spawn-sh = "${lib.getExe pkgs.playerctl} next";
	  };
	  "XF86MonBrightnessUp" = _: {
	    props.allow-when-locked = true;
	    content.spawn-sh = "${lib.getExe self'.packages.smartDimmer} +0.1";
	   };
	  "XF86MonBrightnessDown" = _: {
	    props.allow-when-locked = true;
	    content.spawn-sh = "${lib.getExe self'.packages.smartDimmer} -0.1";
	  };
	  "Mod+O" = _: {
	    props.repeat = false;
	    content.toggle-overview = _: {};
	  };
	  "Mod+Q" = _: {
	    props.repeat = false;
	    content.close-window = _: {};
	  };
	  "Mod+Left" = {
	    focus-column-left = _: {};
	  };
	  "Mod+Down" = {
	    focus-window-down = _: {};
	  };
	  "Mod+Up" = {
	    focus-window-up = _: {};
	  };
	  "Mod+Right" = {
	    focus-column-right = _: {};
	  };
	  "Mod+H" = {
	    focus-column-left = _: {};
	  };
	  "Mod+J" = {
	    focus-window-down = _: {};
	  };
	  "Mod+K" = {
	    focus-window-up = _: {};
	  };
	  "Mod+L" = {
	    focus-column-right = _: {};
	  };
	  "Mod+Ctrl+Left" = {
	    move-column-left = _: {};
	  };
	  "Mod+Ctrl+Down" = {
	    move-window-down = _: {};
	  };
	  "Mod+Ctrl+Up" = {
	    move-window-up = _: {};
	  };
	  "Mod+Ctrl+Right" = {
	    move-column-right = _: {};
	  };
	  "Mod+Ctrl+H" = {
	    move-column-left = _: {};
	  };
	  "Mod+Ctrl+J" = {
	    move-window-down = _: {};
	  };
	  "Mod+Ctrl+K" = {
	    move-window-up = _: {};
	  };
	  "Mod+Ctrl+L" = {
	    move-column-right = _: {};
	  };
	  "Mod+Home" = {
	    focus-column-first = _: {};
	  };
	  "Mod+End" = {
	    focus-column-last = _: {};
	  };
	  "Mod+Ctrl+Home" = {
	    move-column-to-first = _: {};
	  };
	  "Mod+Ctrl+End" = {
	    move-column-to-last = _: {};
	  };
	  "Mod+Shift+Left" = {
	    focus-monitor-left = _: {};
	  };
	  "Mod+Shift+Down" = {
	    focus-monitor-down = _: {};
	  };
	  "Mod+Shift+Up" = {
	    focus-monitor-up = _: {};
	  };
	  "Mod+Shift+Right" = {
	    focus-monitor-right = _: {};
	  };
	  "Mod+Shift+H" = {
	    focus-monitor-left = _: {};
	  };
	  "Mod+Shift+J" = {
	    focus-monitor-down = _: {};
	  };
	  "Mod+Shift+K" = {
	    focus-monitor-up = _: {};
	  };
	  "Mod+Shift+L" = {
	    focus-monitor-right = _: {};
	  };
	  "Mod+Shift+Ctrl+Left" = {
	    move-column-to-monitor-left = _: {};
	  };
	  "Mod+Shift+Ctrl+Down" = {
	    move-column-to-monitor-down = _: {};
	  };
	  "Mod+Shift+Ctrl+Up" = {
	    move-column-to-monitor-up = _: {};
	  };
	  "Mod+Shift+Ctrl+Right" = {
	    move-column-to-monitor-right = _: {};
	  };
	  "Mod+Shift+Ctrl+H" = {
	    move-column-to-monitor-left = _: {};
	  };
	  "Mod+Shift+Ctrl+J" = {
	    move-column-to-monitor-down = _: {};
	  };
	  "Mod+Shift+Ctrl+K" = {
	    move-column-to-monitor-up = _: {};
	  };
	  "Mod+Shift+Ctrl+L" = {
	    move-column-to-monitor-right = _: {};
	  };
	  "Mod+Page_Down" = {
	    focus-workspace-down = _: {};
	  };
	  "Mod+Page_Up" = {
	    focus-workspace-up = _: {};
	  };
	  "Mod+U" = {
	    focus-workspace-down = _: {};
	  };
	  "Mod+I" = {
	    focus-workspace-up = _: {};
	  };
	  "Mod+Ctrl+Page_Down" = {
	    move-column-to-workspace-down = _: {};
	  };
	  "Mod+Ctrl+Page_Up" = {
	    move-column-to-workspace-up = _: {};
	  };
	  "Mod+Ctrl+U" = {
	    move-column-to-workspace-down = _: {};
	  };
	  "Mod+Ctrl+I" = {
	    move-column-to-workspace-up = _: {};
	  };
	  "Mod+Shift+Page_Down" = {
	    move-workspace-down = _: {};
	  };
	  "Mod+Shift+Page_Up" = {
	    move-workspace-up = _: {};
	  };
	  "Mod+Shift+U" = {
	    move-workspace-down = _: {};
	  };
	  "Mod+Shift+I" = {
	    move-workspace-up = _: {};
	  };
	  "Mod+WheelScrollDown" = _: {
	    props.cooldown-ms = 150;
	    content.focus-workspace-down = _: {};
	  };
	  "Mod+WheelScrollUp" = _: {
	    props.cooldown-ms = 150;
	    content.focus-workspace-up = _: {};
	  };
	  "Mod+Ctrl+WheelScrollDown" = _: {
	    props.cooldown-ms = 150;
	    content.move-column-to-workspace-down = _: {};
	  };
	  "Mod+Ctrl+WheelScrollUp" = _: {
	    props.cooldown-ms = 150;
	    content.move-column-to-workspace-up = _: {};
	  };
	  "Mod+WheelScrollRight" = {
	    focus-column-right = _: {};
	  };
	  "Mod+WheelScrollLeft" = {
	    focus-column-left = _: {};
	  };
	  "Mod+Ctrl+WheelScrollRight" = {
	    move-column-right = _: {};
	  };
	  "Mod+Ctrl+WheelScrollLeft" = {
	    move-column-left = _: {};
	  };
	  "Mod+Shift+WheelScrollDown" = {
	    focus-column-right = _: {};
	  };
	  "Mod+Shift+WheelScrollUp" = {
	    focus-column-left = _: {};
	  };
	  "Mod+Ctrl+Shift+WheelScrollDown" = {
	    move-column-right = _: {};
	  };
	  "Mod+Ctrl+Shift+WheelScrollUp" = {
	    move-column-to-workspace-up = _: {};
	  };
	  "Mod+1".focus-workspace = 1;
	  "Mod+2".focus-workspace = 2;
	  "Mod+3".focus-workspace = 3;
	  "Mod+4".focus-workspace = 4;
	  "Mod+5".focus-workspace = 5;
	  "Mod+6".focus-workspace = 6;
	  "Mod+7".focus-workspace = 7;
	  "Mod+8".focus-workspace = 8;
	  "Mod+9".focus-workspace = 9;
	  "Mod+Ctrl+1".focus-workspace = 1;
	  "Mod+Ctrl+2".focus-workspace = 2;
	  "Mod+Ctrl+3".focus-workspace = 3;
	  "Mod+Ctrl+4".focus-workspace = 4;
	  "Mod+Ctrl+5".focus-workspace = 5;
	  "Mod+Ctrl+6".focus-workspace = 6;
	  "Mod+Ctrl+7".focus-workspace = 7;
	  "Mod+Ctrl+8".focus-workspace = 8;
	  "Mod+Ctrl+9".focus-workspace = 9;
	  "Mod+BracketLeft".consume-or-expel-window-left = _: {};
	  "Mod+BracketRight".consume-or-expel-window-right = _: {};
	  "Mod+Comma".consume-window-into-column = _: {};
	  "Mod+Period".expel-window-from-column = _: {};
	  "Mod+R".switch-preset-column-width = _: {};
	  "Mod+Shift+R".switch-preset-column-width-back = _: {};
	  "Mod+Ctrl+Shift+R".switch-preset-window-height = _: {};
	  "Mod+Ctrl+R".reset-window-height = _: {};
	  "Mod+F".maximize-column = _: {};
	  "Mod+Shift+F".fullscreen-window = _: {};
	  "Mod+M".maximize-window-to-edges = _: {};
	  "Mod+Ctrl+F".expand-column-to-available-width = _: {};
	  "Mod+C".center-column = _: {};
	  "Mod+Ctrl+C".center-visible-columns = _: {};
	  "Mod+Minus".set-column-width = "-10";
	  "Mod+Equal".set-column-width = "+10";
	  "Mod+Shift+Minus".set-window-height = "-10";
	  "Mod+Shift+Equal".set-window-height = "+10";
	  "Mod+V".toggle-window-floating = _: {};
	  "Mod+Shift+V".switch-focus-between-floating-and-tiling = _: {};
	  "Mod+W".toggle-column-tabbed-display = _: {};
	  "Print".screenshot = _: {};
	  "Ctrl+Print".screenshot-screen = _: {};
	  "Alt+Print".screenshot-window = _: {};
	  "Mod+Escape" = _: {
	    props.allow-inhibiting = false;
	    content.toggle-keyboard-shortcuts-inhibit = _: {};
	  };
	  "Mod+Shift+E".quit = _: {};
	  "Ctrl+Alt+Delete".quit = _: {};
	  "Mod+Shift+P".power-off-monitors = _: {};
	};
      };
    };
  
  };

}
