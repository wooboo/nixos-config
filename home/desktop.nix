{ pkgs, ... }:
{
  home.packages = with pkgs; [
    firefox
    vscode
    ghostty
  ];
  services.gpg-agent.enable = true;
}
