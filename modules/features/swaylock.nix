{inputs, ... }:

{
  flake = {
    nixosModules.mySwaylock = { pkgs, ... }: {
      environment.systemPackages = [
	inputs.self.packages.${pkgs.stenv.hostPlatform.system}.mySwaylock
      ];
      security.pam.services.swaylock = {};
    };
  };

  perSystem = { pkgs, ... }: {
    packages.mySwaylock = inputs.wrapper-modules.wrappers.swaylock.wrap {
      inherit pkgs;
      settings = {
	color = "000000";
	show-failed-attempts = true;
	indicator-idle-visible = true;
      };
    };
  };
}
