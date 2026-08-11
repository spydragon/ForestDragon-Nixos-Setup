{ ... }:

{
  perSystem = { pkgs, ... }: {
    devShells.QTCreator = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        cmake
        ninja
        gcc
        gdb
        qt6.wrapQtAppsHook
      ];

      buildInputs = with pkgs; [
        qt6.qtbase
        qt6.qtdeclarative
        qt6.qtwayland
        qtcreator
      ];

      QT_QPA_PLATFORM = "wayland;xcb";

      shellHook = ''
        echo "Qt 6 Development Shell Loaded"
        echo "Type 'qtcreator &' to launch the IDE with full Nix toolchain context."
      '';
    };
  };
}
