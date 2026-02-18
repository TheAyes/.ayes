{ pkgs, ... }:
{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-replay-source
      advanced-scene-switcher
      obs-pipewire-audio-capture
    ];
  };
}
