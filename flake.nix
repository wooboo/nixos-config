{
  description = "Unified NixOS + WSL + Home Manager flake";
  inputs = {
    nixpkgs        = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    nixos-wsl      = { url = "github:nix-community/NixOS-WSL/main"; };
    home-manager   = { url = "github:nix-community/home-manager/release-23.05";
                       inputs.nixpkgs.follows = "nixpkgs"; };
    flake-utils    = { url = "github:numtide/flake-utils"; };
  };

  outputs = inputs@{ self, nixpkgs, nixos-wsl, home-manager, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        nixosConfigurations = {
          smallnix = pkgs.lib.nixosSystem {
            system = system;
            modules = [
              ./hosts/common.nix
              ./hosts/desktop.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.wooboo = import ./home/common.nix;
              }
            ];
          };
          wslnix = pkgs.lib.nixosSystem {
            system = system;
            modules = [
              nixos-wsl.nixosModules.default
              ./hosts/common.nix
              ./hosts/wsl.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.wooboo = import ./home/common.nix;
              }
            ];
          };
        };

        homeConfigurations = {
          "wooboo@smallnix" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs system;
            modules = [ ./home/common.nix ./home/desktop.nix ];
          };
          "wooboo@wslnix" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs system;
            modules = [ ./home/common.nix ./home/wsl.nix ];
          };
        };
      });
}
