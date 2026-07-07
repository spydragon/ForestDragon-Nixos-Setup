{inputs, ... }:

{
  flake = {
    nixosModules.myKitty = {pkgs, ... }: {
      environment.systemPackages = [
	inputs.self.packages.${pkgs.stenv.hostPlatform.system}.myAlacritty
      ];
    };
  };

  perSystem = { pkgs, ... }: {
    packages.myAlacritty = inputs.wrapper-modules.wrappers.alacritty.wrap {
      inherit pkgs;
      settings = {
        colors = {
	  cursor = {
	    cursor = "#e8d161";
	  };
	};
	window = {
	  decorations = "none";
	};
      };
    };
  };
}
