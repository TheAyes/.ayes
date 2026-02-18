{ pkgs, ... }:
{
  home.packages = with pkgs; [
    heroic
    lutris
    (prismlauncher.override {
      jdks = [
        graalvmPackages.graalvm-ce
        temurin-jre-bin
        zulu17
      ];
    })
  ];
}
