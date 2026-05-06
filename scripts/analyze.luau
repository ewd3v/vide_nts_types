local config = require("./config")
local fs = require("@lune/fs")
local net = require("@lune/net")
local process = require("@lune/process")

process.exec("lune", { "setup" }, {
	cwd = "scripts",
})

local typeDefinitionsPath = "types/globalTypes.d.luau"
local typeDefinitionsLink =
	"https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/refs/heads/main/scripts/globalTypes.d.luau"

local requestResult = net.request(typeDefinitionsLink)
if not requestResult.ok then
	print(requestResult.statusMessage, requestResult.body)
	process.exit(1)
end

fs.writeFile(typeDefinitionsPath, requestResult.body)

local selene = process.exec("selene", { "--no-summary", unpack(config.analyzePaths) }, {
	stdio = "forward",
})
local luau_lsp = process.exec("luau-lsp", {
	"analyze",
	"--platform=roblox",
	"--defs",
	typeDefinitionsPath,
	"--settings=.vscode/settings.json",
	unpack(config.analyzePaths),
}, {
	stdio = "forward",
})

if selene.ok == false then
	process.exit(selene.code)
end
if luau_lsp.ok == false then
	process.exit(luau_lsp.code)
end
