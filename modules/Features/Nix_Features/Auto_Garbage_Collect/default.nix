{self, inputs, ... }:

{
  flake.nixosModules.autoGarbageCollect =
  {config, pkgs, lib, ... }:

  {
    nix = {
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 10d";
      };
      settings.auto-optimise-store = true;
    };
  };
}
