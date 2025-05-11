local targetingui = {}

local gui

function targetingui.setup()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
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
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0.5, -175, 0.75, 0)
    frame.Size = UDim2.new(0, 350, 0, 140)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6) -- less curvy
    corner.Parent = frame

    -- === Make draggable ===
    frame.Active = true
    frame.Draggable = true

    -- === Top bar effect ===
    local topEffect = Instance.new("ImageLabel")
    topEffect.Name = "TopEffect"
    topEffect.Parent = frame
    topEffect.BackgroundTransparency = 1
    topEffect.Image = "rbxassetid://14239914881"
    topEffect.Size = UDim2.new(1, 0, 0, 10) -- small strip on top
    topEffect.Position = UDim2.new(0, 0, 0, 0)
    topEffect.ImageColor3 = Color3.fromRGB(0, 255, 0)

    -- === Animate topEffect color ===
    RunService.RenderStepped:Connect(function()
        topEffect.ImageColor3 = topEffect.ImageColor3:Lerp(Color3.fromRGB(0, 255, 0), 0.02)
    end)

    -- === Username ===
    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Name = "TargetUsername"
    usernameLabel.Parent = frame
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Position = UDim2.new(0.3, 0, 0, 5)
    usernameLabel.Size = UDim2.new(0.7, -5, 0, 30)
    usernameLabel.Font = Enum.Font.GothamBold
    usernameLabel.Text = "Target Username"
    usernameLabel.TextColor3 = Color3.fromRGB(255, 200, 255)
    usernameLabel.TextSize = 16

    -- === Avatar ===
    local image = Instance.new("ImageLabel")
    image.Name = "TargetingImage"
    image.Parent = frame
    image.BackgroundTransparency = 1
    image.Position = UDim2.new(0.025, 0, 0.25, 0)
    image.Size = UDim2.new(0, 75, 0, 75)
    image.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

    local imageCorner = Instance.new("UICorner")
    imageCorner.CornerRadius = UDim.new(0, 8)
    imageCorner.Parent = image

    -- === Stat bars function ===
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
        local bgCorner = Instance.new("UICorner", bg)
        bgCorner.CornerRadius = UDim.new(0, 4)

        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Parent = holder
        fill.BackgroundColor3 = color1
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BorderSizePixel = 0
        local fillCorner = Instance.new("UICorner", fill)
        fillCorner.CornerRadius = UDim.new(0, 4)

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

    -- === Create Bars ===
    gui.HealthBar = makeBar("Health", Color3.fromRGB(85, 255, 128), Color3.fromRGB(0, 200, 100), 0.35)
    gui.ShieldBar = makeBar("Shield", Color3.fromRGB(85, 200, 255), Color3.fromRGB(0, 100, 255), 0.55)
    gui.DownedBar = makeBar("Downed", Color3.fromRGB(255, 100, 100), Color3.fromRGB(255, 50, 50), 0.75)
end

-- === Update Function ===
function targetingui.update(data)
    if not gui then return end

    local Players = game:GetService("Players")
    local PLACEHOLDER_IMAGE = "rbxassetid://0"

    gui.TargetingFrame.TargetUsername.Text = data.username or "Unknown"

    if data.userid then
        local content, isReady = Players:GetUserThumbnailAsync(data.userid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        gui.TargetingFrame.TargetingImage.Image = isReady and content or PLACEHOLDER_IMAGE
    end

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
