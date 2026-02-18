{
  services.pipewire = {
    enable = true;
    audio.enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    wireplumber.enable = true;
    pulse.enable = true;
  };
}
