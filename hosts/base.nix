{ lib
, inputs
, pkgs
, ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = lib.mkDefault true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = lib.mkDefault "nix-command flakes";
        flake-registry = lib.mkDefault "";
      };
      channel.enable = lib.mkForce false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  programs = {
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    command-not-found.enable = false;

    git.enable = lib.mkDefault true;
  };

  environment.systemPackages = with pkgs; [
    micro
    linuxHeaders
    jq
  ];

  system.stateVersion = lib.mkForce "23.11";
}
