{ ... }:
{
  flake.nixosModules.libation = {pkgs, ... }: {
    environment.systemPackages = [
      pkgs.libation
    ];
  };
}
