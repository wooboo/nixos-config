{ config, pkgs, lib, ... }:
{
  networking.hostName = "wslnix";
  wsl.enable = true;
  wsl.defaultUser = "wooboo";
  services.xserver.enable = false;
}
