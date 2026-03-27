{
  pkgs,
  lib,
  ...
}: {
  programs.btop = {
    package = lib.mkDefault pkgs.btop-rocm;
  };
}
