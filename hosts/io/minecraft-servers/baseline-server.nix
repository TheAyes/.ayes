# Global per-server baseline. Returns the default settings every Minecraft server
# inherits. A pack layer applies it to each of its servers (see
# prominence-2-base.nix); instance directories then override specifics.
#
# Everything here is wrapped in lib.mkDefault so a pack or an individual server
# can override any value.
#
#   let mkBaseline = import ./baseline-server.nix { inherit lib pkgs; };
#   in mkBaseline { heapSize = "16G"; }
{ lib, pkgs }:
{ heapSize ? "8G" }:
{
  enable = lib.mkDefault true;
  autoStart = lib.mkDefault true;
  package = lib.mkDefault (
    pkgs.fabricServers.fabric-1_20_1.override { jre_headless = pkgs.temurin-jre-bin; }
  );

  jvmOpts = lib.mkDefault (lib.concatStringsSep " " [
    # Heap sizing
    "-Xmx${heapSize}"
    "-Xms${heapSize}"

    # Unlock non-standard options used below
    "-XX:+UnlockExperimentalVMOptions"
    "-XX:+UnlockDiagnosticVMOptions"

    # General runtime tuning
    "-XX:+AlwaysActAsServerClassMachine"
    "-XX:+AlwaysPreTouch"
    "-XX:+DisableExplicitGC"
    "-XX:+UseNUMA"
    "-XX:+UseVectorCmov"
    "-XX:+PerfDisableSharedMem"
    "-XX:+UseFastUnorderedTimeStamps"
    "-XX:+UseCriticalJavaThreadPriority"
    "-XX:ThreadPriorityPolicy=1"
    "-XX:AllocatePrefetchStyle=3"

    # JIT / code cache
    "-XX:NmethodSweepActivity=1"
    "-XX:ReservedCodeCacheSize=400M"
    "-XX:NonNMethodCodeHeapSize=12M"
    "-XX:ProfiledCodeHeapSize=194M"
    "-XX:NonProfiledCodeHeapSize=194M"
    "-XX:-DontCompileHugeMethods"
    "-XX:MaxNodeLimit=240000"
    "-XX:NodeLimitFudgeFactor=8000"

    # G1 garbage collector
    "-XX:+UseG1GC"
    "-XX:MaxGCPauseMillis=130"
    "-XX:G1NewSizePercent=28"
    "-XX:G1HeapRegionSize=16M"
    "-XX:G1ReservePercent=20"
    "-XX:G1MixedGCCountTarget=3"
    "-XX:InitiatingHeapOccupancyPercent=10"
    "-XX:G1MixedGCLiveThresholdPercent=90"
    "-XX:G1RSetUpdatingPauseTimePercent=0"
    "-XX:SurvivorRatio=32"
    "-XX:MaxTenuringThreshold=1"
    "-XX:G1SATBBufferEnqueueingThresholdPercent=30"
    "-XX:G1ConcMarkStepDurationMillis=5"
    "-XX:G1ConcRSHotCardLimit=16"
    "-XX:G1ConcRefinementServiceIntervalMillis=150"
    "-XX:ConcGCThreads=6"
  ]);

  serverProperties = {
    force-gamemode = lib.mkDefault true;
    white-list = lib.mkDefault true;
    enforce-whitelist = lib.mkDefault true;
    pvp = lib.mkDefault false;
    sync-chunk-write = lib.mkDefault false;
    simulation-distance = lib.mkDefault 8;
    view-distance = lib.mkDefault 12;
    spawn-protection = lib.mkDefault 0;
  };

  # Admin access on every server.
  whitelist = {
    Ayes_For_Real = "9de723f7-dc47-4f22-bc46-bdf912e99f80";
  };
  operators = {
    Ayes_For_Real = {
      level = 4;
      uuid = "9de723f7-dc47-4f22-bc46-bdf912e99f80";
      bypassesPlayerLimit = true;
    };
  };
}
