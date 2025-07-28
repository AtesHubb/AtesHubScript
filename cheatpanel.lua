local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Loading Screen
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingScreen"
loadingGui.Parent = playerGui

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 300, 0, 80)
loadingFrame.Position = UDim2.new(0.5, -150, 0.5, -40)
loadingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
loadingFrame.BorderSizePixel = 0
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.Parent = loadingGui
loadingFrame.ClipsDescendants = true

-- Loading Text
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, -20, 0, 40)
loadingText.Position = UDim2.new(0, 10, 0, 10)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading... Hold Right Ctrl to open menu"
loadingText.TextColor3 = Color3.fromRGB(220, 220, 220)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 18
loadingText.Parent = loadingFrame
loadingText.TextWrapped = true
loadingText.TextXAlignment = Enum.TextXAlignment.Center
loadingText.TextYAlignment = Enum.TextYAlignment.Center

-- Progress Bar Background
local progressBarBG = Instance.new("Frame")
progressBarBG.Size = UDim2.new(0.9, 0, 0, 20)
progressBarBG.Position = UDim2.new(0.05, 0, 0, 50)
progressBarBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
progressBarBG.BorderSizePixel = 0
progressBarBG.Parent = loadingFrame
progressBarBG.AnchorPoint = Vector2.new(0, 0)
progressBarBG.ClipsDescendants = true
progressBarBG.Rotation = 0

-- Progress Bar Fill
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBarBG
progressBar.AnchorPoint = Vector2.new(0, 0)

-- RGB color cycling for progress bar
local hue = 0
local progressRunning = true
local runConnection = RunService.Heartbeat:Connect(function()
    hue = (hue + 2) % 360
    progressBar.BackgroundColor3 = Color3.fromHSV(hue / 360, 1, 1)
    if not progressRunning then
        runConnection:Disconnect()
    end
end)

-- Animate progress bar fill
coroutine.wrap(function()
    for i = 0, 1, 0.02 do
        progressBar.Size = UDim2.new(i, 0, 1, 0)
        wait(0.02)
    end
    wait(0.3)
    progressRunning = false
    loadingGui:Destroy()
    gui.Enabled = false
end)()

-- Main GUI (başlangıçta kapalı)
local gui = Instance.new("ScreenGui")
gui.Name = "AtesHub"
gui.Parent = playerGui
gui.Enabled = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0, 10, 1, -160)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local guiHue = 0 -- RGB döngü için

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Ates Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255) -- Bu renk RunService ile RGB olacak
title.Font = Enum.Font.GothamBold
title.TextSize = 26
title.Parent = frame

RunService.Heartbeat:Connect(function()
    guiHue = (guiHue + 1) % 360
    local color = Color3.fromHSV(guiHue / 360, 1, 0.7)
    frame.BackgroundColor3 = color
    title.TextColor3 = color
end)

-- WalkSpeed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Position = UDim2.new(0, 15, 0, 50)
speedLabel.Size = UDim2.new(0, 90, 0, 25)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "WalkSpeed:"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.SourceSansSemibold
speedLabel.TextSize = 20
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = frame

-- WalkSpeed TextBox
local speedBox = Instance.new("TextBox")
speedBox.Position = UDim2.new(0, 110, 0, 50)
speedBox.Size = UDim2.new(0, 170, 0, 25)
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.Font = Enum.Font.SourceSans
speedBox.TextSize = 20
speedBox.ClearTextOnFocus = false
speedBox.Text = tostring(16)
speedBox.Parent = frame

-- Infinity Jump Label
local infLabel = Instance.new("TextLabel")
infLabel.Position = UDim2.new(0, 15, 0, 90)
infLabel.Size = UDim2.new(0, 140, 0, 25)
infLabel.BackgroundTransparency = 1
infLabel.Text = "Infinity Jump:"
infLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infLabel.Font = Enum.Font.SourceSansSemibold
infLabel.TextSize = 20
infLabel.TextXAlignment = Enum.TextXAlignment.Left
infLabel.Parent = frame

-- Infinity Jump Toggle Button
local infToggle = Instance.new("TextButton")
infToggle.Position = UDim2.new(0, 160, 0, 90)
infToggle.Size = UDim2.new(0, 120, 0, 25)
infToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
infToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
infToggle.Font = Enum.Font.SourceSansBold
infToggle.TextSize = 20
infToggle.Text = "OFF"
infToggle.Parent = frame

local infinityJumpEnabled = false

infToggle.MouseButton1Click:Connect(function()
    infinityJumpEnabled = not infinityJumpEnabled
    infToggle.Text = infinityJumpEnabled and "ON" or "OFF"
end)

-- WalkSpeed değişikliği
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
            -- Geçersiz değer girilirse eski değeri geri koy
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

-- Sağ Ctrl ile GUI aç/kapa
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)
