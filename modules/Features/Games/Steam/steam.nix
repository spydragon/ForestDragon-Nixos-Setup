{self, inputs, ... }:
{
  flake.nixosModules.Steam = 
  {config, pkgs, lib, ... }:

  {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # for Steam Remote Play
      dedicatedServer.openFirewall = true; # for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # for Steam Local Network Game Transfers
    };
  };
}
