local coreGui = cloneref(game:GetService("CoreGui"))
local userInputService = cloneref(game:GetService("UserInputService"))
local tweenService = cloneref(game:GetService("TweenService"))
local Players = game:GetService("Players")

-- Hapus UI lama jika ada
if coreGui:FindFirstChild("AceSniperUI") then
    coreGui.AceSniperUI:Destroy()
end

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

-- Fungsi Animasi Stroke Smooth & Hemat Performa
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
    
    task.spawn(function()
        while s and s.Parent do
            g.Offset = Vector2.new(-1, 0)
            local t = tweenService:Create(g, TweenInfo.new(3, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)})
            t:Play()
            t.Completed:Wait()
        end
    end)
    return s
end

-- Setup ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "AceSniperUI"
gui.ResetOnSpawn = false
gui.Parent = coreGui

local FULL_H = 210
local MINI_H = 42

-- Main Frame
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

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 16)
title.Position = UDim2.new(0, 12, 0, 8)
title.BackgroundTransparency = 1
title.Text = "GUIBY: MONSTERS VS BABIES"
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

-- Description
local desc = Instance.new("TextLabel")
desc.Size = UDim2.new(1, -40, 0, 10)
desc.Position = UDim2.new(0, 12, 0, 22)
desc.BackgroundTransparency = 1
desc.Text = "Made By Virgoboy"
desc.Font = Enum.Font.GothamMedium
desc.TextSize = 8.5
desc.TextColor3 = Color3.fromRGB(110, 110, 115)
desc.TextXAlignment = Enum.TextXAlignment.Left
desc.Parent = main

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
    local tween = tweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
        Size = minimized and UDim2.new(0, 290, 0, MINI_H) or UDim2.new(0, 290, 0, FULL_H)
    })
    tween:Play()
    minBtn.Text = minimized and "+" or "-"
end)

---------------------------------------------------------
-- FITUR INSTANT KILL V2 (SISTEM LOOPING ULTRA FAST) + TIMER
---------------------------------------------------------
local isToggled = false
local killStartTime = 0

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -24, 0, 30)
toggleBtn.Position = UDim2.new(0, 12, 0, 42)
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
toggleBtn.Text = "Instant Kill: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.BorderSizePixel = 0
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = main
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)
animStroke(toggleBtn, 1)

local function getEnemiesFolder()
    local alives = workspace:WaitForChild("Alives", 5)
    return alives and alives:WaitForChild("Enemies", 5) or nil
end

-- Eksekusi pembunuhan instan tanpa penundaan internal
local function killEnemy(enemy)
    local humanoid = enemy:FindFirstChildOfClass("Humanoid")
    local rootPart = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso") or enemy:FindFirstChild("UpperTorso")
    
    -- Metode 1: Hancurkan Neck joint (Instan mati secara struktural)
    local head = enemy:FindFirstChild("Head")
    if head then
        local neck = head:FindFirstChild("Neck") or head:FindFirstChildOfClass("Motor6D") or head:FindFirstChildOfClass("Weld")
        if neck then 
            neck:Destroy() 
        end
    end
    
    -- Metode 2: Set Health ke 0
    if humanoid and humanoid.Health > 0 then
        humanoid.Health = 0
    end
    
    -- Metode 3: Teleport part ke Void jika server lambat memperbarui status mati
    if rootPart and rootPart:IsA("BasePart") then
        rootPart.CFrame = CFrame.new(0, -99999, 0)
    end
end

-- Thread Loop Utama yang berjalan di background
task.spawn(function()
    while true do
        task.wait(0.01) -- Loop berjalan sangat cepat setiap 10 milidetik
        if isToggled then
            local enemiesFolder = getEnemiesFolder()
            if enemiesFolder then
                local enemies = enemiesFolder:GetChildren()
                for i = 1, #enemies do
                    local enemy = enemies[i]
                    -- Hanya eksekusi jika musuh valid dan belum mati
                    local hum = enemy:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        killEnemy(enemy)
                    elseif not hum then
                        -- Jaga-jaga jika humanoid belum termuat sepenuhnya
                        killEnemy(enemy)
                    end
                end
            end
        end
    end
end)

