local coreGui = cloneref(game:GetService("CoreGui"))
local userInputService = cloneref(game:GetService("UserInputService"))
local runService = cloneref(game:GetService("RunService"))
local tweenService = cloneref(game:GetService("TweenService"))
local players = cloneref(game:GetService("Players"))

local localPlayer = players.LocalPlayer

if coreGui:FindFirstChild("VirgoboyHubUI") then
    coreGui.VirgoboyHubUI:Destroy()
end

-- ====================================================
--  DAFTAR MAP BARU
-- ====================================================
local listMap = {
    {
        Nama = "🕷 Guiby: Monster vs Bayi",
        Script = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/VirgoboyScript/VirgoboyHub/refs/heads/main/Guiby.lua"))()]]
    },
    {
        Nama = "👻 The Morgue Shift",
        Script = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/VirgoboyScript/VirgoboyHub/main/TMS_Wowo.lua"))()]]
    },
    {
        Nama = "🦁 BBC Wonder Chase",
        Script = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/VirgoboyScript/VirgoboyHub/main/WonderChase.lua"))()]]
    },
    {
        Nama = "🎲 Roll For UGC",
        Script = [[loadstring(game:HttpGet("https://pastebin.com/raw/Ny6T6dwp"))()]]
    },
    {
        Nama = "🏠 Benidorm Fun Town Tycoon",
        Script = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/VirgoboyScript/VirgoboyHub/refs/heads/main/Benidrom.lua"))()]]
    },
}
-- ====================================================

local COL_BG = Color3.fromRGB(15, 15, 18)
local COL_PANEL = Color3.fromRGB(22, 22, 26)
local MIN_NORMAL = Color3.fromRGB(35, 35, 40)
local MIN_HOVER = Color3.fromRGB(50, 50, 55)
local TEXT_MAIN = Color3.fromRGB(240, 240, 245)
local TEXT_SUB = Color3.fromRGB(140, 140, 145)

-- ====================================================
--  SISTEM TEMA WARNA DINAMIS
-- ====================================================
local ColorThemes = {
    ["Cyber Blue"] = {
        Accent = Color3.fromRGB(90, 100, 240),
        Sequence = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 45, 60)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(110, 120, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 45, 60)),
        })
    },
    ["Luxury Gold"] = {
        Accent = Color3.fromRGB(230, 175, 45),
        Sequence = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 50, 25)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 50, 25)),
        })
    },
    ["Neon Green"] = {
        Accent = Color3.fromRGB(50, 220, 110),
        Sequence = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 50, 30)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 130)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 50, 30)),
        })
    },
    ["Ruby Red"] = {
        Accent = Color3.fromRGB(240, 70, 70),
        Sequence = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 30, 30)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 90, 90)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 30, 30)),
        })
    }
}

local currentThemeName = "Cyber Blue"
local COL_ACCENT = ColorThemes[currentThemeName].Accent

local allGrads = {}
local allStrokes = {}
local themeObjectsToUpdate = {}

local function updateTheme(themeName)
    if not ColorThemes[themeName] then return end
    currentThemeName = themeName
    local themeData = ColorThemes[themeName]
    COL_ACCENT = themeData.Accent
    
    for _, g in ipairs(allGrads) do
        g.Color = themeData.Sequence
    end
    
    for obj, prop in pairs(themeObjectsToUpdate) do
        if obj and obj.Parent then
            obj[prop] = COL_ACCENT
        else
            themeObjectsToUpdate[obj] = nil
        end
    end
end

local function animStroke(parent, thick)
    local s = Instance.new("UIStroke")
    s.Thickness = thick or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Color = Color3.new(1, 1, 1)
    s.Parent = parent
    
    local g = Instance.new("UIGradient")
    g.Color = ColorThemes[currentThemeName].Sequence
    g.Rotation = 45
    g.Parent = s
    
    table.insert(allGrads, g)
    table.insert(allStrokes, s)
    return s
end

local gui = Instance.new("ScreenGui")
gui.Name = "VirgoboyHubUI"
gui.ResetOnSpawn = false
gui.Parent = coreGui

local FULL_H = 250
local MINI_H = 42

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, FULL_H)
main.Position = UDim2.new(0.5, -170, 0.4, -FULL_H // 2)
main.BackgroundColor3 = COL_BG
main.BackgroundTransparency = 0.15 -- Ditingkatkan sedikit agar gambar background lebih pop-out
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 12)
animStroke(main, 1.5)

