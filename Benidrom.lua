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
local picnicTargetPos = Vector3.new(933.32, 69.43, 24.97)
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

-- Ukuran responsif untuk isi konten bodi script
local FULL_H = 210
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

-- Header Title
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

local tGrad = Instance.new("UIGradient")
tGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 205)),
    ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 205)),
})
tGrad.Parent = title

-- Status Subtitle
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

-- Tombol Sembunyikan (Minimize Button)
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

local minScale = Instance.new("UIScale")
minScale.Scale = 1
minScale.Parent = minBtn

minBtn.MouseEnter:Connect(function()
    tweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundColor3 = MIN_HOVER}):Play()
end)
minBtn.MouseLeave:Connect(function()
    tweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundColor3 = MIN_NORMAL}):Play()
end)
minBtn.MouseButton1Down:Connect(function()
    tweenService:Create(minBtn, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(15, 15, 18)}):Play()
    tweenService:Create(minScale, TweenInfo.new(0.07, Enum.EasingStyle.Linear), {Scale = 0.93}):Play()
    task.delay(0.07, function()
        tweenService:Create(minBtn, TweenInfo.new(0.18), {BackgroundColor3 = MIN_NORMAL}):Play()
        tweenService:Create(minScale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end)
end)
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
        Size = minimized and UDim2.new(0, 290, 0, MINI_H) or UDim2.new(0, 290, 0, FULL_H)
    }):Play()
    minBtn.Text = minimized and "+" or "-"
end)

----------------------------------------------------------------
-- FUNGSI CUSTOM UNTUK MENIRU ANIMASI TOMBOL BAWAN
----------------------------------------------------------------
local function applyCustomButtonEffects(button)
    local scale = Instance.new("UIScale", button)
    button.MouseEnter:Connect(function()
        tweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = MIN_HOVER}):Play()
    end)
    button.MouseLeave:Connect(function()
        tweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = MIN_NORMAL}):Play()
    end)
    button.MouseButton1Down:Connect(function()
        tweenService:Create(button, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(15, 15, 18)}):Play()
        tweenService:Create(scale, TweenInfo.new(0.07, Enum.EasingStyle.Linear), {Scale = 0.95}):Play()
        task.delay(0.07, function()
            tweenService:Create(button, TweenInfo.new(0.18), {BackgroundColor3 = MIN_NORMAL}):Play()
            tweenService:Create(scale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end)
    end)
end

----------------------------------------------------------------
-- PEMBUATAN 3 TOMBOL FITUR UTAMA
----------------------------------------------------------------
-- 1. Tombol Loadstring
local btnLoadstring = Instance.new("TextButton")
btnLoadstring.Size = UDim2.new(1, -24, 0, 36)
btnLoadstring.Position = UDim2.new(0, 12, 0, 52)
btnLoadstring.BackgroundColor3 = MIN_NORMAL
btnLoadstring.Text = "AUTO TYCOON (EGI)"
btnLoadstring.TextColor3 = Color3.new(1, 1, 1)
btnLoadstring.Font = Enum.Font.GothamBold
btnLoadstring.TextSize = 10.5
btnLoadstring.BorderSizePixel = 0
btnLoadstring.AutoButtonColor = false
btnLoadstring.Parent = main
Instance.new("UICorner", btnLoadstring).CornerRadius = UDim.new(0, 6)
animStroke(btnLoadstring, 1)
applyCustomButtonEffects(btnLoadstring)

-- 2. Tombol Amigos
local btnAmigos = Instance.new("TextButton")
btnAmigos.Size = UDim2.new(1, -24, 0, 36)
btnAmigos.Position = UDim2.new(0, 12, 0, 100)
btnAmigos.BackgroundColor3 = MIN_NORMAL
btnAmigos.Text = "FIND FRIEND"
btnAmigos.TextColor3 = Color3.new(1, 1, 1)
btnAmigos.Font = Enum.Font.GothamBold
btnAmigos.TextSize = 10.5
btnAmigos.BorderSizePixel = 0
btnAmigos.AutoButtonColor = false
btnAmigos.Parent = main
Instance.new("UICorner", btnAmigos).CornerRadius = UDim.new(0, 6)
animStroke(btnAmigos, 1)
applyCustomButtonEffects(btnAmigos)

-- 3. Tombol Picnic
local btnPicnic = Instance.new("TextButton")
btnPicnic.Size = UDim2.new(1, -24, 0, 36)
btnPicnic.Position = UDim2.new(0, 12, 0, 148)
btnPicnic.BackgroundColor3 = MIN_NORMAL
btnPicnic.Text = "TO PICNIC"
btnPicnic.TextColor3 = Color3.new(1, 1, 1)
btnPicnic.Font = Enum.Font.GothamBold
btnPicnic.TextSize = 10.5
btnPicnic.BorderSizePixel = 0
btnPicnic.AutoButtonColor = false
btnPicnic.Parent = main
Instance.new("UICorner", btnPicnic).CornerRadius = UDim.new(0, 6)
animStroke(btnPicnic, 1)
applyCustomButtonEffects(btnPicnic)

