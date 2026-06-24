local coreGui = cloneref(game:GetService("CoreGui"))
local userInputService = cloneref(game:GetService("UserInputService"))
local runService = cloneref(game:GetService("RunService"))
local tweenService = cloneref(game:GetService("TweenService"))
local teleportService = game:GetService("TeleportService")
local httpService = game:GetService("HttpService")
local Players = game:GetService("Players")

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

local gui = Instance.new("ScreenGui")
gui.Name = "AceSniperUI"
gui.ResetOnSpawn = false
gui.Parent = coreGui

local FULL_H = 290
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

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 16)
title.Position = UDim2.new(0, 12, 0, 8)
title.BackgroundTransparency = 1
title.Text = "FIND SUMMER SEASOULS"
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

local desc = Instance.new("TextLabel")
desc.Size = UDim2.new(1, -40, 0, 10)
desc.Position = UDim2.new(0, 12, 0, 22)
desc.BackgroundTransparency = 1
desc.Text = "Made by Virgoboy"
desc.Font = Enum.Font.GothamMedium
desc.TextSize = 8.5
desc.TextColor3 = Color3.fromRGB(110, 110, 115)
desc.TextXAlignment = Enum.TextXAlignment.Left
desc.Parent = main

----------------------------------------------------
-- VARIABLE GLOBAL & LOGIKA COUNTER
----------------------------------------------------
local isToggled = false
local isShellToggled = false
local seasoulsDitemukan = 0
local TARGET_FOLDER = workspace:WaitForChild("Seasouls")
local KEYWORD = "summer"
local DELAY_TIME = 2

local player = Players.LocalPlayer
local queueShell = {}
local idxShell = 1

local minRange = 1
local maxRange = 10

local function shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

local function hitungMaxSeasouls()
    local total = 0
    local success, err = pcall(function()
        for _, object in ipairs(TARGET_FOLDER:GetChildren()) do
            if string.find(string.lower(object.Name), string.lower(KEYWORD)) then
                total = total + 1
            end
        end
    end)
    return total
end

----------------------------------------------------
-- KOMPONEN INPUT MANUAL (MIN & MAX INDEX)
----------------------------------------------------
local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(1, -24, 0, 32)
inputContainer.Position = UDim2.new(0, 12, 0, 44)
inputContainer.BackgroundTransparency = 1
inputContainer.Parent = main

local minInput = Instance.new("TextBox")
minInput.Size = UDim2.new(0.5, -6, 1, 0)
minInput.Position = UDim2.new(0, 0, 0, 0)
minInput.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
minInput.Text = "1"
minInput.PlaceholderText = "Min Item"
minInput.TextColor3 = Color3.new(1, 1, 1)
minInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 105)
minInput.Font = Enum.Font.GothamBold
minInput.TextSize = 11
minInput.ClearTextOnFocus = false
minInput.Parent = inputContainer
Instance.new("UICorner", minInput).CornerRadius = UDim.new(0, 6)
animStroke(minInput, 1)

local maxInput = Instance.new("TextBox")
maxInput.Size = UDim2.new(0.5, -6, 1, 0)
maxInput.Position = UDim2.new(0.5, 6, 0, 0)
maxInput.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
maxInput.Text = "10"
maxInput.PlaceholderText = "Max Item"
maxInput.TextColor3 = Color3.new(1, 1, 1)
maxInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 105)
maxInput.Font = Enum.Font.GothamBold
maxInput.TextSize = 11
maxInput.ClearTextOnFocus = false
maxInput.Parent = inputContainer
Instance.new("UICorner", maxInput).CornerRadius = UDim.new(0, 6)
animStroke(maxInput, 1)

local toggleBtn = Instance.new("TextButton")
local shellBtn = Instance.new("TextButton")

local function updateRanges()
    local cleanMin = string.gsub(minInput.Text, "%D", "")
    local cleanMax = string.gsub(maxInput.Text, "%D", "")
    minRange = tonumber(cleanMin) or 1
    maxRange = tonumber(cleanMax) or 999
    if minRange < 1 then minRange = 1 end
    if maxRange < minRange then maxRange = minRange end
