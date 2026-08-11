{ self, inputs, ... }:

{

  flake.nixosModules.bluetooth =
  {config, pkgs, lib, ... }:

  {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true; # can show battery percentage of device.
          FastConnectable = true; # default: false, makes some connections faster but also uses more battery
        };
        Policy = {
          AutoEnable = true; # enables all bluetooth controllers on device (that are known)
        };
      };
    };

    environment.systemPackages = with pkgs; [
      bluetui
    ];
  };

}
