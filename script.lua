local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- === Main Gui ===
local gui = Instance.new("ScreenGui")
gui.Name = "TargetingGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- === Main Targeting Frame ===
local frame = Instance.new("Frame")
frame.Name = "TargetingFrame"
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Parent = gui

-- === Icon Holder Frame (separate, 1:1 ratio) ===
local iconFrame = Instance.new("Frame")
iconFrame.Name = "IconFrame"
iconFrame.Size = UDim2.new(0, 50, 0, 50) -- 1:1 ratio (square)
iconFrame.Position = frame.Position - UDim2.new(0, 0, 0, 60) -- above main frame
iconFrame.BackgroundTransparency = 1 -- fully transparent bg
iconFrame.Parent = gui

-- === Icon Image ===
local icon_top = Instance.new("ImageLabel")
icon_top.Name = "icon_top"
icon_top.Size = UDim2.new(1, 0, 1, 0) -- full size of holder frame
icon_top.Position = UDim2.new(0, 0, 0, 0)
icon_top.BackgroundTransparency = 1
icon_top.Image = "rbxassetid://14239914881"
icon_top.Parent = iconFrame

-- === Optional: Animate Icon Color (cool effect you wanted) ===
task.spawn(function()
	while true do
		icon_top.ImageColor3 = icon_top.ImageColor3:Lerp(Color3.fromRGB(0, 255, 0), 0.02)
		task.wait(0.05)
	end
end)

-- === Bar Maker Function (for future health/armor bars etc) ===
local function makeBar(labelText, colorMain, colorFill, yScale)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.9, 0, 0.15, 0)
	container.Position = UDim2.new(0.05, 0, yScale, 0)
	container.BackgroundColor3 = colorMain
	container.BackgroundTransparency = 0.2
	container.BorderSizePixel = 0
	container.Parent = frame

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = colorFill
	fill.BorderSizePixel = 0
	fill.Parent = container

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.Gotham
	label.TextScaled = true
	label.Parent = container

	return fill, label
end

-- Example: Health Bar (optional demo)
local healthFill, healthLabel = makeBar("Health: 0%", Color3.fromRGB(50, 50, 50), Color3.fromRGB(255, 0, 0), 0.1)
