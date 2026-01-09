# Neovim + LazyVim + LSP servers
{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Editor
    neovim

    # Build tools (treesitter compilation)
    gcc
    gnumake

    # LazyVim requirements
    unzip
    gnutar
    xclip

    # LSP Servers
    nil # Nix
    lua-language-server # Lua
    nodePackages.typescript-language-server # TypeScript/JS
    nodePackages.bash-language-server # Bash
    yaml-language-server # YAML
    pyright # Python
    gopls # Go
    rust-analyzer # Rust
    terraform-ls # Terraform
    marksman # Markdown

    # Formatters & Linters
    stylua # Lua
    shellcheck # Shell
    shfmt # Shell
    black # Python
    alejandra # Nix
  ];

  # Neovim as default editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Environment
  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Auto-install LazyVim starter on first rebuild
  system.activationScripts.lazyvim = lib.stringAfter ["users"] ''
    NVIM_CONFIG="/home/nixos/.config/nvim"

    if [ ! -d "$NVIM_CONFIG" ]; then
      echo "Installing LazyVim starter..."
      ${pkgs.git}/bin/git clone --depth 1 https://github.com/LazyVim/starter "$NVIM_CONFIG" 2>/dev/null || true
      rm -rf "$NVIM_CONFIG/.git"
      chown -R nixos:users "$NVIM_CONFIG"
    fi

    mkdir -p /home/nixos/.local/{share,state,cache}/nvim
    chown -R nixos:users /home/nixos/.local/{share,state,cache}/nvim
  '';
}
