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

		solaar = {
			url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz"; # For latest stable version
			#url = "https://flakehub.com/f/Svenum/Solaar-Flake/1.1.13.tar.gz" # uncomment line for version 1.1.13
			#url = "github:Svenum/Solaar-Flake/main"; # Uncomment line for latest unstable version
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, hyprsome, nixpkgs-alternate, solaar, ... }@inputs: let
		system = "x86_64-linux";
	in {
		nixosConfigurations = {
			io = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs; };
				modules = [
					./configuration.nix

					solaar.nixosModules.default

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
