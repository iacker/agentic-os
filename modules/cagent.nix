{ config, pkgs, lib, ... }:
{
  # Ajouter ~/.local/bin au PATH via bashrc
  programs.bash.interactiveShellInit = ''
    export PATH="$HOME/.local/bin:$PATH"
  '';

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
