{
  hostname,
  pkgs,
  ...
}: rec {
  imports = [
    ./security.nix
  ];

  system.stateVersion = "23.11";

  wsl = {
    enable = true;
    startMenuLaunchers = true;

    defaultUser = "ayes";

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

    git = {
      enable = true;
      package = pkgs.gitFull;
      /*
        config.credential = {
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        credentialStore = "secretservice";
      };
      */
    };
  };

  services = {
    passSecretService.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      pass

      uv
      powershell
    ];

    shellInit = ''

    '';

    shellAliases = {
      "rebuild-switch" = "nixos-rebuild switch --sudo -v --flake /mnt/c/Projekte/.ayes/";
      "rebuild-test" = "nixos-rebuild switch --sudo -v --flake /mnt/c/Projekte/.ayes/";
      "upgrade" = "pushd /mnt/c/Projekte/.ayes && /mnt/c/Projekte/.ayes/scripts/upgrade.sh && popd";
      "bc14-push" = "git push apps/bc14 \"$(git subtree split --prefix=apps/bc14 main --rejoin):refs/heads/justin\" && git push";
      "bc14-pull-master" = "git subtree pull --prefix apps/bc14 apps/bc14 refs/heads/master";
      "bc14-object-split" = "pushd /mnt/c/Projekte/bosmono/ && bc14-pull-master && pushd /mnt/c/Projekte/bosmono/apps/bc14/BC/ && powershell.exe \"C:\\Projekte\\bosmono\\packages\\cal-ps-tools\\ObjectSplit.ps1\" obj.txt && popd && popd";
    };
  };

  users.defaultUserShell = pkgs.fish;
  virtualisation.docker.enable = true;
}
