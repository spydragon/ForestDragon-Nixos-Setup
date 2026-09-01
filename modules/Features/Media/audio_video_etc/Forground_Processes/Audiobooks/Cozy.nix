{ ... }:
{
  flake.nixosModules.cozy = {pkgs, ... }: {
    environment.systemPackages = [
      pkgs.cozy
    ];
  };
}
