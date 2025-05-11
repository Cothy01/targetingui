local targetingui = {}

local gui -- We'll store the GUI here so we can update it later

-- Setup function (creates the UI)
function targetingui.setup()
    local Players = game:GetService("Players")
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

    -- === GUI Creation ===
    gui = Instance.new("ScreenGui")
    gui.Name = "TargetingGui"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = playerGui

    -- === Main Frame ===
    local frame = Instance.new("Frame")
    frame.Name = "TargetingFrame"
    frame.Parent = gui
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 60) -- dark but not pure black
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0.5, -140, 0.75, 0)
    frame.Size = UDim2.new(0, 280, 0, 130)
    frame.Active = true -- Needed for dragging
    frame.Draggable = true -- Makes it draggable just by default (simple way)

    -- Round corners (slight curve looks modern)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    -- Gradient background (looks cooler)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 90)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 50))
    }
    gradient.Rotation = 45
    gradient.Parent = frame

    -- === Username Label ===
    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Name = "TargetUsername"
    usernameLabel.Parent = frame
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Position = UDim2.new(0.3, 0, 0, 5)
    usernameLabel.Size = UDim2.new(0.6, -5, 0, 25)
    usernameLabel.Font = Enum.Font.GothamBold
    usernameLabel.Text = "Target Username"
    usernameLabel.TextColor3 = Color3.fromRGB(255, 170, 255)
    usernameLabel.TextScaled = true

    -- === Target Image ===
    local image = Instance.new("ImageLabel")
    image.Name = "TargetingImage"
    image.Parent = frame
    image.BackgroundTransparency = 1
    image.Position = UDim2.new(0.025, 0, 0.2, 0)
    image.Size = UDim2.new(0, 60, 0, 60)
    image.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

    local imageCorner = Instance.new("UICorner")
    imageCorner.CornerRadius = UDim.new(0, 12)
    imageCorner.Parent = image

    -- === Helper to make stats clean ===
    local function makeStat(titleText, valueName, yOffset, titleColor)
        local title = Instance.new("TextLabel")
        title.Name = "Title" .. valueName
        title.Parent = frame
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0.3, 0, yOffset, 0)
        title.Size = UDim2.new(0.35, -5, 0, 25)
        title.Font = Enum.Font.GothamSemibold
        title.Text = titleText
        title.TextColor3 = titleColor
        title.TextScaled = true

        local value = Instance.new("TextLabel")
        value.Name = "Value" .. valueName
        value.Parent = frame
        value.BackgroundTransparency = 1
        value.Position = UDim2.new(0.65, 0, yOffset, 0)
        value.Size = UDim2.new(0.3, 0, 0, 25)
        value.Font = Enum.Font.GothamBold
        value.Text = "N/A"
        value.TextColor3 = Color3.fromRGB(255, 255, 255)
        value.TextScaled = true
    end

    -- Health, Shield, Downed (in a tidy stack)
    makeStat("HP:", "Health", 0.3, Color3.fromRGB(185, 255, 174)) -- greenish
    makeStat("Shield:", "Shield", 0.5, Color3.fromRGB(175, 255, 255)) -- cyan
    makeStat("Down:", "Downed", 0.7, Color3.fromRGB(255, 151, 151)) -- reddish
end

-- Update function (updates the UI with new info)
function targetingui.update(data)
    if not gui then return end

    local Players = game:GetService("Players")
    local PLACEHOLDER_IMAGE = "rbxassetid://0"

    -- Username
    gui.TargetingFrame.TargetUsername.Text = data.username or "Unknown"

    -- Avatar image
    if data.userid then
        local content, isReady = Players:GetUserThumbnailAsync(data.userid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        gui.TargetingFrame.TargetingImage.Image = isReady and content or PLACEHOLDER_IMAGE
    end

    -- Stats
    gui.TargetingFrame.ValueHealth.Text = tostring(data.health or "N/A")
    gui.TargetingFrame.ValueShield.Text = tostring(data.shield or "N/A")
    gui.TargetingFrame.ValueDowned.Text = tostring(data.downed or "N/A")
end

return targetingui
