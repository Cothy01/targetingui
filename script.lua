local targetingui = {}

local gui

function targetingui.setup()
    local Players = game:GetService("Players")
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

    -- === Main GUI ===
    gui = Instance.new("ScreenGui")
    gui.Name = "TargetingGui"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = playerGui

    -- === Main Frame ===
    local frame = Instance.new("Frame")
    frame.Name = "TargetingFrame"
    frame.Parent = gui
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30) -- darker for modern look
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0.5, -150, 0.75, 0)
    frame.Size = UDim2.new(0, 300, 0, 110)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10) -- smoother corners
    corner.Parent = frame

    -- === Make draggable ===
    frame.Active = true
    frame.Draggable = true

    -- === Username ===
    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Name = "TargetUsername"
    usernameLabel.Parent = frame
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Position = UDim2.new(0.3, 0, 0, 0)
    usernameLabel.Size = UDim2.new(0.7, -5, 0, 25)
    usernameLabel.Font = Enum.Font.GothamBold
    usernameLabel.Text = "Target Username"
    usernameLabel.TextColor3 = Color3.fromRGB(255, 200, 255)
    usernameLabel.TextSize = 12 -- way smaller

    -- === Avatar ===
    local image = Instance.new("ImageLabel")
    image.Name = "TargetingImage"
    image.Parent = frame
    image.BackgroundTransparency = 1
    image.Position = UDim2.new(0.025, 0, 0.25, 0)
    image.Size = UDim2.new(0, 60, 0, 60)
    image.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

    local imageCorner = Instance.new("UICorner")
    imageCorner.CornerRadius = UDim.new(0, 10)
    imageCorner.Parent = image

    -- === Stat bars function ===
    local function makeBar(name, color1, color2, posY)
        local holder = Instance.new("Frame")
        holder.Name = name .. "Holder"
        holder.Parent = frame
        holder.BackgroundTransparency = 1
        holder.Position = UDim2.new(0.3, 0, posY, 0)
        holder.Size = UDim2.new(0.65, 0, 0, 15)

        -- background bar
        local bg = Instance.new("Frame")
        bg.Parent = holder
        bg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BorderSizePixel = 0
        local bgCorner = Instance.new("UICorner", bg)
        bgCorner.CornerRadius = UDim.new(0, 5)

        -- fill bar (changes with value)
        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Parent = holder
        fill.BackgroundColor3 = color1
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BorderSizePixel = 0
        local fillCorner = Instance.new("UICorner", fill)
        fillCorner.CornerRadius = UDim.new(0, 5)

        -- gradient for fancy color
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, color1),
            ColorSequenceKeypoint.new(1, color2)
        }
        gradient.Rotation = 90
        gradient.Parent = fill

        -- stat % label
        local label = Instance.new("TextLabel")
        label.Name = "Value"
        label.Parent = holder
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Font = Enum.Font.Gotham
        label.Text = name .. ": 0%"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Center

        return holder
    end

    -- === Create Bars ===
    gui.HealthBar = makeBar("Health", Color3.fromRGB(85, 255, 128), Color3.fromRGB(0, 200, 100), 0.3)
    gui.ShieldBar = makeBar("Shield", Color3.fromRGB(85, 200, 255), Color3.fromRGB(0, 100, 255), 0.5)
    gui.DownedBar = makeBar("Downed", Color3.fromRGB(255, 100, 100), Color3.fromRGB(255, 50, 50), 0.7)
end

-- === Update Function ===
function targetingui.update(data)
    if not gui then return end

    local Players = game:GetService("Players")
    local PLACEHOLDER_IMAGE = "rbxassetid://0"

    -- Update username
    gui.TargetingFrame.TargetUsername.Text = data.username or "Unknown"

    -- Update avatar
    if data.userid then
        local content, isReady = Players:GetUserThumbnailAsync(data.userid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        gui.TargetingFrame.TargetingImage.Image = isReady and content or PLACEHOLDER_IMAGE
    end

    -- Helper to update bars
    local function updateBar(holder, value)
        value = math.clamp(tonumber(value) or 0, 0, 100)
        local fill = holder.Fill
        fill:TweenSize(UDim2.new(value/100, 0, 1, 0), "Out", "Quad", 0.3, true)
        holder.Value.Text = holder.Name:gsub("Holder","") .. ": " .. value .. "%"
    end

    updateBar(gui.HealthBar, data.health)
    updateBar(gui.ShieldBar, data.shield)
    updateBar(gui.DownedBar, data.downed)
end

return targetingui
