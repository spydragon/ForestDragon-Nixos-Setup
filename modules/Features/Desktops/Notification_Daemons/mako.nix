{inputs, ... }:

{
  flake = {
    nixosModules.myMako = { pkgs, ... }: {
      environment.systemPackages = [
	inputs.self.packages.${pkgs.stenv.hostPlatform.system}.myMako
      ];
    };
  };

  perSystem = { pkgs, ... }: {
    packages.myMako = inputs.wrapper-modules.wrappers.mako.wrap {
      inherit pkgs;
      settings = {
	anchor = "bottom-left";
	default-timeout = 5000;
      };
    };
  };

}
