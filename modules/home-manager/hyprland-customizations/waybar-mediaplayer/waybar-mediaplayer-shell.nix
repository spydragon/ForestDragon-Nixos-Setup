let
  pkgs = import <nixpkgs> {};
in pkgs.mkShell {
  packages = [
    (pkgs.python312.withPackages (python-pkgs: with python-pkgs; [
      pandas
      requests
      syncedlyrics
      pillow
    ])
    )
    (pkgs.python312Packages.pygobject3)
    (pkgs.playerctl)
  ];
}