{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    solaar = {
      url = "github:Svenum/Solaar-Flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs
    , flake-parts
    , ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        imports = [ ./modules/flake-parts/host-manager ];

        systems = [ "x86_64-linux" ];

        host-manager = {
          enable = true;

          home-manager = { };

          sharedHostModules = [
            inputs.sops-nix.nixosModules.sops
          ];

          hosts = {
            io = {
              enable = true;

              extraModules = [
                inputs.solaar.nixosModules.default
                inputs.nix-minecraft.nixosModules.minecraft-servers
              ];

              home-manager = {
                enable = true;

                # Modules for all users
                sharedModules = [
                  inputs.nixcord.homeModules.nixcord
                  inputs.zen-browser.homeModules.twilight
                  ./modules/home-manager/bitwig
                ];
              };

              users = {
                ayes = {
                  enable = true;
                  home-manager.enable = true;
                  groups = [
                    "networkmanager"
                    "wheel"
                    "gaming"
                    "audio"
                    "docker"
                    "minecraft"
                    "libvirtd"
                  ];
                };
              };
            };

            leda = {
              enable = true;
              home-manager.enable = true;

              users = {
                ayes = {
                  enable = true;
                  home-manager.enable = true;
                  groups = [
                    "wheel"
                    "docker"
                  ];
                };
              };

              extraModules = [ inputs.nixos-wsl.nixosModules.default ];
            };

            calliope = {
              enable = true;
              ayes = {
                enable = true;
                groups = [
                  "wheel"
                ];
              };
            };

            janus = {
              enable = true;
              users = {
                ayes = {
                  enable = true;
                  groups = [
                    "wheel"
                  ];
                };
              };
            };
          };
        };

        perSystem =
          { pkgs, ... }:
          {
            formatter = pkgs.nixpkgs-fmt;
          };
      }
    );
}
