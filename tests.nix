{lib, pkgs, stdenv}:
with lib;
let
  mkReport = guides: pkgs.symlinkJoin {
    name = "report";
    paths = mapAttrsToList mkReportGuide guides;
  };
  mkReportGuide = guide: test_cases: pkgs.symlinkJoin {
    name = "guide-report-${guide}";
    paths = mapAttrsToList (mkTestCaseReport guide) test_cases;
  };
  mkTestCaseReport = guide: testCaseName: testCaseJson:
    with import (<nixpkgs> + "/nixos/lib/testing.nix") { system = builtins.currentSystem; };
    makeTest {
      name = "test-case-${guide}-${testCaseName}";
      machine = { config, pkgs, lib, nodes, ... }:
      {
        boot.kernelModules = [ "kvm-intel" ];
        virtualisation.memorySize = 2048;
        virtualisation.diskSize = 10240;
      };

      testScript = ''
        startAll;
        $machine->succeed("cd /root; ${guide-tester}/bin/runner -j ${testCaseJson}")
      '';
    };
  guide-tester = pkgs.callPackage ./guide_tester {};
in
rec {
  inherit guide-tester;
  tests = stdenv.mkDerivation {
    name = "all-guide-tests";
    src = ./guides;
    phases = "genPhase";
    genPhase = "mkdir $out; ${guide-tester}/bin/gen_tests -b $src -o $out";
  };

  report = mkReport (import tests);
}
