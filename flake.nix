{
  inputs = {
    # I want to use unstable by default but for some things use stable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix?rev=762c07ee10b381bc8e085be5b6c2ec43139f13b0";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprsome.url = "github:sopa0/hyprsome";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    users = [
      {
        username = "ayes";
        extraGroups = ["wheel" "networkmanager" "libvirtd" "docker"];
      }
      {
        username = "janny";
        extraGroups = ["networkmanager"];
      }
    ];

    hosts = [
      {
        hostname = "io";
        modules = [
          inputs.stylix.nixosModules.stylix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;

              users = builtins.listToAttrs (
                builtins.map
                (user: {
                  name = user.username;
                  value =
                    (import ./${user.username} {user = user.username;})
                    // {
                      home = {
                        username = user.username;
                        homeDirectory = "/home/${user.username}";

                        stateVersion = "23.11";
                      };
                    };
                })
                users
              );
            };
          }
        ];
      }
    ];
  in {
    nixosConfigurations = builtins.listToAttrs (
      builtins.map (
        host: {
          name = host.hostname;

          value = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              users = users; # Todo: Switch to a custom module
              host = host.hostname; # Todo: ^
            };

            modules =
              [
                ./repo.nix

                ./hosts/base.nix
                ./hosts/${host.hostname}
              ]
              ++ host.modules;
          };
        }
      )
      hosts
    );
  };
}
