{ hostname
, pkgs
, ...
}: {
  imports = [
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
      pinentryPackage = pkgs.pinentry-curses;
      enableSSHSupport = true;
    };
  };

  services = {
    passSecretService.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      claude-code
      pass
      gnupg1

      nodejs
      uv
      powershell
    ];

    shellInit = ''

    '';

    shellAliases = {
      "rebuild-switch" = "pushd /mnt/c/Projekte/.ayes && /mnt/c/Projekte/.ayes/scripts/rebuild.sh switch && popd";
      "rebuild-test" = "pushd /mnt/c/Projekte/.ayes && /mnt/c/Projekte/.ayes/scripts/rebuild.sh test && popd";
      "upgrade" = "pushd /mnt/c/Projekte/.ayes && /mnt/c/Projekte/.ayes/scripts/rebuild.sh switch --update && popd";
      #"bc14-push"      = "pushd /mnt/c/Projekte/bosmono/ && git update-index && git push apps/bc14 \"$(git subtree split --prefix=apps/bc14 main --rejoin):refs/heads/justin\" && git push && popd";
      #"bc14-push-force" = "pushd /mnt/c/Projekte/bosmono/ && git update-index && git push apps/bc14 \"$(git subtree split --prefix=apps/bc14 main --rejoin):refs/heads/justin\" --force && git push --force && popd";
      #"bc14-pull-master" = "pushd /mnt/c/Projekte/bosmono/ && git update-index && git subtree pull --prefix apps/bc14 apps/bc14 refs/heads/master && popd";
      #"bc14-object-split" = "pushd /mnt/c/Projekte/bosmono/ && git update-index && bc14-pull-master && pushd /mnt/c/Projekte/bosmono/apps/bc14/BC/ && powershell.exe \"C:\\Projekte\\bosmono\\packages\\cal-ps-tools\\ObjectSplit.ps1\" obj.txt && popd && popd";
    };
  };

  users.defaultUserShell = pkgs.fish;
  virtualisation.docker.enable = true;
}
