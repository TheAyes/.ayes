{ user
, pkgs
, system
, inputs
, ...
}: {
  imports = [
    ../../../../common/users/ayes/home.nix

    ./nixcord.nix
  ];

  home.packages = with pkgs; [
    # Gaming
    #xivlauncher
    prismlauncher
    graalvm-ce
    heroic

    # Music Production
    bitwig-studio

    jetbrains.webstorm
    jetbrains.pycharm-professional
    jetbrains.idea-ultimate
    jetbrains.rider
    inputs.godot-fix.legacyPackages.${system}.godot-mono

    bun
    uv
    dotnetCorePackages.dotnet_9.sdk

    #revolt-desktop
    blockbench
    proton-pass

    inputs.zen-browser.packages.${system}.default
  ];

  programs = {
    bitwig.enable = true;
  };
}
