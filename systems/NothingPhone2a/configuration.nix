{}:    #               #             #              #                 #
#           #           #         #           #                  #            #
#   Here Be Dragons... and cobwebs #             #       #                   #
#          #              #                      #                  #
{
  imports = [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./Users/users.nix
    ../../modules/nixos/default-config.nix
  ];
}