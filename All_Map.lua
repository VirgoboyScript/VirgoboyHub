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
--  DAFTAR MAP BARU (Tambahkan Map Kamu di Sini!)
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
        Nama = "⛄ Tamagochi",
        Script = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/VirgoboyScript/Script/main/Tamagochi.lua"))()]]
    },
    -- Kamu bisa tambah map baru lagi di bawah ini dengan format yang sama:
    -- {
    --     Nama = "Nama Map Kamu",
    --     Script = [[loadstring(game:HttpGet("Link Script Kamu"))()]]
    -- },
}
-- ====================================================

local COL_BG = Color3.fromRGB(15, 15, 18)
local COL_PANEL = Color3.fromRGB(22, 22, 26)
local COL_ACCENT = Color3.fromRGB(90, 100, 240)
local MIN_NORMAL = Color3.fromRGB(35, 35, 40)
local MIN_HOVER = Color3.fromRGB(50, 50, 55)
local TEXT_MAIN = Color3.fromRGB(240, 240, 245)
local TEXT_SUB = Color3.fromRGB(140, 140, 145)

local STROKE_CS = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 45, 60)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(110, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 45, 60)),
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
gui.Name = "VirgoboyHubUI"
gui.ResetOnSpawn = false
gui.Parent = coreGui

local FULL_H = 250
local MINI_H = 42

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, FULL_H)
main.Position = UDim2.new(0.5, -170, 0.4, -FULL_H // 2)
main.BackgroundColor3 = COL_BG
main.BackgroundTransparency = 0.05
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
animStroke(main, 1.5)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, MINI_H)
header.BackgroundTransparency = 1
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
desc.Parent = header

local minimized = false
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
minBtn.Parent = header
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
animStroke(minBtn, 1)

minBtn.MouseEnter:Connect(function()
    tweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundColor3 = MIN_HOVER}):Play()
end)
minBtn.MouseLeave:Connect(function()
    tweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundColor3 = MIN_NORMAL}):Play()
end)

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
        Size = minimized and UDim2.new(0, 340, 0, MINI_H) or UDim2.new(0, 340, 0, FULL_H)
    }):Play()
    minBtn.Text = minimized and "+" or "-"
end)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 80, 1, -MINI_H - 10)
sidebar.Position = UDim2.new(0, 10, 0, MINI_H)
sidebar.BackgroundColor3 = COL_PANEL
sidebar.Parent = main
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

local container = Instance.new("Frame")
container.Size = UDim2.new(1, -110, 1, -MINI_H - 10)
container.Position = UDim2.new(0, 100, 0, MINI_H)
container.BackgroundTransparency = 1
container.Parent = main

local tabs = {}
local pages = {}

local function createPage(name)
    local p = Instance.new("Frame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
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
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        for tName, tBtn in pairs(tabs) do
            tweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = TEXT_SUB}):Play()
            pages[tName].Visible = false
        end
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0, BackgroundColor3 = COL_ACCENT, TextColor3 = TEXT_MAIN}):Play()
        pages[name].Visible = true
    end)
    
    tabs[name] = btn
end

registerTab("Home")
registerTab("Map")
registerTab("Setting")

tabs["Home"].BackgroundTransparency = 0
tabs["Home"].BackgroundColor3 = COL_ACCENT
tabs["Home"].TextColor3 = TEXT_MAIN
homePage.Visible = true

----------------------------------------------------
-- CONTENT: HOME (User Data)
----------------------------------------------------
local profileImg = Instance.new("ImageLabel")
profileImg.Size = UDim2.new(0, 60, 0, 60)
profileImg.Position = UDim2.new(0, 5, 0, 10)
profileImg.BackgroundColor3 = COL_PANEL
profileImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. localPlayer.UserId .. "&w=150&h=150"
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
accountAgeLabel.Parent = homePage

local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(1, -10, 0, 40)
welcomeLabel.Position = UDim2.new(0, 5, 0, 85)
welcomeLabel.BackgroundColor3 = COL_PANEL
welcomeLabel.Text = "Welcome to Virgoboy Hub!\nSelect a tab to begin your exploitation."
welcomeLabel.Font = Enum.Font.Gotham
welcomeLabel.TextSize = 10
welcomeLabel.TextColor3 = TEXT_SUB
welcomeLabel.Parent = homePage
Instance.new("UICorner", welcomeLabel).CornerRadius = UDim.new(0, 6)

