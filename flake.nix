{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    flake-parts.url = "github:hercules-ci/flake-parts";

    stylix.url = "github:danth/stylix";

    nixcord.url = "github:kaylorben/nixcord";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs =
    inputs @ { nixpkgs
    , flake-parts
    , ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, flake-parts-lib, ... }: {
      imports = [
        ./modules/flake/host-manager
      ];

      systems = [
        "x86_64-linux"
      ];

      host-manager = {
        enable = true;
        hosts = {
          io = {
            enable = true;

            home-manager = {
              enable = true;
              sharedModules = [ inputs.nixcord.homeManagerModules.nixcord ];
            };

            users = {
              ayes = {
                enable = true;
                home-manager.enable = true;
                groups = [ "networkmanager" "wheel" ];
              };

              janny = {
                enable = true;
                home-manager.enable = true;
              };
            };
          };

          leda = {
            enable = true;

            extraModules = [
              inputs.nixos-wsl.nixosModules.default
            ];
          };
        };
      };

      perSystem =
        { pkgs
        , config
        , ...
        }: {
          formatter = pkgs.nixpkgs-fmt;
        };
    });
}
