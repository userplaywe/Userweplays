-- PB FakeCheat | UI-only client test panel
-- No gameplay automation, player targeting, or real network interruption.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("PBFakeCheat")
if old then old:Destroy() end

local COLORS = {
    bg = Color3.fromRGB(18, 20, 27),
    panel = Color3.fromRGB(27, 30, 40),
    button = Color3.fromRGB(39, 43, 56),
    accent = Color3.fromRGB(76, 220, 145),
    text = Color3.fromRGB(235, 238, 245),
    muted = Color3.fromRGB(155, 163, 178),
    danger = Color3.fromRGB(220, 95, 95)
}

local gui = Instance.new("ScreenGui")
gui.Name = "PBFakeCheat"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local window = Instance.new("Frame")
window.Name = "Window"
window.Size = UDim2.fromOffset(600, 440)
window.Position = UDim2.new(0.5, -300, 0.5, -220)
window.BackgroundColor3 = COLORS.bg
window.BorderSizePixel = 0
window.Parent = gui
Instance.new("UICorner", window).CornerRadius = UDim.new(0, 10)

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 44)
top.BackgroundColor3 = COLORS.panel
top.BorderSizePixel = 0
top.Parent = window
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 10)

local heading = Instance.new("TextLabel")
heading.Size = UDim2.new(1, -60, 1, 0)
heading.Position = UDim2.fromOffset(14, 0)
heading.BackgroundTransparency = 1
heading.Text = "PB FAKECHEAT  /  ANTICHEAT TEST PANEL"
heading.TextColor3 = COLORS.accent
heading.Font = Enum.Font.GothamBold
heading.TextSize = 14
heading.TextXAlignment = Enum.TextXAlignment.Left
heading.Parent = top

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 30)
close.Position = UDim2.new(1, -42, 0, 7)
close.BackgroundColor3 = COLORS.danger
close.Text = "×"
close.TextColor3 = COLORS.text
close.Font = Enum.Font.GothamBold
close.TextSize = 20
close.Parent = top
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.fromOffset(10, 54)
sidebar.Size = UDim2.fromOffset(145, 376)
sidebar.BackgroundColor3 = COLORS.panel
sidebar.BorderSizePixel = 0
sidebar.Parent = window
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

local body = Instance.new("Frame")
body.Position = UDim2.fromOffset(165, 54)
body.Size = UDim2.new(1, -175, 1, -64)
body.BackgroundColor3 = COLORS.panel
body.BorderSizePixel = 0
body.Parent = window
Instance.new("UICorner", body).CornerRadius = UDim.new(0, 8)

local tabs = {
    Shooting = {
        {"Auto Green simulation", "toggle", "ShotTiming"},
        {"Release lead (ms)", "slider", 0, 250, "ShotTiming"},
        {"Ping estimate (ms)", "slider", 0, 500, "Network"},
        {"Meter correction", "slider", 0, 100, "ShotTiming"},
        {"Precision window", "toggle", "ShotTiming"},
        {"Shot statistics", "toggle", "Telemetry"}
    },
    Defense = {
        {"Auto Block simulation", "toggle", "Block"},
        {"Block range (studs)", "slider", 0, 30, "Block"},
        {"Jump delay (ms)", "slider", 0, 500, "Block"},
        {"Pump-fake recognition", "toggle", "Block"},
        {"Auto Steal simulation", "toggle", "Steal"},
        {"Steal cooldown (ms)", "slider", 0, 1500, "Steal"}
    },
    Player = {
        {"Auto Guard simulation", "toggle", "Guard"},
        {"Target highlight preview", "toggle", "Visual"},
        {"Highlight radius", "slider", 0, 100, "Visual"},
        {"Stop-at-rim rule", "toggle", "Guard"},
        {"Guard speed profile", "slider", 1, 100, "Movement"},
        {"Stamina anomaly simulation", "toggle", "Stamina"},
        {"Sprint anomaly simulation", "toggle", "Movement"}
    },
    Appearance = {
        {"Green effect (1–24)", "slider", 1, 24, "Appearance"},
        {"Skin tone preset (1–10)", "slider", 1, 10, "Appearance"},
        {"Shirt asset ID (preview value)", "slider", 0, 1000000, "Appearance"},
        {"Pants asset ID (preview value)", "slider", 0, 1000000, "Appearance"},
        {"Banner background (1–24)", "slider", 1, 24, "Appearance"},
        {"Banner title preset (1–24)", "slider", 1, 24, "Appearance"}
    },
    Farming = {
        {"Auto-farm behavior simulation", "toggle", "Farming"},
        {"Farm interval (seconds)", "slider", 1, 60, "Farming"}
    },
    Network = {
        {"Lag-switch anomaly simulation", "toggle", "Network"},
        {"Simulated ping (ms)", "slider", 0, 500, "Network"},
        {"Simulated jitter (ms)", "slider", 0, 300, "Network"},
        {"Simulated packet loss (%)", "slider", 0, 100, "Network"},
        {"Network calibration readout", "toggle", "Telemetry"}
    },
    Logs = {}
}

