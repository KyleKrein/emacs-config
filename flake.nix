{
  description = "KyleKrein's emacs flake configuration";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    nix-org-babel.url = "github:emacs-twist/org-babel";
  };

  outputs = {
    self,
    nixpkgs,
    emacs-overlay,
    nix-org-babel,
  }: {
    packages.x86_64-linux.default = import ./package.nix {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          emacs-overlay.overlays.default
          nix-org-babel.overlays.default
        ];
      };
    };
    packages.aarch64-linux.default = import ./package.nix {
      pkgs = import nixpkgs {
        system = "aarch64-linux";
        overlays = [
          emacs-overlay.overlays.default
          nix-org-babel.overlays.default
        ];
      };
    };
    packages.x86_64-linux.x11 = import ./package.nix {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          emacs-overlay.overlays.default
          nix-org-babel.overlays.default
        ];
      };
      x11 = true;
    };
    packages.aarch64-linux.x11 = import ./package.nix {
      pkgs = import nixpkgs {
        system = "aarch64-linux";
        overlays = [
          emacs-overlay.overlays.default
          nix-org-babel.overlays.default
        ];
      };
      x11 = true;
    };
  };
}
