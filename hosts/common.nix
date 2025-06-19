{ config, pkgs, lib, ... }:
{
  users.users.wooboo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    git curl neovim tmux htop
  ];
}
