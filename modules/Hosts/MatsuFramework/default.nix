{self, inputs, lib, ...}: {

  flake.nixosConfigurations.MatsuFramework = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      MatsuFrameworkConfiguration
      
      autoGarbageCollect
      autoUpgrade
      bluetooth
      cozy
      fingerPrint
      frameworkFanControl
      frameworkPowerManagement
      fwupd
      git
      libation
      myNeovim
      network
      niri
      smartDimmer
      Steam
      superfile
      userMatsuNoKi
      myWaybar
      zen
    ];
  };
}
