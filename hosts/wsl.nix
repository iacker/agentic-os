{ config, pkgs, ... }:
{
  imports = [
    ../modules/docker.nix
    ../modules/tools.nix
    ../modules/vscode.nix
    ../modules/cagent.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "nixos";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  users.users.nixos.extraGroups = [ "docker" ];
  time.timeZone = "Europe/Paris";
  system.stateVersion = "25.05";
}
