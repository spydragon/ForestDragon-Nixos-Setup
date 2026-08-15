{ ... }: {
  perSystem = { pkgs, ... }: 
    let
      myQtEnv = pkgs.qt6.env "qt6-dev-env" [
        pkgs.qt6.qtbase
        pkgs.qt6.qtdeclarative
        pkgs.qt6.qtwayland
      ];
    in {
      devShells.QTCreator = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          cmake
          ninja
          gcc
          gdb
          qt6.wrapQtAppsHook
        ];

        buildInputs = [
          myQtEnv
          pkgs.qt6.qtbase # <-- ADDED THIS BACK to satisfy the setup hook
          pkgs.qtcreator
        ];

        QT_QPA_PLATFORM = "wayland;xcb";

        shellHook = ''
          if [ -z "$XDG_RUNTIME_DIR" ]; then
            export XDG_RUNTIME_DIR="/run/user/$(id -u)"
          fi

          echo "Qt 6 Combined Environment Shell Loaded"
          echo "Launch with: qtcreator &"
        '';
      };
    };
}
