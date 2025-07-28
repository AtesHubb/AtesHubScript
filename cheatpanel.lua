local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Infinity jump toggle
local infinityJumpEnabled = false

-- Loading Screen
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingScreen"
loadingGui.Parent = playerGui

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 220, 0, 35)
loadingFrame.Position = UDim2.new(0.5, -110, 0.5, -17)
loadingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
loadingFrame.BackgroundTransparency = 0.7
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.Parent = loadingGui
loadingFrame.BorderSizePixel = 0
loadingFrame.ClipsDescendants = true

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
progressBar.Parent = loadingFrame
progressBar.BorderSizePixel = 0

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 1, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading... Hold Right Ctrl to open menu"
loadingText.TextColor3 = Color3.fromRGB(220, 220, 220)
loadingText.Font = Enum.Font.SourceSansSemibold
loadingText.TextSize = 16
loadingText.Parent = loadingFrame

-- RGB effect for progressBar
local hue = 0
local runConnection
runConnection = RunService.Heartbeat:Connect(function()
    hue = (hue + 1) % 360
    progressBar.BackgroundColor3 = Color3.fromHSV(hue/360, 1, 1)
end)

-- Progress bar fill animation (fast)
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
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Ates Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
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
            speedBox.Text = tostring(humanoid.WalkSpeed)
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
