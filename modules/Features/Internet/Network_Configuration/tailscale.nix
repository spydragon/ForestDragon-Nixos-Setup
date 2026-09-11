{ ... }:

{
  flake.nixosModules.Tailscale = { ... }: {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
  };
}
