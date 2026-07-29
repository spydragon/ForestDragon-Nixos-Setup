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

    environment.systemPackages = with pkgs; [
      git
      lazygit
    ];
  };
}
