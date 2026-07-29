{ self, inputs, ... }:

{
  flake.nixosModules.frameworkFanControl =
  { config, pkgs, lib, ... }:

  {

    systemd.services.fw-fanctrl = {
      after = [ "systemd-logind.service" ];
    };

    hardware.fw-fanctrl = {
      enable = true;
      config = {
        defaultStrategy = "Minimal";
        strategies = {
          "Default" = {
            fanSpeedUpdateFrequency = 5;
            movingAverageInterval = 30;
            speedCurve = [
              { temp =   1; speed =  20; }
              { temp =  43; speed =  64; }
              { temp =  66; speed =  76; }
              { temp =  86; speed =  99; }
            ];
          };
          "Minimal" = {
            fanSpeedUpdateFrequency = 5;
            movingAverageInterval = 30;
            speedCurve = [
              { temp =  24; speed =   0; }
              { temp =  40; speed =  40; }
              { temp =  75; speed =  70; }
              { temp =  90; speed = 100; }
            ];
          };
          "allOut" = {
            fanSpeedUpdateFrequency = 5;
            movingAverageInterval = 30;
            speedCurve = [
              { temp =  18; speed = 100; }
              { temp = 100; speed = 100; }
            ];
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      fw-fanctrl
    ];
  };
}
