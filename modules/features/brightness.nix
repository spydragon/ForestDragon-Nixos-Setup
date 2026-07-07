{ self, ... }:

{
  # 1. Define the package for all system architectures
  perSystem = { pkgs, ... }: {
    packages.smartDimmer = pkgs.writeShellApplication {
      name = "smart-dimmer";
      
      # Ensures all required binaries are available to the script
      runtimeInputs = [ 
        pkgs.brightnessctl 
        pkgs.systemd 
        pkgs.gawk
        pkgs.coreutils
      ];
      
      text = ''
        show_help() {
          echo "Usage: smart-dimmer [+VALUE|-VALUE|get-value]"
          echo "Example: smart-dimmer -0.1  (Decreases brightness by 10%)"
          echo "Example: smart-dimmer +0.1  (Increases brightness by 10%)"
        }

        if [ "''${#}" -ne 1 ]; then
          show_help
          exit 1
        fi

        INPUT="''${1}"

        # 1. Validate the input strictly matches the +0.X or -0.X format
        if ! [[ "''${INPUT}" =~ ^([+-][0]?\.[0-9]{1,2}|[+-][1]\.[0]|get\-value)$ ]]; then
          echo "Error: Input must be a decimal preceded by + or - (e.g., -0.1) or get-value"
          exit 1
        fi

        # 2. Extract the direction (+ or -) and the raw decimal value
        DIR="''${INPUT:0:1}"
        VAL_DEC="''${INPUT:1}"

        # 3. Fetch current hardware percentage (0-100)
        HW_PCT=$(brightnessctl -m | awk -F, '{print $4}' | tr -d '%')
        
        # 4. Fetch current software decimal (0.0-1.0)
        # We use awk to strip the 'd' type prefix from the D-Bus output
        SW_DEC=$(busctl --user get-property rs.wl-gammarelay / rs.wl.gammarelay Brightness | awk '{print $2}')

        result=''$(awk -v hw="''${HW_PCT}" -v sw="''${SW_DEC}" '
          BEGIN {
            sw = sw * 100;
            print (hw + sw) / 2;
          }
        ')

        if [[ "''${INPUT}" =~ ^get\-value$ ]]; then
          printf '{"text":"%s", "percentage": %s}\n' "''${result}" "''${result}"
          exit 0
        fi

        # 5. Calculate the new states using awk to handle the decimal math
        read -r NEW_HW NEW_SW <<< "$(awk -v hw="''${HW_PCT}" -v sw="''${SW_DEC}" -v dir="''${DIR}" -v val_dec="''${VAL_DEC}" '
          BEGIN {
            val_dec = val_dec * 2;
            val_pct = val_dec * 100;
            new_hw = hw;
            new_sw = sw;

            if (dir == "+") {
              # Increasing: Raise Software first. If maxed, raise Hardware.
              if (sw < 1.0) {
                new_sw = sw + val_dec;
                if (new_sw > 1.0) {
                  overflow_dec = new_sw - 1.0;
                  new_sw = 1.0;
                  new_hw = hw + (overflow_dec * 100);
                }
              } else {
                new_hw = hw + val_pct;
              }
            } else if (dir == "-") {
              # Decreasing: Lower Hardware first. If at minimum, lower Software.
              if (hw > 0) {
                new_hw = hw - val_pct;
                if (new_hw < 0) {
                  overflow_pct = -new_hw;
                  new_hw = 0;
                  new_sw = sw - (overflow_pct / 100);
                }
              } else {
                new_sw = sw - val_dec;
              }
            }

            # Safety Bounds: Ensure values never exceed system limits
            if (new_hw > 100) new_hw = 100;
            if (new_hw < 0) new_hw = 0;
            if (new_sw > 1.0) new_sw = 1.0;
            if (new_sw < 0.1) new_sw = 0.1; # Safety net to prevent a pitch-black, unrecoverable screen

            # Print the results back to the bash read array
            printf "%d %.2f\n", new_hw, new_sw;
          }
        ')"

        # 6. Apply the calculated states
        brightnessctl set "''${NEW_HW}%" -q
        busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d "''${NEW_SW}"
        pkill -RTMIN+8 waybar
      '';
    };
  };

  # 2. Define the NixOS module that exposes it to your system config
  flake.nixosModules.smartDimmer = { pkgs, ... }: {
    environment.systemPackages = [ 
      # Reference the package we built above, fetching the correct system architecture
      self.packages.${pkgs.stdenv.hostPlatform.system}.smartDimmer 
    ];
  };
}
