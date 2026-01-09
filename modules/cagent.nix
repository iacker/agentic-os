{ config, pkgs, lib, ... }:

let
  cagent = pkgs.stdenv.mkDerivation rec {
    pname = "cagent";
    version = "1.15.1"; # Mettre à jour selon: https://github.com/docker/cagent/releases

    src = pkgs.fetchurl {
      url = "https://github.com/docker/cagent/releases/download/v${version}/cagent-linux-amd64";
      sha256 = "0svak7vfvkxdrvglwcgmr2lr4ayd9n3z1shgh8n9kkhn4bxdyb9g";
    };

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/cagent
      runHook postInstall
    '';

    meta = with lib; {
      description = "Agent Builder and Runtime by Docker Engineering";
      homepage = "https://github.com/docker/cagent";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
      mainProgram = "cagent";
    };
  };
in
{
  environment.systemPackages = [ cagent ];
}

