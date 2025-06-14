{ pkgs, ... }:
with pkgs; [
  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  wget
  neovim
  ghostty
  btop
  neofetch
  vscode
  bat
]