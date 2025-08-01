{
  pkgs,
  withLsps ? false,
  native ? false,
  ...
}: let
  preTangledFile = pkgs.writeText "config.org" ''
    ${builtins.readFile ./config.org}
    #+begin_src emacs-lisp
    (setq dashboard-startup-banner '("${./nixmacs.xpm}" 'logo))

    ;;https://github.com/wbolster/emacs-direnv/issues/85
    (setenv "PATH" (mapconcat 'identity exec-path ":")) ;;fixes direnv losing nix pkgs
    #+end_src
  '';
  configFile = pkgs.tangleOrgBabelFile "default.el" preTangledFile {
    languages = ["emacs-lisp"];
  };
  emacs = pkgs.emacsWithPackagesFromUsePackage {
    # Your Emacs config file. Org mode babel files are also
    # supported.
    # NB: Config files cannot contain unicode characters, since
    #     they're being parsed in nix, which lacks unicode
    #     support.
    # config = ./emacs.org;
    config = configFile;

    # Whether to include your config as a default init file.
    # If being bool, the value of config is used.
    # Its value can also be a derivation like this if you want to do some
    # substitution:
    #   defaultInitFile = pkgs.substituteAll {
    #     name = "default.el";
    #     src = ./emacs.el;
    #     inherit (config.xdg) configHome dataHome;
    #   };
    defaultInitFile = true;
    # Package is optional, defaults to pkgs.emacs
    package =
      if native
      then
        pkgs.emacs30-pgtk.overrideAttrs (
          oldAttrs: {
            NIX_CFLAGS_COMPILE = builtins.toString oldAttrs.NIX_CFLAGS_COMPILE or "" + "-march=native -O3";
          }
        )
      else pkgs.emacs30-pgtk;

    # By default emacsWithPackagesFromUsePackage will only pull in
    # packages with `:ensure`, `:ensure t` or `:ensure <package name>`.
    # Setting `alwaysEnsure` to `true` emulates `use-package-always-ensure`
    # and pulls in all use-package references not explicitly disabled via
    # `:ensure nil` or `:disabled`.
    # Note that this is NOT recommended unless you've actually set
    # `use-package-always-ensure` to `t` in your config.
    alwaysEnsure = false;

    # For Org mode babel files, by default only code blocks with
    # `:tangle yes` are considered. Setting `alwaysTangle` to `true`
    # will include all code blocks missing the `:tangle` argument,
    # defaulting it to `yes`.
    # Note that this is NOT recommended unless you have something like
    # `#+PROPERTY: header-args:emacs-lisp :tangle yes` in your config,
    # which defaults `:tangle` to `yes`.
    alwaysTangle = false;

    # Optionally provide extra packages not in the configuration file.
    # This can also include extra executables to be run by Emacs (linters,
    # language servers, formatters, etc)
    extraEmacsPackages = epkgs: (with pkgs;
      [
        #nerd-fonts.jetbrains-mono
        #jetbrains-mono
        unzip
        librsvg
        imagemagick
        fontconfig
        freetype
        ripgrep
        vips
        ffmpegthumbnailer
        mediainfo
        p7zip
        epub-thumbnailer
        poppler-utils
        gzip
        gnutar
      ]
      ++ (with epkgs; [
        tree-sitter
        tree-sitter-langs
        treesit-grammars.with-all-grammars
        el-easydraw
      ])
      ++ lib.optionals withLsps [
        csharp-ls
        clang-tools
        cmake-language-server
        nixd
	alejandra
	ty
      ]);

    # Optionally override derivations.
    override = final: prev: {
      #weechat = prev.melpaPackages.weechat.overrideAttrs (old: {
      #  patches = [./weechat-el.patch];
      #});
    };
  };
  fontConfig = pkgs.makeFontsConf {
    fontDirectories = with pkgs; [
      nerd-fonts.jetbrains-mono
      jetbrains-mono
      ubuntu-classic
      nerd-fonts.symbols-only
      hack-font
      noto-fonts-emoji
    ];
  };
  mkEmacs = emacs:
    pkgs.runCommand "nixmacs"
    {
      nativeBuildInputs = [pkgs.makeBinaryWrapper];
      inherit (emacs) meta;
    }
    ''
      mkdir -p $out/bin
      for bin in ${emacs}/bin/*; do
        makeWrapper "$bin" $out/bin/$(basename "$bin") --inherit-argv0 \
          --set FONTCONFIG_FILE ${fontConfig}
      done
      ln -s ${emacs}/share $out/share
    '';
in
  mkEmacs emacs
