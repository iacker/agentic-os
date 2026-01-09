{
  description = "AGENTIC NIX OS WSL - AI-powered NixOS-WSL Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # AI CLI tools - DO NOT follow nixpkgs (compatibility issue)
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    llm-agents,
    ...
  }: {
    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit llm-agents;};
      modules = [
        nixos-wsl.nixosModules.wsl
        ./hosts/wsl.nix
      ];
    };
  };
}
