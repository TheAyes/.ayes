{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  nixpkgs = {
    config = {
      allowUnfree = lib.mkForce true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      optimise.automatic = true;
      settings = {
        experimental-features = lib.mkDefault "nix-command flakes";
        flake-registry = lib.mkDefault "";
        auto-optimise-store = true;
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

    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 14d --keep 5";
      };
    };
    command-not-found.enable = false;

    git.enable = lib.mkDefault true;
  };

  environment.systemPackages = with pkgs; [
    micro
    linuxHeaders
    jq
    nixfmt-rfc-style
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.caskaydia-cove
  ];

  system.stateVersion = lib.mkForce "23.11";
}
