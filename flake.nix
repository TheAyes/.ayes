{
  description = "Nixos config flake";

  inputs = {
    nixpkgs_unstable.url = "github:nixos/nixpkgs/f5ff3cf76b1875f1f6104a4d0032e2c85c6f1b3a";
    nixpkgs_stable.url = "github:nixos/nixpkgs/nixos-24.11";
    #nixpkgs_workaround.url = "github:mschwaig/nixpkgs/comically-bad-rocm-workaround";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    stylix.url = "github:danth/stylix";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprsome.url = "github:sopa0/hyprsome";
    ags.url = "github:Aylur/ags/v1";

    nixcord.url = "github:kaylorben/nixcord";
  };

  outputs =
    { nixpkgs_unstable
    , home-manager
    , ...
    } @ inputs:
    let
    in
    {
      nixosConfigurations = {
        io = nixpkgs_unstable.lib.nixosSystem {
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

              home-manager.sharedModules = [ inputs.nixcord.homeManagerModules.nixcord ];
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };
      };

      #devShells.${system}.default = import ./environments/development.nix nixpkgs.legacyPackages.${system};
    };
}
