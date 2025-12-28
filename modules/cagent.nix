{ config, pkgs, ... }:
{
  # Ajouter ~/.local/bin au PATH pour tous les users
  environment.sessionVariables = {
    PATH = "$HOME/.local/bin:$PATH";
    ANTHROPIC_API_KEY = ""; # On le set manuellement pour la sécurité
  };

  # Script d'installation de cagent au démarrage
  system.activationScripts.cagent = ''
    mkdir -p /home/nixos/.local/bin
    if [ ! -f /home/nixos/.local/bin/cagent ]; then
      ${pkgs.curl}/bin/curl -sL https://github.com/docker/cagent/releases/latest/download/cagent-linux-amd64 -o /home/nixos/.local/bin/cagent
      chmod +x /home/nixos/.local/bin/cagent
      chown nixos:users /home/nixos/.local/bin/cagent
    fi
  '';
}
