local status, Worktree = pcall(require, "git-worktree")
if (not status) then return end

local function isNodeProject(path)
	local packagePath = path .. "/package.json"
	local file = io.open(packagePath, "r")
	if file then
		io.close(file)
		return true
	end
	return false
end

Worktree.on_tree_change(function(op, metadata)
	if op == Worktree.Operations.Create then
		if isNodeProject(metadata.path) then
			os.execute("cd " .. metadata.path .. " && yarn")
		end
	end
end)
