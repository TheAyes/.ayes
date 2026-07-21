{
  # Minecraft host entry point. Layers, from broad to specific:
  #   protection.nix       - host-wide firewall / fail2ban / tunnelling
  #   baseline-server.nix  - defaults every server inherits (applied by a pack)
  #   <pack>-base.nix      - config shared across one modpack's servers
  #   <pack>/<server>      - individual server overrides
  #
  # Each modpack is a directory (pack base + its <server>.nix files); the global
  # baseline and host protection live here in the root. `example/` is a disabled
  # template you can copy to add a real pack — then import its directory here.
  imports = [
    ./protection.nix
    ./example
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
  };
}
