{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    godot-fix.url = "github:nixos/nixpkgs?rev=e32a27edc351e188df549efdcee3ca11bdb4af28";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    flake-parts.url = "github:hercules-ci/flake-parts";

    stylix.url = "github:danth/stylix";

    nixcord.url = "github:kaylorben/nixcord";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    solaar = {
      url = "github:Svenum/Solaar-Flake/main"; # Uncomment line for latest unstable version
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      withSystem,
      flake-parts-lib,
      ...
    }: {
      imports = [./modules/flake-parts/host-manager];

      systems = ["x86_64-linux"];

      host-manager = {
        enable = true;

        home-manager = {};

        hosts = {
          io = {
            enable = true;

            extraModules = [inputs.solaar.nixosModules.default];

            home-manager = {
              enable = true;

              # Modules for all users
              sharedModules = [
                inputs.nixcord.homeModules.nixcord
                ./modules/home-manager/bitwig
              ];
            };

            users = {
              ayes = {
                enable = true;
                home-manager.enable = true;
                groups = ["networkmanager" "wheel" "gaming" "audio" "docker"];
              };

              janny = {
                enable = false;
                home-manager.enable = true;
                groups = ["gaming"];
              };
            };
          };

          leda = {
            enable = true;

            users = {
              ayes = {
                enable = true;
                home-manager.enable = true;
                groups = ["wheel" "docker"];
              };
            };

            extraModules = [inputs.nixos-wsl.nixosModules.default];
          };
        };
      };

      perSystem = {
        pkgs,
        config,
        ...
      }: {
        formatter = pkgs.nixpkgs-fmt;
      };
    });
}
