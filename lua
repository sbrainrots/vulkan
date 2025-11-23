--// VoxiumHub Standalone Loading Screen (purple loading bar + percentage + dot animation, 5min progressive, fixed percentage ranges, minimize to circle)

local player = game:GetService("Players").LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = pgui

-- Main panel
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.57, 0, 0.51, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 25)
mainCorner.Parent = mainFrame

-- Minimize Button (circular)
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.AnchorPoint = Vector2.new(0, 0)
minimizeButton.Text = "_"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 24
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.BorderSizePixel = 0
minimizeButton.Parent = mainFrame
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1,0)
minCorner.Parent = minimizeButton

local minimized = false

-- Title
local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0.06, 0)
title.Text = "VoxiumHub"
title.Font = Enum.Font.GothamBold
title.TextSize = 36
title.TextColor3 = Color3.fromRGB(170, 110, 255)
title.Parent = mainFrame

-- Discord link
local support = Instance.new("TextLabel")
support.BackgroundTransparency = 1
support.Size = UDim2.new(1, 0, 0, 25)
support.Position = UDim2.new(0, 0, 0.22, 0)
support.Text = "https://discord.gg/AMJPmuan5"
support.Font = Enum.Font.GothamMedium
support.TextSize = 16
support.TextColor3 = Color3.fromRGB(90, 180, 255)
support.Parent = mainFrame

-- Bottom box
local bottomBox = Instance.new("Frame")
bottomBox.Size = UDim2.new(0.57, 0, 0.12, 0)
bottomBox.Position = UDim2.new(0.5, 0, 0.75, 0)
bottomBox.AnchorPoint = Vector2.new(0.5, 0.5)
bottomBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
bottomBox.BackgroundTransparency = 0.2
bottomBox.BorderSizePixel = 0
bottomBox.Parent = mainFrame
local bottomCorner = Instance.new("UICorner")
bottomCorner.CornerRadius = UDim.new(0, 15)
bottomCorner.Parent = bottomBox

-- Loading bar
local loadingBar = Instance.new("Frame")
loadingBar.Size = UDim2.new(0, 0, 1, 0)
loadingBar.Position = UDim2.new(0, 0, 0, 0)
loadingBar.BackgroundColor3 = Color3.fromRGB(170, 110, 255)
loadingBar.BorderSizePixel = 0
loadingBar.Parent = bottomBox
local loadCorner = Instance.new("UICorner")
loadCorner.CornerRadius = UDim.new(0, 15)
loadCorner.Parent = loadingBar

-- Gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 140, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170, 110, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 140, 255))
})
gradient.Rotation = 0
gradient.Parent = loadingBar

-- Percentage label
local percentLabel = Instance.new("TextLabel")
percentLabel.BackgroundTransparency = 1
percentLabel.Size = UDim2.new(1, 0, 1, 0)
percentLabel.Position = UDim2.new(0, 0, 0, 0)
percentLabel.Font = Enum.Font.GothamBold
percentLabel.TextSize = 18
percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
percentLabel.Text = "0%"
percentLabel.TextScaled = true
percentLabel.Parent = bottomBox

-- Message label
local messageLabel = Instance.new("TextLabel")
messageLabel.BackgroundTransparency = 1
messageLabel.Size = UDim2.new(1, 0, 0, 25)
messageLabel.Position = UDim2.new(0, 0, -1.1, 0)
messageLabel.Font = Enum.Font.GothamMedium
messageLabel.TextSize = 16
messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
messageLabel.Text = ""
messageLabel.Parent = bottomBox

-- Status messages with fixed percentage ranges
local statusRanges = {
    {message = "Bypassing anti-cheat", min = 1, max = 23},
    {message = "Loading resources", min = 24, max = 36},
    {message = "Initializing components", min = 37, max = 50},
    {message = "Syncing data", min = 51, max = 64},
    {message = "Optimizing performance", min = 65, max = 78},
    {message = "Almost ready", min = 79, max = 92},
    {message = "Finalizing setup", min = 93, max = 100}
}

-- Dot animation variables
local startTime = tick()
local duration = 300
local dotCount = 0

RunService.RenderStepped:Connect(function()
    local elapsed = tick() - startTime
    local progress = math.clamp(elapsed / duration, 0, 1)
    local eased = 1 - math.pow(1 - progress, 2)

    -- Loading bar & percent
    loadingBar.Size = UDim2.new(eased, 0, 1, 0)
    local percent = math.floor(eased * 100)
    percentLabel.Text = percent .. "%"

    -- Select message based on percent
    local currentMsg = ""
    for _, range in ipairs(statusRanges) do
        if percent >= range.min and percent <= range.max then
            currentMsg = range.message
            break
        end
    end

    -- Dot animation
    dotCount = (dotCount + 1) % 60
    local dots = string.rep(".", math.floor(dotCount / 15))
    messageLabel.Text = currentMsg .. dots
end)

-- Minimize button
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame:TweenSizeAndPosition(
            UDim2.new(0, 60, 0, 60),
            UDim2.new(0, 10, 0.25, 0),
            Enum.EasingDirection.InOut,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
        mainCorner.CornerRadius = UDim.new(0, 30)
        title.Visible = false
        support.Visible = false
        bottomBox.Visible = false
        messageLabel.Visible = false
    else
        mainFrame:TweenSizeAndPosition(
            UDim2.new(0.57, 0, 0.51, 0),
            UDim2.new(0.5, 0, 0.5, 0),
            Enum.EasingDirection.InOut,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
        mainCorner.CornerRadius = UDim.new(0, 25)
        title.Visible = true
        support.Visible = true
        bottomBox.Visible = true
        messageLabel.Visible = true
    end
end)
