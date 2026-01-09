# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NixOS-WSL configuration using Nix flakes. It provides a declarative, reproducible development environment optimized for AI-assisted coding on Windows WSL2.

## Essential Commands

```bash
# Apply configuration changes (requires git add first for flakes)
git add .
sudo nixos-rebuild switch --flake .#wsl

# Dry-run to test changes without applying
sudo nixos-rebuild dry-build --flake .#wsl

# Update all flake inputs
nix flake update

# Update only AI tools
nix flake update llm-agents

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# List all generations
sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# Clean Nix store
sudo nix-collect-garbage -d

# Test a package without installing
nix-shell -p <package>
```

## Architecture

**Entry Point**: `flake.nix` defines inputs (nixpkgs 25.05, NixOS-WSL, llm-agents) and outputs a single `wsl` NixOS configuration.

**Host Configuration**: `hosts/wsl.nix` is the main system config that imports all modules and sets WSL-specific options (user=`nixos`, timezone=Europe/Paris, allowUnfree=true).

**Module Structure** (`modules/`):
- `ai-cli.nix` - AI coding tools from llm-agents flake (claude-code, gemini-cli, opencode) plus codex from nixpkgs and custom cagent derivation
- `lazyvim.nix` - Neovim with 10+ LSP servers and formatters, auto-installs LazyVim starter config on first rebuild
- `docker.nix` - Docker daemon with auto-prune enabled
- `tools.nix` - CLI utilities (git, gh, lazygit, fzf, ripgrep, fd, nodejs_22, python312)
- `vscode.nix` - nix-ld with common libraries for VS Code Remote compatibility
- `cagent.nix` - Standalone cagent module (not imported, kept as reference; cagent is defined inline in ai-cli.nix)

## Key Patterns

**llm-agents Input**: The `llm-agents` flake provides pre-built AI CLI tools. It intentionally does NOT follow nixpkgs to avoid compatibility issues. Access packages via `llm-agents.packages.x86_64-linux.*`.

**Custom Derivations**: For tools not in nixpkgs (like cagent), use `pkgs.stdenv.mkDerivation` with `pkgs.fetchurl` to download release binaries. To update:
```bash
# Get new SHA256 for a release binary
nix-prefetch-url https://github.com/docker/cagent/releases/download/v<VERSION>/cagent-linux-amd64
```

**Flake Requirement**: All file changes must be `git add`ed before `nixos-rebuild` can see them - flakes only see tracked files.

**Activation Scripts**: `lazyvim.nix` uses `system.activationScripts` to clone the LazyVim starter on first rebuild. This pattern is useful for one-time setup that can't be done declaratively.

## Default User

The system user is `nixos` with home at `/home/nixos`. LazyVim config lives at `/home/nixos/.config/nvim`.
