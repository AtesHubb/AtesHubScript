local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function getHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end

local humanoid = getHumanoid()

-- Main GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "CheatPanel"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 350, 0, 300)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(255,0,0)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 15)

-- RGB background anim
task.spawn(function()
    while true do
        for h = 0, 1, 0.005 do
            mainFrame.BackgroundColor3 = Color3.fromHSV(h,1,1)
            task.wait(0.01)
        end
    end
end)

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Text = "Cheat Panel"
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 28

-- Tabs buttons container
local tabButtons = Instance.new("Frame", mainFrame)
tabButtons.Size = UDim2.new(1, 0, 0, 40)
tabButtons.Position = UDim2.new(0, 0, 0.15, 0)
tabButtons.BackgroundTransparency = 1

local tabs = {"Movement", "ESP", "Misc"}
local tabFrames = {}

local function createButton(name, pos)
    local btn = Instance.new("TextButton", tabButtons)
    btn.Text = name
    btn.Size = UDim2.new(1/#tabs, 0, 1, 0)
    btn.Position = UDim2.new((pos-1)/#tabs, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    return btn
end

for i, tabName in ipairs(tabs) do
    local btn = createButton(tabName, i)
    btn.MouseButton1Click:Connect(function()
        for _, frame in pairs(tabFrames) do
            frame.Visible = false
        end
        tabFrames[tabName].Visible = true
    end)
end

-- Create tab frames
for _, tabName in pairs(tabs) do
    local frame = Instance.new("Frame", mainFrame)
    frame.Size = UDim2.new(1, -20, 1, -90)
    frame.Position = UDim2.new(0, 10, 0, 60)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    tabFrames[tabName] = frame
end

tabFrames["Movement"].Visible = true

-- === Movement Tab ===

-- WalkSpeed Label & TextBox
local wsLabel = Instance.new("TextLabel", tabFrames["Movement"])
wsLabel.Text = "WalkSpeed (min 16):"
wsLabel.Size = UDim2.new(0.5, 0, 0, 25)
wsLabel.Position = UDim2.new(0, 0, 0, 5)
wsLabel.BackgroundTransparency = 1
wsLabel.TextColor3 = Color3.new(1,1,1)
wsLabel.Font = Enum.Font.GothamBold
wsLabel.TextSize = 16

local wsBox = Instance.new("TextBox", tabFrames["Movement"])
wsBox.Size = UDim2.new(0.4, 0, 0, 30)
wsBox.Position = UDim2.new(0.5, 0, 0, 0)
wsBox.PlaceholderText = "16"
wsBox.Font = Enum.Font.Gotham
wsBox.TextSize = 16
wsBox.BackgroundColor3 = Color3.fromRGB(240,240,240)
Instance.new("UICorner", wsBox).CornerRadius = UDim.new(0,8)

-- Infinite Jump Toggle
local infJumpBtn = Instance.new("TextButton", tabFrames["Movement"])
infJumpBtn.Size = UDim2.new(0.9, 0, 0, 35)
infJumpBtn.Position = UDim2.new(0.05, 0, 0, 50)
infJumpBtn.Text = "Infinite Jump: OFF"
infJumpBtn.Font = Enum.Font.GothamBold
infJumpBtn.TextSize = 18
infJumpBtn.TextColor3 = Color3.new(1,1,1)
infJumpBtn.BackgroundColor3 = Color3.fromRGB(60,180,90)
Instance.new("UICorner", infJumpBtn).CornerRadius = UDim.new(0,8)

local infJumpEnabled = false
infJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    infJumpBtn.Text = infJumpEnabled and "Infinite Jump: ON" or "Infinite Jump: OFF"
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Apply WalkSpeed button
local applyWsBtn = Instance.new("TextButton", tabFrames["Movement"])
applyWsBtn.Size = UDim2.new(0.9, 0, 0, 35)
applyWsBtn.Position = UDim2.new(0.05, 0, 0, 95)
applyWsBtn.Text = "Apply WalkSpeed"
applyWsBtn.Font = Enum.Font.GothamBold
applyWsBtn.TextSize = 18
applyWsBtn.TextColor3 = Color3.new(1,1,1)
applyWsBtn.BackgroundColor3 = Color3.fromRGB(50,150,250)
Instance.new("UICorner", applyWsBtn).CornerRadius = UDim.new(0,8)

applyWsBtn.MouseButton1Click:Connect(function()
    local ws = tonumber(wsBox.Text)
    if ws and ws >= 16 and humanoid then
        humanoid.WalkSpeed = ws
    else
        warn("WalkSpeed must be at least 16")
    end
end)

-- === ESP Tab ===
local espEnabled = false
local espBoxes = {}

local function createEspBox(part)
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = part
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 6, 1)
    box.Color3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    box.Transparency = 0.5
    box.Parent = part
    return box
end

local function clearEsp()
    for _, box in pairs(espBoxes) do
        box:Destroy()
    end
    espBoxes = {}
end

local function updateEsp()
    if not espEnabled then
        clearEsp()
        return
    end
    
    clearEsp()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local box = createEspBox(hrp)
            table.insert(espBoxes, box)
        end
    end
end

RunService.RenderStepped:Connect(updateEsp)

local espToggle = Instance.new("TextButton", tabFrames["ESP"])
espToggle.Size = UDim2.new(0.9, 0, 0, 50)
espToggle.Position = UDim2.new(0.05, 0, 0, 20)
espToggle.Text = "ESP: OFF"
espToggle.Font = Enum.Font.GothamBold
espToggle.TextSize = 22
espToggle.TextColor3 = Color3.new(1,1,1)
espToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Instance.new("UICorner", espToggle).CornerRadius = UDim.new(0, 12)

espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    espToggle.BackgroundColor3 = espEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

-- === Misc Tab ===
-- Simple fly toggle example (hover fly)
local flying = false
local flySpeed = 50
local bodyVelocity

local flyToggle = Instance.new("TextButton", tabFrames["Misc"])
flyToggle.Size = UDim2.new(0.9, 0, 0, 50)
flyToggle.Position = UDim2.new(0.05, 0, 0, 20)
flyToggle.Text = "Fly: OFF"
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 22
flyToggle.TextColor3 = Color3.new(1,1,1)
flyToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
Instance.new("UICorner", flyToggle).CornerRadius = UDim.new(0, 12)

flyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    flyToggle.Text = flying and "Fly: ON" or "Fly: OFF"
    if flying then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.Parent = hrp

            RunService:BindToRenderStep("Fly", 301, function()
                local moveDir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector end
                moveDir = Vector3.new(moveDir.X, 0, moveDir.Z).Unit * flySpeed
                if moveDir ~= Vector3.new() then
                    bodyVelocity.Velocity = Vector3.new(moveDir.X, 0, moveDir.Z)
                else
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        RunService:UnbindFromRenderStep("Fly")
    end
end)
