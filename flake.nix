{
  description = "Unified NixOS + WSL + Home Manager flake";
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.05";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      home-manager,
      ...
    }:

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        smallnix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux"; # or legacyPackages.${system}.system
          modules = [
            ./hosts/common.nix
            ./hosts/desktop.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                ./home/common.nix
                ./home/desktop.nix
              ];
              home-manager.users.wooboo = import ./home/wooboo.nix;
            }
          ];
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
              home-manager.sharedModules = [
                ./home/common.nix
                ./home/wsl.nix
              ];
              home-manager.users.wooboo = import ./home/wooboo.nix;
            }
          ];
        };
      };
      homeConfigurations = {
        "wooboo@smallnix" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./home/wooboo.nix
            ./home/common.nix
            ./home/desktop.nix
          ];
        };
        "wooboo@wslnix" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./home/wooboo.nix
            ./home/common.nix
            ./home/wsl.nix
          ];
        };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

    };
}
