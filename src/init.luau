local vide = require("./roblox_packages/vide")

export type source<T> = vide.source<T>
export type Source<T> = vide.Source<T>
export type context<T> = vide.context<T>
export type Context<T> = vide.Context<T>

local create = require("@self/create")
export type Properties<T> = create.Properties<T>
export type properties<T> = Properties<T>

local read = require("@self/read")
export type Read<T> = read.Read<T>
export type read<T> = Read<T>

return setmetatable({
	create = create,
	read = read,
}, {
	__index = vide,
})
