{self, inputs, ... }:

{
  flake.nixosModules.autoUpgrade =
    { config, pkgs, lib, ... }:

    {
      system.autoUpgrade = {
        enable = true;
        dates = "weekly";
        flake = "/home/nixos#${config.networking.hostName}";
        flags = [
          "--update-input"
          "nixpkgs"
          "--impure"
        ];
      };
    };
}
