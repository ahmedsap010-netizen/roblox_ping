-- Control Europe GUI Ultimate | By Ahmed
-- تشمل الواجهة كل الأوامر: جيش، تحالف، حرب (تبرير/إعلان), Anti‑AFK

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Replicated = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Anti-AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- الدول الأوروبية (اختصار)
local countries = {
    "Albania","Andorra","Austria","Belarus","Belgium","Bosnia and Herzegovina","Bulgaria",
    "Croatia","Czechia","Denmark","Estonia","Finland","France","Germany","Greece","Hungary",
    "Iceland","Ireland","Italy","Kosovo","Latvia","Liechtenstein","Lithuania","Luxembourg",
    "Malta","Moldova","Monaco","Montenegro","Netherlands","North Macedonia","Norway","Poland",
    "Portugal","Romania","San Marino","Serbia","Slovakia","Slovenia","Spain","Sweden","Switzerland",
    "Ukraine","United Kingdom","Vatican City"
}

-- Build GUI
local screen = Instance.new("ScreenGui", PlayerGui)
screen.Name = "ControlEuropeGUI"

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 360, 0, 490)
frame.Position = UDim2.new(0.5, -180, 0.5, -245)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active, frame.Draggable = true, true

-- Watermark
local wm = Instance.new("TextLabel", frame)
wm.Size = UDim2.new(1,0,0,25)
wm.Position = UDim2.new(0,0,1,-25)
wm.BackgroundTransparency = 1
wm.Text = "Control Europe GUI by Ahmed"
wm.TextColor3 = Color3.fromRGB(200,200,200)
wm.TextScaled = true
wm.Font = Enum.Font.SourceSansBold

-- Hide/Show toggle
local toggle = Instance.new("TextButton", screen)
toggle.Size = UDim2.new(0, 100, 0, 30)
toggle.Position = UDim2.new(0.9, -50, 0.05, 0)
toggle.Text = "Hide GUI"
toggle.Font = Enum.Font.SourceSansBold
toggle.TextScaled = true
toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggle.Text = frame.Visible and "Hide GUI" or "Show GUI"
end)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Control Europe Hub"
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(55,10,80)

-- Helper
local function createDropdown(list, ypos, placeholder)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9,0,0,30)
    btn.Position = UDim2.new(0.05,0,ypos,0)
    btn.Text = placeholder
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)

    local container = Instance.new("Frame", btn)
    container.Size = UDim2.new(1,0,0,#list*25)
    container.Position = UDim2.new(0,0,1,0)
    container.BackgroundColor3 = Color3.fromRGB(50,50,50)
    container.Visible = false
    container.ClipsDescendants = true

    local selected = nil
    for i,v in ipairs(list) do
        local opt = Instance.new("TextButton", container)
        opt.Size = UDim2.new(1,0,0,25)
        opt.Position = UDim2.new(0,0,(i-1)*25,0)
        opt.Text = v
        opt.Font = Enum.Font.SourceSans
        opt.TextScaled = true
        opt.TextColor3 = Color3.new(1,1,1)
        opt.BackgroundColor3 = Color3.fromRGB(70,70,70)
        opt.MouseButton1Click:Connect(function()
            selected = v
            btn.Text = v
            container.Visible = false
        end)
    end
    btn.MouseButton1Click:Connect(function()
        container.Visible = not container.Visible
    end)
    return function() return selected end
end

local getCountry = createDropdown(countries, 0.15, "Select Country")
local cityDropdownBtn = Instance.new("TextButton", frame)
cityDropdownBtn.Size = UDim2.new(0.9,0,0,30)
cityDropdownBtn.Position = UDim2.new(0.05,0,0.27,0)
cityDropdownBtn.Text = "Select Country First"
cityDropdownBtn.Font = Enum.Font.SourceSansBold
cityDropdownBtn.TextScaled = true
cityDropdownBtn.TextColor3 = Color3.new(1,1,1)
cityDropdownBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
local getCity = function() return cityDropdownBtn.Text ~= "Select Country First" and cityDropdownBtn.Text or nil end

cityDropdownBtn.MouseButton1Click:Connect(function()
    local c = getCountry()
    if c and Workspace.Regions:FindFirstChild(c) then
        cityDropdownBtn.Text = c
    end
end)

local unitTypes = {"Soldier","Tank","Artillery","AntiAir","Ship"}
local getUnit = createDropdown(unitTypes, 0.35, "Select Unit Type")

local countBox = Instance.new("TextBox", frame)
countBox.Size = UDim2.new(0.9,0,0,30)
countBox.Position = UDim2.new(0.05,0,0.45,0)
countBox.PlaceholderText = "Unit Count"
countBox.Font = Enum.Font.SourceSans
countBox.TextScaled = true
countBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
countBox.TextColor3 = Color3.new(1,1,1)

local function createButton(txt,ypos,color,callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9,0,0,30)
    btn.Position = UDim2.new(0.05,0,ypos,0)
    btn.Text = txt
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = color
    btn.MouseButton1Click:Connect(callback)
end

createButton("Create Army", 0.55, Color3.fromRGB(0,120,0), function()
    local c = getCountry(); local city = getCity(); local u = getUnit(); local num = tonumber(countBox.Text)
    if c and city and u and num and num>0 then
        local ev = Replicated:FindFirstChild("RemoteEvent_4")
        local tile = Workspace.Regions and Workspace.Regions:FindFirstChild(city)
        if ev and tile then
            ev:FireServer("CreateArmyOnTile", tile, u, num)
        end
    end
end)

createButton("Form Ally", 0.65, Color3.fromRGB(0,0,200), function()
    local c = getCountry()
    if c then for _,evn in ipairs({"RemoteEvent_1","RemoteEvent_4"}) do
            local ev = Replicated:FindFirstChild(evn)
            if ev then ev:FireServer("FormAlly",c) end
        end
    end
end)

createButton("Justify War", 0.75, Color3.fromRGB(200,200,0), function()
    local c = getCountry()
    if c then
        local ev = Replicated:FindFirstChild("RemoteEvent_2")
        if ev then ev:FireServer("JustifyWar",c) end
    end
end)

createButton("Declare War", 0.85, Color3.fromRGB(200,0,0), function()
    local c = getCountry()
    if c then
        local ev = Replicated:FindFirstChild("RemoteEvent_3")
        if ev then ev:FireServer("DeclareWar",c) end
    end
end)
