{ config, pkgs, lib, ... }:
{
  networking.hostName = "wslnix";
  wsl.enable = true;
  wsl.defaultUser = "wooboo";
  services.xserver.enable = false;
  environment.systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      neovim
      btop
      neofetch
      bat
  ];
}
