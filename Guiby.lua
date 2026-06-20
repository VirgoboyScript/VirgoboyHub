
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")

local flying = false
local noclip = false
local speed = 50
local keys = {w = false, s = false, a = false, d = false}

-- Membuat GUI Status
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local statusLabel = Instance.new("TextLabel", screenGui)
statusLabel.Size = UDim2.new(0, 200, 0, 50)
statusLabel.Position = UDim2.new(0, 10, 0.5, -25)
statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusLabel.BackgroundTransparency = 0.5
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.TextSize = 18
statusLabel.Text = "Status: OFF (F)"

-- Fungsi Arah Gerak
local function getDirection()
    local cam = workspace.CurrentCamera.CFrame
    local dir = Vector3.new(0, 0, 0)
    if keys.w then dir = dir + cam.LookVector end
    if keys.s then dir = dir - cam.LookVector end
    if keys.a then dir = dir - cam.RightVector end
    if keys.d then dir = dir + cam.RightVector end
    return dir
end

-- Fungsi NoClip (Menembus Dinding)
runService.Stepped:Connect(function()
    if noclip then
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

mouse.KeyDown:Connect(function(key)
    local k = key:lower()
    if k == "f" then
        flying = not flying
        noclip = flying -- NoClip aktif saat terbang
        
        local char = player.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        if flying and root and hum then
            statusLabel.Text = "FLY & NOCLIP: ON"
            statusLabel.TextColor3 = Color3.new(0, 1, 0)
            hum.PlatformStand = true
            
            local bg = Instance.new("BodyGyro", root)
            local bv = Instance.new("BodyVelocity", root)
            bg.P = 9e4
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            
            task.spawn(function()
                while flying do
                    runService.RenderStepped:Wait()
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    bv.Velocity = getDirection() * speed
                end
                bg:Destroy()
                bv:Destroy()
                hum.PlatformStand = false
                statusLabel.Text = "Status: OFF (E)"
                statusLabel.TextColor3 = Color3.new(1, 1, 1)
            end)
        end
    elseif keys[k] ~= nil then
        keys[k] = true
    end
end)

mouse.KeyUp:Connect(function(key)
    local k = key:lower()
    if keys[k] ~= nil then
        keys[k] = false
    end
end)
