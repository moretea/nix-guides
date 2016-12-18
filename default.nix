with import <nixpkgs> {};
with lib;
let
  python = import ./requirements.nix { inherit pkgs; };
in
{
  release = stdenv.mkDerivation {
    name = "release";
    srcs = [ ./mkdocs.yml ./guides];
    builtInputs = [glibc];
    phases = "buildPhase";

    LANG="en_US.utf-8";
    LC_ALL="en_US.utf-8";

    buildPhase = ''
      for src in $srcs; do
        name=$(echo $src | awk '{split($0,a,"-"); print a[2]}')
        ln -s $src $name
      done

      ${python.packages."mkdocs"}/bin/mkdocs build
      mv site $out
    '';
  };

  dev-server = pkgs.writeTextFile {
    name = "dev-server";
    executable = true;
    text = ''
      ${python.packages."mkdocs"}/bin/mkdocs serve
    '';
  };

  tests = import ./tests.nix { inherit lib pkgs stdenv; };
}
