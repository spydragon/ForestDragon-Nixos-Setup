{ config, ... }:

{
  programs.wlogout = {
    enable = true;
    
    style = ''
    * {
      background-image: none;
      box-shadow: none;
    }

    window {
      background-color: rgba(12, 12, 12, 0.9);
    }

    button {
        border-radius: 0;
        border-color: black;
      text-decoration-color: #FFFFFF;
        color: #FFFFFF;
      background-color: #1E1E1E;
      border-style: solid;
      border-width: 1px;
      background-repeat: no-repeat;
      background-position: center;
      background-size: 25%;
    }

    button:focus, button:active, button:hover {
      background-color: #3700B3;
      outline-style: none;
    }

    #lock {
        background-image: image(url("${config.home.homeDirectory}/nixos/modules/home-manager/hyprland-customizations/wlogout-icons/lock.png"));
    }

    #logout {
        background-image: image(url("${config.home.homeDirectory}/nixos/modules/home-manager/hyprland-customizations/wlogout-icons/logout.png"));
    }

    #suspend {
        background-image: image(url("${config.home.homeDirectory}/nixos/modules/home-manager/hyprland-customizations/wlogout-icons/suspend.png"));
    }

    #hibernate {
        background-image: image(url("${config.home.homeDirectory}/nixos/modules/home-manager/hyprland-customizations/wlogout-icons/hibernate.png"));
    }

    #shutdown {
        background-image: image(url("${config.home.homeDirectory}/nixos/modules/home-manager/hyprland-customizations/wlogout-icons/shutdown.png"));
    }

    #reboot {
        background-image: image(url("${config.home.homeDirectory}/nixos/modules/home-manager/hyprland-customizations/wlogout-icons/reboot.png"));
    }
    '';

    layout = [
            {
          label = "lock";
          action = "loginctl lock-session";
          text = "Lock";
          keybind = "l";
      }
      {
          label = "hibernate";
          action = "systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
      }
      {
          label = "logout";
          action = "sleep 1; hyprctl dispatch exit";
          text = "Logout";
          keybind = "e";
      }
      {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
      }
      {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "u";
      }
      {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
      }
    ];
  };
}