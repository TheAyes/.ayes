{
  description = "Nixos config flake";

  inputs = {
    nixpkgs_unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs_workaround.url = "github:mschwaig/nixpkgs/comically-bad-rocm-workaround";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    stylix.url = "github:danth/stylix?rev=762c07ee10b381bc8e085be5b6c2ec43139f13b0";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprsome.url = "github:sopa0/hyprsome";
    ags.url = "github:Aylur/ags/v1";
  };

  outputs =
    { nixpkgs_unstable
    , nixpkgs_workaround
    , home-manager
    , ...
    } @ inputs:
    let
    in
    {
      nixosConfigurations = {
        io = nixpkgs_workaround.lib.nixosSystem {
          specialArgs = { inherit inputs; pkgs_stable = inputs.nixpkgs_stable.legacyPackages."x86_64-linux"; };

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
