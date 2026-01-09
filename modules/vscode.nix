# Compatibilité VS Code Remote et binaires dynamiques
{pkgs, ...}: {
  # nix-ld permet d'exécuter des binaires non-Nix (VS Code, etc.)
  programs.nix-ld = {
    enable = true;
    # Bibliothèques communes requises par VS Code et autres outils
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      curl
      glib
      util-linux
      icu
      libunwind
      libuuid
    ];
  };
}
