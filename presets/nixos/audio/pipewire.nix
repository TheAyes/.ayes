{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;
    wireplumber.enable = true;

    jack.enable = true;
    extraConfig = {
      jack = {
        "10-clock-rate" = {
          "jack.properties" = {
            "node.latency" = "128/48000";
            "node.rate" = "1/48000";
          };
        };
      };
      pipewire = {
        "10-clock-rate" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.allowed-rates" = [
              44100
              48000
            ];
            "default.clock.quantum" = 32;
            "default.clock.min-quantum" = 16;
            "default.clock.max-quantum" = 8192;
          };
        };
      };
    };
  };

}