-- ====================================================
--  IMAGE BACKGROUND SYSTEM (NEW)
-- ====================================================
local mainBgImage = Instance.new("ImageLabel")
mainBgImage.Size = UDim2.new(1, 0, 1, 0)
mainBgImage.BackgroundTransparency = 1
mainBgImage.Image = "rbxassetid://93224938541267"
mainBgImage.ScaleType = Enum.ScaleType.Crop
mainBgImage.ImageTransparency = 0.4 -- Transparansi awal (60% terlihat)
mainBgImage.ZIndex = 0
mainBgImage.Parent = main

Instance.new("UICorner", mainBgImage).CornerRadius = UDim.new(0, 12)
-- ====================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, MINI_H)
header.BackgroundTransparency = 1
header.ZIndex = 2
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 18)
title.Position = UDim2.new(0, 14, 0, 6)
title.BackgroundTransparency = 1
title.Text = "VIRGOBOY HUB"
title.Font = Enum.Font.GothamBlack
title.TextSize = 14
title.TextColor3 = TEXT_MAIN
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 2
title.Parent = header

local desc = Instance.new("TextLabel")
desc.Size = UDim2.new(1, -60, 0, 10)
desc.Position = UDim2.new(0, 14, 0, 24)
desc.BackgroundTransparency = 1
desc.Text = "Premium Multi-Script Hub"
desc.Font = Enum.Font.GothamBold
desc.TextSize = 9
desc.TextColor3 = COL_ACCENT
desc.TextXAlignment = Enum.TextXAlignment.Left
desc.ZIndex = 2
desc.Parent = header
themeObjectsToUpdate[desc] = "TextColor3"

-- ====================================================
--  SISTEM MINIMIZE KE IKON GAMBAR (BULAT)
-- ====================================================
local minimized = false

local minIcon = Instance.new("ImageButton")
minIcon.Size = UDim2.new(1, 0, 1, 0)
minIcon.BackgroundTransparency = 1
minIcon.Image = "rbxassetid://93224938541267"
minIcon.ScaleType = Enum.ScaleType.Crop
minIcon.ClipsDescendants = true
minIcon.Visible = false
minIcon.ZIndex = 3
minIcon.Parent = main

local iconCorner = Instance.new("UICorner", minIcon)
iconCorner.CornerRadius = UDim.new(0, 25)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -34, 0, 9)
minBtn.BackgroundColor3 = MIN_NORMAL
minBtn.Text = "-"
minBtn.TextColor3 = TEXT_MAIN
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 14
minBtn.BorderSizePixel = 0
minBtn.AutoButtonColor = false
minBtn.ZIndex = 2
minBtn.Parent = header
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
animStroke(minBtn, 1)

minBtn.MouseEnter:Connect(function()
    tweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundColor3 = MIN_HOVER}):Play()
end)
minBtn.MouseLeave:Connect(function()
    tweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundColor3 = MIN_NORMAL}):Play()
end)

local savedTransparency = 0.4 -- Menyimpan transparansi asli sebelum minimize

local function toggleMinimize()
    minimized = not minimized
    
    if minimized then
        savedTransparency = mainBgImage.ImageTransparency
        header.Visible = false
        mainBgImage.ImageTransparency = 1 -- Sembunyikan bg gambar utama agar tidak double dengan ikon
        
        for _, child in ipairs(main:GetChildren()) do
            if child:IsA("Frame") then
                child.Visible = false
            end
        end
        
        tweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 50, 0, 50),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.2
        }):Play()
        
        tweenService:Create(mainCorner, TweenInfo.new(0.25), {CornerRadius = UDim.new(0, 25)}):Play()
        
        task.wait(0.2)
        minIcon.Visible = true
    else
        minIcon.Visible = false
        mainBgImage.ImageTransparency = savedTransparency
        
        tweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 340, 0, FULL_H),
            BackgroundColor3 = COL_BG,
            BackgroundTransparency = 0.15
        }):Play()
        
        tweenService:Create(mainCorner, TweenInfo.new(0.3), {CornerRadius = UDim.new(0, 12)}):Play()
        
        task.wait(0.1)
        header.Visible = true
        for _, child in ipairs(main:GetChildren()) do
            if child:IsA("Frame") then
                child.Visible = true
            end
        end
    end
end

