{ hostname
, pkgs
, ...
}: {
  imports = [
    ./security.nix
    ./sops.nix
  ];

  system.stateVersion = "23.11";

  wsl = {
    enable = true;
    startMenuLaunchers = true;

    defaultUser = "ayes";
    interop.includePath = false;

    wslConf = {
      network = {
        hostname = hostname;
        generateResolvConf = false;
      };
      interop.enabled = false;
    };
  };

  programs = {
    fish.enable = true;

    dconf.enable = true;
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
  };

  services = {
    passSecretService.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      icu
      pass
      gnupg1
      meson
      ninja
      python315

      nodejs
      uv
      powershell
      claude-code
    ];

    shellAliases = {
      "rebuild-switch" = "pushd /mnt/c/Projekte/.ayes && /mnt/c/Projekte/.ayes/scripts/rebuild.sh switch && popd";
      "rebuild-test" = "pushd /mnt/c/Projekte/.ayes && /mnt/c/Projekte/.ayes/scripts/rebuild.sh test && popd";
      "upgrade" = "pushd /mnt/c/Projekte/.ayes && /mnt/c/Projekte/.ayes/scripts/rebuild.sh switch --update && popd";
    };
  };

  virtualisation.docker.enable = true;
}
