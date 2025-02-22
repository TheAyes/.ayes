{...}: {
  /*
  This file handles everything surrounding this very repository.
  */
  environment = {
    etc = {
      "commands.sh" = {
        target = "./.home/commands.sh";
        text = ''
          #! /run/current-system/sw/bin/bash

          pushd () {
          		command pushd "$@" > /dev/null
          }

          popd () {
          		command popd "$@" > /dev/null
          }

          export -f pushd popd
          export nixosConfigPath="$HOME/.nixos"
          export update="nix flake update --flake $nixosConfigPath"
          export rebuild="nixos-rebuild -v --use-remote-sudo --flake $nixosConfigPath"

          export return=popd

          set -e
          pushd "$nixosConfigPath"
        '';
      };

      "rebuild.sh" = {
        target = "./.home/rebuild.sh";
        text = ''
          #! /run/current-system/sw/bin/bash
          . ./commands.sh

          # Rebuild, output simplified errors, log tracebacks
          $rebuild "switch"

          echo "rebuild completed! Proceeding with git operations..."

          # Commit all changes with the generation metadata
          git add .
          git commit -am "$(nixos-rebuild list-generations | grep current)"

          $return
        '';
      };
    };
  };
}
