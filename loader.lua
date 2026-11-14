-- PB FakeCheat UI-only loader
-- Replace YOUR_USERNAME with your GitHub username.
local URL = "https://raw.githubusercontent.com/YOUR_USERNAME/PB-FakeCheat/main/main.lua"

local ok, source = pcall(function()
    return game:HttpGet(URL)
end)

if not ok or type(source) ~= "string" then
    warn("[PB FakeCheat] Could not fetch main.lua:", source)
    return
end

local compile, err = loadstring(source)
if not compile then
    warn("[PB FakeCheat] Compile error:", err)
    return
end

local success, result = pcall(compile)
if not success then
    warn("[PB FakeCheat] Runtime error:", result)
end
