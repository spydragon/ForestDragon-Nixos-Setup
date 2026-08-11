{ self, iputs, ... }:

{
  flake.nixosModules.superfile =
  { config, pkgs, lib, ... }:

  {
    environment.systemPackages = with pkgs; [
      superfile
    ];
  };
}