-- Thread Pengelola Timer Real-time
task.spawn(function()
    while true do
        task.wait(1)
        if isToggled then
            local elapsed = math.floor(os.clock() - killStartTime)
            local minutes = math.floor(elapsed / 60)
            local seconds = elapsed % 60
            toggleBtn.Text = string.format("Efek ON dalam 1 menit (%02d:%02d)", minutes, seconds)
        end
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    isToggled = not isToggled
    if isToggled then
        killStartTime = os.clock() -- Catat waktu mulai aktif
        tweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 60, 45)}):Play()
        toggleBtn.Text = "Efek ON dalam 1 menit (00:00)"
        toggleBtn.TextColor3 = Color3.fromRGB(80, 220, 120)
    else
        tweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        toggleBtn.Text = "Instant Kill: OFF"
        toggleBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
    end
end)

---------------------------------------------------------
-- FITUR AUTO OPEN CHEST
---------------------------------------------------------
local isChestToggled = false
local chestBtn = Instance.new("TextButton")
chestBtn.Size = UDim2.new(1, -24, 0, 30)
chestBtn.Position = UDim2.new(0, 12, 0, 78)
chestBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
chestBtn.Text = "Auto Open Chest: OFF"
chestBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
chestBtn.Font = Enum.Font.GothamBold
chestBtn.TextSize = 12
chestBtn.BorderSizePixel = 0
chestBtn.AutoButtonColor = false
chestBtn.Parent = main
Instance.new("UICorner", chestBtn).CornerRadius = UDim.new(0, 6)
animStroke(chestBtn, 1)

local function firePrompt(prompt)
    if prompt and prompt:IsA("ProximityPrompt") then
        local oldDuration = prompt.HoldDuration
        prompt.HoldDuration = 0
        prompt:InputHoldBegin()
        task.wait(0.05)
        prompt:InputHoldEnd()
        prompt.HoldDuration = oldDuration
    end
end

local function scanAndOpenChests()
    local LocalPlayer = Players.LocalPlayer
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    local dungeonsFolder = workspace:FindFirstChild("Dungeons")
    
    if not hrp or not dungeonsFolder then return end
    
    for _, obj in ipairs(dungeonsFolder:GetDescendants()) do
        if not isChestToggled then break end
        if obj.Name == "BossChest" then
            local targetCFrame = nil
            if obj:IsA("BasePart") then
                targetCFrame = obj.CFrame
            elseif obj:IsA("Model") then
                if obj.PrimaryPart then
                    targetCFrame = obj.PrimaryPart.CFrame
                else
                    targetCFrame = obj:GetPivot()
                end
            end
            
            if targetCFrame then
                hrp.CFrame = targetCFrame + Vector3.new(0, 2, 0)
                task.wait(0.15)
                
                local promptFound = false
                for _, child in ipairs(obj:GetDescendants()) do
                    if child:IsA("ProximityPrompt") then
                        firePrompt(child)
                        promptFound = true
                    end
                end
                
                if not promptFound then
                    local directPrompt = obj:FindFirstChildOfClass("ProximityPrompt")
                    if directPrompt then
                        firePrompt(directPrompt)
                    end
                end
                task.wait(0.3)
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        if isChestToggled then
            pcall(scanAndOpenChests)
        end
    end
end)

chestBtn.MouseButton1Click:Connect(function()
    isChestToggled = not isChestToggled
    if isChestToggled then
        tweenService:Create(chestBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 60, 45)}):Play()
        chestBtn.Text = "Auto Open Chest: ON"
        chestBtn.TextColor3 = Color3.fromRGB(80, 220, 120)
    else
        tweenService:Create(chestBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        chestBtn.Text = "Auto Open Chest: OFF"
        chestBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
    end
end)

---------------------------------------------------------
-- FITUR WALKSPEED SLIDER
---------------------------------------------------------
local targetWalkSpeed = 16

local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(1, -24, 0, 14)
wsLabel.Position = UDim2.new(0, 12, 0, 116)
wsLabel.BackgroundTransparency = 1
wsLabel.Text = "WalkSpeed: 16"
wsLabel.Font = Enum.Font.GothamBold
wsLabel.TextSize = 10.5
wsLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Parent = main

