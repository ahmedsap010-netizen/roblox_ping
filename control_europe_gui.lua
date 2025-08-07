-- Control Europe GUI by Ahmed 🛡️
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Anti-AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)

-- UI Setup
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "ControlEuropeGUI"
gui.ResetOnSpawn = false

local openButton = Instance.new("TextButton", gui)
openButton.Size = UDim2.new(0, 120, 0, 30)
openButton.Position = UDim2.new(0, 10, 0, 10)
openButton.Text = "فتح القائمة"
openButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.Font = Enum.Font.SourceSansBold
openButton.TextScaled = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Visible = false
frame.Active = true
frame.Draggable = true

local watermark = Instance.new("TextLabel", frame)
watermark.Size = UDim2.new(1, 0, 0, 25)
watermark.Position = UDim2.new(0, 0, 0, 0)
watermark.Text = "Control Europe GUI | by Ahmed 🛡️"
watermark.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
watermark.TextColor3 = Color3.new(1, 1, 1)
watermark.Font = Enum.Font.SourceSansBold
watermark.TextScaled = true

-- Dropdown
local countries = {
    "France", "Germany", "Italy", "Spain", "United Kingdom", "Poland", "Netherlands",
    "Belgium", "Switzerland", "Austria", "Sweden", "Norway", "Finland", "Denmark",
    "Czech Republic", "Slovakia", "Hungary", "Romania", "Bulgaria", "Greece",
    "Portugal", "Ireland", "Ukraine", "Russia", "Serbia", "Croatia", "Slovenia", "Albania",
    "Lithuania", "Latvia", "Estonia", "Moldova", "Bosnia", "North Macedonia", "Montenegro"
}

local dropdown = Instance.new("TextButton", frame)
dropdown.Size = UDim2.new(0.9, 0, 0, 30)
dropdown.Position = UDim2.new(0.05, 0, 0.15, 0)
dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdown.TextColor3 = Color3.new(1, 1, 1)
dropdown.Font = Enum.Font.SourceSans
dropdown.Text = "اختار الدولة"
dropdown.TextScaled = true

local selectedCountry = nil

local dropFrame = Instance.new("Frame", frame)
dropFrame.Size = UDim2.new(0.9, 0, 0, #countries * 20)
dropFrame.Position = dropdown.Position + UDim2.new(0, 0, 0, 30)
dropFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
dropFrame.Visible = false
dropFrame.ClipsDescendants = true
dropFrame.ZIndex = 5

for _, country in pairs(countries) do
    local option = Instance.new("TextButton", dropFrame)
    option.Size = UDim2.new(1, 0, 0, 20)
    option.Text = country
    option.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    option.TextColor3 = Color3.new(1, 1, 1)
    option.Font = Enum.Font.SourceSans
    option.TextScaled = true
    option.MouseButton1Click:Connect(function()
        selectedCountry = country
        dropdown.Text = "📍 " .. country
        dropFrame.Visible = false
    end)
end

dropdown.MouseButton1Click:Connect(function()
    dropFrame.Visible = not dropFrame.Visible
end)

-- Justify War
local justifyBtn = Instance.new("TextButton", frame)
justifyBtn.Size = UDim2.new(0.4, 0, 0, 30)
justifyBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
justifyBtn.Text = "تبرير حرب"
justifyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
justifyBtn.TextColor3 = Color3.new(1,1,1)
justifyBtn.Font = Enum.Font.SourceSansBold
justifyBtn.TextScaled = true
justifyBtn.MouseButton1Click:Connect(function()
    if selectedCountry then
        ReplicatedStorage:WaitForChild("RemoteEvent_2"):FireServer("JustifyWar", selectedCountry)
    end
end)

-- Declare War
local declareBtn = Instance.new("TextButton", frame)
declareBtn.Size = UDim2.new(0.4, 0, 0, 30)
declareBtn.Position = UDim2.new(0.55, 0, 0.45, 0)
declareBtn.Text = "إعلان حرب"
declareBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
declareBtn.TextColor3 = Color3.new(1,1,1)
declareBtn.Font = Enum.Font.SourceSansBold
declareBtn.TextScaled = true
declareBtn.MouseButton1Click:Connect(function()
    if selectedCountry then
        ReplicatedStorage:WaitForChild("RemoteEvent_3"):FireServer("DeclareWar", selectedCountry)
    end
end)

-- Toggle GUI
openButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)
