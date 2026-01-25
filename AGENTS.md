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

## Critical Rules for Plugin Development

⚠️ **ALWAYS follow these patterns to avoid debugging issues:**

1. **for_cat Syntax**: Use `for_cat = "category.subcategory"` (string), never `for_cat = nixCats("category")`
2. **Plugin Placement**: VimEnter plugins → `startupPlugins`, lazy-loaded → `optionalPlugins`
3. **Import Pattern**: Always add `{ import = "clement.plugins.plugin-name" }` to `plugins/init.lua`
4. **Check Conflicts**: Look for existing similar plugins or autocommands before adding new ones
5. **Verify Documentation**: Use Context7 to get current plugin documentation, don't assume config structure

## File Organization

- `lua/clement/core/` - Core Neovim configuration (options, keymaps, autocommands)
- `lua/clement/plugins/` - Individual plugin configurations
- `lua/clement/LSPs/` - LSP-specific configurations
- `flake.nix` - Nix package definitions and plugin categories

## Development Tools and Documentation

### Context7 MCP Integration

When implementing features or debugging issues, **always check fresh documentation with Context7**:

#### Usage Pattern:

1. **Resolve Library ID**: Use `resolve-library-id` to find the correct Context7-compatible library ID
2. **Get Documentation**: Use `get-library-docs` with the resolved ID to fetch up-to-date docs
3. **Focus Topics**: Use the `topic` parameter to get specific information (e.g., "installation", "configuration", "api")

#### Key Libraries:

- `/microsoft/debugpy` - Python debugger configuration
- `/saghen/blink.cmp` - Modern Neovim completion engine
- `/hrsh7th/nvim-cmp` - Traditional completion engine (for comparison)
- `/neovim/nvim-lspconfig` - LSP configuration (though use `vim.lsp.config` in 0.11+)

#### Example:

```lua
-- Before implementing, check docs:
-- 1. resolve-library-id: "blink.cmp"
-- 2. get-library-docs: "/saghen/blink.cmp" with topic "installation configuration"
-- 3. Implement based on fresh documentation
```

### NixOS MCP Integration

Use NixOS MCP tools for package discovery and management:

#### Available Commands:

- `nixos_search(query, search_type="packages")` - Search for packages in nixpkgs
- `nixos_info(name, type="package")` - Get detailed package information
- `nixos_channels()` - List available NixOS channels
- `nixos_stats(channel="unstable")` - Get channel statistics

#### Common Patterns:

```bash
# Search for vim plugins
nixos_search("vimplugin-NAME", "packages")

# Check if a package exists
nixos_search("package-name", "packages")

# Get package details
nixos_info("package-name", "package")
```

#### Package Naming Rules:

- **nixpkgs package names**: Often use hyphens (e.g., `blink-cmp`)
- **Plugin directory names**: May use dots (e.g., `blink.cmp`)
- **Always verify**: Check actual plugin directory structure in `/nix/store/.../pack/myNeovimPackages/opt/`

### Plugin Development Workflow

#### Adding New Plugins - Step-by-Step Process:

1. **Research the Plugin**:
   - Use Context7 to get up-to-date documentation: `resolve-library-id` → `get-library-docs`
   - Use NixOS search to verify package availability: `nixos_search("vimplugin-PLUGIN-NAME")`

2. **Determine Plugin Type**:
   - **VimEnter plugins** (dashboards, start screens): Add to `startupPlugins`
   - **Lazy-loaded plugins**: Add to `optionalPlugins`
   - **Always-loaded plugins**: Add to `startupPlugins`

3. **Add to flake.nix**:
   - Add plugin to appropriate section in `categoryDefinitions`
   - Use actual nixpkgs package name (often `vimplugin-name` or just `name`)
   - Place in correct category (e.g., `general.always`, `general.extra`)

4. **Create Plugin Configuration**:
   - File: `lua/clement/plugins/plugin-name.lua`
   - Use `for_cat = "category.subcategory"` (string, not function call)
   - Import in `lua/clement/plugins/init.lua` with `{ import = "clement.plugins.plugin-name" }`

5. **Test and Debug**:
   - Run `nix build` to ensure plugin is included
   - Check with `nix-store -q --references $(nix build --print-out-paths) | grep plugin-name`
   - Test with `nix run .#nvim`

#### Common Plugin Loading Issues:

1. **Plugin Not Loading**:
   - ✅ **Check nixCats category**: Ensure plugin category is enabled in `flake.nix`
   - ✅ **Verify plugin location**: VimEnter plugins → `startupPlugins`, others → `optionalPlugins`
   - ✅ **Match directory names**: Plugin names in Lua must match actual directory names
   - ✅ **for_cat syntax**: Use string `"general.always"`, not function `nixCats("general.always")`
   - ✅ **Import in init.lua**: Add `{ import = "clement.plugins.plugin-name" }` to lze.load()

2. **Plugin Conflicts**:
   - ✅ **Check for conflicting files**: Remove or disable old plugin configurations
   - ✅ **Autocommand conflicts**: Check `lua/clement/core/autocommands.lua` for conflicting VimEnter events
   - ✅ **Event conflicts**: Ensure only one plugin handles the same event/functionality

3. **Configuration Issues**:
   - ✅ **Read official documentation**: Always check GitHub README for correct config structure
   - ✅ **Theme-specific config**: Different themes (doom vs hyper) have different config structures
   - ✅ **Required dependencies**: Add required plugins to `load` function or `startupPlugins`

#### Plugin Loading Patterns:

```lua
-- For startupPlugins (VimEnter, always-loaded)
return {
    {
        "plugin-name",           -- Must match nix package directory name
        for_cat = "general.always",  -- String, not function call
        event = "VimEnter",      -- or other appropriate event
        after = function()       -- Use 'after', not 'config'
            require("plugin").setup({
                -- configuration
            })
        end,
    },
}

-- For optionalPlugins (lazy-loaded)
return {
    {
        "plugin-name",
        for_cat = "general.telescope",  -- Match category in flake.nix
        cmd = { "Command" },        -- or keys, event, etc.
        load = function(name)       -- Explicit loading for optionalPlugins
            vim.cmd.packadd(name)
            vim.cmd.packadd("dependency-plugin")
        end,
        after = function()
            require("plugin").setup({})
        end,
    },
}
```

#### Performance Optimization:

- **Skip tests**: Use `overrideAttrs { doCheck = false; }` for Python packages
- **Disable installation checks**: Add `doInstallCheck = false; pytestCheckPhase = "";`
- **Example**: See `debugpy`, `black`, `isort` overrides in `flake.nix`

#### LSP Configuration:

- **Neovim 0.11+**: Use `vim.lsp.config()` instead of `require('lspconfig')`
- **Integration**: Add `blink.get_lsp_capabilities()` for completion engine compatibility
- **Default on_attach**: Ensure consistent LSP behavior across all servers

