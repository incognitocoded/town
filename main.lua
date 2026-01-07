-- [[ LOST HUB PREMIER: VERSION 1 ]] --
-- [[ DRAG LOCK FIX & REFINED UI ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // 1. АНИМАЦИЯ ПОЯВЛЕНИЯ
local IntroGui = Instance.new("ScreenGui", game.CoreGui)
local IntroText = Instance.new("TextLabel", IntroGui)
IntroText.Size = UDim2.new(1, 0, 1, 0)
IntroText.BackgroundTransparency = 1
IntroText.Text = "LOST HUB"
IntroText.TextColor3 = Color3.fromRGB(255, 0, 0)
IntroText.TextSize = 1
IntroText.Font = Enum.Font.GothamBold
IntroText.TextTransparency = 1

TweenService:Create(IntroText, TweenInfo.new(1), {TextSize = 70, TextTransparency = 0}):Play()
task.wait(1.5)
TweenService:Create(IntroText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
task.wait(0.5)
IntroGui:Destroy()

-- // 2. ПЕРЕМЕННЫЕ
_G.AimEnabled = false
_G.AimPart = "Head"
_G.FOV = 42
_G.ESPEnabled = false
_G.WallCheck = false

-- // 3. ГЛАВНОЕ ОКНО
local MainGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", MainGui)
local UICorner = Instance.new("UICorner", MainFrame)
local UIStroke = Instance.new("UIStroke", MainFrame)

MainFrame.Size = UDim2.new(0, 240, 0, 400)
MainFrame.Position = UDim2.new(0.5, -120, 0.4, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Active = true
MainFrame.Draggable = true -- Базовое перемещение

UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Thickness = 2
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "LOST HUB V1"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold

-- Функция создания кнопок
local function CreateBtn(text, pos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.Size = UDim2.new(0, 210, 0, 40)
    btn.Position = UDim2.new(0, 15, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

CreateBtn("AIMBOT: OFF", 60, function(b)
    _G.AimEnabled = not _G.AimEnabled
    b.Text = _G.AimEnabled and "AIMBOT: ACTIVE" or "AIMBOT: OFF"
    b.TextColor3 = _G.AimEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(200, 200, 200)
end)

CreateBtn("TARGET: HEAD", 110, function(b)
    _G.AimPart = (_G.AimPart == "Head" and "HumanoidRootPart" or "Head")
    b.Text = "TARGET: " .. (_G.AimPart == "Head" and "HEAD" or "BODY")
end)

CreateBtn("WALLCHECK: OFF", 160, function(b)
    _G.WallCheck = not _G.WallCheck
    b.Text = "WALLCHECK: " .. (_G.WallCheck and "ON" or "OFF")
end)

CreateBtn("ESP: OFF", 210, function(b)
    _G.ESPEnabled = not _G.ESPEnabled
    b.Text = _G.ESPEnabled and "ESP: ACTIVE" or "ESP: OFF"
    b.TextColor3 = _G.ESPEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(200, 200, 200)
end)

-- // 4. ПОЛЗУНОК FOV (С ФИКСАЦИЕЙ МЕНЮ)
local SliderLabel = Instance.new("TextLabel", MainFrame)
SliderLabel.Size = UDim2.new(1, 0, 0, 20)
SliderLabel.Position = UDim2.new(0, 0, 0, 265)
SliderLabel.Text = "FOV RADIUS: " .. _G.FOV
SliderLabel.TextColor3 = Color3.new(1, 1, 1)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.TextSize = 13

local SliderFrame = Instance.new("Frame", MainFrame)
SliderFrame.Size = UDim2.new(0, 210, 0, 4)
SliderFrame.Position = UDim2.new(0, 15, 0, 295)
SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", SliderFrame)

local SliderFill = Instance.new("Frame", SliderFrame)
SliderFill.Size = UDim2.new(_G.FOV/500, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", SliderFill)

local SliderDot = Instance.new("Frame", SliderFill)
SliderDot.Size = UDim2.new(0, 14, 0, 14)
SliderDot.Position = UDim2.new(1, -7, 0.5, -7)
SliderDot.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SliderDot)

local function UpdateSlider()
    local mouseX = UserInputService:GetMouseLocation().X
    local pos = math.clamp((mouseX - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
    _G.FOV = math.floor(pos * 500)
    SliderLabel.Text = "FOV RADIUS: " .. _G.FOV
end

local isDraggingSlider = false

SliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        isDraggingSlider = true 
        MainFrame.Draggable = false -- Блокируем перемещение меню
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        isDraggingSlider = false 
        MainFrame.Draggable = true -- Возвращаем перемещение меню
    end
end)

RunService.RenderStepped:Connect(function() 
    if isDraggingSlider then UpdateSlider() end 
end)

-- // 5. НИЖНЯЯ ПАНЕЛЬ (БЕЛЫЙ ПРОЗРАЧНЫЙ ТЕКСТ)
local BottomTab = Instance.new("Frame", MainFrame)
BottomTab.Size = UDim2.new(1, 0, 0, 50)
BottomTab.Position = UDim2.new(0, 0, 1, -50)
BottomTab.BackgroundTransparency = 1

local TgText = Instance.new("TextLabel", BottomTab)
TgText.Size = UDim2.new(1, 0, 1, 0)
TgText.Text = "TG/@losthubscript"
TgText.TextColor3 = Color3.new(1, 1, 1) -- Белый
TgText.TextTransparency = 0.5 -- Полупрозрачный
TgText.BackgroundTransparency = 1
TgText.Font = Enum.Font.GothamBold
TgText.TextSize = 14

-- // 6. ФУНКЦИОНАЛ (AIM & ESP)
local Circle = Drawing.new("Circle")
Circle.Thickness = 2
Circle.Color = Color3.fromRGB(255, 0, 0)
Circle.Filled = false

local function IsVisible(part)
    if not _G.WallCheck then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
    local res = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), params)
    return res == nil
end

RunService.RenderStepped:Connect(function()
    Circle.Radius = _G.FOV
    Circle.Position = UserInputService:GetMouseLocation()
    Circle.Visible = _G.AimEnabled

    if _G.AimEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil
        local dist = _G.FOV
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(_G.AimPart) then
                local p = v.Character[_G.AimPart]
                local pos, onS = Camera:WorldToViewportPoint(p.Position)
                if onS then
                    local mag = (Vector2.new(pos.X, pos.Y) - Circle.Position).Magnitude
                    if mag < dist and IsVisible(p) then target = p; dist = mag end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end
end)

RunService.Heartbeat:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            -- Удаление красных кубов и прочего мусора
            for _, obj in pairs(p.Character:GetChildren()) do
                if obj.Name == "Box" or obj.Name == "LOST_ESP" or obj:IsA("BoxHandleAdornment") then
                    obj:Destroy()
                end
            end
            
            local hl = p.Character:FindFirstChild("LOST_HL")
            if _G.ESPEnabled then
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "LOST_HL"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            elseif hl then hl:Destroy() end
        end
    end
end)
