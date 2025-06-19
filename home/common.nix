{ config, pkgs, ... }:
{
  home.stateVersion = "23.05";
  home.packages = [ pkgs.fzf pkgs.ripgrep ];
  programs.zsh.enable = true;
  programs.git.enable = true;
}
