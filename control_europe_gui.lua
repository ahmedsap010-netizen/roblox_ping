-- Control Europe GUI Hub | By Ahmed
-- مميزات:
-- • واجهة مستطيلة منظمة
-- • زر لإظهار/إخفاء (Toggle GUI)
-- • علامة مائية
-- • Dropdown لاختيار دولة
-- • زر لعرض الدولة المختارة
-- • تحديث تلقائي كل 60 ثانية لمدن الدولة

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")

local countries = {
    "Germany","France","Italy","Spain","Netherlands","Belgium","Sweden",
    "Poland","Austria","Switzerland","Denmark","Norway","Portugal","Greece",
    "Czechia","Hungary","Finland","Ireland","Croatia","Slovakia"
}

-- GUI Setup
local screen = Instance.new("ScreenGui", PlayerGui)
screen.Name = "EuropeControlGUI_Hub"

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.4, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active, frame.Draggable = true, true

-- Watermark
local watermark = Instance.new("TextLabel", frame)
watermark.Size = UDim2.new(1, 0, 0, 25)
watermark.Position = UDim2.new(0, 0, 1, -25)
watermark.Text = "Control Europe GUI by Ahmed"
watermark.TextScaled = true
watermark.TextColor3 = Color3.fromRGB(180,180,180)
watermark.BackgroundTransparency = 1

-- Toggle Button
local toggleBtn = Instance.new("TextButton", screen)
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Position = UDim2.new(0.9, -50, 0.05, 0)
toggleBtn.Text = "Hide GUI"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleBtn.Text = frame.Visible and "Hide GUI" or "Show GUI"
end)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Europe Control Hub"
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(60, 0, 60)

-- Helper function for Dropdown
local function createDropdown(options, positionY, placeholder)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, positionY, 0)
    btn.Text = placeholder
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)

    local list = Instance.new("Frame", btn)
    list.Size = UDim2.new(1, 0, 0, #options * 25)
    list.Position = UDim2.new(0, 0, 1, 0)
    list.BackgroundColor3 = Color3.fromRGB(45,45,45)
    list.Visible = false
    list.ClipsDescendants = true

    local selected = nil
    for i, option in ipairs(options) do
        local itm = Instance.new("TextButton", list)
        itm.Size = UDim2.new(1, 0, 0, 25)
        itm.Position = UDim2.new(0, 0, (i - 1) * 25, 0)
        itm.Text = option
        itm.TextScaled = true
        itm.Font = Enum.Font.SourceSans
        itm.TextColor3 = Color3.new(1,1,1)
        itm.BackgroundColor3 = Color3.fromRGB(80,80,80)
        itm.MouseButton1Click:Connect(function()
            selected = option
            btn.Text = option
            list.Visible = false
        end)
    end

    btn.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
    end)

    return function() return selected end
end

local getCountry = createDropdown(countries, 0.15, "Select Country")

-- Display Selected Country Label
local countryLabel = Instance.new("TextLabel", frame)
countryLabel.Size = UDim2.new(0.9, 0, 0, 25)
countryLabel.Position = UDim2.new(0.05, 0, 0.30, 0)
countryLabel.Text = "Selected: None"
countryLabel.TextScaled = true
countryLabel.Font = Enum.Font.SourceSans
countryLabel.TextColor3 = Color3.new(1,1,1)
countryLabel.BackgroundTransparency = 1

-- Update country name
createDropdown(countries, 0.15, "") -- hidden to capture selection
getCountry = getCountry -- ensure closure
Run.RenderStepped:Connect(function()
    local c = getCountry()
    countryLabel.Text = "Selected: " .. (c or "None")
end)

-- Auto-safe cities display (dummy for now, update logic as needed)
local citiesLabel = Instance.new("TextLabel", frame)
citiesLabel.Size = UDim2.new(0.9, 0, 0.2, 0)
citiesLabel.Position = UDim2.new(0.05, 0, 0.40, 0)
citiesLabel.Text = "Cities: Loading..."
citiesLabel.TextWrapped = true
citiesLabel.TextScaled = true
citiesLabel.Font = Enum.Font.SourceSans
citiesLabel.TextColor3 = Color3.new(1,1,1)
citiesLabel.BackgroundTransparency = 1

-- Function to fetch player cities for selected country
local function updateCities()
    local c = getCountry()
    if c then
        -- Dummy logic; replace with real server query if exists
        citiesLabel.Text = "Cities for " .. c .. ": CityA, CityB"
    else
        citiesLabel.Text = "Cities: None"
    end
end

-- Auto-refresh cities every 60 seconds
spawn(function()
    while wait(60) do
        updateCities()
    end
end)

-- Start initial cities update
updateCities()