local sliderMain = Instance.new("Frame")
sliderMain.Size = UDim2.new(1, -24, 0, 6)
sliderMain.Position = UDim2.new(0, 12, 0, 136)
sliderMain.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
sliderMain.BorderSizePixel = 0
sliderMain.Parent = main
Instance.new("UICorner", sliderMain).CornerRadius = UDim.new(0, 3)
animStroke(sliderMain, 1)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(140, 145, 150)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderMain
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 3)

local sliderBtn = Instance.new("TextButton")
sliderBtn.Size = UDim2.new(0, 12, 0, 12)
sliderBtn.AnchorPoint = Vector2.new(0.5, 0.5)
sliderBtn.Position = UDim2.new(0, 0, 0.5, 0)
sliderBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
sliderBtn.Text = ""
sliderBtn.BorderSizePixel = 0
sliderBtn.Parent = sliderMain
Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)

local minWS, maxWS = 16, 150
local function updateSlider(input)
    local absPos = sliderMain.AbsolutePosition.X
    local absSize = sliderMain.AbsoluteSize.X
    local clampedX = math.clamp(input.Position.X - absPos, 0, absSize)
    local percentage = clampedX / absSize
    
    targetWalkSpeed = math.round(minWS + (percentage * (maxWS - minWS)))
    wsLabel.Text = "WalkSpeed: " .. tostring(targetWalkSpeed)
    
    sliderBtn.Position = UDim2.new(percentage, 0, 0.5, 0)
    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
end

local sliderActive = false
sliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderActive = true
    end
end)

userInputService.InputChanged:Connect(function(input)
    if sliderActive and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input)
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderActive = false
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        local lp = Players.LocalPlayer
        local char = lp and lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            if targetWalkSpeed > 16 and hum.WalkSpeed ~= targetWalkSpeed then
                hum.WalkSpeed = targetWalkSpeed
            end
        end
    end
end)

---------------------------------------------------------
-- FITUR TELEPORT TO ENEMY (TOGGLE SYSTEM)
---------------------------------------------------------
local isTpEnemyToggled = false

local tpEnemyBtn = Instance.new("TextButton")
tpEnemyBtn.Size = UDim2.new(1, -24, 0, 30)
tpEnemyBtn.Position = UDim2.new(0, 12, 0, 168)
tpEnemyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
tpEnemyBtn.Text = "TP to Enemy: OFF"
tpEnemyBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
tpEnemyBtn.Font = Enum.Font.GothamBold
tpEnemyBtn.TextSize = 12
tpEnemyBtn.BorderSizePixel = 0
tpEnemyBtn.AutoButtonColor = false
tpEnemyBtn.Parent = main
Instance.new("UICorner", tpEnemyBtn).CornerRadius = UDim.new(0, 6)
animStroke(tpEnemyBtn, 1)

local function teleportToNearestEnemy()
    local lp = Players.LocalPlayer
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local enemiesFolder = getEnemiesFolder()
    if not enemiesFolder then return end
    
    local nearestEnemy = nil
    local shortestDistance = math.huge
    
    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        local eRoot = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso") or enemy:FindFirstChild("UpperTorso")
        local eHum = enemy:FindFirstChildOfClass("Humanoid")
        
        if eRoot and eHum and eHum.Health > 0 then
            local distance = (hrp.Position - eRoot.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestEnemy = eRoot
            end
        end
    end
    
    if nearestEnemy then
        hrp.CFrame = nearestEnemy.CFrame * CFrame.new(0, 3, 0)
    end
end

-- Thread Loop untuk Auto Teleport saat Toggle ON
task.spawn(function()
    while true do
        task.wait(0.2) -- Loop deteksi jarak musuh terdekat setiap 200ms agar smooth & aman
        if isTpEnemyToggled then
            pcall(teleportToNearestEnemy)
        end
    end
end)

tpEnemyBtn.MouseButton1Click:Connect(function()
    isTpEnemyToggled = not isTpEnemyToggled
    if isTpEnemyToggled then
        tweenService:Create(tpEnemyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 60, 45)}):Play()
        tpEnemyBtn.Text = "TP to Enemy: ON"
        tpEnemyBtn.TextColor3 = Color3.fromRGB(80, 220, 120)
    else
        tweenService:Create(tpEnemyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        tpEnemyBtn.Text = "TP to Enemy: OFF"
        tpEnemyBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
    end
end)

---------------------------------------------------------
-- SYSTEM DRAG GUI
---------------------------------------------------------
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
