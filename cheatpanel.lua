local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Loading ekranı (küçük kutucuk içinde)
local loadingGui = Instance.new("ScreenGui", playerGui)
loadingGui.Name = "LoadingScreen"

local loadingFrame = Instance.new("Frame", loadingGui)
loadingFrame.Size = UDim2.new(0, 300, 0, 80)
loadingFrame.Position = UDim2.new(0.5, -150, 0.5, -40)
loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
loadingFrame.BackgroundTransparency = 0.3
loadingFrame.BorderSizePixel = 2
loadingFrame.BorderColor3 = Color3.new(0,0,0)
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local loadingText = Instance.new("TextLabel", loadingFrame)
loadingText.Size = UDim2.new(1, -20, 0, 40)
loadingText.Position = UDim2.new(0, 10, 0, 10)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading... Hold Right Ctrl to open menu"
loadingText.TextColor3 = Color3.fromRGB(230, 230, 230)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 18
loadingText.TextWrapped = true
loadingText.TextXAlignment = Enum.TextXAlignment.Center
loadingText.TextYAlignment = Enum.TextYAlignment.Center

local progressBarBG = Instance.new("Frame", loadingFrame)
progressBarBG.Size = UDim2.new(0.9, 0, 0, 20)
progressBarBG.Position = UDim2.new(0.05, 0, 0, 50)
progressBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
progressBarBG.BorderSizePixel = 0
progressBarBG.ClipsDescendants = true

local progressBar = Instance.new("Frame", progressBarBG)
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
progressBar.BorderSizePixel = 0

-- Animate progress bar dolumu
coroutine.wrap(function()
    for i = 0, 1, 0.02 do
        progressBar.Size = UDim2.new(i, 0, 1, 0)
        wait(0.02)
    end
    wait(0.3)
    loadingGui:Destroy()
    gui.Enabled = false
end)()

-- Ana GUI
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "AtesHub"
gui.Enabled = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 350, 0, 220)
mainFrame.Position = UDim2.new(0, 10, 1, -230)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.new(0,0,0)
mainFrame.Active = true
mainFrame.Draggable = true

-- Solda sekme çubuğu
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(0, 80, 1, 0)
tabFrame.Position = UDim2.new(0,0,0,0)
tabFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
tabFrame.BackgroundTransparency = 0.2
tabFrame.BorderSizePixel = 0

local tabs = {"Main", "ESP"}
local buttons = {}
local contentFrames = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, (i-1)*45 + 10)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.BackgroundTransparency = 0.1
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.AutoButtonColor = false
    buttons[i] = btn

    local content = Instance.new("Frame", mainFrame)
    content.Size = UDim2.new(1, -90, 1, -20)
    content.Position = UDim2.new(0, 85, 0, 10)
    content.BackgroundColor3 = Color3.fromRGB(20,20,20)
    content.BackgroundTransparency = 0.4
    content.BorderSizePixel = 0
    content.Visible = false
    contentFrames[i] = content
end

-- Sekme geçiş animasyonu ve logic
local currentTab = 1
contentFrames[currentTab].Visible = true
buttons[currentTab].BackgroundColor3 = Color3.fromRGB(70,70,70)

local function switchTab(newTab)
    if newTab == currentTab then return end
    buttons[currentTab].BackgroundColor3 = Color3.fromRGB(40,40,40)
    contentFrames[currentTab].Visible = false

    currentTab = newTab
    buttons[currentTab].BackgroundColor3 = Color3.fromRGB(70,70,70)
    contentFrames[currentTab].Visible = true
    -- Animasyon basit fade-in yapalım
    contentFrames[currentTab].BackgroundTransparency = 1
    for i=1, 10 do
        contentFrames[currentTab].BackgroundTransparency = contentFrames[currentTab].BackgroundTransparency - 0.04
        wait(0.03)
    end
end

for i, btn in ipairs(buttons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(i)
    end)
end

-- Main Sekmesi: WalkSpeed ve Infinity Jump

-- WalkSpeed Label
local speedLabel = Instance.new("TextLabel", contentFrames[1])
speedLabel.Position = UDim2.new(0, 10, 0, 20)
speedLabel.Size = UDim2.new(0, 100, 0, 25)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "WalkSpeed:"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.SourceSansSemibold
speedLabel.TextSize = 20
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

-- WalkSpeed TextBox
local speedBox = Instance.new("TextBox", contentFrames[1])
speedBox.Position = UDim2.new(0, 120, 0, 20)
speedBox.Size = UDim2.new(0, 180, 0, 25)
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.Font = Enum.Font.SourceSans
speedBox.TextSize = 20
speedBox.ClearTextOnFocus = false
speedBox.Text = tostring(16)

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
            speedBox.Text = "16"
        end
    end
end)

-- Infinity Jump Label
local infLabel = Instance.new("TextLabel", contentFrames[1])
infLabel.Position = UDim2.new(0, 10, 0, 60)
infLabel.Size = UDim2.new(0, 140, 0, 25)
infLabel.BackgroundTransparency = 1
infLabel.Text = "Infinity Jump:"
infLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infLabel.Font = Enum.Font.SourceSansSemibold
infLabel.TextSize = 20
infLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Infinity Jump Toggle Button
local infToggle = Instance.new("TextButton", contentFrames[1])
infToggle.Position = UDim2.new(0, 150, 0, 60)
infToggle.Size = UDim2.new(0, 150, 0, 25)
infToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
infToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
infToggle.Font = Enum.Font.SourceSansBold
infToggle.TextSize = 20
infToggle.Text = "OFF"

local infinityJumpEnabled = false

infToggle.MouseButton1Click:Connect(function()
    infinityJumpEnabled = not infinityJumpEnabled
    infToggle.Text = infinityJumpEnabled and "ON" or "OFF"
end)

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

-- ESP Sekmesi

local espEnabled = false

local espToggle = Instance.new("TextButton", contentFrames[2])
espToggle.Position = UDim2.new(0, 10, 0, 20)
espToggle.Size = UDim2.new(0, 150, 0, 30)
espToggle.BackgroundColor3 = Color3.fromRGB(80,80,80)
espToggle.TextColor3 = Color3.fromRGB(255,255,255)
espToggle.Font = Enum.Font.SourceSansBold
espToggle.TextSize = 22
espToggle.Text = "Toggle ESP"

local espBoxes = {}

local function createBox(player)
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = nil
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 6, 1)
    box.Transparency = 0.5
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Parent = workspace.CurrentCamera
    espBoxes[player] = box
end

local function removeBox(player)
    if espBoxes[player] then
        espBoxes[player]:Destroy()
        espBoxes[player] = nil
    end
end

local function updateBoxes()
    for plr, box in pairs(espBoxes) do
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            box.Adornee = char.HumanoidRootPart
        else
            box.Adornee = nil
        end
    end
end

RunService.Heartbeat:Connect(function()
    if espEnabled then
        updateBoxes()
    end
end)

espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = espEnabled and "ESP ON" or "ESP OFF"
    if espEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                createBox(plr)
            end
        end
    else
        for _, plr in pairs(Players:GetPlayers()) do
            removeBox(plr)
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    if espEnabled and plr ~= player then
        createBox(plr)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    removeBox(plr)
end)

-- Sağ Ctrl ile GUI aç/kapa
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)
