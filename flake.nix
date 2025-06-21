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
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-wsl,
      home-manager,
      vscode-server,
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
            vscode-server.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              services.vscode-server.enable = true;
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
            vscode-server.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              services.vscode-server.enable = true;
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
