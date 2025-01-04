{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix?rev=762c07ee10b381bc8e085be5b6c2ec43139f13b0";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprsome.url = "github:sopa0/hyprsome";
    ags.url = "github:Aylur/ags/v1";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, hyprsome, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        io = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix

            inputs.stylix.nixosModules.stylix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ayes = import ./users/ayes.nix;
              home-manager.users.janny = import ./users/janny.nix;

              home-manager.extraSpecialArgs = { inherit inputs; };
            }

          ];
        };
      };

      #devShells.${system}.default = import ./environments/development.nix nixpkgs.legacyPackages.${system};
    };
}