end
minInput:GetPropertyChangedSignal("Text"):Connect(updateRanges)
maxInput:GetPropertyChangedSignal("Text"):Connect(updateRanges)
minInput.FocusLost:Connect(updateRanges)
maxInput.FocusLost:Connect(updateRanges)
updateRanges()

----------------------------------------------------
-- KOMPONEN TOGGLE & BUTTONS
----------------------------------------------------
toggleBtn.Size = UDim2.new(1, -24, 0, 34)
toggleBtn.Position = UDim2.new(0, 12, 0, 86)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
toggleBtn.Text = "AUTO SEASOULS: OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 11
toggleBtn.BorderSizePixel = 0
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = main

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)
animStroke(toggleBtn, 1)

local toggleScale = Instance.new("UIScale")
toggleScale.Scale = 1
toggleScale.Parent = toggleBtn

shellBtn.Size = UDim2.new(1, -24, 0, 34)
shellBtn.Position = UDim2.new(0, 12, 0, 126)
shellBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
shellBtn.Text = "AUTO KERANG: OFF"
shellBtn.TextColor3 = Color3.new(1, 1, 1)
shellBtn.Font = Enum.Font.GothamBold
shellBtn.TextSize = 11
shellBtn.BorderSizePixel = 0
shellBtn.AutoButtonColor = false
shellBtn.Parent = main

Instance.new("UICorner", shellBtn).CornerRadius = UDim.new(0, 6)
animStroke(shellBtn, 1)

local shellScale = Instance.new("UIScale")
shellScale.Scale = 1
shellScale.Parent = shellBtn

local serverBtn = Instance.new("TextButton")
serverBtn.Size = UDim2.new(1, -24, 0, 34)
serverBtn.Position = UDim2.new(0, 12, 0, 166)
serverBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
serverBtn.Text = "FIND LOW SERVER"
serverBtn.TextColor3 = Color3.new(1, 1, 1)
serverBtn.Font = Enum.Font.GothamBold
serverBtn.TextSize = 11
serverBtn.BorderSizePixel = 0
serverBtn.AutoButtonColor = false
serverBtn.Parent = main

Instance.new("UICorner", serverBtn).CornerRadius = UDim.new(0, 6)
animStroke(serverBtn, 1)

local serverScale = Instance.new("UIScale")
serverScale.Scale = 1
serverScale.Parent = serverBtn

local counterLabel = Instance.new("TextLabel")
counterLabel.Size = UDim2.new(1, -24, 0, 30)
counterLabel.Position = UDim2.new(0, 12, 0, 206)
counterLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
counterLabel.Text = "Seasouls Diambil: 0 / " .. hitungMaxSeasouls()
counterLabel.Font = Enum.Font.GothamBold
counterLabel.TextSize = 11
counterLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
counterLabel.Parent = main

Instance.new("UICorner", counterLabel).CornerRadius = UDim.new(0, 6)
animStroke(counterLabel, 1)

task.spawn(function()
    while true do
        counterLabel.Text = "Seasouls Diambil: " .. seasoulsDitemukan .. " / " .. hitungMaxSeasouls()
        task.wait(1)
    end
end)

----------------------------------------------------
-- SCRIPT LOGIC DENGAN AUTO-STOP SETELAH MAX
----------------------------------------------------
local function matikanToggleSeasouls()
    isToggled = false
    tweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 50, 50)}):Play()
    toggleBtn.Text = "AUTO SEASOULS: OFF"
end

local function matikanToggleShell()
    isShellToggled = false
    tweenService:Create(shellBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 50, 50)}):Play()
    shellBtn.Text = "AUTO KERANG: OFF"
    queueShell = {}
    idxShell = 1
end

