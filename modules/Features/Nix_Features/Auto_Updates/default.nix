{self, inputs, ... }:

{
  flake.nixosModules.autoUpgrade =
    { config, pkgs, lib, ... }:

    {
      system.autoUpgrade = {
        enable = true;
        dates = "weekly";
        flake = "home/nixos";
      };
    };
}
