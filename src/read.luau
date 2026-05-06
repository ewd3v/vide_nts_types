export type function Read(value: type): type
	local function parseType(t: type): type?
		if t:is("union") or t:is("intersection") then
			local final: { type } = {}
			for _, component in t:components() do
				local parsedComponent = parseType(component)
				if parsedComponent ~= nil then
					table.insert(final, parsedComponent)
				end
			end

			if t:is("union") then
				return types.unionof(unpack(final))
			end

			return types.intersectionof(unpack(final))
		elseif t:is("function") then
			local parameters = t:parameters()
			if parameters.head ~= nil or parameters.tail ~= nil then
				-- read() call's function without parameters, so this avoids overloads that write into the source, context, etc
				return nil
			end

			local returns = t:returns()
			if returns.head ~= nil and returns.head[1] ~= nil then
				return returns.head[1]
			elseif returns.tail ~= nil then
				return returns.tail
			end

			return types.singleton(nil)
		end

		return t
	end

	return parseType(value) or types.singleton(nil)
end

local read = require("../roblox_packages/vide").read
return (read :: any) :: <T>(value: T) -> Read<T>
