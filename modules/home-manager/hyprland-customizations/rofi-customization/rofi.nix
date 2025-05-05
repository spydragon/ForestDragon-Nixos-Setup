{ /*config,*/ ... }:
let
  # inherit (config.lib.formats.rasi) mkLiteral;
in {
  programs.rofi = {
    enable = true;
    theme = ./rounded-gray-dark.rasi;
    location = "center";
    yoffset = 100;

  };
}