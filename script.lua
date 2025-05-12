-- targetingui.lua
local targetingui = {}

local gui

function targetingui.setup()
    local Players = game:GetService("Players")
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

    -- === Main GUI ===
    gui = Instance.new("ScreenGui")
    gui.Name = "TargetGui"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = playerGui

    -- === Main Frame ===
    local frame = Instance.new("Frame")
    frame.Name = "TargetFrame"
    frame.Parent = gui
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0.5, -175, 0.75, 0)
    frame.Size = UDim2.new(0, 350, 0, 160) -- made taller for distance label

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    -- === Make draggable ===
    frame.Active = true
    frame.Draggable = true

    -- === Title Label ===
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TargetTitle"
    titleLabel.Parent = frame
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 0, 0, -20)
    titleLabel.Size = UDim2.new(1, 0, 0, 20)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "Target Locked"
    titleLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center

    -- === Username Label ===
    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Name = "TargetUsername"
    usernameLabel.Parent = frame
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Position = UDim2.new(0.3, 0, 0, 5)
    usernameLabel.Size = UDim2.new(0.7, -5, 0, 30)
    usernameLabel.Font = Enum.Font.GothamBold
    usernameLabel.Text = "Username"
    usernameLabel.TextColor3 = Color3.fromRGB(255, 200, 255)
    usernameLabel.TextSize = 16

    -- === Avatar Image ===
    local image = Instance.new("ImageLabel")
    image.Name = "TargetImage"
    image.Parent = frame
    image.BackgroundTransparency = 1
    image.Position = UDim2.new(0.025, 0, 0.25, 0)
    image.Size = UDim2.new(0, 75, 0, 75)
    image.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

    local imageCorner = Instance.new("UICorner")
    imageCorner.CornerRadius = UDim.new(0, 8)
    imageCorner.Parent = image

    -- === Stat Bars Creator ===
    local function makeBar(name, color1, color2, posY)
        local holder = Instance.new("Frame")
        holder.Name = name .. "Holder"
        holder.Parent = frame
        holder.BackgroundTransparency = 1
        holder.Position = UDim2.new(0.3, 0, posY, 0)
        holder.Size = UDim2.new(0.65, 0, 0, 20)

        local bg = Instance.new("Frame")
        bg.Parent = holder
        bg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BorderSizePixel = 0
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 4)

        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Parent = holder
        fill.BackgroundColor3 = color1
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BorderSizePixel = 0
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, color1),
            ColorSequenceKeypoint.new(1, color2)
        }
        gradient.Rotation = 90
        gradient.Parent = fill

        local label = Instance.new("TextLabel")
        label.Name = "Value"
        label.Parent = holder
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Font = Enum.Font.Gotham
        label.Text = name .. ": 0%"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Center

        return holder
    end

    -- === Create Bars (Health + Shield) ===
    frame.HealthBar = makeBar("Health", Color3.fromRGB(85, 255, 128), Color3.fromRGB(0, 200, 100), 0.35)
    frame.ShieldBar = makeBar("Shield", Color3.fromRGB(85, 200, 255), Color3.fromRGB(0, 100, 255), 0.55)


    -- === Downed Status Label ===
    local downedLabel = Instance.new("TextLabel")
    downedLabel.Name = "DownedLabel"
    downedLabel.Parent = frame
    downedLabel.BackgroundTransparency = 1
    downedLabel.Position = UDim2.new(0.3, 0, 0.75, 0)
    downedLabel.Size = UDim2.new(0.65, 0, 0, 20)
    downedLabel.Font = Enum.Font.GothamBold
    downedLabel.Text = "Downed: NO"
    downedLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    downedLabel.TextSize = 14
    downedLabel.TextXAlignment = Enum.TextXAlignment.Center

    -- === Distance Label ===
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Parent = frame
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Position = UDim2.new(0.3, 0, 0.88, 0)
    distanceLabel.Size = UDim2.new(0.65, 0, 0, 20)
    distanceLabel.Font = Enum.Font.GothamBold
    distanceLabel.Text = "Distance: N/A"
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distanceLabel.TextSize = 14
    distanceLabel.TextXAlignment = Enum.TextXAlignment.Center
end

-- === Update Function ===
function targetingui.update(data)
    if not gui then return end

    local Players = game:GetService("Players")
    local PLACEHOLDER_IMAGE = "rbxassetid://0"

    gui.TargetFrame.TargetUsername.Text = data.username or "Unknown"

    -- === Avatar ===
    if data.userid then
        local content, isReady = Players:GetUserThumbnailAsync(data.userid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        gui.TargetFrame.TargetImage.Image = isReady and content or PLACEHOLDER_IMAGE
    end

    -- === Update Bars ===
    local function updateBar(holder, value)
        value = math.clamp(tonumber(value) or 0, 0, 100)
        local fill = holder.Fill
        fill:TweenSize(UDim2.new(value/100, 0, 1, 0), "Out", "Quad", 0.3, true)
        holder.Value.Text = holder.Name:gsub("Holder","") .. ": " .. value .. "%"
    end
    updateBar(gui.TargetFrame.HealthBar, data.health)
    updateBar(gui.TargetFrame.ShieldBar, data.shield)

    -- === Downed Status ===
    if data.downed ~= nil then
        local label = gui.TargetFrame.DownedLabel
        if data.downed == true then
            label.Text = "Downed: YES"
            label.TextColor3 = Color3.fromRGB(255, 50, 50)
        else
            label.Text = "Downed: NO"
            label.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
    end

    -- === Distance (with coloring) ===
    if data.targetPosition then
        local player = Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerPos = player.Character.HumanoidRootPart.Position
            local distance = math.floor((data.targetPosition - playerPos).Magnitude)

            local distanceLabel = gui.TargetFrame.DistanceLabel
            distanceLabel.Text = "Distance: " .. tostring(distance) .. " studs"

            if distance <= 50 then
                distanceLabel.TextColor3 = Color3.fromRGB(255, 50, 50) -- Red (close)
            elseif distance <= 100 then
                distanceLabel.TextColor3 = Color3.fromRGB(255, 150, 50) -- Orange (medium)
            else
                distanceLabel.TextColor3 = Color3.fromRGB(100, 255, 100) -- Green (far)
            end
        end
    end
end

return targetingui
