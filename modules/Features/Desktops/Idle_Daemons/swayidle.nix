{inputs, ... }:

{
  flake = {
    nixosModules.mySwayidle = { pkgs, ... }: {
      environment.systemPackages = [
        inputs.self.packages.${pkgs.stenv.hostPlatform.system}.mySwayidle
      ];
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.mySwayidle = inputs.wrapper-modules.wrappers.swayidle.wrap {
      inherit pkgs;
      timeouts = [
        {
          timeout = 150;
          command = "${lib.getExe pkgs.brightnessctl} -s set 0";
          resumeCommand = "${lib.getExe pkgs.brightnessctl} -r";
        }
        {
          timeout = 150;
          command = "${lib.getExe pkgs.brightnessctl} -sd rgb:kbd_backlight set 0";
          resumeCommand = "${lib.getExe pkgs.brightnessctl} -rd rgb:kbd_backlight";
        }
        {
          timeout = 300;
          command = "${lib.getExe self'.packages.mySwaylock} -f";
        }
        {
          timeout = 330;
          command = "${lib.getExe pkgs.niri} msg action power-off-monitors";
          resumeCommand = "${lib.getExe pkgs.niri} msg action power-on-monitors";
        }
        {
          timeout = 420;
          command = "systemctl suspend-then-hibernate";
        }
      ];
      events = {
        before-sleep = "${lib.getExe self'.packages.mySwaylock} -f";
      };
    };
  };
}
