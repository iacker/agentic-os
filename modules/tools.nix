{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Essentiels
    git
    curl
    wget
    jq
    yq
    htop
    
    # Dev
    python312
    python312Packages.pip
    nodejs_22
    
    # Navigation
    fzf
    ripgrep
    fd
    lsd
    bat
    
    # Git
    gh
    lazygit
  ];
}
