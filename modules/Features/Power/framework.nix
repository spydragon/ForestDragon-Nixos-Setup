{ self, inputs, ... }:

{
  flake.nixosModules.frameworkPowerManagement =
  { config, pkgs, lib, ... }:

  {
    services.logind.settings = {
      Login = {
        HandleLidSwitch = "suspend-then-hibernate";
        HandleLidSwitchExternalPower = "suspend-then-hibernate";
        HandleLidSwitchDocked = "ignore";
      };
    };
    
    systemd.sleep.settings.Sleep = {
      HibernateDelaySec = "30min";
    };
    
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
      SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
      SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0018", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    '';

    services = {
      acpid.enable = true;
      power-profiles-daemon.enable = true;
      upower = {
        enable = true;
        criticalPowerAction = "Hibernate";
      };
    };
  };
}
