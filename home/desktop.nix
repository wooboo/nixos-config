{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    firefox
    vscode
    ghostty
    vscode
  ];
  programs.gpg.agent.enable = true;
}
