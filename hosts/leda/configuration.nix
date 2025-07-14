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
      config.credential = {
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        credentialStore = "secretservice";
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      keepassxc
      uv
      powershell
    ];

    shellAliases = {
      "rebuild-switch" = "nixos-rebuild switch --use-remote-sudo -v --flake /mnt/c/Projekte/.ayes/";
      "rebuild-test" = "nixos-rebuild switch --use-remote-sudo -v --flake /mnt/c/Projekte/.ayes/";
      "upgrade" = "command=(cd /mnt/c/Projekte/.ayes && /mnt/c/Projekte/.ayes/scripts/upgrade.sh) $command";
      "bc14-push" = "git push apps/bc14 \"$(git subtree split --prefix=apps/bc14 main --rejoin):refs/heads/justin\" && git push";
      "bc14-pull-master" = "git subtree pull --prefix apps/bc14 apps/bc14 refs/heads/master";
      "bc14-object-split" = "pushd /mnt/c/Projekte/bosmono/ && bc14-pull-master && pushd /mnt/c/Projekte/bosmono/apps/bc14/BC/ && powershell.exe \"C:\\Projekte\\bosmono\\packages\\cal-ps-tools\\ObjectSplit.ps1\" obj.txt && popd && popd";
    };
  };

  users.defaultUserShell = pkgs.fish;
}
