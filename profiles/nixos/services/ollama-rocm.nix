{ pkgs, lib, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    rocmOverrideGfx = lib.mkDefault "gfx1101";
  };
}
