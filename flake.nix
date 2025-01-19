{
  inputs = {
    # I want to use unstable by default but for some things use stable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
          home-manager.nixosModules.home-manager
          {
            /*
              home-manager = import ./home/base.nix {
              inherit users;
              inherit inputs;
            };
            */
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
            specialArgs = {inherit inputs;};
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
