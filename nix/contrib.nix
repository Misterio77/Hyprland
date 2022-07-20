{ lib
, stdenv
, coreutils
, makeWrapper
, installShellFiles
, wl-clipboard
, libnotify
, slurp
, grim
, jq
, bash
, hyprland
}:

{
  grimblast = stdenv.mkDerivation rec {
    pname = "grimblast";
    inherit (hyprland) version src;

    dontBuild = true;
    dontConfigure = true;

    outputs = [ "out" "man" ];

    strictDeps = true;
    nativeBuildInputs = [ makeWrapper installShellFiles ];
    buildInputs = [ bash ];
    installPhase = ''
      installManPage contrib/grimblast.1
      install -Dm 0755 contrib/grimblast $out/bin/grimblast
      wrapProgram $out/bin/grimblast --set PATH \
        "${lib.makeBinPath [
          hyprland
          wl-clipboard
          coreutils
          libnotify
          slurp
          grim
          jq
          ] }"
    '';

    doInstallCheck = true;

    installCheckPhase = ''
      # check always returns 0
      if [[ $($out/bin/grimblast check | grep "NOT FOUND") ]]; then false
      else
        echo "grimblast check passed"
      fi
    '';

    meta = with lib; {
      description = "A helper for screenshots within hyprland, based on grimshot";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
}
