{buildRubyGem, bundlerEnv, ruby}:
buildRubyGem {
  inherit ruby;
  gemName = "guide-tester";
  version = "inrepo";
  src = ./.;
}
