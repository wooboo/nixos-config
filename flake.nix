{
  description = "Unified NixOS + WSL + Home Manager flake";
  inputs = {
    nixpkgs        = { url = "github:nixos/nixpkgs/nixos-25.05"; };
    nixos-wsl      = { url = "github:nix-community/NixOS-WSL/main"; };
    home-manager   = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }:

  let
    hosts = {
      smallnix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # or legacyPackages.${system}.system
        modules = [ 
          ./hosts/common.nix
          ./hosts/desktop.nix
          home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.wooboo = import ./home/wooboo.nix;
            } ];
      };
      wslnix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          nixos-wsl.nixosModules.default
          ./hosts/common.nix
          ./hosts/wsl.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.wooboo = import ./home/wooboo.nix;
          }];
      };
    };

    homes = {
      "wooboo@smallnix" = home-manager.lib.homeManagerConfiguration {
        modules = [ ./home/common.nix ./home/desktop.nix ];
      };
      "wooboo@wslnix" = home-manager.lib.homeManagerConfiguration {
        modules = [ ./home/common.nix ./home/wsl.nix ];
      };
    };
  in
  {
    nixosConfigurations = hosts;
    homeConfigurations = homes;
  };
}
