{ ... }:

{
  flake.nixosModules.Tailscale = { config, ... }: {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    networking.firewall = {
      enable = true;
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };
}
