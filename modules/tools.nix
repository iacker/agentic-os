# Outils CLI pour le développement
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Navigation et recherche
    fzf
    ripgrep
    fd
    lsd
    bat

    # Données
    jq
    yq

    # Réseau
    curl
    wget
    htop

    # Git
    git
    gh
    lazygit

    # Dev
    python312
    python312Packages.pip
    nodejs_22
  ];
}
