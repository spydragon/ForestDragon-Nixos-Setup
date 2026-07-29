{self, inputs, ... }:

{
  flake.nixosModules.network =
  {config, pkgs, lib, ... }:

  {
    # networking.wireless.enable = true;  # Enables Wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enabling networking
    networking.networkmanager.enable = true;
  };
}
