--[[ Control Europe GUI by Ahmed 🪄🤌 ]]--

local plr = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.Name = "ControlEuropeGUI"
gui.ResetOnSpawn = false

-- Toggle key
local toggleKey = Enum.KeyCode.X
local isVisible = true

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 380)
frame.Position = UDim2.new(0.5, -160, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Visible = isVisible

-- Watermark
local watermark = Instance.new("TextLabel", frame)
watermark.Text = "Control Europe GUI by Ahmed 🪄🤌"
watermark.Size = UDim2.new(1, 0, 0, 25)
watermark.BackgroundTransparency = 1
watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
watermark.Font = Enum.Font.SourceSansBold
watermark.TextScaled = true

-- Dropdown for countries
local dropdown = Instance.new("TextBox", frame)
dropdown.PlaceholderText = "اكتب اسم الدولة (مثلاً Germany)"
dropdown.Size = UDim2.new(0.9, 0, 0, 30)
dropdown.Position = UDim2.new(0.05, 0, 0, 40)
dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dropdown.TextColor3 = Color3.new(1, 1, 1)
dropdown.TextScaled = true
dropdown.Font = Enum.Font.SourceSans

-- Army type
local armyBox = Instance.new("TextBox", frame)
armyBox.PlaceholderText = "نوع الجيش: Soldier / Tank"
armyBox.Size = UDim2.new(0.9, 0, 0, 30)
armyBox.Position = UDim2.new(0.05, 0, 0, 80)
armyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
armyBox.TextColor3 = Color3.new(1, 1, 1)
armyBox.TextScaled = true
armyBox.Font = Enum.Font.SourceSans

-- City Name
local cityBox = Instance.new("TextBox", frame)
cityBox.PlaceholderText = "اكتب اسم المدينة (مثلاً Amsterdam)"
cityBox.Size = UDim2.new(0.9, 0, 0, 30)
cityBox.Position = UDim2.new(0.05, 0, 0, 120)
cityBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
cityBox.TextColor3 = Color3.new(1, 1, 1)
cityBox.TextScaled = true
cityBox.Font = Enum.Font.SourceSans

-- Amount
local amountBox = Instance.new("TextBox", frame)
amountBox.PlaceholderText = "عدد الوحدات"
amountBox.Size = UDim2.new(0.9, 0, 0, 30)
amountBox.Position = UDim2.new(0.05, 0, 0, 160)
amountBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
amountBox.TextColor3 = Color3.new(1, 1, 1)
amountBox.TextScaled = true
amountBox.Font = Enum.Font.SourceSans

-- Function buttons
local function makeButton(text, posY)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.9, 0, 0, 30)
	btn.Position = UDim2.new(0.05, 0, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextScaled = true
	btn.Text = text
	return btn
end

local createArmy = makeButton("🔫 أنشئ جيش", 200)
local justifyWar = makeButton("📜 تبرير حرب", 240)
local declareWar = makeButton("🔥 إعلان حرب", 280)
local allyBtn = makeButton("🤝 طلب تحالف", 320)

-- RemoteEvents
local RS = game:GetService("ReplicatedStorage")

createArmy.MouseButton1Click:Connect(function()
	local city = cityBox.Text
	local unit = armyBox.Text
	local amt = tonumber(amountBox.Text)
	if city ~= "" and unit ~= "" and amt then
		local args = {
			"CreateArmyOnTile",
			workspace:WaitForChild("Regions"):WaitForChild(city),
			unit,
			amt
		}
		RS:WaitForChild("RemoteEvent_4"):FireServer(unpack(args))
	end
end)

justifyWar.MouseButton1Click:Connect(function()
	local target = dropdown.Text
	if target ~= "" then
		local args = {"JustifyWar", target}
		RS:WaitForChild("RemoteEvent_2"):FireServer(unpack(args))
	end
end)

declareWar.MouseButton1Click:Connect(function()
	local target = dropdown.Text
	if target ~= "" then
		local args = {"DeclareWar", target}
		RS:WaitForChild("RemoteEvent_3"):FireServer(unpack(args))
	end
end)

allyBtn.MouseButton1Click:Connect(function()
	local target = dropdown.Text
	if target ~= "" then
		local args = {"FormAlly", target}
		RS:WaitForChild("RemoteEvent_1"):FireServer(unpack(args))
	end
end)

-- Anti-AFK
local vu = game:GetService("VirtualUser")
plr.Idled:Connect(function()
	vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	wait(1)
	vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Toggle GUI on/off
game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.KeyCode == toggleKey then
		isVisible = not isVisible
		frame.Visible = isVisible
	end
end)
