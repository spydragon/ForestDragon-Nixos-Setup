{self, inputs, ... }:

{
  flake.nixosModules.fwupd =
  { config, pkgs, lib, ... }:

  {
    services.fwupd = {
      enable = true;
      extraRemotes = [ "lvfs-testing" ];
      uefiCapsuleSettings.DisableCapsuleUpdateOnDisk = true;
    };
  };
}
