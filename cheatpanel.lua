local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local infinityJumpEnabled = false

-- Loading Screen
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingScreen"
loadingGui.Parent = playerGui

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 250, 0, 50)
loadingFrame.Position = UDim2.new(0.5, -125, 0.5, -25)
loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
loadingFrame.BackgroundTransparency = 0.1
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = loadingGui
loadingFrame.ClipsDescendants = true
loadingFrame.ZIndex = 10
loadingFrame.Rotation = 3

-- Progress Bar Background
local progressBarBG = Instance.new("Frame")
progressBarBG.Size = UDim2.new(0.9, 0, 0.3, 0)
progressBarBG.Position = UDim2.new(0.05, 0, 0.6, 0)
progressBarBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
progressBarBG.BorderSizePixel = 0
progressBarBG.Parent = loadingFrame
progressBarBG.AnchorPoint = Vector2.new(0, 0)

-- Progress Bar Fill
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBarBG
progressBar.AnchorPoint = Vector2.new(0, 0)

-- Loading Text
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0.6, 0)
loadingText.Position = UDim2.new(0, 0, 0, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading... Hold Right Ctrl to open menu"
loadingText.TextColor3 = Color3.fromRGB(230, 230, 230)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 18
loadingText.Parent = loadingFrame
loadingText.TextWrapped = true
loadingText.TextXAlignment = Enum.TextXAlignment.Center
loadingText.TextYAlignment = Enum.TextYAlignment.Center

-- RGB effect for progressBar
local hue = 0
local runConnection
runConnection = RunService.Heartbeat:Connect(function()
    hue = (hue + 2) % 360
    progressBar.BackgroundColor3 = Color3.fromHSV(hue / 360, 1, 1)
end)

-- Animate progress bar fill
coroutine.wrap(function()
    for i = 0, 1, 0.02 do
        progressBar.Size = UDim2.new(i, 0, 1, 0)
        wait(0.02)
    end
    wait(0.3)
    loadingGui:Destroy()
    runConnection:Disconnect()
    gui.Enabled = false
end)()

-- Main GUI (Başlangıçta kapalı)
local gui = Instance.new("ScreenGui")
gui.Name = "AtesHub"
gui.Parent = playerGui
gui.Enabled = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 140)
frame.Position = UDim2.new(0, 10, 1, -160)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local guiHue = 0 -- GUI renk döngüsü için

RunService.Heartbeat:Connect(function()
    guiHue = (guiHue + 1) % 360
    local color = Color3.fromHSV(guiHue / 360, 1, 0.7)
    frame.BackgroundColor3 = color
    title.TextColor3 = color
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Ates Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255) -- başlangıç rengi, üstte sürekli değişecek
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = frame

-- WalkSpeed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Position = UDim2.new(0, 15, 0, 45)
speedLabel.Size = UDim2.new(0, 90, 0, 20)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "WalkSpeed:"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.SourceSansSemibold
speedLabel.TextSize = 18
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = frame

-- WalkSpeed TextBox
local speedBox = Instance.new("TextBox")
speedBox.Position = UDim2.new(0, 110, 0, 45)
speedBox.Size = UDim2.new(0, 120, 0, 20)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.Font = Enum.Font.SourceSans
speedBox.TextSize = 18
speedBox.ClearTextOnFocus = false
speedBox.Text = tostring(16) -- default walkspeed
speedBox.Parent = frame

-- Infinity Jump Checkbox Label
local infLabel = Instance.new("TextLabel")
infLabel.Position = UDim2.new(0, 15, 0, 80)
infLabel.Size = UDim2.new(0, 140, 0, 20)
infLabel.BackgroundTransparency = 1
infLabel.Text = "Infinity Jump:"
infLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infLabel.Font = Enum.Font.SourceSansSemibold
infLabel.TextSize = 18
infLabel.TextXAlignment = Enum.TextXAlignment.Left
infLabel.Parent = frame

-- Infinity Jump Checkbox (simple toggle)
local infToggle = Instance.new("TextButton")
infToggle.Position = UDim2.new(0, 160, 0, 80)
infToggle.Size = UDim2.new(0, 70, 0, 20)
infToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
infToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
infToggle.Font = Enum.Font.SourceSansBold
infToggle.TextSize = 18
infToggle.Text = "OFF"
infToggle.Parent = frame

infToggle.MouseButton1Click:Connect(function()
    infinityJumpEnabled = not infinityJumpEnabled
    infToggle.Text = infinityJumpEnabled and "ON" or "OFF"
end)

-- WalkSpeed change handler
speedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = tonumber(speedBox.Text)
        if val and val >= 0 and val <= 500 then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = val
                end
            end
        else
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    speedBox.Text = tostring(humanoid.WalkSpeed)
                else
                    speedBox.Text = "16"
                end
            else
                speedBox.Text = "16"
            end
        end
    end
end)

-- Infinity jump logic
UserInputService.JumpRequest:Connect(function()
    if infinityJumpEnabled then
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum:GetState() == Enum.HumanoidStateType.Freefall then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- Right Ctrl key toggle GUI visibility
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)
