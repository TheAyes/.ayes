# Aethyria modpack — Fabric mc-26.2.
{ lib, pkgs, ... }:
let
  mkBaseline = import ../baseline-server.nix { inherit lib pkgs; };

  package = pkgs.fabricServers.fabric-26_2.override { jre_headless = pkgs.temurin-jre-bin; };

  # One entry per server in this pack; the key must match a <server>.nix file.
  heapSize = {
    aethyria = "16G";
    aethyria-dev = "8G";
  };

  serverNames = builtins.attrNames heapSize;
in
{
  imports = builtins.map (server: ./. + "/${server}.nix") serverNames;

  services.minecraft-servers.servers = lib.attrsets.genAttrs serverNames (
    name:
    lib.mkMerge [
      (mkBaseline { heapSize = heapSize.${name}; })
      { inherit package; }
    ]
  );
}
