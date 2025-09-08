{ pkgs, config, ... }: {

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.prominence =
      let
        allowedRam = "32G";
      in
      {
        enable = false;
        autoStart = false;
        openFirewall = true;
        package = pkgs.fabricServers.fabric-1_20_1;
        jvmOpts = "-Xmx${allowedRam} -Xms${allowedRam}";
        serverProperties = {
          gamemode = 0;
          force-gamemode = true;
          difficulty = 3;
          max-players = 10;
          white-list = true;
          enforce-whitelist = true;
          #level-seed = "-7827161134340464580";
          pvp = false;
          sync-chunk-write = false;
          simulation-distance = 8;
          view-distance = 12;
          spawn-protection = 0;

          enable-rcon = true;
          "rcon.password" = "local";
          "rcon.port" = 26656;
          broadcast-rcon-to-ops = true;
        };

        whitelist = {
          Ayes_For_Real = "9de723f7-dc47-4f22-bc46-bdf912e99f80";
          Slayandra = "548c4941-a799-40a0-b149-4296084ab876";
          #Bestiary = "3585a188-dd90-4322-8e89-3bb457648e82";
          Yuzumi25 = "8f371ca9-3095-4a7d-a641-9592e5355ba4";
          Ebilknibel = "89055e10-10cc-4cf0-a872-b5e713a786ba";
          Tekklar334 = "cba06ef3-102b-43e9-962d-62ef49fc1ff3";
          #moonshiiine = "a09fedac-4b1c-485d-86b5-436a087b110d";
          Ebil_1337 = "022e3770-2b75-49f0-a15c-65800ec2e263";
          Jehuty362 = "e89138b1-8b1b-4665-a9bc-dedf7f789bed";
        };

        symlinks = {
          "ops.json" = {
            value = [
              {
                name = "Ayes_For_Real";
                uuid = "9de723f7-dc47-4f22-bc46-bdf912e99f80";
                level = 99;
              }
            ];
          };
        };
      };
  };

  environment.systemPackages = with pkgs; [
    mcrcon
  ];

  networking.firewall = {
    allowedTCPPorts = [ 25565 8100 ];
    allowedUDPPorts = [ 24454 ];
    extraCommands = ''
      iptables -A INPUT -p tcp --dport 25565 -m conntrack --ctstate NEW -m limit --limit 5/min --limit-burst 10 -j ACCEPT
      iptables -A INPUT -p tcp --dport 25565 -m conntrack --ctstate NEW -j DROP
    '';
  };

  services.ddclient = {
    zone = "aethyria.live";
    domains = [ "mc.aethyria.live" ];
  };

  services.cloudflared = {
    enable = true;
  };


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

  services.fail2ban = {
    jails = {
      minecraft.settings = {
        enabled = true;
        port = "25565";
        filter = "minecraft";
        logpath = "/srv/minecraft/prominence/logs/latest.log";
        backend = "auto";
        maxretry = 5;
        bantime = "1h";
        findtime = "10m";
        action = ''%(action_)s[blocktype=DROP] ntfy mail-whois[name=NoAuthFailures, dest=server-alert-ayes@proton.me]'';
      };


      minecraft-ddos.settings = {
        enabled = true;
        filter = "minecraft-ddos";
        logpath = "/srv/minecraft/prominence/logs/latest.log";
        backend = "auto";
        maxretry = 10;
        findtime = "1m";
        bantime = "1h";
        action = ''%(action_)s[blocktype=DROP] ntfy mail-whois[name=NoAuthFailures, dest=server-alert-ayes@proton.me]'';
      };
    };
  };
}
