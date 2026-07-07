{self, inputs, lib, ...}: {

  flake.nixosConfigurations.MatsuFramework = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.MatsuFrameworkConfiguration
    ];
  };

}
