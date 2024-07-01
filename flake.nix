{
	description = "Nixos config flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nixpkgs-alternate.url = "github:NixOS/nixpkgs/6acd31ddaff676c571d58636985a4802f7743809";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		hyprsome.url = "github:sopa0/hyprsome";
		ags.url = "github:Aylur/ags";
	};

	outputs = { self, nixpkgs, home-manager, hyprsome, nixpkgs-alternate, ... }@inputs: let
		system = "x86_64-linux";
	in {
		nixosConfigurations = {
			io = nixpkgs.lib.nixosSystem {
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

		devShells.${system}.default = import ./environments/development.nix nixpkgs.legacyPackages.${system};
	};
}
