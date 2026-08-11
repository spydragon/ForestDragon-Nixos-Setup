{ self, inputs, ... }:

{
  flake.nixosModules.fingerPrint =
  { config, pkgs, lib, ... }:

  {
    services.fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };

    environment.systemPackages = with pkgs; [
      fprintd
    ];
  };
}
