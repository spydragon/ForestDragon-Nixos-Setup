{inputs, ... }:

{
  flake = {
    nixosModules.myFuzzel = { pkgs, ... }: {
      environment.systemPackages = [
	inputs.self.packages.${pkgs.stenv.hostPlatform.system}.myFuzzel
      ];
    };
  };

  perSystem = { pkgs, ... }: {
    packages.myFuzzel = inputs.wrapper-modules.wrappers.fuzzel.wrap {
      inherit pkgs;
      settings = {
        main = {
	  placeholder = "Apps & Themes";
	};
	colors = {
	  background = "34333dff";
	  text = "e8d161ff";
	};
      };
    };
  };
}
