local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- تأكد إن فيه RemoteEvent موجود
local PingEvent = ReplicatedStorage:FindFirstChild("PingEvent") or Instance.new("RemoteEvent", ReplicatedStorage)
PingEvent.Name = "PingEvent"

if RunService:IsClient() then
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local head = character:WaitForChild("Head")

	-- إنشاء BillboardGui فوق رأس اللاعب
	local billboard = Instance.new("BillboardGui", head)
	billboard.Name = "PingDisplay"
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.AlwaysOnTop = true

	local label = Instance.new("TextLabel", billboard)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(0, 1, 0)
	label.TextScaled = true
	label.Font = Enum.Font.SourceSansBold
	label.Text = "Ping: ... ms"

	-- تحديث البنج
	while true do
		local t0 = tick()
		PingEvent:FireServer(t0)
		PingEvent.OnClientEvent:Once(function(ping)
			label.Text = "Ping: " .. ping .. " ms"
		end)
		wait(2)
	end
end

if RunService:IsServer() then
	PingEvent.OnServerEvent:Connect(function(player, sentTime)
		local ping = math.floor((tick() - sentTime) * 1000)
		PingEvent:FireClient(player, ping)
	end)
end
