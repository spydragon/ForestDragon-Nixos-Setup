{ self, inputs, ...}: {

  flake.nixosModules.MatsuFrameworkConfiguration =
    # Edit this configuration file to define what should be installed on
    # your system.  Help is available in the configuration.nix(5) man page
    # and in the NixOS manual (accessible by running ‘nixos-help’).

    { config, pkgs, ... }:

    {
      imports =
        [ # Include the results of the hardware scan.
          self.nixosModules.MatsuFrameworkHardware
    	  self.nixosModules.niri
	      self.nixosModules.zen
    	  self.nixosModules.myNeovim
    	  self.nixosModules.myWaybar
          self.nixosModules.smartDimmer
        ];

      services.upower = {
        enable = true;
        criticalPowerAction = "Hibernate";
      };

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      };


      system.autoUpgrade = {
    	enable = true;
    	dates = "weekly";
    	flake = "/home/nixos#MatsuFramework";
      };

      services.logind.settings = {
    	Login = {
    	  HandleLidSwitch = "suspend-then-hibernate";
    	  HandleLidSwitchExternalPower = "suspend-then-hibernate";
    	  HandelLidSwitchDocked = "ignore";
    	};
      };

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            # Shows battery charge of connected devices on supported
            # Bluetooth adapters. Defaults to 'false'.
            Experimental = true;
            # When enabled other devices can connect faster to us, however
            # the tradeoff is increased power consumption. Defaults to
            # 'false'.
            FastConnectable = true;
          };
          Policy = {
            # Enable all controllers when they are found. This includes
            # adapters present on start as well as adapters that are plugged
            # in later on. Defaults to 'true'.
            AutoEnable = true;
          };
        };
      };

      environment.etc."gitconfig".text = ''
        [user]
          name = spydragon
          email = spydragon23526@gmail.com
        [init]
          defaultBranch = main
        [pull]
          rebase = true
      '';

      systemd.sleep.settings.Sleep = {
    	HibernateDelaySec = "30min";
      };

      nix = {
    	gc = {
    	  automatic = true;
    	  dates = "daily";
    	  options = "--delete-older-than 10d";
    	};
    	settings.auto-optimise-store = true;
      };

      # Enable Wayland support
      services.xserver.enable = true;
      services.displayManager.defaultSession = "niri";

      # enable flakes
      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      # Bootloader.
      boot.loader.grub = {
        enable = true;
    	device = "nodev";
    	useOSProber = true;
    	efiSupport = true;
      };
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "nixos"; # Define your hostname.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Enable networking
      networking.networkmanager.enable = true;

      # Set your time zone.
      time.timeZone = "America/Boise";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users."matsunoki" = {
        isNormalUser = true;
        description = "MatsuNoKi";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [];
      };

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      xdg.portal = {
        enable = true;

    	extraPortals = with pkgs; [
    	  xdg-desktop-portal-gtk
    	  xdg-desktop-portal-gnome
    	];
  
        config = {
    	  niri = {
	        default = [
    	      "gnome"
    	      "gtk"
    	    ];
    	    "org.freedesktop.impl.portal.Access" = [ "gtk" ];
    	    "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
    	    "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    	  };
        };
        # extraPortals = with pkgs; [
        #   xdg-desktop-portal-gnome
        #   xdg-desktop-portal-gtk
        # ];
        # config = {
        #   common = {
        #     default = [ "gnome" "gtk" ];
        #     "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        #     "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        #   };
        # };
      };


      boot.kernelParams = [ "amdgpu.abmlevel=0" ];

      services.udev.extraRules = ''
        SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
        SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
        SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0018", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
      '';

      services.fwupd.enable = true;

      services.power-profiles-daemon.enable = true;

      services.fwupd.extraRemotes = [ "lvfs-testing" ];
      # Might be necessary once to make the update succeed
      services.fwupd.uefiCapsuleSettings.DisableCapsuleUpdateOnDisk = true;

      hardware.fw-fanctrl = {
        enable = true;
        config = {
          defaultStrategy = "Minimal";
          strategies = {
            "Default" = {
              fanSpeedUpdateFrequency = 5;
              movingAverageInterval = 30;
              speedCurve = [
                { temp =  01; speed =  20; }
                { temp =  43; speed =  64; }
                { temp =  66; speed =  76; }
                { temp =  86; speed =  99; }
              ];
            };
            "Minimal" = {
              fanSpeedUpdateFrequency = 5;
              movingAverageInterval = 30;
              speedCurve = [
                { temp =  24; speed =   0; }
                { temp =  40; speed =  40; }
                { temp =  75; speed =  70; }
                { temp =  90; speed = 100; }
              ];
            };
            "allOut" = {
               fanSpeedUpdateFrequency = 5;
               movingAverageInterval = 30;
               speedCurve = [
                 { temp =  18; speed = 100; }
                 { temp = 100; speed = 100; }
               ];
             };
          };
        };
      };

      systemd.services.fw-fanctrl = {
        after = ["systemd-logind.service"];
      };

      security.rtkit.enable = true;

      services.pipewire = {
	    enable = true;

	    wireplumber.enable = true;
	    pulse.enable = true;
	    alsa = {
    	  enable = true;
    	  support32Bit = true;
    	};
      };


      services.pulseaudio = {
        enable = false;
    	support32Bit = false;
      };



      services.fprintd.enable = true;
  
      services.fprintd.tod.enable = true;
      services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

      # List packages installed in system profile. To search, run:
      # $ nix search wget

      environment.systemPackages = with pkgs; [
        git
        lazygit
        bluetui
        krita
        obs-studio
        busybox
        fprintd
      	kdePackages.kdenlive
	    cider-2
      	pavucontrol
        fw-fanctrl
	    fastfetch
        vesktop
        superfile
        firefox
        xwayland-satellite
        gnome-keyring
        zip
        # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      #  wget
      ];

      fonts.packages = with pkgs; [
	# font-awesome
	# emacsPackages.ligature-pragmatapro
	# nerd-fonts.jetbrains-mono
      ];

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      # services.openssh.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "26.05"; # Did you read the comment?

    };

}
