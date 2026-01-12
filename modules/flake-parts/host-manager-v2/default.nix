{
  flake-parts-lib,
  nixpkgs-lib,
  ...
}: {
  lib,
  inputs,
  ...
}:
assert inputs.nixpkgs || throw "'inputs.nixpkgs' was not given. Host-Manager cannot build configurations without it."; {
  imports = [
    ./host.nix
  ];

  options.host-manager = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable host-manager";
      example = true;
    };

    hostsPath = lib.mkOption {
      type = lib.types.path;
      default = /hosts;
      description = "The location for where your host-files are going to reside in";
      example = /some/other/host/path;
    };

    usersPath = lib.mkOption {
      type = lib.types.path;
      default = /users;
      description = "The location for where your user-files are going to reside in";
      example = /some/other/user/path;
    };

    nixos = {
      input = lib.mkOption {
        type = lib.types.deferredModule;
        default = inputs.nixpkgs;
        description = "The input to take for nixpkgs";
        example = inputs.nixpkgs-unstable;
      };

      globalNixosModules = lib.mkOption {
        type = with lib.types; listOf deferredModule;
        default = [];
        description = "Extra modules that will be imported for all hosts managed by host-manager";
        example = [
          inputs.sops-nix.nixosModules.sops
          inputs.solaar.nixosModules.default
          ./modules/nixos/my-custom-module
        ];
      };
    };

    home-manager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable home-manager";
        example = true;
      };

      input = lib.mkOption {
        type = lib.types.deferredModule;
        default = inputs.home-manager;
        description = "The input to take for home-manager";
        example = inputs.home-manager-unstable;
      };

      useGlobalPkgs = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "A wrapper for the original 'home-manager.useGlobalPkgs' for you to set";
        example = false;
      };

      useUserPackages = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "A wrapper for the original 'home-manager.useUserPackages' for you to set";
        example = false;
      };

      globalHomeManagerModules = lib.mkOption {
        type = with lib.types; listOf deferredModule;
        default = [];
        description = "Extra modules that will be imported for all home-manager users across all hosts managed by host-manager";
        example = [
          inputs.nixcord.homeModules.nixcord
          inputs.zen-browser.homeModules.twilight
          ./modules/home-manager/my-custom-module
        ];
      };
    };
  };

  config.flake = lib.mkIf config.host-manager.enable {
    nixosConfigurations = lib.mapAttrs (hostname: hostConfig:
      lib.nixosSystem {
        modules = [
        ];
      })
    config.host-manager.hosts;
  };
}
