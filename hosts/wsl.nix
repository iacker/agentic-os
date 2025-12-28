{ config, pkgs, ... }:
{
  imports = [
    ../modules/docker.nix
    ../modules/tools.nix
    ../modules/vscode.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "nixos";
  };

  # Activer les flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Autoriser les paquets non-libres
  nixpkgs.config.allowUnfree = true;

  # Utilisateur
  users.users.nixos.extraGroups = [ "docker" ];

  # Timezone
  time.timeZone = "Europe/Paris";

  # Version NixOS
  system.stateVersion = "25.05";
}
