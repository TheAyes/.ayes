{
  # Top-level constants for repetitive values

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = inputs @ {nixpkgs, ...}: let
    # Function to map users for better reusability
    usersBuilder = usersAttrs:
      nixpkgs.lib.mapAttrs
      (name: value: {${name} = value;})
      usersAttrs;

    systemStateVersion = "23.11";

    # User definitions
    users = usersBuilder {
      ayes = {
        groups = ["wheel"];
        home-manager.enable = true;
      };

      janny = {
        home-manager.enable = true;
      };
    };

    # System configurations
    systemConfigurations = {
      io = {
        importsDefault = true;
        extraModules = [
        ];
        users = [
          users.ayes
          users.janny
        ];
      };

      leda = {
        importsDefault = true;
        extraModules = [
          inputs.nixos-wsl.nixosModules.default
        ];
        users = [];
      };
    };
  in {
    # System generation with reusable logic
    nixosConfigurations =
      nixpkgs.lib.mapAttrs
      (
        name: systemConfig:
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {inherit inputs systemStateVersion;};
            modules =
              [
                inputs.home-manager.nixosModules.home-manager
                ./modules/user-manager
                (
                  if systemConfig.importsDefault
                  then ./hosts
                  else null
                )
                ./hosts/${name}

                {
                  user-manager =
                    builtins.foldl' (acc: elt: acc // elt) {}
                    systemConfig.users;
                }
              ]
              ++ systemConfig.extraModules;
          }
      )
      systemConfigurations;
  };
}