----------------------------------------------------
-- CONTENT: MAP (Sistem Scrolling Otomatis)
----------------------------------------------------
-- Mengubah container map menjadi ScrollingFrame agar jika map-nya banyak bisa di-scroll ke bawah
local mapScroll = Instance.new("ScrollingFrame")
mapScroll.Size = UDim2.new(1, 0, 1, 0)
mapScroll.BackgroundTransparency = 1
mapScroll.CanvasSize = UDim2.new(0, 0, 0, 0) -- Otomatis bertambah panjang
mapScroll.ScrollBarThickness = 4
mapScroll.ScrollBarImageColor3 = COL_ACCENT
mapScroll.Parent = mapPage

local mapLayout = Instance.new("UIListLayout")
mapLayout.Padding = UDim.new(0, 6)
mapLayout.SortOrder = Enum.SortOrder.LayoutOrder
mapLayout.Parent = mapScroll

-- Padding agar tidak terlalu mepet ke atas/bawah
local mapPadding = Instance.new("UIPadding")
mapPadding.PaddingTop = UDim.new(0, 5)
mapPadding.PaddingBottom = UDim.new(0, 5)
mapPadding.PaddingLeft = UDim.new(0, 2)
mapPadding.PaddingRight = UDim.new(0, 5)
mapPadding.Parent = mapScroll

-- Fungsi Otomatis mengatur panjang Scroll Area berdasarkan isi map
mapLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    mapScroll.CanvasSize = UDim2.new(0, 0, 0, mapLayout.AbsoluteContentSize.Y + 10)
end)

-- LOOPING: Membuat Tombol Map Secara Otomatis dari Tabel `listMap`
for _, mapData in ipairs(listMap) do
    local mapBtn = Instance.new("TextButton")
    mapBtn.Size = UDim2.new(1, 0, 0, 40) -- Tinggi tombol disesuaikan agar muat banyak
    mapBtn.BackgroundColor3 = COL_PANEL
    mapBtn.Text = mapData.Nama
    mapBtn.Font = Enum.Font.GothamBold
    mapBtn.TextSize = 11
    mapBtn.TextColor3 = TEXT_MAIN
    mapBtn.Parent = mapScroll
    Instance.new("UICorner", mapBtn).CornerRadius = UDim.new(0, 6)
    animStroke(mapBtn, 1)

    -- Efek Hover saat mouse masuk/keluar tombol
    mapBtn.MouseEnter:Connect(function()
        tweenService:Create(mapBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 38)}):Play()
    end)
    mapBtn.MouseLeave:Connect(function()
        tweenService:Create(mapBtn, TweenInfo.new(0.15), {BackgroundColor3 = COL_PANEL}):Play()
    end)

    -- Fungsi klik tombol
    mapBtn.MouseButton1Click:Connect(function()
        task.spawn(function()
            pcall(function()
                assert(loadstring(mapData.Script))()
            end)
        end)
        gui:Destroy() -- Hancurkan hub saat diklik
    end)
end

----------------------------------------------------
-- CONTENT: SETTING (General Settings)
----------------------------------------------------
local closeHubBtn = Instance.new("TextButton")
closeHubBtn.Size = UDim2.new(1, -10, 0, 36)
closeHubBtn.Position = UDim2.new(0, 5, 0, 15)
closeHubBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeHubBtn.Text = "Matikan / Tutup Script"
closeHubBtn.Font = Enum.Font.GothamBold
closeHubBtn.TextSize = 12
closeHubBtn.TextColor3 = TEXT_MAIN
closeHubBtn.Parent = settingPage
Instance.new("UICorner", closeHubBtn).CornerRadius = UDim.new(0, 6)

closeHubBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(1, -10, 0, 40)
creditLabel.Position = UDim2.new(0, 5, 0, 65)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "Virgoboy Hub © 2026\nUI Engine Modded with Auto-List System"
creditLabel.Font = Enum.Font.GothamMedium
creditLabel.TextSize = 10
creditLabel.TextColor3 = TEXT_SUB
creditLabel.Parent = settingPage

----------------------------------------------------
-- CORE SYSTEMS: DRAG & ANIMATION LOGIC
----------------------------------------------------
do
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(i)
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
    local off = Vector2.new(math.sin(tick() * 2.5), 0)
    for _, g in ipairs(allGrads) do
        g.Offset = off
    end
end)
