# AGENTS.md - Neovim Configuration

## Build/Test Commands
- `nix run .#nvim` - Run the Neovim configuration locally
- `nix flake check` - Validate flake configuration
- `nix build` - Build the Neovim package
- No traditional test suite - configuration is validated through Nix flake checks

## Code Structure
- **Language**: Lua configuration for Neovim
- **Package Manager**: nixCats (Nix-based plugin management)
- **Plugin Loader**: lze (lazy loading system)
- **Main entry**: `init.lua` → `lua/clement/init.lua` → `lua/clement/core/init.lua`

## Code Style Guidelines
- **Imports**: Use `require("module.path")` for Lua modules
- **Formatting**: Use tabs for indentation, snake_case for variables/functions
- **Plugin Loading**: Use lze specs with `for_cat` for conditional loading by nixCats categories
- **Keymaps**: Define in `lua/clement/core/keymaps.lua`, use descriptive `desc` fields
- **Configuration**: Check nixCats categories with `nixCats("category.subcategory")` before setup
- **Error Handling**: Use `pcall()` for optional plugin loading: `local ok, plugin = pcall(require, "plugin")`

## File Organization
- `lua/clement/core/` - Core Neovim configuration (options, keymaps, autocommands)
- `lua/clement/plugins/` - Individual plugin configurations
- `lua/clement/LSPs/` - LSP-specific configurations
- `flake.nix` - Nix package definitions and plugin categories