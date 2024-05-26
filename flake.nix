{
	description = "Nixos config flake";

	inputs = {
	  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

	  home-manager = {
	  	url = "github:nix-community/home-manager";
	  	inputs.nixpkgs.follows = "nixpkgs";
	  };

	  hyprsome.url = "github:sopa0/hyprsome";
	};

	outputs = { self, nixpkgs, home-manager, hyprsome, ... }@inputs: {
		nixosConfigurations = {
			io = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit inputs; };
				modules = [
					./configuration.nix

					home-manager.nixosModules.home-manager.home-manager {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.ayes = import ./home.nix;

						# Optionally, use home-manager.extraSpecialArgs to pass
						# arguments to home.nix
						extraSpecialArgs = { inherit inputs; };
					}
				];
			};
		};
		
	};
}
