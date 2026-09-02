{ self, ... }:

{
  flake.nixosModules.superfile = { pkgs, ... }:
    let
      myAlacritty = self.packages.${pkgs.system}.myAlacritty;
      superfileDesktopEntry = pkgs.writeText "superfile.desktop"
      ''
        [Desktop Entry]
        Type=Application
        Name=Superfile
        Comment=Terminal file manager
        Exec=${myAlacritty}/bin/alacritty -e ${pkgs.superfile}/bin/superfile %f
        Terminal=false
        Categories=System;FileManager;
        MimeType=inode/directory;
      '';
    in
    {
      environment = {
        etc."xdg/applications/superfile.desktop".source = superfileDesktopEntry;
        systemPackages = [
          myAlacritty
          pkgs.superfile
        ];
      };
    };
}
