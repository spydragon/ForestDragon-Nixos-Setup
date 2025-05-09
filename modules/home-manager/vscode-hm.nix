{ pkgs, inputs, config, ... }:

{
  home.packages = with pkgs; with nerd-fonts; [
    nixd
    direnv

    # Fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    jetbrains-mono
    font-awesome
  ];

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  programs.vscode = {
    enable = true;

    # if downgrading caused problems, un-nest profiles.default
    profiles.default = {
      # extensions = (with pkgs.vscode-extensions; [
        
      # ]);

      userSettings = /* json */ {
        # Nix Language Server
        "nix.serverPath" = "nixd";
        "nix.enableLanguageServer" = true;
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [ "alejandra" ]; # or nixfmt or nixpkgs-fmt
            };
            "options" = {
              "nixos" = {
                "expr" = "(builtins.getFlake \"${config.home.homeDirectory}/nixos/flake.nix\").nixosConfigurations.frameworkLaptop16.options";
              };
              "home_manager" = {
                "expr" = "(builtins.getFlake \"${config.home.homeDirectory}/nixos/flake.nix\").homeConfigurations.frameworkLaptop16.options";
              };
            };
          };
        };
      };
    };
  };
}