minBtn.MouseButton1Click:Connect(toggleMinimize)
minIcon.MouseButton1Click:Connect(toggleMinimize)
-- ====================================================

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 80, 1, -MINI_H - 10)
sidebar.Position = UDim2.new(0, 10, 0, MINI_H)
sidebar.BackgroundColor3 = COL_PANEL
sidebar.BackgroundTransparency = 0.2 -- Sedikit transparan agar tembus pandang ke gambar background
sidebar.ZIndex = 2
sidebar.Parent = main
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

local container = Instance.new("Frame")
container.Size = UDim2.new(1, -110, 1, -MINI_H - 10)
container.Position = UDim2.new(0, 100, 0, MINI_H)
container.BackgroundTransparency = 1
container.ZIndex = 2
container.Parent = main

local tabs = {}
local pages = {}

local function createPage(name)
    local p = Instance.new("Frame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ZIndex = 2
    p.Parent = container
    pages[name] = p
    return p
end

local homePage = createPage("Home")
local mapPage = createPage("Map")
local settingPage = createPage("Setting")

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = sidebar
Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 6)

local function registerTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 30)
    btn.Position = UDim2.new(0, 6, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = TEXT_SUB
    btn.ZIndex = 2
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        for tName, tBtn in pairs(tabs) do
            tweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = TEXT_SUB}):Play()
            pages[tName].Visible = false
        end
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2, BackgroundColor3 = COL_ACCENT, TextColor3 = TEXT_MAIN}):Play()
        pages[name].Visible = true
    end)
    
    tabs[name] = btn
end

registerTab("Home")
registerTab("Map")
registerTab("Setting")

tabs["Home"].BackgroundTransparency = 0.2
tabs["Home"].BackgroundColor3 = COL_ACCENT
tabs["Home"].TextColor3 = TEXT_MAIN
homePage.Visible = true
themeObjectsToUpdate[tabs["Home"]] = "BackgroundColor3"

----------------------------------------------------
-- CONTENT: HOME (User Data)
----------------------------------------------------
local profileImg = Instance.new("ImageLabel")
profileImg.Size = UDim2.new(0, 60, 0, 60)
profileImg.Position = UDim2.new(0, 5, 0, 10)
profileImg.BackgroundColor3 = COL_PANEL
profileImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. localPlayer.UserId .. "&w=150&h=150"
profileImg.ZIndex = 2
profileImg.Parent = homePage
Instance.new("UICorner", profileImg).CornerRadius = UDim.new(0, 30)
animStroke(profileImg, 1)

local usernameLabel = Instance.new("TextLabel")
usernameLabel.Size = UDim2.new(1, -75, 0, 20)
usernameLabel.Position = UDim2.new(0, 75, 0, 12)
usernameLabel.BackgroundTransparency = 1
usernameLabel.Text = "User: " .. localPlayer.Name
usernameLabel.Font = Enum.Font.GothamBold
usernameLabel.TextSize = 12
usernameLabel.TextColor3 = TEXT_MAIN
usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
usernameLabel.ZIndex = 2
usernameLabel.Parent = homePage

local accountAgeLabel = Instance.new("TextLabel")
accountAgeLabel.Size = UDim2.new(1, -75, 0, 20)
accountAgeLabel.Position = UDim2.new(0, 75, 0, 32)
accountAgeLabel.BackgroundTransparency = 1
accountAgeLabel.Text = "Account Age: " .. localPlayer.AccountAge .. " Days"
accountAgeLabel.Font = Enum.Font.GothamMedium
accountAgeLabel.TextSize = 11
accountAgeLabel.TextColor3 = TEXT_SUB
accountAgeLabel.TextXAlignment = Enum.TextXAlignment.Left
accountAgeLabel.ZIndex = 2
accountAgeLabel.Parent = homePage

local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(1, -10, 0, 40)
welcomeLabel.Position = UDim2.new(0, 5, 0, 85)
welcomeLabel.BackgroundColor3 = COL_PANEL
welcomeLabel.BackgroundTransparency = 0.2
welcomeLabel.Text = "Welcome to Virgoboy Hub!\nSelect a tab to begin your exploitation."
welcomeLabel.Font = Enum.Font.Gotham
welcomeLabel.TextSize = 10
welcomeLabel.TextColor3 = TEXT_SUB
welcomeLabel.ZIndex = 2
welcomeLabel.Parent = homePage
Instance.new("UICorner", welcomeLabel).CornerRadius = UDim.new(0, 6)

