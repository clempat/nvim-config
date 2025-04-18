{ inputs }:
let inherit (inputs.nixpkgs) legacyPackages;
in rec {
  mkVimPlugin = { system }:
    let
      inherit (pkgs) vimUtils;
      inherit (vimUtils) buildVimPlugin;
      pkgs = legacyPackages.${system};
    in buildVimPlugin {
      name = "clement";
      postInstall = ''
        rm -rf $out/.envrc
        rm -rf $out/.gitignore
        rm -rf $out/LICENSE
        rm -rf $out/README.md
        rm -rf $out/flake.lock
        rm -rf $out/flake.nix
        rm -rf $out/lib
      '';
      src = ../.;
    };

  mkNeovimPlugins = { system }:
    let
      inherit (pkgs) vimPlugins;
      pkgs = legacyPackages.${system};
      clement-nvim = mkVimPlugin { inherit system; };
    in [
      {
        plugin = pkgs.vimPlugins.sqlite-lua;
        config = if (builtins.pathExists
          "${pkgs.sqlite.out}/lib/libsqlite3.dylib") then
          "let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.dylib'"
        else
          "let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'";
      }
      clement-nvim
    ];

  mkExtraPackages = { system }:
    let
      inherit (pkgs) nodePackages ocamlPackages python310Packages;
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in [
      pkgs.cargo
      pkgs.fzf
      pkgs.git
      pkgs.luajitPackages.luarocks
      pkgs.nixfmt-classic
      # pkgs.php
      # pkgs.php83Packages.composer
      pkgs.python311
      pkgs.python311Packages.pip
      pkgs.sqlite
      pkgs.zulu
      pkgs.nodejs
    ];

  mkExtraConfig = { system }: 
    let pkgs = legacyPackages.${system};
    in ''
    lua << EOF
      _G.nodejs = '${pkgs.nodejs}/bin/node'
      require("clement").init()
      require("clement.lazy")
    EOF
  '';

  mkNeovim = { system }:
    let
      inherit (pkgs) lib neovim;
      extraPackages = mkExtraPackages { inherit system; };
      pkgs = legacyPackages.${system};
      start = mkNeovimPlugins { inherit system; };
    in neovim.override {
      configure = {
        customRC = mkExtraConfig { inherit system; };
        packages.main = { inherit start; };
      };
      extraMakeWrapperArgs =
        ''--suffix PATH : "${lib.makeBinPath extraPackages}"'';
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };

  mkHomeManager = { system }:
    let
      extraConfig = mkExtraConfig { inherit system; };
      extraPackages = mkExtraPackages { inherit system; };
      plugins = mkNeovimPlugins { inherit system; };
    in {
      inherit extraConfig extraPackages plugins;
      enable = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
}
