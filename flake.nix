{
  description = "KyleKrein's emacs flake configuration";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.inputs.nixpkgs-stable.follows = "nixpkgs";
    nix-org-babel.url = "github:emacs-twist/org-babel";
  };

  outputs = {
    self,
    nixpkgs,
    emacs-overlay,
    nix-org-babel,
  }: let
    systems = ["aarch64-linux" "x86_64-linux"];
    eachSystem = nixpkgs.lib.genAttrs systems;
    pkgsFor = eachSystem (system:
      import nixpkgs {
        localSystem = system;
        overlays = [
          emacs-overlay.overlays.default
          nix-org-babel.overlays.default
        ];
      });
  in {
    formatter = eachSystem (
      system: let
        pkgs = pkgsFor.${system};
      in
        pkgs.alejandra
    );
    packages = eachSystem (system: let
      pkgs = pkgsFor.${system};
    in {
      default = import ./package.nix {
        inherit pkgs;
      };
      with-lsps = self.packages.${system}.default.override {
        withLsps = true;
      };
      native = self.packages.${system}.default.override {
        native = true;
      };
      with-lsps-native = self.packages.${system}.with-lsps.override {
        native = true;
      };
    });
  };
}
