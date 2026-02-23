# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license

# This is an empty nixCats config.
# you may import this template directly into your nvim folder
# and then add plugins to categories here,
# and call the plugins with their default functions
# within your lua, rather than through the nvim package manager's method.
# Use the help, and the example config github:BirdeeHub/nixCats-nvim?dir=templates/example

# It allows for easy adoption of nix,
# while still providing all the extra nix features immediately.
# Configure in lua, check for a few categories, set a few settings,
# output packages with combinations of those categories and settings.

# All the same options you make here will be automatically exported in a form available
# in home manager and in nixosModules, as well as from other flakes.
# each section is tagged with its relevant help section.

{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    # };

    # see :help nixCats.flake.inputs
    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesnt have an extra build step.
    # Then you should name it "plugins-something"
    # If you wish to define a custom build step not handled by nixpkgs,
    # then you should name it in a different format, and deal with that in the
    # overlay defined for custom builds in the overlays directory.
    # for specific tags, branches and commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples

    # Add lzextras since it's not in stable nixpkgs
    "plugins-lzextras" = {
      url = "github:BirdeeHub/lzextras";
      flake = false;
    };

    # Add smart-open.nvim for improved file finding
    "plugins-smart-open-nvim" = {
      url = "github:danielfalk/smart-open.nvim";
      flake = false;
    };

    # Add blink-cmp-avante for Avante completion
    "plugins-blink-cmp-avante" = {
      url = "github:Kaiser-Yang/blink-cmp-avante";
      flake = false;
    };

    # Add mcphub.nvim for MCP integration
    "plugins-mcphub-nvim" = {
      url = "github:ravitemer/mcphub.nvim";
      flake = false;
    };

    # Add codecompanion.nvim for AI coding assistant
    "plugins-codecompanion-nvim" = {
      url = "github:olimorris/codecompanion.nvim";
      flake = false;
    };

  };

  # see :help nixCats.flake.outputs
  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      # the following extra_pkg_config contains any values
      # which you want to pass to the config set of nixpkgs
      # import nixpkgs { config = extra_pkg_config; inherit system; }
      # will not apply to module imports
      # as that will have your system values
      extra_pkg_config = {
        allowUnfree = true;
      };
      # management of the system variable is one of the harder parts of using flakes.

      # so I have done it here in an interesting way to keep it out of the way.
      # It gets resolved within the builder itself, and then passed to your
      # categoryDefinitions and packageDefinitions.

      # this allows you to use ${pkgs.system} whenever you want in those sections
      # without fear.

      # see :help nixCats.flake.outputs.overlays
      dependencyOverlays = # (import ./overlays inputs) ++
        [
          # This overlay grabs all the inputs named in the format
          # `plugins-<pluginName>`
          # Once we add this overlay to our nixpkgs, we are able to
          # use `pkgs.neovimPlugins`, which is a set of our plugins.
          (utils.standardPluginOverlay inputs)
          # add any other flake overlays here.

          # when other people mess up their overlays by wrapping them with system,
          # you may instead call this function on their overlay.
          # it will check if it has the system in the set, and if so return the desired overlay
          # (utils.fixSystemizedOverlay inputs.codeium.overlays
          #   (system: inputs.codeium.overlays.${system}.default)
          # )
        ];

      # see :help nixCats.flake.outputs.categories
      # and
      # :help nixCats.flake.outputs.categoryDefinitions.scheme
      categoryDefinitions =
        {
          pkgs,
          settings,
          categories,
          extra,
          name,
          mkPlugin,
          ...
        }@packageDef:
        {
          # to define and use a new category, simply add a new list to a set here,
          # and later, you will include categoryname = true; in the set you
          # provide when you build the package using this builder function.
          # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

          # lspsAndRuntimeDeps:
          # this section is for dependencies that should be available
          # at RUN TIME for plugins. Will be available to PATH within neovim terminal
          # this includes LSPs
          lspsAndRuntimeDeps = {
            general = {
              always = with pkgs; [
                universal-ctags
                ripgrep
                fd
                lazygit
                vscode-langservers-extracted
                yaml-language-server
                sqlite # Required for smart-open.nvim
              ];

              format = with pkgs; [
                nixfmt-rfc-style
                prettierd
                stylua
                djlint
                eslint_d
                shfmt
                gofumpt
              ];

              lint = with pkgs; [
                lua54Packages.luacheck
                shellcheck
                yamllint
                statix
                golangci-lint
              ];

              extra = with pkgs; [ imagemagick_light ];
            };

            frontend = with pkgs; [
              typescript-language-server
              vtsls
              vue-language-server
              tailwindcss-language-server
              astro-language-server
            ];

            infrastructure = with pkgs; [ terraform-ls ];

            neonixdev = {
              # also you can do this.
              inherit (pkgs) nix-doc lua-language-server nixd;
              # and each will be its own sub category
            };

            ai = with pkgs; [ nodejs ];

            python = with pkgs; [
              ty
              ruff
              # Skip debugpy tests for much faster builds (~10x speedup)
              # debugpy has extensive test suite that's not needed for runtime
              (python311Packages.debugpy.overrideAttrs {
                doCheck = false;
                doInstallCheck = false;
                pytestCheckPhase = "";
                installCheckPhase = "";
                checkPhase = "";
              })
            ];

            debug = {
              node = with pkgs; [ vscode-js-debug ];
            };
          };

          # This is for plugins that will load at startup without using packadd:
          startupPlugins = {
            general = with pkgs.vimPlugins; {
              # you can make subcategories!!!
              # (always isnt a special name, just the one I chose for this subcategory)
              always = [
                lze
                pkgs.neovimPlugins.lzextras
                vim-repeat
                plenary-nvim
                nvim-notify
                dashboard-nvim
              ];
              extra = [
                oil-nvim
                nvim-web-devicons
                vim-tmux-navigator
                ReplaceWithRegister
              ];
            };

            debug = with pkgs.vimPlugins; [ nvim-nio ];

            ai = with pkgs.vimPlugins; [
              copilot-lua
              copilot-lualine
              pkgs.neovimPlugins.codecompanion-nvim
            ];

            # You can retreive information from the
            # packageDefinitions of the package this was packaged with.
            # :help nixCats.flake.outputs.categoryDefinitions.scheme
            themer =
              with pkgs.vimPlugins;
              (builtins.getAttr (categories.colorscheme or "onedark") {
                # Theme switcher without creating a new category
                "onedark" = onedark-nvim;
                "catppuccin" = catppuccin-nvim;
                "catppuccin-mocha" = catppuccin-nvim;
                "catppuccin-frappe" = catppuccin-nvim;
                "tokyonight" = tokyonight-nvim;
                "tokyonight-day" = tokyonight-nvim;
              });
          };

          # not loaded automatically at startup.
          # use with packadd and an autocommand in config to achieve lazy loading
          optionalPlugins = {
            general = {
              telescope = with pkgs.vimPlugins; [
                telescope-fzf-native-nvim
                telescope-ui-select-nvim
                telescope-nvim
                telescope-file-browser-nvim
                package-info-nvim
                telescope-live-grep-args-nvim
                telescope-frecency-nvim
                sqlite-lua
                pkgs.neovimPlugins.smart-open-nvim
              ];
              treesitter = with pkgs.vimPlugins; [
                nvim-treesitter.withAllGrammars
                nvim-treesitter-context
                # This is for if you only want some of the grammars
                # (nvim-treesitter.withPlugins
                #   (plugins: with plugins; [ nix lua ]))
              ];

              format = with pkgs.vimPlugins; [ conform-nvim ];

              lint = with pkgs.vimPlugins; [ nvim-lint ];

              cmp = with pkgs.vimPlugins; [
                blink-cmp
                luasnip
                friendly-snippets
                lspkind-nvim
                pkgs.neovimPlugins.blink-cmp-avante
              ];

              always = with pkgs.vimPlugins; [
                git-worktree-nvim
                gitsigns-nvim
                lualine-nvim
                nvim-lspconfig
                vim-fugitive
                vim-rhubarb
                vim-sleuth
                auto-pairs
                SchemaStore-nvim
                undotree
              ];

              extra = with pkgs.vimPlugins; [
                diffview-nvim
                gitlinker-nvim
                lualine-lsp-progress
                mini-nvim
                snacks-nvim
                trouble-nvim
                vim-carbon-now-sh
                vista-vim
                which-key-nvim
              ];

              database = with pkgs.vimPlugins; [
                vim-dadbod
                vim-dadbod-ui
                vim-dadbod-completion
              ];

              debug = with pkgs.vimPlugins; {
                # it is possible to add default values.
                # there is nothing special about the word "default"
                # but we have turned this subcategory into a default value
                # via the extraCats section at the bottom of categoryDefinitions.
                default = [
                  nvim-dap
                  nvim-dap-ui
                  nvim-dap-virtual-text
                ];
                go = [ nvim-dap-go ];
                python = [ nvim-dap-python ];

              };
            };

            tracking = with pkgs.vimPlugins; [ vim-wakatime ];

            neonixdev = with pkgs.vimPlugins; [ lazydev-nvim ];

            ai = with pkgs.vimPlugins; [
              pkgs.neovimPlugins.mcphub-nvim
              # avante-nvim  # Commented to test CodeCompanion ACP
            ];

            noice = with pkgs.vimPlugins; [
              noice-nvim
              nui-nvim
              nvim-notify
            ];
          };

          extraCats = {
            debug = [
              [
                "debug"
                "default"
              ]
            ];
            node = [
              [
                "debug"
                "node"
              ]
            ];
            python_debug = [
              [
                "debug"
                "python"
              ]
            ];
            cmp = [
              [
                "general"
                "cmp"
              ]
            ]; # Enable general.cmp subcategory for completion
            lint = [
              [
                "general"
                "lint"
              ]
            ]; # Enable general.lint subcategory for linting
          };

          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = {
            general = with pkgs; [
              # libgit2
            ];
          };

          # environmentVariables:
          # this section is for environmentVariables that should be available
          # at RUN TIME for plugins. Will be available to path within neovim terminal
          environmentVariables = {
            ai = {
              NODE_PATH = "${pkgs.nodejs}/bin/node";
            };
          };

          # If you know what these are, you can provide custom ones by category here.
          # If you dont, check this link out:
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
          extraWrapperArgs = {
            test = [ ''--set CATTESTVAR2 "It worked again!"'' ];
          };

          # lists of the functions you would have passed to
          # python.withPackages or lua.withPackages
          # do not forget to set `hosts.python3.enable` in package settings

          # get the path to this python environment
          # in your lua config via
          # vim.g.python3_host_prog
          # or run from nvim terminal via :!<packagename>-python3
          python3.libraries = {
            test = (_: [ ]);
          };
          # populates $LUA_PATH and $LUA_CPATH
          extraLuaPackages = {
            test = [ (_: [ ]) ];
          };
        };

      # And then build a package with specific categories from above here:
      # All categories you wish to include must be marked true,
      # but false may be omitted.
      # This entire set is also passed to nixCats for querying within the lua.

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions = {
        # These are the names of your packages
        # you can include as many as you wish.
        nvim =
          { pkgs, name, ... }:
          let
            categories = {
              general = true;
              themer = true;
              neonixdev = true;
              ai = true;
              noice = true;
              frontend = true;
              database = true;
              python = true;
              infrastructure = true;
              colorscheme = "catppuccin-frappe";
              debug = true; # Enable debugging support
              node = true; # Enable Node.js debugging
              python_debug = true; # Enable Python debugging
              cmp = true; # Enable completion plugins (general.cmp subcategory)
              lint = true; # Enable linting with nvim-lint
            };
          in
          {
            # they contain a settings set defined above
            # see :help nixCats.flake.outputs.settings
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              # IMPORTANT:
              # your alias may not conflict with your other packages.
              aliases = [ "vim" ];
              # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
              hosts.python3.enable = categories.python or categories.python_debug or false;
              hosts.node.enable = true;
            };
            # and a set of categories that you want
            # (and other information to pass to lua)
            inherit categories;
          };
      };
      # In this section, the main thing you will need to do is change the default package name
      # to the name of the packageDefinitions entry you wish to use as the default.
      defaultPackageName = "nvim";

      # see :help nixCats.flake.outputs.exports
    in
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        # this is just for using utils such as pkgs.mkShell
        # The one used to build neovim is resolved inside the builder
        # and is passed to our categoryDefinitions and packageDefinitions
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # these outputs will be wrapped with ${system} by utils.eachSystem

        # this will make a package out of each of the packageDefinitions defined above
        # and set the default package to the one passed in here.
        packages = utils.mkAllWithDefault defaultPackage;

        # choose your package for devShell
        # and add whatever else you want in it.
        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = "";
          };
        };

      }
    )
    // (
      let
        # we also export a nixos module to allow reconfiguration from configuration.nix
        nixosModule = utils.mkNixosModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
        # and the same for home manager
        homeModule = utils.mkHomeModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
      in
      {

        # these outputs will be NOT wrapped with ${system}

        # this will make an overlay out of each of the packageDefinitions defined above
        # and set the default overlay to the one named here.
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );

}
