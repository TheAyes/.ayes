{
	description = "Nixos config flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nixpkgs-old.url = "github:nixos/nixpkgs/63346afdb84343873a5ea407279dc6a111f7e2e2";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		hyprsome.url = "github:sopa0/hyprsome";
		ags.url = "github:Aylur/ags";
	};

	outputs = { self, nixpkgs, nixpkgs-old, home-manager, hyprsome, ... }@inputs: let
		system = "x86_64-linux";
	in {
		nixosConfigurations = {
			io = nixpkgs.lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs; };
				modules = [
					./configuration.nix

					home-manager.nixosModules.home-manager {
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.users.ayes = import ./home.nix;

						# Optionally, use home-manager.extraSpecialArgs to pass
						# arguments to home.nix
						home-manager.extraSpecialArgs = { inherit inputs; };
					}
				];
			};
		};

		devShells.${system}.default = import ./environments/development.nix;
		
	};
}
