{ pkgs, config, lib, ... }: {
  options.programs.bitwig = {
    enable = lib.mkEnableOption "Bitwig";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bitwig-studio;
    };
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
    pluginPaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "$HOME/.nix-profile/lib"
        "/run/current-system/sw/lib"
        "/etc/profiles/per-user/$USER/lib"
      ];
    };
  };

  config = lib.mkIf config.programs.bitwig.enable {
    home = {
      packages = [
        config.programs.bitwig.package
      ] ++ config.programs.bitwig.extraPackages;

      sessionVariables =
        let
          makePluginPath = format:
            (lib.strings.makeSearchPath format config.programs.bitwig.pluginPaths)
            + ":$HOME/.${format}";
        in
        {
          DSSI_PATH = makePluginPath "dssi";
          LADSPA_PATH = makePluginPath "ladspa";
          LV2_PATH = makePluginPath "lv2";
          LXVST_PATH = makePluginPath "lxvst";
          VST_PATH = makePluginPath "vst";
          VST3_PATH = makePluginPath "vst3";
        };
    };


  };
}
