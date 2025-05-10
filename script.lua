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

    local frame = Instance.new("Frame")
    frame.Name = "TargetingFrame"
    frame.Parent = gui
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0.3479, 0, 0.6601, 0)
    frame.Size = UDim2.new(0, 367, 0, 146)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame

    -- Username label
    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Name = "TargetUsername"
    usernameLabel.Parent = frame
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Position = UDim2.new(0.2261, 0, 0, 0)
    usernameLabel.Size = UDim2.new(0, 201, 0, 35)
    usernameLabel.Font = Enum.Font.GothamBold
    usernameLabel.Text = "Target Username"
    usernameLabel.TextColor3 = Color3.fromRGB(255, 165, 251)
    usernameLabel.TextSize = 14

    -- Target Image
    local image = Instance.new("ImageLabel")
    image.Name = "TargetingImage"
    image.Parent = frame
    image.BackgroundTransparency = 1
    image.Position = UDim2.new(0.0354, 0, 0.2397, 0)
    image.Size = UDim2.new(0, 100, 0, 100)
    image.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

    local imageCorner = Instance.new("UICorner")
    imageCorner.CornerRadius = UDim.new(0, 15)
    imageCorner.Parent = image

    -- Labels + Values
    local function makeStat(titleText, valueName, titlePos, valuePos, titleColor)
        local title = Instance.new("TextLabel")
        title.Name = "Title" .. valueName
        title.Parent = frame
        title.BackgroundTransparency = 1
        title.Position = titlePos
        title.Size = UDim2.new(0, 69, 0, 35)
        title.Font = Enum.Font.GothamBold
        title.Text = titleText
        title.TextColor3 = titleColor
        title.TextSize = 14

        local value = Instance.new("TextLabel")
        value.Name = "Value" .. valueName
        value.Parent = frame
        value.BackgroundTransparency = 1
        value.Position = valuePos
        value.Size = UDim2.new(0, 69, 0, 35)
        value.Font = Enum.Font.GothamBold
        value.Text = "N/A"
        value.TextColor3 = Color3.fromRGB(255, 255, 255)
        value.TextSize = 14
    end

    makeStat("Health:", "Health", UDim2.new(0.4032, 0, 0.2397, 0), UDim2.new(0.6294, 0, 0.2397, 0), Color3.fromRGB(185, 255, 174))
    makeStat("Shield:", "Shield", UDim2.new(0.4032, 0, 0.4794, 0), UDim2.new(0.6294, 0, 0.4794, 0), Color3.fromRGB(175, 255, 255))
    makeStat("Downed:", "Downed", UDim2.new(0.4059, 0, 0.7191, 0), UDim2.new(0.6294, 0, 0.7191, 0), Color3.fromRGB(255, 151, 151))
end

-- Update function (updates the UI with new info)
function targetingui.update(data)
    if not gui then return end -- Don't update if GUI not setup

    local Players = game:GetService("Players")
    local PLACEHOLDER_IMAGE = "rbxassetid://0"

    -- Update username
    gui.TargetingFrame.TargetUsername.Text = data.username or "Unknown"

    -- Update avatar image
    if data.userid then
        local content, isReady = Players:GetUserThumbnailAsync(data.userid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        gui.TargetingFrame.TargetingImage.Image = isReady and content or PLACEHOLDER_IMAGE
    end

    -- Update health/shield/downed
    gui.TargetingFrame.ValueHealth.Text = data.health or "N/A"
    gui.TargetingFrame.ValueShield.Text = data.shield or "N/A"
    gui.TargetingFrame.ValueDowned.Text = data.downed or "N/A"
end

return targetingui