----------------------------------------------------
-- CONTENT: MAP
----------------------------------------------------
local mapScroll = Instance.new("ScrollingFrame")
mapScroll.Size = UDim2.new(1, 0, 1, 0)
mapScroll.BackgroundTransparency = 1
mapScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
mapScroll.ScrollBarThickness = 4
mapScroll.ScrollBarImageColor3 = COL_ACCENT
mapScroll.ZIndex = 2
mapScroll.Parent = mapPage
themeObjectsToUpdate[mapScroll] = "ScrollBarImageColor3"

local mapLayout = Instance.new("UIListLayout")
mapLayout.Padding = UDim.new(0, 6)
mapLayout.SortOrder = Enum.SortOrder.LayoutOrder
mapLayout.Parent = mapScroll

local mapPadding = Instance.new("UIPadding")
mapPadding.PaddingTop = UDim.new(0, 5)
mapPadding.PaddingBottom = UDim.new(0, 5)
mapPadding.PaddingLeft = UDim.new(0, 2)
mapPadding.PaddingRight = UDim.new(0, 5)
mapPadding.Parent = mapScroll

mapLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    mapScroll.CanvasSize = UDim2.new(0, 0, 0, mapLayout.AbsoluteContentSize.Y + 10)
end)

for _, mapData in ipairs(listMap) do
    local mapBtn = Instance.new("TextButton")
    mapBtn.Size = UDim2.new(1, 0, 0, 40)
    mapBtn.BackgroundColor3 = COL_PANEL
    mapBtn.BackgroundTransparency = 0.2
    mapBtn.Text = mapData.Nama
    mapBtn.Font = Enum.Font.GothamBold
    mapBtn.TextSize = 11
    mapBtn.TextColor3 = TEXT_MAIN
    mapBtn.ZIndex = 2
    mapBtn.Parent = mapScroll
    Instance.new("UICorner", mapBtn).CornerRadius = UDim.new(0, 6)
    animStroke(mapBtn, 1)

    mapBtn.MouseEnter:Connect(function()
        tweenService:Create(mapBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1, BackgroundColor3 = Color3.fromRGB(30, 30, 38)}):Play()
    end)
    mapBtn.MouseLeave:Connect(function()
        tweenService:Create(mapBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2, BackgroundColor3 = COL_PANEL}):Play()
    end)

    mapBtn.MouseButton1Click:Connect(function()
        task.spawn(function()
            pcall(function()
                assert(loadstring(mapData.Script))()
            end)
        end)
        gui:Destroy()
    end)
end

----------------------------------------------------
-- CONTENT: SETTING (Ditambah Slider Transparansi Background)
----------------------------------------------------
local settingScroll = Instance.new("ScrollingFrame")
settingScroll.Size = UDim2.new(1, 0, 1, 0)
settingScroll.BackgroundTransparency = 1
settingScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
settingScroll.ScrollBarThickness = 2
settingScroll.ScrollBarImageColor3 = COL_ACCENT
settingScroll.ZIndex = 2
settingScroll.Parent = settingPage
themeObjectsToUpdate[settingScroll] = "ScrollBarImageColor3"

local settingLayout = Instance.new("UIListLayout")
settingLayout.Padding = UDim.new(0, 6)
settingLayout.SortOrder = Enum.SortOrder.LayoutOrder
settingLayout.Parent = settingScroll

local settingPadding = Instance.new("UIPadding")
settingPadding.PaddingTop = UDim.new(0, 5)
settingPadding.PaddingBottom = UDim.new(0, 5)
settingPadding.PaddingLeft = UDim.new(0, 2)
settingPadding.PaddingRight = UDim.new(0, 5)
settingPadding.Parent = settingScroll

settingLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    settingScroll.CanvasSize = UDim2.new(0, 0, 0, settingLayout.AbsoluteContentSize.Y + 10)
end)

local antiAfkEnabled = false
local autoReconnectEnabled = false

