-- Control Europe Ultimate GUI | By Ahmed
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Replicated = game:GetService("ReplicatedStorage")
local Run = game:GetService("RunService")

-- Anti-AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- Create GUI
local screen = Instance.new("ScreenGui", PlayerGui)
screen.Name = "EuropeControlHub"

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 360, 0, 450)
frame.Position = UDim2.new(0.5, -180, 0.4, -225)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active, frame.Draggable = true, true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "Europe Control Hub"
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(50,0,50)

-- Helper function
local function createButton(text, ypos, color, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9,0,0,35)
    btn.Position = UDim2.new(0.05,0,ypos,0)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = color
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createDropdown(labelText, options, ypos)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.9,0,0,25)
    lbl.Position = UDim2.new(0.05,0,ypos-0.03,0)
    lbl.Text = labelText
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    lbl.TextScaled = true

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9,0,0,30)
    btn.Position = UDim2.new(0.05,0,ypos,0)
    btn.Text = "اختر..."
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)

    local list = Instance.new("Frame", btn)
    list.Size = UDim2.new(1,0,0,#options*30)
    list.Position = UDim2.new(0,0,1,0)
    list.BackgroundColor3 = Color3.fromRGB(45,45,45)
    list.Visible = false
    list.ClipsDescendants = true

    local selected = nil
    for i,opt in ipairs(options) do
        local it = Instance.new("TextButton", list)
        it.Size = UDim2.new(1,0,0,30)
        it.Position = UDim2.new(0,0,(i-1)*30,0)
        it.Text = opt
        it.Font = Enum.Font.SourceSans
        it.TextScaled = true
        it.TextColor3 = Color3.new(1,1,1)
        it.BackgroundColor3 = Color3.fromRGB(70,70,70)
        it.MouseButton1Click:Connect(function()
            selected = opt
            btn.Text = opt
            list.Visible = false
        end)
    end

    btn.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
    end)

    return function() return selected end
end

-- إعداد القوائم
local cities = { "Amsterdam", "Berlin", "Paris", "London" }
local units = { "Soldier", "Tank", "Artillery", "AntiAir", "Ship" }
local countries = { "Germany", "France", "Spain", "Italy" }

local getCity = createDropdown("اختر المدينة", cities, 0.15)
local getUnit = createDropdown("اختر نوع الوحدة", units, 0.25)
local countBox = Instance.new("TextBox", frame)
countBox.PlaceholderText = "عدد الوحدات"
countBox.Size = UDim2.new(0.9,0,0,30)
countBox.Position = UDim2.new(0.05,0,0.35,0)
countBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
countBox.TextColor3 = Color3.new(1,1,1)
countBox.TextScaled = true

local getCountry = createDropdown("اختر الدولة", countries, 0.45)

-- زر إنشاء جيش
createButton("أنشئ الجيش", 0.55, Color3.fromRGB(0,120,0), function()
    local city = getCity()
    local unit = getUnit()
    local num = tonumber(countBox.Text)
    if city and unit and num and num>0 then
        local ev = Replicated:FindFirstChild("RemoteEvent_4")
        local tile = workspace:WaitForChild("Regions"):WaitForChild(city)
        if ev then
            ev:FireServer("CreateArmyOnTile", tile, unit, num)
            print("تم إرسال الجيش", unit, "عدد", num, "إلى", city)
        end
    end
end)

-- زر طلب تحالف
createButton("طلب تحالف", 0.65, Color3.fromRGB(0,0,200), function()
    local country = getCountry()
    if country then
        local ev1 = Replicated:FindFirstChild("RemoteEvent_1")
        local ev4 = Replicated:FindFirstChild("RemoteEvent_4")
        if ev1 then ev1:FireServer("FormAlly", country) end
        if ev4 then ev4:FireServer("FormAlly", country) end
        print("طلب تحالف مع", country)
    end
end)

-- زر تبرير حرب
createButton("تبرير حرب", 0.75, Color3.fromRGB(200,200,0), function()
    local country = getCountry()
    if country then
        local ev2 = Replicated:FindFirstChild("RemoteEvent_2")
        if ev2 then ev2:FireServer("JustifyWar", country) end
        print("تبرير الحرب ضد", country)
    end
end)

-- زر إعلان حرب
createButton("إعلان حرب", 0.85, Color3.fromRGB(200,0,0), function()
    local country = getCountry()
    if country then
        local ev3 = Replicated:FindFirstChild("RemoteEvent_3")
        if ev3 then ev3:FireServer("DeclareWar", country) end
        print("إنهاء الحرب ضد", country)
    end
end)
