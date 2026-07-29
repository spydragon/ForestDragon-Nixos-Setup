{ self, inputs, ... }:

{

  flake.nixosModules.zen = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myZenBrowser
    ];
  };

  perSystem = { pkgs, system, ... }: {
    packages.myZenBrowser = inputs.zen-browser.packages.${system}.default;
  };

}
