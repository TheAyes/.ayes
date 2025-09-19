{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord.url = "github:kaylorben/nixcord";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    solaar = {
      url = "github:Svenum/Solaar-Flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs =
    inputs @ { nixpkgs
    , flake-parts
    , ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem
      , flake-parts-lib
      , ...
      }: {

        imports = [ ./modules/flake-parts/host-manager ];

        systems = [ "x86_64-linux" ];

        host-manager = {
          enable = true;

          home-manager = { };

          sharedHostModules = [
            inputs.stylix.nixosModules.stylix
          ];

          hosts = {
            io = {
              enable = true;

              extraModules = [
                inputs.solaar.nixosModules.default
                inputs.nix-minecraft.nixosModules.minecraft-servers
                inputs.sops-nix.nixosModules.sops
              ];

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
                  groups = [ "networkmanager" "wheel" "gaming" "audio" "docker" "minecraft" ];
                };
              };
            };

            leda = {
              enable = true;

              users = {
                ayes = {
                  enable = true;
                  home-manager.enable = true;
                  groups = [ "wheel" "docker" ];
                };
              };

              extraModules = [ inputs.nixos-wsl.nixosModules.default ];
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
      }
    );
}
