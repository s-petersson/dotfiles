local system = require("shared.system")

if system.is_omarchy then
	dofile(system.omarchy_bootstrap)
	require("default.hypr.omarchy")
end

require("shared.monitors")
require("shared.input")
require("shared.bindings")

if system.is_omarchy then
	require("default.hypr.toggles")
end
