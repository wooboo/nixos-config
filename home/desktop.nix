{ config, pkgs, ... }:
{
  home.packages = [ pkgs.firefox pkgs.vscode ];
  programs.gpg.agent.enable = true;
}
