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
      config = {
        credential = {
          helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
          credentialStore = "wincredman";
        };
      };
    };
  };



  environment = {
    systemPackages = with pkgs; [

    ];

    shellInit = ''

    '';

    shellAliases = {
      "rebuild-switch" = "pushd /mnt/c/Projekte/.ayes && /mnt/c/Projekte/.ayes/scripts/rebuild.sh switch && popd";
      "rebuild-test" = "pushd /mnt/c/Projekte/.ayes && /mnt/c/Projekte/.ayes/scripts/rebuild.sh test && popd";
      "upgrade" = "pushd /mnt/c/Projekte/.ayes && /mnt/c/Projekte/.ayes/scripts/rebuild.sh switch --update && popd";
    };
  };

  virtualisation.docker.enable = true;
}
