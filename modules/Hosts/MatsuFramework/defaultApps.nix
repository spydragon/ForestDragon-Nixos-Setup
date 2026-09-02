{ ... }:

{
  flake.nixosModules.defaultApps = { ... }: {
    xdg.mime = {
      enable = true;
      defaultApplications = {
        # Web browser
        "text/html" = [ "zen.desktop" ];
        "x-scheme-handler/http" = [ "zen.desktop" ];
        "x-scheme-handler/https" = [ "zen.desktop" ];

        # PDF files
        # "application/pdf" = [ "org.gnome.Evince.desktop" ];

        # Text files
        "text/plain" = [ "nvim.desktop" ];

        # Directories / file manager
        "inode/directory" = [ "superfile.desktop" ];
      };

    };
  };
}
