local status, n = pcall(require, "lualine")
if (not status) then return end

n.setup {
  options = {
    icons_enabled = false,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
}