local function createToggle(text, layoutOrder, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.BackgroundColor3 = COL_PANEL
    frame.BackgroundTransparency = 0.2
    frame.LayoutOrder = layoutOrder
    frame.ZIndex = 2
    frame.Parent = settingScroll
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    animStroke(frame, 1)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.TextColor3 = TEXT_MAIN
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 2
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -46, 0.5, -10)
    btn.BackgroundColor3 = defaultState and COL_ACCENT or Color3.fromRGB(45, 45, 50)
    btn.Text = defaultState and "ON" or "OFF"
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 9
    btn.TextColor3 = TEXT_MAIN
    btn.ZIndex = 2
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    if defaultState then
        themeObjectsToUpdate[btn] = "BackgroundColor3"
    end

    btn.MouseButton1Click:Connect(function()
        defaultState = not defaultState
        btn.Text = defaultState and "ON" or "OFF"
        
        if defaultState then
            themeObjectsToUpdate[btn] = "BackgroundColor3"
            btn.BackgroundColor3 = COL_ACCENT
        else
            themeObjectsToUpdate[btn] = nil
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        end
        callback(defaultState)
    end)
end

createToggle("📜 Enable Anti-AFK", 1, false, function(state) antiAfkEnabled = state end)
createToggle("🔄 Auto Reconnect", 2, false, function(state) autoReconnectEnabled = state end)

local themeFrame = Instance.new("Frame")
themeFrame.Size = UDim2.new(1, 0, 0, 55)
themeFrame.BackgroundColor3 = COL_PANEL
themeFrame.BackgroundTransparency = 0.2
themeFrame.LayoutOrder = 3
themeFrame.ZIndex = 2
themeFrame.Parent = settingScroll
Instance.new("UICorner", themeFrame).CornerRadius = UDim.new(0, 6)
animStroke(themeFrame, 1)

local themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(1, 0, 0, 18)
themeLabel.Position = UDim2.new(0, 10, 0, 4)
themeLabel.BackgroundTransparency = 1
themeLabel.Text = "🎨 Pilih Warna Elemen UI (Theme)"
themeLabel.Font = Enum.Font.GothamBold
themeLabel.TextSize = 10
themeLabel.TextColor3 = TEXT_MAIN
themeLabel.TextXAlignment = Enum.TextXAlignment.Left
themeLabel.ZIndex = 2
themeLabel.Parent = themeFrame

local themeList = {"Cyber Blue", "Luxury Gold", "Neon Green", "Ruby Red"}
local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(1, -20, 0, 24)
btnContainer.Position = UDim2.new(0, 10, 0, 24)
btnContainer.BackgroundTransparency = 1
btnContainer.ZIndex = 2
btnContainer.Parent = themeFrame

local tLayout = Instance.new("UIListLayout")
tLayout.FillDirection = Enum.FillDirection.Horizontal
tLayout.Padding = UDim.new(0, 4)
tLayout.Parent = btnContainer

local activeColorIndicator = Instance.new("UIStroke")

for _, tName in ipairs(themeList) do
    local cBtn = Instance.new("TextButton")
    cBtn.Size = UDim2.new(0.25, -3, 1, 0)
    cBtn.BackgroundColor3 = ColorThemes[tName].Accent
    cBtn.Text = ""
    cBtn.ZIndex = 2
    cBtn.Parent = btnContainer
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 4)
    
    if tName == currentThemeName then
        activeColorIndicator.Thickness = 1.5
        activeColorIndicator.Color = Color3.new(1, 1, 1)
        activeColorIndicator.Parent = cBtn
    end
    
    cBtn.MouseButton1Click:Connect(function()
        activeColorIndicator.Parent = cBtn
        updateTheme(tName)
        for name, tBtn in pairs(tabs) do
            if tBtn.BackgroundTransparency == 0.2 then
                tBtn.BackgroundColor3 = COL_ACCENT
            end
        end
    end)
end

-- ====================================================
--  MENU BARU: SLIDER TRANSPARANSI BACKGROUND (NEW)
-- ====================================================
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1, 0, 0, 45)
sliderFrame.BackgroundColor3 = COL_PANEL
sliderFrame.BackgroundTransparency = 0.2
sliderFrame.LayoutOrder = 4
sliderFrame.ZIndex = 2
sliderFrame.Parent = settingScroll
Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)
animStroke(sliderFrame, 1)

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, -20, 0, 18)
sliderLabel.Position = UDim2.new(0, 10, 0, 4)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "👁 Transparansi Background: 60%"
sliderLabel.Font = Enum.Font.GothamBold
sliderLabel.TextSize = 10
sliderLabel.TextColor3 = TEXT_MAIN
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.ZIndex = 2
sliderLabel.Parent = sliderFrame

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, -20, 0, 6)
sliderTrack.Position = UDim2.new(0, 10, 0, 26)
sliderTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
sliderTrack.ZIndex = 2
sliderTrack.Parent = sliderFrame
Instance.new("UICorner", sliderTrack).CornerRadius = UDim.new(0, 3)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.6, 0, 1, 0) -- Default 60% terisi (0.4 ImageTransparency)
sliderFill.BackgroundColor3 = COL_ACCENT
sliderFill.ZIndex = 2
sliderFill.Parent = sliderTrack
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 3)
themeObjectsToUpdate[sliderFill] = "BackgroundColor3"

