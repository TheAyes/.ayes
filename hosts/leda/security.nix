{
  nix.settings.secret-key-files = [ "/etc/nix/private-key" ];
  security = {
    pki.certificateFiles = [
      ../../certificates/BosRoot-CA.cer
    ];
  };
}
