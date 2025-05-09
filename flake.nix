{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    fw-fanctrl = {
      url = "github:TamtamHero/fw-fanctrl/packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, fw-fanctrl, zen-browser, ...}@inputs: {
    nixosConfigurations = {

      frameworkLaptop16 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          fw-fanctrl.nixosModules.default
          nixos-hardware.nixosModules.framework-16-7040-amd
          ./systems/FrameworkLaptop16/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      nothingPhone2a = {
        # this js a possible future project (I have no Idea what I'm getting my self into...)
        specialArgs = { inherit inputs; };
        modules = [
          ./systems/NothingPhone2a/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

    };
  };
}
