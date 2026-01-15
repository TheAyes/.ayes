{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.mkFlake {inherit inputs;} {
      systems = [];
      flake = {
        flakeModule = ./module.nix;
      };
      perSystem = {pkgs, ...}: {
        formatter = pkgs.nixpkgs-fmt;
      };
    };
}
