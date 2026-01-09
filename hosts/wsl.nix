{
  config,
  pkgs,
  llm-agents,
  ...
}: {
  imports = [
    ../modules/docker.nix
    ../modules/tools.nix
    ../modules/ai-cli.nix
    ../modules/lazyvim.nix
    ../modules/vscode.nix
  ];

  # WSL Configuration
  wsl = {
    enable = true;
    defaultUser = "nixos";
  };

  # Nix Settings
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  # System
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Europe/Paris";
  system.stateVersion = "25.05";

  # User - docker group added in docker.nix
  users.users.nixos.extraGroups = ["docker"];

  # Pass llm-agents to modules
  _module.args.llm-agents = llm-agents;
}
