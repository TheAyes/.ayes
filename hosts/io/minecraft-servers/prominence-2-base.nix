{ lib, pkgs, ... }:
let
  servers = [ "prominence" "prominence-dev" ];
in
{
  imports = builtins.map (server: "./" + server) servers;

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = lib.attrsets.genAttrs servers (
      name:
      let
        allowedRam = "16G";
      in
      {
        "${name}" = {

          enable = true;
          autoStart = true;
          package = pkgs.fabricServers.fabric-1_20_1.override { jre_headless = pkgs.temurin-jre-bin; };
          jvmOpts = "-Xmx${allowedRam} -Xms${allowedRam} -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+AlwaysActAsServerClassMachine -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseNUMA -XX:NmethodSweepActivity=1 -XX:ReservedCodeCacheSize=400M -XX:NonNMethodCodeHeapSize=12M -XX:ProfiledCodeHeapSize=194M -XX:NonProfiledCodeHeapSize=194M -XX:-DontCompileHugeMethods -XX:MaxNodeLimit=240000 -XX:NodeLimitFudgeFactor=8000 -XX:+UseVectorCmov -XX:+PerfDisableSharedMem -XX:+UseFastUnorderedTimeStamps -XX:+UseCriticalJavaThreadPriority -XX:ThreadPriorityPolicy=1 -XX:AllocatePrefetchStyle=3 -XX:+UseG1GC -XX:MaxGCPauseMillis=130 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=28 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=20 -XX:G1MixedGCCountTarget=3 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=0 -XX:SurvivorRatio=32 -XX:MaxTenuringThreshold=1 -XX:G1SATBBufferEnqueueingThresholdPercent=30 -XX:G1ConcMarkStepDurationMillis=5 -XX:G1ConcRSHotCardLimit=16 -XX:G1ConcRefinementServiceIntervalMillis=150 -XX:ConcGCThreads=6";

          serverProperties = {
            force-gamemode = true;
            white-list = true;
            enforce-whitelist = true;
            pvp = false;
            sync-chunk-write = false;
            simulation-distance = 8;
            view-distance = 12;
            spawn-protection = 0;
          };

          whitelist = { Ayes_For_Real = "9de723f7-dc47-4f22-bc46-bdf912e99f80"; };
          operators = {
            Ayes_For_Real = {
              level = 4;
              uuid = "9de723f7-dc47-4f22-bc46-bdf912e99f80";
              bypassesPlayerLimit = true;
            };
          };
        };
      }
    );
  };
}
