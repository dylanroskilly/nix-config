{
  description = "Home Manager Development Environment Configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-vscode-extensions,
      mac-app-util,
      rust-overlay,
      ...
    }:
    let
      systemMap = {
        linux = "x86_64-linux";
        macos = "aarch64-darwin";
      };
      secrets = import ./secrets.nix;
      mkHome =
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              nix-vscode-extensions.overlays.default
              rust-overlay.overlays.default
            ];
            config.allowUnfree = true;
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit secrets self system; };
          modules = [
            ./home.nix
          ]
          ++ (if pkgs.stdenv.isDarwin then [ mac-app-util.homeManagerModules.default ] else [ ]);
        };
    in
    {
      homeConfigurations = builtins.mapAttrs (name: system: mkHome system) systemMap;
    };
}
