local coreGui = cloneref(game:GetService("CoreGui"))
local userInputService = cloneref(game:GetService("UserInputService"))
local runService = cloneref(game:GetService("RunService"))
local tweenService = cloneref(game:GetService("TweenService"))
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

-- Hapus UI lama jika duplikat
if coreGui:FindFirstChild("AceSniperUI") then
    coreGui.AceSniperUI:Destroy()
end

-- Konfigurasi Koordinat & Desain
local COL_BG = Color3.fromRGB(18, 18, 20)
local MIN_NORMAL = Color3.fromRGB(40, 40, 45)
local MIN_HOVER = Color3.fromRGB(25, 25, 28)

local STROKE_CS = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 35)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(140, 145, 150)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(240, 240, 245)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(240, 240, 245)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(140, 145, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 35)),
})

local allGrads = {}

local function animStroke(parent, thick)
    local s = Instance.new("UIStroke")
    s.Thickness = thick or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Color = Color3.new(1, 1, 1)
    s.Parent = parent
    local g = Instance.new("UIGradient")
    g.Color = STROKE_CS
    g.Rotation = 45
    g.Parent = s
    table.insert(allGrads, g)
    return s
end

-- Setup Base ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "AceSniperUI"
gui.ResetOnSpawn = false
gui.Parent = coreGui

-- Ukuran responsif
local FULL_H = 250 -- Diperbesar agar muat 4 tombol
local MINI_H = 42

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 290, 0, FULL_H)
main.Position = UDim2.new(0.5, -145, 0.4, -FULL_H // 2)
main.BackgroundColor3 = COL_BG
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
animStroke(main, 1.5)

-- Header
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 16)
title.Position = UDim2.new(0, 12, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Benidorm Fun Town Tycoon"
title.Font = Enum.Font.GothamBlack
title.TextSize = 11.5
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 10)
statusLabel.Position = UDim2.new(0, 12, 0, 22)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 8.5
statusLabel.TextColor3 = Color3.fromRGB(140, 140, 145)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = main

-- Minimize Button
local minimized = false
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(1, -30, 0, 8)
minBtn.BackgroundColor3 = MIN_NORMAL
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 13
minBtn.BorderSizePixel = 0
minBtn.AutoButtonColor = false
minBtn.Parent = main
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)
animStroke(minBtn, 1)

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
        Size = minimized and UDim2.new(0, 290, 0, MINI_H) or UDim2.new(0, 290, 0, FULL_H)
    }):Play()
    minBtn.Text = minimized and "+" or "-"
end)

local function applyCustomButtonEffects(button)
    local scale = Instance.new("UIScale", button)
    button.MouseEnter:Connect(function() tweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = MIN_HOVER}):Play() end)
    button.MouseLeave:Connect(function() tweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = MIN_NORMAL}):Play() end)
    button.MouseButton1Down:Connect(function()
        tweenService:Create(button, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(15, 15, 18)}):Play()
        tweenService:Create(scale, TweenInfo.new(0.07), {Scale = 0.95}):Play()
        task.wait(0.07)
        tweenService:Create(button, TweenInfo.new(0.18), {BackgroundColor3 = MIN_NORMAL}):Play()
        tweenService:Create(scale, TweenInfo.new(0.28, Enum.EasingStyle.Back), {Scale = 1}):Play()
    end)
end

-- Fungsi Pembuat Tombol
local function createBtn(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -24, 0, 36)
    btn.Position = UDim2.new(0, 12, 0, pos)
    btn.BackgroundColor3 = MIN_NORMAL
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10.5
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    animStroke(btn, 1)
    applyCustomButtonEffects(btn)
    btn.MouseButton1Click:Connect(callback)
end

-- Implementasi Tombol
createBtn("AUTO TYCOON (EGI)", 52, function()
    statusLabel.Text = "Status: Loading..."
    local s, _ = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/starSoon1/FeinDownTycoon/refs/heads/main/Fein%20Down%20Tycoon.txt"))() end)
    statusLabel.Text = s and "Status: Loaded!" or "Status: Failed!"
end)

createBtn("LOKASI MISI (HARIAN)", 100, function()
    local target = workspace:FindFirstChild("QuestBeamTarget")
    if target and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        localPlayer.Character.HumanoidRootPart.CFrame = target:IsA("BasePart") and target.CFrame or (target.PrimaryPart and target.PrimaryPart.CFrame or target:FindFirstChildWhichIsA("BasePart", true).CFrame)
        statusLabel.Text = "Status: Teleported!"
    end
end)

createBtn("PUNGUT SAMPAH", 148, function()
    local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(723.19, 5.27, -214.24)
        task.wait(0.5)
        local folder = workspace:FindFirstChild("QuestSemanal1") and workspace.QuestSemanal1:FindFirstChild("Basura")
        if folder then
            for i = 1, 11 do
                local p = folder:FindFirstChild("PilaBasura_" .. i)
                local prompt = p and p:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then fireproximityprompt(prompt) end
            end
            statusLabel.Text = "Status: Done!"
        end
    end
end)

createBtn("KE LAUT", 196, function()
    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(721.95, 87.73, 671.78)
        statusLabel.Text = "Status: Di Laut!"
    end
end)

-- Dragging Logic
local dragging, dragStart, startPos = false, nil, nil
main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = main.Position end end)
userInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - dragStart main.Position = UDim2.new(0, startPos.X.Offset + d.X, 0, startPos.Y.Offset + d.Y) end end)
userInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

runService.RenderStepped:Connect(function()
    local off = Vector2.new(math.sin(tick() * 2.8), 0)
    for _, g in ipairs(allGrads) do g.Offset = off end
end)
