{ pkgs, lib, ... }:
{
  home.packages = with pkgs;
    lib.attrValues (
      lib.genAttrs
        [
          "idea"
          "clion"
        ]
        (ide:
          jetbrains."${ide}".override {
            forceWayland = true;
          }
        )
    );
}
