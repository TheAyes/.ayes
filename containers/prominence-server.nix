{
  containers.prominence = {
    autoStart = true;

    config = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
      services.minecraft-server = {
        enable = true;
        # I'm overriding this in order to get a fabric server instead of fabric
        package = pkgs.minecraftServers.vanilla-1-20.override {
          url = "https://meta.fabricmc.net/v2/versions/loader/1.20.1/0.17.2/1.1.0/server/jar";
          sha1 = "sha1-wgNqF+JMKvJt9DCn2Uc41jM4lio=";
        };
        eula = true;
        openFirewall = true;
        declarative = true;
        jvmOpts = "-Xms32G -Xmx32G";
        serverProperties = {
          difficulty = 3;
          gamemode = 0;
          max-players = 10;
          white-list = false;
          allow-cheats = false;
          enforce-gamemode = true;
        };
        whitelist = { };

      };
    };
  };
}