local sliderBtn = Instance.new("ImageButton")
sliderBtn.Size = UDim2.new(0, 14, 0, 14)
sliderBtn.Position = UDim2.new(0.6, -7, 0.5, -7)
sliderBtn.BackgroundColor3 = TEXT_MAIN
sliderBtn.ZIndex = 3
sliderBtn.Parent = sliderTrack
Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(0, 7)
animStroke(sliderBtn, 1)

-- Logika Interaksi Slider (Support HP & Chromebook)
local sliderDragging = false

local function updateSlider(inputObj)
    local trackWidth = sliderTrack.AbsoluteSize.X
    local relativeX = math.clamp(inputObj.Position.X - sliderTrack.AbsolutePosition.X, 0, trackWidth)
    local percentage = relativeX / trackWidth
    
    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    sliderBtn.Position = UDim2.new(percentage, -7, 0.5, -7)
    
    -- Konversi persentase ke ImageTransparency (0 = Terlihat Jelas, 1 = Hilang)
    local imageTrans = 1 - percentage
    mainBgImage.ImageTransparency = imageTrans
    
    -- Tampilkan teks info kekuatan persentase transparansi gambar
    sliderLabel.Text = "👁 Transparansi Background: " .. math.floor(percentage * 100) .. "%"
end

sliderBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
    end
end)

userInputService.InputChanged:Connect(function(i)
    if sliderDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(i)
    end
end)

userInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)
-- ====================================================

local closeHubBtn = Instance.new("TextButton")
closeHubBtn.Size = UDim2.new(1, 0, 0, 32)
closeHubBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeHubBtn.Text = "Matikan / Tutup Script"
closeHubBtn.Font = Enum.Font.GothamBold
closeHubBtn.TextSize = 11
closeHubBtn.TextColor3 = TEXT_MAIN
closeHubBtn.LayoutOrder = 5
closeHubBtn.ZIndex = 2
closeHubBtn.Parent = settingScroll
Instance.new("UICorner", closeHubBtn).CornerRadius = UDim.new(0, 6)

closeHubBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(1, 0, 0, 30)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "Virgoboy Hub © 2026\nUI Engine Modded with Auto-List System"
creditLabel.Font = Enum.Font.GothamMedium
creditLabel.TextSize = 9
creditLabel.TextColor3 = TEXT_SUB
creditLabel.LayoutOrder = 6
creditLabel.ZIndex = 2
creditLabel.Parent = settingScroll

----------------------------------------------------
-- BACKGROUND SYSTEMS: ANTI-AFK & AUTO RECONNECT LOGIC
----------------------------------------------------
local virtualUser = cloneref(game:GetService("VirtualUser"))
localPlayer.Idled:Connect(function()
    if antiAfkEnabled then
        pcall(function()
            virtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            virtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

local guiService = cloneref(game:GetService("GuiService"))
local teleportService = cloneref(game:GetService("TeleportService"))

guiService.ErrorMessageChanged:Connect(function()
    if autoReconnectEnabled then
        task.wait(2)
        pcall(function()
            if #players:GetPlayers() <= 1 then
                teleportService:Teleport(game.PlaceId, localPlayer)
            else
                teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
            end
        end)
    end
end)

----------------------------------------------------
-- CORE SYSTEMS: DRAG & ANIMATION LOGIC
----------------------------------------------------
do
    local dragging, dragStart, startPos = false, nil, nil
    
    local function initDrag(inputObj)
        local abs = main.AbsolutePosition
        main.Position = UDim2.new(0, abs.X, 0, abs.Y)
        dragging = true
        dragStart = inputObj.Position
        startPos = main.Position
    end

    header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            initDrag(i)
        end
    end)
    
    minIcon.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            initDrag(i)
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
    local off = Vector2.new(math.sin(tick() * 2.5), 0)
    for _, g in ipairs(allGrads) do
        g.Offset = off
    end
end)
