-- pick your plugin manager
local pack = "lazy"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local function bootstrap(url, ref)
	local name = url:gsub(".*/", "")
	local path

	if pack == "lazy" then
		path = vim.fn.stdpath("data") .. "/lazy/" .. name
		vim.opt.rtp:prepend(path)
	else
		path = vim.fn.stdpath("data") .. "/site/pack/" .. pack .. "/start/" .. name
	end

	if vim.fn.isdirectory(path) == 0 then
		print(name .. ": installing in data dir...")

		vim.fn.system { "git", "clone", url, path }
		if ref then
			vim.fn.system { "git", "-C", path, "checkout", ref }
		end

		vim.cmd "redraw"
		print(name .. ": finished installing")
	end
end

-- for stable version [recommended]
bootstrap("https://github.com/udayvir-singh/tangerine.nvim")

-- for git head
bootstrap("https://github.com/udayvir-singh/tangerine.nvim")

require("tangerine").setup(
	{
		-- save fnl output in a separate dir, it gets automatically added to package.path
		target = vim.fn.stdpath [[data]] .. "/tangerine",

		-- compile files in &rtp
		rtpdirs = {
			"ftplugin",
		},

		compiler = {
			-- disable popup showing compiled files
			verbose = false,

			-- compile every time you change fennel files or on entering vim
			hooks = { "onsave", "oninit" }
		}
	}
)
