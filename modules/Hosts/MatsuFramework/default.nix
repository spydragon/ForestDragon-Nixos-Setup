{self, inputs, lib, ...}: {

  flake.nixosConfigurations.MatsuFramework = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.MatsuFrameworkConfiguration
      
      self.nixosModules.autoGarbageCollect
      self.nixosModules.autoUpgrade
      self.nixosModules.bluetooth
      self.nixosModules.fingerPrint
      self.nixosModules.frameworkFanControl
      self.nixosModules.frameworkPowerManagement
      self.nixosModules.fwupd
      self.nixosModules.git
      self.nixosModules.myNeovim
      self.nixosModules.network
      self.nixosModules.niri
      self.nixosModules.smartDimmer
      self.nixosModules.Steam
      self.nixosModules.superfile
      self.nixosModules.userMatsuNoKi
      self.nixosModules.myWaybar
      self.nixosModules.zen
    ];
  };
}
