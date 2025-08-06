local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PingEvent = Instance.new("RemoteEvent", ReplicatedStorage)
PingEvent.Name = "PingEvent"

if game:GetService("RunService"):IsClient() then
	local player = Players.LocalPlayer
	local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	gui.Name = "PingGUI"

	local label = Instance.new("TextLabel", gui)
	label.Size = UDim2.new(0, 220, 0, 40)
	label.Position = UDim2.new(0, 10, 0, 10)
	label.BackgroundColor3 = Color3.new(0, 0, 0)
	label.TextColor3 = Color3.new(0, 1, 0)
	label.TextScaled = true
	label.Font = Enum.Font.SourceSansBold
	label.Text = "Ping: ... ms"

	while true do
		local t0 = tick()
		PingEvent:FireServer(t0)
		PingEvent.OnClientEvent:Once(function(ping)
			label.Text = "Ping: " .. ping .. " ms"
		end)
		wait(2)
	end
end

if game:GetService("RunService"):IsServer() then
	PingEvent.OnServerEvent:Connect(function(player, sentTime)
		local ping = math.floor((tick() - sentTime) * 1000)
		PingEvent:FireClient(player, ping)
	end)
end
