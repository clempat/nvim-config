local status, tmux_nav = pcall(require, "nvim-tmux-navigation")
if (not status) then return end

tmux_nav.setup{}
