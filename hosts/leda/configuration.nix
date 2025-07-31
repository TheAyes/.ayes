{
  hostname,
  pkgs,
  ...
}: {
  imports = [
    ../../presets/nixos/desktopManagers/kde.nix

    ./security.nix
  ];

  system.stateVersion = "23.11";

  wsl = {
    enable = true;
    startMenuLaunchers = true;

    defaultUser = "ayes";
    interop.includePath = true;

    wslConf = {
      network.hostname = hostname;
      boot.systemd = true;
      interop.enabled = true;
    };
  };

  programs = {
    fish.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
      ];
    };

    git = {
      enable = true;
      config.credential = {
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        credentialStore = "gpg";
      };
    };

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry.tty;
      enableSSHSupport = true;
    };
  };

  services = {
    passSecretService.enable = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    fonts = {
      serif = {
        package = pkgs.caladea;
        name = "Caladea-Regular";
      };

      sansSerif = {
        package = pkgs.encode-sans;
        name = "EncodeSans-Regular";
      };

      monospace = {
        package = pkgs.cascadia-code;
        name = "CascadiaCodeNF";
      };

      emoji = {
        package = pkgs.serenityos-emoji-font;
        name = "SerenityOS Emoji";
      };
    };

    autoEnable = false;
    targets = {
      gtk.enable = true;
      qt.enable = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      pass
      gnupg1

      nodejs
      uv
      powershell
    ];

    shellInit = ''

    '';

    shellAliases = {
      "rebuild-switch" = "pushd /mnt/c/Projekte/.ayes && /mnt/c/Projekte/.ayes/scripts/rebuild.sh && popd";
      "rebuild-test" = "nixos-rebuild switch --sudo --flake /mnt/c/Projekte/.ayes/";
      "upgrade" = "pushd /mnt/c/Projekte/.ayes && /mnt/c/Projekte/.ayes/scripts/upgrade.sh && popd";
      "bc14-push" = "git push apps/bc14 \"$(git subtree split --prefix=apps/bc14 main --rejoin):refs/heads/justin\" && git push";
      "bc14-push-force" = "git push apps/bc14 \"$(git subtree split --prefix=apps/bc14 main --rejoin):refs/heads/justin --force\" && git push";
      "bc14-pull-master" = "git subtree pull --prefix apps/bc14 apps/bc14 refs/heads/master";
      "bc14-object-split" = "pushd /mnt/c/Projekte/bosmono/ && bc14-pull-master && pushd /mnt/c/Projekte/bosmono/apps/bc14/BC/ && powershell.exe \"C:\\Projekte\\bosmono\\packages\\cal-ps-tools\\ObjectSplit.ps1\" obj.txt && popd && popd";
    };
  };

  users.defaultUserShell = pkgs.fish;
  virtualisation.docker.enable = true;
}
