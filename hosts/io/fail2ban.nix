{ pkgs, ... }: {
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

    # Define an action that will trigger a Ntfy push notification upon the issue of every new ban
    "fail2ban/action.d/ntfy.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      [Definition]
      norestored = true # Needed to avoid receiving a new notification after every restart
      actionban = curl -H "Title: <ip> has been banned" -d "<name> jail has banned <ip> from accessing $(hostname) after <failures> attempts of hacking the system." https://ntfy.sh/Fail2banNotifications
    '');

  };

  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "24h";
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      #formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      multipliers = "1 4 8 16 32 64 128 256";
      maxtime = "720h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
    jails = {
      minecraft.settings = {
        enabled = true;
        port = "25565"; # Default Minecraft port
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
