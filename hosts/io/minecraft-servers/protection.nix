# Host-level protection for the Minecraft host. This is a thin wrapper around
# nix-minecraft: it reads the declared servers and automatically generates
# fail2ban jails and connection rate-limiting for each one, so a newly added
# server is protected without touching this file.
#
# A server is protected when it is enabled AND exposed (openFirewall = true).
# Private servers (openFirewall = false, e.g. local dev instances) are skipped.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.minecraft-servers;

  publicServers = lib.filterAttrs (_: s: s.enable && s.openFirewall) cfg.servers;

  serverPort = s: toString (s.serverProperties.server-port or 25565);
  logpath = name: "${cfg.dataDir}/${name}/logs/latest.log";

  ntfyAction = ''%(action_)s[blocktype=DROP] ntfy mail-whois[name=NoAuthFailures, dest=server-alert-ayes@proton.me]'';

  # One auth-abuse jail and one connection-flood jail per public server.
  mkJails = name: s: {
    "minecraft-${name}".settings = {
      enabled = true;
      port = serverPort s;
      filter = "minecraft";
      logpath = logpath name;
      backend = "auto";
      maxretry = 5;
      bantime = "1h";
      findtime = "10m";
      action = ntfyAction;
    };
    "minecraft-ddos-${name}".settings = {
      enabled = true;
      port = serverPort s;
      filter = "minecraft-ddos";
      logpath = logpath name;
      backend = "auto";
      maxretry = 10;
      findtime = "1m";
      bantime = "1h";
      action = ntfyAction;
    };
  };

  # Throttle new connections on each public server's port. The port itself is
  # opened by nix-minecraft's own openFirewall handling.
  mkRateLimit =
    _: s:
    let
      p = serverPort s;
    in
    ''
      iptables -A INPUT -p tcp --dport ${p} -m conntrack --ctstate NEW -m limit --limit 5/min --limit-burst 10 -j ACCEPT
      iptables -A INPUT -p tcp --dport ${p} -m conntrack --ctstate NEW -j DROP
    '';
in
{
  environment.systemPackages = with pkgs; [
    mcrcon
  ];

  # Host ports not tied to a single server (BlueMap web UI, Simple Voice Chat).
  networking.firewall = {
    allowedTCPPorts = [ 8100 ];
    allowedUDPPorts = [ 24454 ];
    extraCommands = lib.concatStrings (lib.mapAttrsToList mkRateLimit publicServers);
  };

  # Shared filters referenced by every generated jail.
  environment.etc = {
    "fail2ban/filter.d/minecraft.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      [Definition]
      failregex = ^.*\(/<HOST>\) lost connection: You are not white-listed on this server!.*$
                  ^.*<HOST>.*tried to log in with an invalid session.*$
                  ^.*Player.*\[/<HOST>:\d+\] was kicked.*$
    '');

    "fail2ban/filter.d/minecraft-ddos.conf".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      [Definition]
      failregex = ^.*<HOST>.*connection throttled.*$
                  ^.*Too many connections from <HOST>.*$
    '');
  };

  services.fail2ban.jails = lib.mkMerge (lib.mapAttrsToList mkJails publicServers);
}
