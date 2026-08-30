local system = require("shared.system")

-- Vim-style window navigation.
if system.is_omarchy then
	hl.unbind("SUPER + J")
	hl.unbind("SUPER + K")
	hl.unbind("SUPER + L")
	hl.unbind("SUPER + LEFT")
	hl.unbind("SUPER + DOWN")
	hl.unbind("SUPER + UP")
	hl.unbind("SUPER + RIGHT")
end

o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

-- Layout/tree layer, matching Aerospace muscle memory from macOS.
if system.is_omarchy then
	hl.unbind("SUPER + CTRL + H")
	hl.unbind("SUPER + CTRL + K")
	hl.unbind("SUPER + CTRL + L")
	hl.unbind("SUPER + T")
	hl.unbind("SUPER + CTRL + R")
end

o.bind("SUPER + CTRL + SHIFT + L", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + SHIFT + CTRL + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
o.bind("SUPER + CTRL + R", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

o.bind("SUPER + CTRL + H", "Shrink window width", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
o.bind("SUPER + CTRL + L", "Grow window width", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
o.bind("SUPER + CTRL + K", "Shrink window height", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
o.bind("SUPER + CTRL + J", "Grow window height", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))
