{ self, inputs, ...}: {

  flake.nixosModules.MatsuFrameworkConfiguration =
    # Edit this configuration file to define what should be installed on
    # your system.  Help is available in the configuration.nix(5) man page
    # and in the NixOS manual (accessible by running ‘nixos-help’).

    { config, pkgs, lib, ... }:

    {
      imports =
        [ # Include the results of the hardware scan.
          self.nixosModules.MatsuFrameworkHardware
          /home/matsunoki/smb/smb.nix
        ];

      # Enable Wayland support
      services.xserver.enable = true;
      services.displayManager.defaultSession = "niri";

      # enable flakes
      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      # Bootloader.
      boot = {

        consoleLogLevel = 3;
        initrd.verbose = false;
        kernelParams = [
          "quiet"
          "amdgpu.abmlevel=0"
          "udev.log_level=3"
          "systemd.show_status=auto"
        ];
        loader.grub = {
          enable = true;
    	  device = "nodev";
    	  useOSProber = true;
          efiSupport = true;
        };
      };
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "nixos"; # Define your hostname.

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

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

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
      # List packages installed in system profile. To search, run:
      # $ nix search wget

      environment.systemPackages = with pkgs; [
        krita
        obs-studio
        busybox
      	kdePackages.kdenlive
	    cider-2
      	pavucontrol
	    fastfetch
        vesktop
        firefox
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
