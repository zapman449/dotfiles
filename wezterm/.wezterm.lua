local wezterm = require("wezterm")

local config = {
  font = wezterm.font('JetBrains Mono'),
  pane_focus_follows_mouse = true,
  color_scheme = 'tokyonight_night',
  -- integrate the tabs into the window title bar
  window_decorations = "INTEGRATED_BUTTONS|RESIZE",
  keys = {
    {
      key = 'd',
      mods = 'CMD',
      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
      key = 'd',
      mods = 'CMD|SHIFT',
      action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
    {
      key="LeftArrow",
      mods="OPT",
      action=wezterm.action{SendString="\x1bb"}
    },
    -- Make Option-Right equivalent to Alt-f; forward-word
    {
      key="RightArrow",
      mods="OPT",
      action=wezterm.action{SendString="\x1bf"}
    },
    -- Select next tab with cmd-opt-left/right arrow
    {
      key = 'LeftArrow',
      mods = 'CMD|OPT',
      action = wezterm.action.ActivateTabRelative(-1)
    },
    {
      key = 'RightArrow',
      mods = 'CMD|OPT',
      action = wezterm.action.ActivateTabRelative(1)
    },
    -- Select next pane with cmd-left/right arrow
    {
      key = 'LeftArrow',
      mods = 'CMD',
      action = wezterm.action{ActivatePaneDirection='Prev'},
    },
    {
      key = 'RightArrow',
      mods = 'CMD',
      action = wezterm.action{ActivatePaneDirection='Next'},
    },
  },
  mouse_bindings = {
    {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'CMD|ALT',
      action = wezterm.action.SelectTextAtMouseCursor 'Block',
      alt_screen='Any'
    },
    {
      event = { Down = { streak = 4, button = 'Left' } },
      action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
      mods = 'NONE',
    },
  }
}

return config
