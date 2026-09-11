{ self, inputs, ... }:

{

  flake.nixosModules.zen = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myZenBrowser
      pkgs.ffmpeg

    ];
  };

  # perSystem = { system, ... }: {
    # packages.myZenBrowser = inputs.zen-browser.packages.${system}.default;
  # };


  # temperary solution until the flake is updated.
  perSystem = { system, pkgs, ... }: let
    zen-unwrapped = inputs.zen-browser.packages.${system}.zen-browser-unwrapped.overrideAttrs (old: {
      passthru = (old.passthru or {}) // {
        withFFmpeg = true;
      };
    });

    zen = pkgs.wrapFirefox zen-unwrapped {
      pname = "zen-browser";
    };
  in {
    packages.myZenBrowser = zen;
  };
}
