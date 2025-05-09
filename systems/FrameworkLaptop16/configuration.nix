# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  imports = [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./Users/users.nix
    ../../modules/nixos/default-config.nix
  ];

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

  programs.fw-fanctrl = {
    enable = true;
    config = {
      defaultStrategy = "lazy";
      strategies = {
        "lazy" = {
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 30;
          speedCurve = [
            { temp = 20; speed =   0; }
            { temp = 38; speed =  30; }
            { temp = 65; speed =  40; }
            { temp = 70; speed =  50; }
            { temp = 85; speed = 100; }
          ];
        };
        "test" = {
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 30;
          speedCurve = [
            { temp = 20; speed =   0; }
            { temp = 38; speed =  30; }
            { temp = 85; speed = 100; }
          ];
        };
      };
    };
  };

  systemd.services.fw-fanctrl = {
    after = ["systemd-logind.service"];
  };



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
