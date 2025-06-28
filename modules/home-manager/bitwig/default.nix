{ pkgs, config, lib, ... }: {
  options.programs.bitwig = {
    enable = lib.mkEnableOption "Bitwig";
    package = lib.mkOption {
      type = lib.types.unspecified;
      default = pkgs.bitwig-studio;
    };
  };

  config = lib.mkIf config.programs.bitwig.enable {
    home.packages = with pkgs; [
      config.programs.bitwig.package

      yabridge
      yabridgectl

      # VST's
      vital
      #decent-sampler
    ];


  };
}
