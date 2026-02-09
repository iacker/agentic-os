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

**Entry Point**: `flake.nix` defines inputs (nixpkgs 25.05, NixOS-WSL, llm-agents, sops-nix) and outputs a single `wsl` NixOS configuration.

**Host Configuration**: `hosts/wsl.nix` is the main system config that imports all modules and sets WSL-specific options (user=`nixos`, timezone=Europe/Paris, allowUnfree=true).

**Module Structure** (`modules/`):
- `ai-cli.nix` - AI coding tools from llm-agents flake (claude-code, gemini-cli, opencode) plus codex from nixpkgs and custom cagent derivation
- `lazyvim.nix` - Neovim with 10+ LSP servers and formatters, auto-installs LazyVim starter config on first rebuild
- `docker.nix` - Docker daemon with auto-prune enabled
- `tools.nix` - CLI utilities (git, gh, lazygit, fzf, ripgrep, fd, nodejs_22, python312, talosctl, kubectl, helm)
- `vscode.nix` - nix-ld with common libraries for VS Code Remote compatibility
- `sops.nix` - Secrets management with sops-nix (talosconfig, kubeconfig)
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

## Secrets Management (sops-nix)

This configuration uses sops-nix to encrypt sensitive files (talosconfig, kubeconfig) that can be safely committed to git.

**How it works**:
1. Secrets are encrypted with age in `secrets/cluster.yaml`
2. At `nixos-rebuild`, sops-nix decrypts them using the age key
3. Decrypted secrets are placed in `/run/secrets/` (tmpfs, never on disk)
4. Environment variables `TALOSCONFIG` and `KUBECONFIG` point to `/run/secrets/*`

**Key files**:
```
.sops.yaml                           # sops config (public age key)
secrets/cluster.yaml                 # Encrypted talosconfig + kubeconfig
/home/nixos/.config/sops/age/keys.txt # Private age key (NEVER commit!)
```

**Commands**:
```bash
# Edit encrypted secrets
nix-shell -p sops --run "sops secrets/cluster.yaml"

# Re-encrypt after changing .sops.yaml
nix-shell -p sops --run "sops updatekeys secrets/cluster.yaml"

# Verify decrypted secrets after rebuild
sudo ls -la /run/secrets/
```

**CRITICAL**: The private age key at `/home/nixos/.config/sops/age/keys.txt` must be backed up securely (password manager, encrypted USB). Without it, secrets cannot be decrypted. This file must NEVER be committed to git.

## Talos Kubernetes Cluster

This machine administers a Talos Linux cluster at `192.168.1.20`.

**Tools installed**: `talosctl`, `kubectl`, `helm` (persistent in system PATH)

**Connection**: Automatic via sops-decrypted secrets in `/run/secrets/`

**Quick checks**:
```bash
# Cluster health
talosctl health

# Kubernetes nodes
kubectl get nodes

# Helm releases
helm list -A
```

**Services running on cluster**:
| Service | Port | Notes |
|---------|------|-------|
| Homepage | 30000 | Dashboard |
| Harbor | 30080 | Container registry |
| Gitea | 30300 | Git server |
| ArgoCD | 30880 | GitOps |
| Hubble | 31235 | Cilium observability |
| Teleport | 32687 | Access management |
