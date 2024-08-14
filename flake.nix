{
	description = "Nixos config flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		hyprsome.url = "github:sopa0/hyprsome";
		ags.url = "github:Aylur/ags";
		nix-ld = {
			url = "github:Mic92/nix-ld";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, hyprsome, nix-ld, ... }@inputs: let
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

						home-manager.extraSpecialArgs = { inherit inputs; };
					}

					nix-ld.nixosModules.nix-ld
					{ programs.nix-ld.dev.enable = true; }

				];
			};
		};

		#devShells.${system}.default = import ./environments/development.nix nixpkgs.legacyPackages.${system};
	};
}