----------------------------------------------------------------
-- SISTEM LOGIKA SCRIPT (SEKALI JALAN)
----------------------------------------------------------------
local function getClosestPrompt(position)
    local closestPrompt = nil
    local shortestDistance = math.huge
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled then
            local parentPart = v.Parent
            if parentPart and parentPart:IsA("BasePart") then
                local distance = (parentPart.Position - position).Magnitude
                if distance < shortestDistance and distance < 15 then
                    shortestDistance = distance
                    closestPrompt = v
                end
            end
        end
    end
    return closestPrompt
end

local function executeAmigos()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    if not humanoidRootPart then return end
    
    local questFolder = workspace:FindFirstChild("QuestSemanal6")
    local targetFolder = questFolder and questFolder:FindFirstChild("PosicionesAmigos")
    
    if not targetFolder then
        statusLabel.Text = "Status: Folder Amigos tak ada!"
        return
    end
    
    local targets = {}
    for _, object in ipairs(targetFolder:GetChildren()) do
        if object.Name == "Friend" then
            local prompt = object:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt and prompt.Enabled then
                table.insert(targets, {object = object, prompt = prompt})
            end
        end
    end
    
    if #targets == 0 then
        statusLabel.Text = "Status: Tidak ada Amigos ditemukan!"
        return
    end
    
    for _, targetData in ipairs(targets) do
        local object = targetData.object
        local prompt = targetData.prompt
        
        if prompt and prompt.Parent and prompt.Enabled then
            statusLabel.Text = "Status: Amigos -> " .. object.Name
            
            if object:IsA("Model") and object.PrimaryPart then
                humanoidRootPart.CFrame = object.PrimaryPart.CFrame * CFrame.new(0, 2, -2)
            else
                local parentPart = prompt.Parent or object
                if parentPart:IsA("BasePart") then
                    humanoidRootPart.CFrame = parentPart.CFrame * CFrame.new(0, 2, -2)
                end
            end
            
            task.wait(0.3)
            if fireproximityprompt then fireproximityprompt(prompt) else prompt:InputBegan(localPlayer) end
            task.wait(prompt.HoldTime + 0.2)
        end
    end
    statusLabel.Text = "Status: Amigos Selesai!"
end

local function executePicnic()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    if not humanoidRootPart then return end
    
    statusLabel.Text = "Status: Teleporting Picnic..."
    humanoidRootPart.CFrame = CFrame.new(picnicTargetPos)
    task.wait(0.4)
    
    local prompt = getClosestPrompt(picnicTargetPos)
    if prompt then
        statusLabel.Text = "Status: Triggering Picnic..."
        if fireproximityprompt then fireproximityprompt(prompt) else prompt:InputBegan(localPlayer) end
        task.wait(prompt.HoldTime + 0.1)
        statusLabel.Text = "Status: Picnic Selesai!"
    else
        statusLabel.Text = "Status: Prompt Picnic tak ketemu!"
    end
end

----------------------------------------------------------------
-- TRIGGER EVENT TOMBOL
----------------------------------------------------------------
btnLoadstring.MouseButton1Click:Connect(function()
    statusLabel.Text = "Status: Loading External Script..."
    local successRun, _ = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/starSoon1/FeinDownTycoon/refs/heads/main/Fein%20Down%20Tycoon.txt"))()
    end)
    statusLabel.Text = successRun and "Status: Script Loaded!" or "Status: Load Failed!"
end)

btnAmigos.MouseButton1Click:Connect(function()
    task.spawn(executeAmigos)
end)

btnPicnic.MouseButton1Click:Connect(function()
    task.spawn(executePicnic)
end)

-- Sistem Drag & Rotasi Animasi Garis Batas (Bawaan Template)
do
    local dragging, dragStart, startPos = false, nil, nil
    main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local abs = main.AbsolutePosition
            main.Position = UDim2.new(0, abs.X, 0, abs.Y)
            dragging = true
            dragStart = i.Position
            startPos = main.Position
        end
    end)
    
    userInputService.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            local d = i.Position - dragStart
            local vp = workspace.CurrentCamera.ViewportSize
            local gs = main.AbsoluteSize
            main.Position = UDim2.new(
                0,
                math.clamp(startPos.X.Offset + d.X, 0, vp.X - gs.X),
                0,
                math.clamp(startPos.Y.Offset + d.Y, 0, vp.Y - gs.Y)
            )
        end
    end)
    
    userInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

runService.RenderStepped:Connect(function()
    local off = Vector2.new(math.sin(tick() * 2.8), 0)
    for _, g in ipairs(allGrads) do
        g.Offset = off
    end
end)
