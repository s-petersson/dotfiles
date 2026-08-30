local M = {}

local function file_exists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	end
	return false
end

M.omarchy_path = os.getenv("OMARCHY_PATH") or "/usr/share/omarchy"
M.omarchy_bootstrap = M.omarchy_path .. "/default/hypr/bootstrap.lua"
M.is_omarchy = file_exists(M.omarchy_bootstrap)

return M
