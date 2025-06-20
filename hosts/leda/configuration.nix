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

  services.gnome.gnome-keyring.enable = true;

  environment = {
    systemPackages = with pkgs; [
      gcr
      uv
      powershell
      podman
      podman-desktop
      jetbrains.webstorm
    ];

    shellAliases = {
      "push-bosmono" = "";
    };
  };

  users.defaultUserShell = pkgs.fish;
}
