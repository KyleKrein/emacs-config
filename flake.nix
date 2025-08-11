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
    snowfall-lib = {
      url = "github:KyleKrein/snowfall-lib"; #"git+file:///home/kylekrein/Git/snowfall-lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.snowfall-lib.mkFlake {
    inherit inputs;
      src = ./.;

      overlays = with inputs; [
        nix-org-babel.overlays.default
        emacs-overlay.overlays.default
      ];

      outputs-builder = channels: {
        formatter = channels.nixpkgs.alejandra;
      };

    snowfall = {
        namespace = "custom";
        meta = {
          name = "KyleKrein's emacs configuration powered by Nix";
          title = "KyleKrein's emacs configuration powered by Nix";
        };
      };
  };
}
