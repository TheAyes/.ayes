{ user
, pkgs
, lib
, system
, inputs
, ...
}: {
  imports = [

  ];

  dconf.enable = lib.mkForce false;

  home.packages = with pkgs; [
    bun
  ];
}
