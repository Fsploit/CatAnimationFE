local pathToGithub = "https://raw.githubusercontent.com/xhayper/Animator/main/Source/"

local sub = string.sub

getgenv().httpRequireCache = getgenv().httpRequireCache or {}

getgenv().HttpRequire = function(path, noCache)
	if sub(path, 1, 8) == "https://" or sub(path, 1, 7) == "http://" then
		if not noCache and httpRequireCache[path] then
			return httpRequireCache[path]
		end

		httpRequireCache[path] = loadstring(
			(syn and syn.request) and syn.request({ Url = path }).Body
				or (request and request({ Url = path }).Body or game:HttpGet(path))
		)()
		return httpRequireCache[path]
	else
		return require(path)
	end
end

getgenv().animatorRequire = function(path)
	return HttpRequire(pathToGithub .. path)
end

getgenv().Animator = animatorRequire("Animator.lua")

local Utility = animatorRequire("Utility.lua")

getgenv().hookAnimatorFunction = function()
	local OldFunc
	OldFunc = hookmetamethod(game, "__namecall", function(Object, ...)
		local NamecallMethod = getnamecallmethod()
		if not checkcaller() or Object.ClassName ~= "Humanoid" or NamecallMethod ~= "LoadAnimation" then
			return OldFunc(Object, ...)
		end
		local args = { ... }
		if args[2] then
			return OldFunc(Object, ...)
		end
		return Animator.new(Object.Parent, ...)
	end)
end

return "Nullware my beloved <3"
