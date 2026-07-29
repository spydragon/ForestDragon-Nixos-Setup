{ self, inputs, ... }:

{
  flake.nixosModules.userMatsuNoKi =
  { config, pkgs, lib, ... }:

  {

    # Defines user MatsuNoKi, remember to set a password on future accounts with 'passwd'.

    users.users."matsunoki" = {
      isNormalUser = true;
      description = "MatsuNoKi";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        
      ];
    };
  };
}
