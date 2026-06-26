-- --- UI CORE SETUP ---
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local CloseBtn = Instance.new("TextButton")
local MinBtn = Instance.new("TextButton")

ScreenGui.Name = "VirgoboyCyberFinal_V6"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- --- CHARACTER REFRESH LOGIC ---
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")

Player.CharacterAdded:Connect(function(NewChar)
    Character = NewChar
    Root = NewChar:WaitForChild("HumanoidRootPart")
end)

-- --- UI DESIGN ---
MainFrame.Name = "Main"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 320) -- Ukuran disesuaikan karena menu berkurang
MainFrame.Active = true
MainFrame.Draggable = true 

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Glow = Instance.new("UIStroke")
Glow.Color = Color3.fromRGB(0, 255, 255)
Glow.Thickness = 1.8
Glow.Parent = MainFrame

-- Header
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -65, 0, 40)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "TOKYO ANIME | VIRGOBOY"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons Close & Min
CloseBtn.Parent = MainFrame
CloseBtn.Position = UDim2.new(1, -32, 0, 9)
CloseBtn.Size = UDim2.new(0, 23, 0, 23)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

MinBtn.Parent = MainFrame
MinBtn.Position = UDim2.new(1, -62, 0, 9)
MinBtn.Size = UDim2.new(0, 23, 0, 23)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.MouseButton1Click:Connect(function()
    Container.Visible = not Container.Visible
    MainFrame.Size = Container.Visible and UDim2.new(0, 240, 0, 320) or UDim2.new(0, 240, 0, 40)
end)
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- Container
Container.Parent = MainFrame
Container.Position = UDim2.new(0, 8, 0, 45)
Container.Size = UDim2.new(1, -16, 1, -55)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
Container.CanvasSize = UDim2.new(0, 0, 0, 0)

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 15)
end)

-- --- COMPONENT BUILDERS ---
local function CreateCategory(name)
    local Frame = Instance.new("Frame")
    local Btn = Instance.new("TextButton")
    local Content = Instance.new("Frame")
    local Layout = Instance.new("UIListLayout")
    Frame.Parent = Container
    Frame.Size = UDim2.new(1, 0, 0, 32)
    Frame.BackgroundTransparency = 1
    Frame.ClipsDescendants = true
    Btn.Parent = Frame
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Btn.Text = "  ▶ " .. name
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
    Content.Parent = Frame
    Content.Position = UDim2.new(0, 0, 0, 38)
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.BackgroundTransparency = 1
    Layout.Parent = Content
    Layout.Padding = UDim.new(0, 4)
    local open = false
    Btn.MouseButton1Click:Connect(function()
        open = not open
        Btn.Text = open and "  ▼ " .. name or "  ▶ " .. name
        Btn.TextColor3 = open and Color3.fromRGB(0, 255, 255) or Color3.new(1,1,1)
        local target = open and (Layout.AbsoluteContentSize.Y + 45) or 32
        game:GetService("TweenService"):Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, target)}):Play()
    end)
    return Content
end

local function AddToggle(parent, txt, callback)
    local state = false
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = txt .. " : OFF"
    btn.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = txt .. (state and " : ON" or " : OFF")
        btn.TextColor3 = state and Color3.fromRGB(0, 255, 255) or Color3.new(0.6, 0.6, 0.6)
        callback(state)
    end)
end

local function AddButton(parent, txt, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = txt
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(callback)
end

-- --- GAME LOGIC ---
local Knit = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.7.0"].knit.Services

-- Fly Tween (Hanya untuk Obby)
local function flyTween(targetCF)
    if not Root then return end
    local TS = game:GetService("TweenService")
    local flyHeight = 250
    local upCF = CFrame.new(Root.Position.X, flyHeight, Root.Position.Z)
    local acrossCF = CFrame.new(targetCF.X, flyHeight, targetCF.Z)
    
    TS:Create(Root, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CFrame = upCF}):Play()
    task.wait(1.6)
    TS:Create(Root, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {CFrame = acrossCF}):Play()
    task.wait(2.6)
    TS:Create(Root, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CFrame = targetCF}):Play()
end

-- 1. AUTOMATION
local AutoCat = CreateCategory("INFINITE COINS")
AddToggle(AutoCat, "Inf Coins", function(v)
    _G.AutoC = v
    task.spawn(function()
        while _G.AutoC do
            pcall(function() Knit.CoinService.RF.GrantCoins:InvokeServer(math.huge) end)
            task.wait(0.1)
        end
    end)
end)

-- 2. TELEPORTS (INSTANT)
local TeleCat = CreateCategory("TELEPORT")
AddButton(TeleCat, "Area Seni", function() if Root then Root.CFrame = CFrame.new(-498.19, 176.02, 223.76) end end)
AddButton(TeleCat, "Studio Musik", function() if Root then Root.CFrame = CFrame.new(656.71, 148.01, -567.13) end end)

-- 3. OBBY (FLY TWEEN)
local ObbyCat = CreateCategory("FINISH OBBY")
AddButton(ObbyCat, "Robot World", function() flyTween(workspace.Areas.Robot.Goal.CFrame) end)
AddButton(ObbyCat, "Space World", function() flyTween(workspace.Areas.Space.Goal.CFrame) end)
AddButton(ObbyCat, "Ninja World", function() flyTween(workspace.Areas.Ninja.Goal.CFrame) end)
AddButton(ObbyCat, "AniOtodama World", function() flyTween(workspace.Areas.AniOtodama.Goal.CFrame) end)

-- 4. SHOP & DECK
local ShopCat = CreateCategory("SHOP CARD")
AddToggle(ShopCat, "CARD PREMIUM", function(v)
    _G.B5 = v
    task.spawn(function()
        while _G.B5 do pcall(function() Knit.TCGShopService.RF.Buy:InvokeServer(1002) end) task.wait(0.5) end
    end)
end)
AddToggle(ShopCat, "CARD NORMAL", function(v)
    _G.B3 = v
    task.spawn(function()
        while _G.B3 do pcall(function() Knit.TCGShopService.RF.Buy:InvokeServer(1001) end) task.wait(0.5) end
    end)
end)
AddToggle(ShopCat, "BUILD CARD", function(v)
    _G.AutoBuild = v
    task.spawn(function()
        local args = {
            {
                SelectedUniqueCards = {
                    501002,
                    502001
                },
                SelectedSkillCards = {
                    201001,
                    202001,
                    203001,
                    204001,
                    205001,
                    206001,
                    207001,
                    208002,
                    209002,
                    210001,
                    211001,
                    212001
                }
            }
        }
        while _G.AutoBuild do
            pcall(function() Knit.TCGBuildDeckService.RF.BuildAnimeCard:InvokeServer(unpack(args)) end)
            task.wait() -- Delay 5 detik agar tidak spam remote terlalu berat
        end
    end)
end)

-- Anti-AFK
local Vu = game:GetService("VirtualUser")
Player.Idled:Connect(function()
    Vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    Vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