local events = {}
local function record_event(category, name, value)
    local event = {
        source = "PB_FAKECHEAT_LOCAL_SIM",
        category = category,
        name = name,
        value = value,
        time = os.date("%X")
    }
    table.insert(events, 1, event)
    while #events > 40 do table.remove(events) end
    print(string.format("[PB TEST] %s | %s | %s", category, name, tostring(value)))
end

local function make(className, props, parent)
    local obj = Instance.new(className)
    for key, value in pairs(props) do obj[key] = value end
    obj.Parent = parent
    return obj
end

local function clear_body()
    for _, child in ipairs(body:GetChildren()) do child:Destroy() end
end

local function add_label(text, y, height, color)
    return make("TextLabel", {
        Position = UDim2.fromOffset(12, y),
        Size = UDim2.new(1, -24, 0, height or 24),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or COLORS.text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, body)
end

local function render(tabName)
    clear_body()
    add_label(string.upper(tabName) .. "  /  LOCAL SIMULATION", 8, 24, COLORS.accent)

    if tabName == "Logs" then
        local y = 40
        if #events == 0 then
            add_label("No events recorded yet.", y, 28, COLORS.muted)
        else
            for i = 1, math.min(#events, 18) do
                local e = events[i]
                add_label(e.time .. "  [" .. e.category .. "]  " .. e.name .. " = " .. tostring(e.value), y, 18, COLORS.muted)
                y = y + 19
            end
        end
        return
    end

    local y = 40
    for _, item in ipairs(tabs[tabName] or {}) do
        local name, kind, a, b, category = unpack(item)
        if kind == "toggle" then
            local enabled = false
            local button = make("TextButton", {
                Position = UDim2.fromOffset(12, y),
                Size = UDim2.new(1, -24, 0, 30),
                BackgroundColor3 = COLORS.button,
                TextColor3 = COLORS.text,
                Text = name .. "  [OFF]",
                Font = Enum.Font.Gotham,
                TextSize = 12
            }, body)
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
            button.MouseButton1Click:Connect(function()
                enabled = not enabled
                button.Text = name .. (enabled and "  [ON]" or "  [OFF]")
                button.BackgroundColor3 = enabled and Color3.fromRGB(35, 95, 67) or COLORS.button
                record_event(a, name, enabled)
            end)
        else
            local minimum, maximum = a, b
            local value = minimum
            local button = make("TextButton", {
                Position = UDim2.fromOffset(12, y),
                Size = UDim2.new(1, -24, 0, 30),
                BackgroundColor3 = COLORS.button,
                TextColor3 = COLORS.text,
                Text = name .. ": " .. tostring(value) .. "  (click to increase)",
                Font = Enum.Font.Gotham,
                TextSize = 11
            }, body)
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
            button.MouseButton1Click:Connect(function()
                local step = math.max(1, math.floor((maximum - minimum) / 20))
                value = value + step
                if value > maximum then value = minimum end
                button.Text = name .. ": " .. tostring(value) .. "  (click to increase)"
                record_event(category, name, value)
            end)
        end
        y = y + 36
    end
    add_label("Controls generate local test events only.", math.min(y + 3, 390), 20, COLORS.muted)
end

local tabNames = {"Shooting", "Defense", "Player", "Appearance", "Farming", "Network", "Logs"}
for i, tabName in ipairs(tabNames) do
    local button = make("TextButton", {
        Position = UDim2.fromOffset(8, 8 + (i - 1) * 43),
        Size = UDim2.new(1, -16, 0, 36),
        BackgroundColor3 = COLORS.button,
        TextColor3 = COLORS.text,
        Text = tabName,
        Font = Enum.Font.GothamBold,
        TextSize = 12
    }, sidebar)
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    button.MouseButton1Click:Connect(function() render(tabName) end)
end

-- Drag window from the title bar.
local dragging, dragStart, startPosition
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = window.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

render("Shooting")
print("[PB FakeCheat] UI-only test panel loaded.")