local function startTeleportLoop()
    while isToggled do
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart", 5)
        
        if rootPart and isToggled then
            local validSeasouls = {}
            for _, object in ipairs(TARGET_FOLDER:GetChildren()) do
                if string.find(string.lower(object.Name), string.lower(KEYWORD)) then
                    table.insert(validSeasouls, object)
                end
            end
            
            local targetMax = math.min(maxRange, #validSeasouls)
            
            if minRange > #validSeasouls or minRange > targetMax then
                matikanToggleSeasouls()
                break
            end
            
            for index = minRange, targetMax do
                if not isToggled then break end
                
                local object = validSeasouls[index]
                if object then
                    local targetCFrame = nil
                    if object:IsA("Model") then
                        targetCFrame = object.PrimaryPart and object.PrimaryPart.CFrame or object:GetPivot()
                    elseif object:IsA("BasePart") then
                        targetCFrame = object.CFrame
                    end
                    
                    if targetCFrame then
                        rootPart.CFrame = targetCFrame
                        seasoulsDitemukan = seasoulsDitemukan + 1
                        counterLabel.Text = "Seasouls Diambil: " .. seasoulsDitemukan .. " / " .. hitungMaxSeasouls()
                        task.wait(DELAY_TIME) 
                    end
                end
            end
            
            -- Jika semua target dalam jangkauan selesai, otomatis matikan perulangan
            matikanToggleSeasouls()
            break
        end
        task.wait(0.5)
    end
end

local function tpShell()
    local char = player.Character
    if not (char and char:FindFirstChild("HumanoidRootPart")) then return end
    
    if #queueShell == 0 or idxShell > #queueShell then
        queueShell = {}
        idxShell = 1
        local folder = workspace:FindFirstChild("ConchasSalvajes")
        if folder then
            local tempShells = {}
            for _, child in ipairs(folder:GetChildren()) do
                if string.find(child.Name, "Shell") and not string.find(child.Name, "TRAP_Shell") then
                    table.insert(tempShells, child)
                end
            end
            
            local targetMax = math.min(maxRange, #tempShells)
            if minRange > #tempShells or minRange > targetMax then
                matikanToggleShell()
                return
            end
            
            for index = minRange, targetMax do
                if tempShells[index] then
                    table.insert(queueShell, tempShells[index])
                end
            end
            shuffle(queueShell)
        else
            matikanToggleShell()
            return
        end
    end
    
    if #queueShell > 0 then
        local target = queueShell[idxShell]
        if target and (target:IsA("Model") or target:IsA("BasePart")) then
            char:PivotTo(target:GetPivot())
            idxShell = idxShell + 1
        else
            idxShell = idxShell + 1
        end
        
        -- Jika index antrean melampaui jumlah total antrean yang sudah difilter, stop otomatis
        if idxShell > #queueShell then
            task.wait(3) -- Tunggu TP terakhir selesai
            matikanToggleShell()
        end
    else
        matikanToggleShell()
    end
end

task.spawn(function()
    while true do
        if isShellToggled then
            tpShell()
        end
        task.wait(3)
    end
end)

-- Event Klik Buttons
toggleBtn.MouseButton1Click:Connect(function()
    isToggled = not isToggled
    tweenService:Create(toggleScale, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Scale = 0.95}):Play()
    task.delay(0.05, function()
        tweenService:Create(toggleScale, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end)
    
    if isToggled then
        tweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 150, 80)}):Play()
        toggleBtn.Text = "AUTO SEASOULS: ON"
        task.spawn(startTeleportLoop)
    else
        matikanToggleSeasouls()
    end
end)

shellBtn.MouseButton1Click:Connect(function()
    isShellToggled = not isShellToggled
    tweenService:Create(shellScale, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Scale = 0.95}):Play()
    task.delay(0.05, function()
        tweenService:Create(shellScale, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end)
    
    if isShellToggled then
        tweenService:Create(shellBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 150, 80)}):Play()
        shellBtn.Text = "AUTO KERANG: ON"
    else
        matikanToggleShell()
    end
end)

serverBtn.MouseButton1Click:Connect(function()
    tweenService:Create(serverScale, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Scale = 0.95}):Play()
    task.delay(0.05, function()
        tweenService:Create(serverScale, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end)
    
    serverBtn.Text = "SEARCHING SERVER..."
    pcall(function()
        local req = httpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, server in ipairs(req.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                serverBtn.Text = "TELEPORTING..."
                teleportService:TeleportToPlaceInstance(game.PlaceId, server.id, game.Players.LocalPlayer)
                break
            end
        end
    end)
    task.delay(3, function()
        if serverBtn.Text == "TELEPORTING..." then return end
        serverBtn.Text = "FIND LOW SERVER"
    end)
end)

----------------------------------------------------
-- SYSTEM GUI (MINIMIZE & DRAG)
----------------------------------------------------
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
