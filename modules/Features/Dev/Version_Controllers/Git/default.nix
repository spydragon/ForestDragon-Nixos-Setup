{self, inputs, ... }:

{
  flake.nixosModules.git =
  {config, pkgs, lib, ... }:

  {
    environment.etc."gitconfig".text = ''
      [user]
        name = spydragon
        email = spydragon23526@gmail.com
      [init]
        defaultBranch = main
      [pull]
        rebase = true
    '';

    programs.git = {
      enable = true;
      config = {
        safe = {
          directory = "/home/nixos";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      git
      lazygit
    ];
  };
}
