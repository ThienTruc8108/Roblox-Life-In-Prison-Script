--[[

▄▄▄█████▓ ██░ ██  ██▓▓█████  ███▄    █    ▄▄▄█████▓ ██▀███   █    ██  ▄████▄  
▓  ██▒ ▓▒▓██░ ██▒▓██▒▓█   ▀  ██ ▀█   █    ▓  ██▒ ▓▒▓██ ▒ ██▒ ██  ▓██▒▒██▀ ▀█  
▒ ▓██░ ▒░▒██▀▀██░▒██▒▒███   ▓██  ▀█ ██▒   ▒ ▓██░ ▒░▓██ ░▄█ ▒▓██  ▒██░▒▓█    ▄ 
░ ▓██▓ ░ ░▓█ ░██ ░██░▒▓█  ▄ ▓██▒  ▐▌██▒   ░ ▓██▓ ░ ▒██▀▀█▄  ▓▓█  ░██░▒▓▓▄ ▄██▒
  ▒██▒ ░ ░▓█▒░██▓░██░░▒████▒▒██░   ▓██░     ▒██▒ ░ ░██▓ ▒██▒▒▒█████▓ ▒ ▓███▀ ░
  ▒ ░░    ▒ ░░▒░▒░▓  ░░ ▒░ ░░ ▒░   ▒ ▒      ▒ ░░   ░ ▒▓ ░▒▓░░▒▓▒ ▒ ▒ ░ ░▒ ▒  ░
    ░     ▒ ░▒░ ░ ▒ ░ ░ ░  ░░ ░░   ░ ▒░       ░      ░▒ ░ ▒░░░▒░ ░ ░   ░  ▒   
  ░       ░  ░░ ░ ▒ ░   ░      ░   ░ ░      ░        ░░   ░  ░░░ ░ ░ ░        
          ░  ░  ░ ░     ░  ░         ░                ░        ░     ░ ░      
                                                                     ░        

--]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local AimbotEnabled = false
local MenuVisible = false
local MaxDistance = 120  
local FOV = 60          
local Smoothness = 0.5  
local ESPEnabled = false
local FullbrightEnabled = false
local InvisibilityEnabled = false
local AntiDeadEnabled = false
local ESPTable = {}
local SavedPosition = nil
local BackButton = nil
local IsAntiDeadActive = false

local UIColors = {
    background = Color3.fromRGB(25, 25, 30),
    header = Color3.fromRGB(0, 0, 0),
    button = Color3.fromRGB(45, 45, 50),
    buttonActive = Color3.fromRGB(0, 180, 0),
    text = Color3.fromRGB(240, 240, 240)
}

-- (GUI)
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "GunpowderScriptUI"
ScreenGui.ResetOnSpawn = false
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local ButtonHeight = IsMobile and 50 or 40

-- menu
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 320)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -160)
MainFrame.BackgroundColor3 = UIColors.background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = MenuVisible
MainFrame.ClipsDescendants = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = UIColors.header
Title.TextColor3 = UIColors.text
Title.Font = Enum.Font.GothamBold
Title.Text = "Fucking Lip"
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Center

-- btn
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(1, -10, 1, -60)
ScrollFrame.Position = UDim2.new(0, 5, 0, 55)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 680) 
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollingEnabled = true

local ListLayout = Instance.new("UIListLayout", ScrollFrame)
ListLayout.Padding = UDim.new(0, 10)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
end)

-- tp fr
local TPFrame = Instance.new("Frame", ScreenGui)
TPFrame.Size = UDim2.new(0, 250, 0, 320)
TPFrame.Position = UDim2.new(0.5, 160, 0.5, -160)
TPFrame.BackgroundColor3 = UIColors.background
TPFrame.BorderSizePixel = 0
TPFrame.Active = true
TPFrame.Draggable = true
TPFrame.Visible = false
TPFrame.ClipsDescendants = true

local TPTitle = Instance.new("TextLabel", TPFrame)
TPTitle.Size = UDim2.new(1, 0, 0, 40)
TPTitle.BackgroundColor3 = UIColors.header
TPTitle.TextColor3 = UIColors.text
TPTitle.Font = Enum.Font.GothamBold
TPTitle.Text = "CHỌN NGƯỜI ĐỂ TELEPORT"
TPTitle.TextSize = 14
TPTitle.TextXAlignment = Enum.TextXAlignment.Center

local TPScroll = Instance.new("ScrollingFrame", TPFrame)
TPScroll.Size = UDim2.new(1, -10, 1, -50)
TPScroll.Position = UDim2.new(0, 5, 0, 45)
TPScroll.BackgroundTransparency = 1
TPScroll.BorderSizePixel = 0
TPScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TPScroll.ScrollBarThickness = 6
local TPListLayout = Instance.new("UIListLayout", TPScroll)
TPListLayout.Padding = UDim.new(0, 5)
TPListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- btn f
local function CreateButton(text, order)
    local Button = Instance.new("TextButton", ScrollFrame)
    Button.Size = UDim2.new(1, -10, 0, ButtonHeight)
    Button.BackgroundColor3 = UIColors.button
    Button.LayoutOrder = order
    Button.TextColor3 = UIColors.text
    Button.Font = Enum.Font.GothamBold
    Button.Text = text
    Button.TextSize = 16
    Button.AutoButtonColor = false
    Button.BorderSizePixel = 0
    
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.35)
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = UIColors.button
    end)
    return Button
end

-- mn btn
local AimbotBtn = CreateButton("AIMBOT: OFF", 1)
local TargetBtn = CreateButton("TARGET: AUTOMATIC", 2)
local DistBtn = CreateButton("DISTANCE: " .. MaxDistance, 3)
local SmoothBtn = CreateButton("SMOOTHNESS: " .. Smoothness, 4)
local ESPBtn = CreateButton("ESP: OFF", 5)
local BrightBtn = CreateButton("FULLBRIGHT: OFF", 6)
local InvisBtn = CreateButton("INVISIBILITY: OFF", 7)
local AntiDeadBtn = CreateButton("ANTI DEAD: OFF", 8)
local TeleportBtn = CreateButton("TELEPORT MENU", 9)

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 150, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 1, -50)
ToggleBtn.BackgroundColor3 = UIColors.header
ToggleBtn.TextColor3 = UIColors.text
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "Truc MENU"
ToggleBtn.TextSize = 16
ToggleBtn.BorderSizePixel = 0

local TargetTeams = {"AUTO", "POLICE", "CRIMINALS"}
local CurrentTeamIndex = 1

local function GetTeamColor(teamName)
    if teamName == "Police" then return Color3.fromRGB(0, 162, 255)
    elseif teamName == "Prisoners" then return Color3.fromRGB(255, 140, 0)
    elseif teamName == "Criminals" then return Color3.fromRGB(255, 0, 0)
    else return Color3.new(1, 1, 1) end
end

local function IsValidTargetTeam(plrTeamName)
    local currentMode = TargetTeams[CurrentTeamIndex]
    local myTeam = (LocalPlayer.Team and LocalPlayer.Team.Name) or ""
    
    if currentMode == "AUTO" then
        return plrTeamName ~= "" and plrTeamName ~= myTeam
    elseif currentMode == "POLICE" then
        return plrTeamName == "Police"
    elseif currentMode == "CRIMINALS" then
        return plrTeamName == "Criminals"
    end
    return false
end

local function GetClosestTarget()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local target, closestDist = nil, MaxDistance
    local myPos = char.HumanoidRootPart.Position
    local camPos = Camera.CFrame.Position
    local lookVec = Camera.CFrame.LookVector
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team and IsValidTargetTeam(plr.Team.Name) then
            local pChar = plr.Character
            if pChar and pChar:FindFirstChild("Humanoid") and pChar.Humanoid.Health > 0 then
                for _, part in ipairs(pChar:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local dist = (myPos - part.Position).Magnitude
                        if dist < closestDist then
                            local camUnit = (part.Position - camPos).Unit
                            local angle = math.deg(math.acos(lookVec:Dot(camUnit)))
                            if angle < FOV then
                                local rayParams = RaycastParams.new()
                                rayParams.FilterDescendantsInstances = {char}
                                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                                local raycastResult = Workspace:Raycast(camPos, camUnit * MaxDistance, rayParams)
                                if not raycastResult or raycastResult.Instance:IsDescendantOf(pChar) then
                                    target = part 
                                    closestDist = dist
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return target
end

-- aimbot
local LastTarget = nil
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then LastTarget = nil return end
    local currentTarget = GetClosestTarget()
    if currentTarget then
        if LastTarget and Smoothness > 0 then
            local oldCFrame = Camera.CFrame
            local targetCFrame = CFrame.new(Camera.CFrame.Position, currentTarget.Position)
            Camera.CFrame = oldCFrame:Lerp(targetCFrame, 1 - Smoothness)
        else
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, currentTarget.Position)
        end
        LastTarget = currentTarget
    else
        LastTarget = nil
    end
end)

-- esp
local function ShouldShowESP(plr)
    if plr == LocalPlayer or not plr.Team then return false end
    local teamName = plr.Team.Name
    local currentMode = TargetTeams[CurrentTeamIndex]
    
    if currentMode == "AUTO" then
        return (teamName ~= "" and teamName ~= (LocalPlayer.Team and LocalPlayer.Team.Name))
    elseif currentMode == "POLICE" then
        return (teamName == "Police")
    elseif currentMode == "CRIMINALS" then
        return (teamName == "Criminals")
    end
    return false
end

local function CreateESP(plr)
    if ESPTable[plr] then return end
    local pChar = plr.Character
    local head = pChar and pChar:FindFirstChild("Head")
    if pChar and pChar:FindFirstChild("Humanoid") and head then
        local teamColor = GetTeamColor((plr.Team and plr.Team.Name) or "")
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.Adornee = pChar
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.FillColor = teamColor
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.Parent = pChar
        
        local gui = Instance.new("BillboardGui")
        gui.Name = "ESPName"
        gui.Adornee = head
        gui.Size = UDim2.new(0, 120, 0, 40)
        gui.AlwaysOnTop = true
        gui.StudsOffset = Vector3.new(0, 2.5, 0)
        gui.Parent = head
        
        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = plr.Name
        label.TextColor3 = teamColor
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
        label.TextStrokeTransparency = 0.5
        
        ESPTable[plr] = {container = gui, nameLabel = label, highlight = highlight}
    end
end

local function UpdateESP()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local pChar = plr.Character
            local hum = pChar and pChar:FindFirstChild("Humanoid")
            local root = pChar and pChar:FindFirstChild("HumanoidRootPart")
            local assets = ESPTable[plr]
            if not pChar or not root or not hum then
                if assets then
                    if assets.container then assets.container:Destroy() end
                    if assets.highlight then assets.highlight:Destroy() end
                    ESPTable[plr] = nil
                end
                continue
            end

            local showTarget = ESPEnabled and ShouldShowESP(plr) and (hum.Health > 0)
            if showTarget and myRoot then
                local distance = (myRoot.Position - root.Position).Magnitude
                if distance > 500 then
                    showTarget = false
                end
            end

            if showTarget then
                if not assets then
                    CreateESP(plr)
                    assets = ESPTable[plr]
                end
                if assets then
                    local teamColor = GetTeamColor((plr.Team and plr.Team.Name) or "")
                    assets.container.Enabled = true
                    assets.highlight.Enabled = true
                    assets.nameLabel.TextColor3 = teamColor
                    assets.highlight.FillColor = teamColor
                end
            elseif assets then
                assets.container.Enabled = false
                assets.highlight.Enabled = false
            end
        end
    end
end
task.spawn(function()
    while task.wait(0.25) do
        UpdateESP()
    end
end)

-- b
local function CreateBackButton()
    if BackButton then return end
    BackButton = Instance.new("TextButton", ScreenGui)
    BackButton.Size = UDim2.new(0, 120, 0, 40)
    BackButton.Position = UDim2.new(0.5, -60, 0.1, 0)
    BackButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    BackButton.TextColor3 = UIColors.text
    BackButton.Font = Enum.Font.GothamBold
    BackButton.Text = "BACK"
    BackButton.TextSize = 16
    BackButton.BorderSizePixel = 0
    BackButton.Active = true
    BackButton.Draggable = true

    BackButton.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and SavedPosition then
            char.HumanoidRootPart.CFrame = SavedPosition
            IsAntiDeadActive = false
            RemoveBackButton()
        end
    end)
end


local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude 

local healthConnection 

-- anti dead
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude 

local healthConnection 

local function CheckAntiDead(currentHealth, humanoid, rootPart, char)
    if not AntiDeadEnabled or IsAntiDeadActive then return end
    
    local healthPercent = (currentHealth / humanoid.MaxHealth) * 100

    if healthPercent <= 35 and healthPercent > 0 then 
        IsAntiDeadActive = true
        SavedPosition = rootPart.CFrame 
        
        local forwardVector = rootPart.CFrame.LookVector
        local escapeDistance = 411 
        local targetPos = rootPart.Position - (forwardVector * escapeDistance) + Vector3.new(0, 10, 0) 
        rayParams.FilterDescendantsInstances = {char}
        local groundCheck = workspace:Raycast(targetPos + Vector3.new(0, 50, 0), Vector3.new(0, -100, 0), rayParams)
        
        local finalCFrame
        if groundCheck then
            finalCFrame = CFrame.new(groundCheck.Position + Vector3.new(0, 3, 0))
        else
            finalCFrame = CFrame.new(rootPart.Position - (forwardVector * 50) + Vector3.new(0, 5, 0))
        end

        rootPart.AssemblyLinearVelocity = Vector3.zero
        rootPart.CFrame = finalCFrame
        
        if CreateBackButton then CreateBackButton() end
    end
end




-- Invisibility
local function ToggleInvisibility()
    local char = LocalPlayer.Character
    if not char then return end
    
    for _, obj in ipairs(char:GetDescendants()) do
        if not (obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") or obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
            if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                if obj.Name ~= "HumanoidRootPart" then 
                    obj.Transparency = InvisibilityEnabled and 1 or 0
                end
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = InvisibilityEnabled and 1 or 0
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Highlight") then
                obj.Enabled = not InvisibilityEnabled
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(newChar)
    IsAntiDeadActive = false
    RemoveBackButton()
    if InvisibilityEnabled then
        task.wait(0.5)
        ToggleInvisibility()
    end
end)

local function ToggleFullbright()
    if FullbrightEnabled then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(0.8, 0.8, 0.8)
        Lighting.OutdoorAmbient = Color3.new(0.8, 0.8, 0.8)
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj:IsA("Atmosphere") or obj:IsA("Sky") then obj.Enabled = false end
        end
    else
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.new(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj:IsA("Atmosphere") or obj:IsA("Sky") then obj.Enabled = true end
        end
    end
end

local function RefreshPlayerList()
    for _, child in ipairs(TPScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local count = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            count = count + 1
            local pBtn = Instance.new("TextButton", TPScroll)
            pBtn.Size = UDim2.new(1, -10, 0, 35)
            pBtn.BackgroundColor3 = UIColors.button
            pBtn.TextColor3 = UIColors.text
            pBtn.Font = Enum.Font.Gotham
            pBtn.Text = plr.Name
            pBtn.TextSize = 14
            pBtn.AutoButtonColor = false
            pBtn.BorderSizePixel = 0
            pBtn.LayoutOrder = count

            pBtn.MouseEnter:Connect(function()
                pBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.35)
            end)
            pBtn.MouseLeave:Connect(function()
                pBtn.BackgroundColor3 = UIColors.button
            end)

            pBtn.MouseButton1Click:Connect(function()
                local char = LocalPlayer.Character
                local targetChar = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") and targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                    local rootPart = char.HumanoidRootPart
                    local targetPart = targetChar.HumanoidRootPart
                    local destination = targetPart.CFrame + Vector3.new(0, 3, 0)
                    local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = destination})
                    tween:Play()
                end
            end)
        end
    end
    TPScroll.CanvasSize = UDim2.new(0, 0, 0, count * 40)
end

AimbotBtn.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimbotBtn.Text = "AIMBOT: " .. (AimbotEnabled and "ON" or "OFF")
    AimbotBtn.BackgroundColor3 = AimbotEnabled and UIColors.buttonActive or UIColors.button
end)

TargetBtn.MouseButton1Click:Connect(function()
    CurrentTeamIndex = (CurrentTeamIndex % #TargetTeams) + 1
    TargetBtn.Text = "TARGET: " .. TargetTeams[CurrentTeamIndex]
end)

DistBtn.MouseButton1Click:Connect(function()
    if MaxDistance == 120 then MaxDistance = 200
    elseif MaxDistance == 200 then MaxDistance = 300
    elseif MaxDistance == 300 then MaxDistance = 400
    elseif MaxDistance == 400 then MaxDistance = 500
    else MaxDistance = 120 end
    DistBtn.Text = "DISTANCE: " .. MaxDistance
end)

SmoothBtn.MouseButton1Click:Connect(function()
    Smoothness = (Smoothness == 0.5) and 0.8 or (Smoothness == 0.8 and 0.2) or 0.5
    SmoothBtn.Text = "SMOOTHNESS: " .. Smoothness
end)

ESPBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPBtn.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    ESPBtn.BackgroundColor3 = ESPEnabled and UIColors.buttonActive or UIColors.button
    if ESPEnabled then UpdateESP() else
        for plr, assets in pairs(ESPTable) do
            assets.container:Destroy()
            ESPTable[plr] = nil
        end
    end
end)

BrightBtn.MouseButton1Click:Connect(function()
    FullbrightEnabled = not FullbrightEnabled
    BrightBtn.Text = "FULLBRIGHT: " .. (FullbrightEnabled and "ON" or "OFF")
    BrightBtn.BackgroundColor3 = FullbrightEnabled and UIColors.buttonActive or UIColors.button
    ToggleFullbright()
end)

InvisBtn.MouseButton1Click:Connect(function()
    InvisibilityEnabled = not InvisibilityEnabled
    InvisBtn.Text = "INVISIBILITY: " .. (InvisibilityEnabled and "ON" or "OFF")
    InvisBtn.BackgroundColor3 = InvisibilityEnabled and UIColors.buttonActive or UIColors.button
    ToggleInvisibility()
end)

AntiDeadBtn.MouseButton1Click:Connect(function()
    AntiDeadEnabled = not AntiDeadEnabled
    AntiDeadBtn.Text = "ANTI DEAD: " .. (AntiDeadEnabled and "ON" or "OFF")
    AntiDeadBtn.BackgroundColor3 = AntiDeadEnabled and UIColors.buttonActive or UIColors.button
    if not AntiDeadEnabled then
        IsAntiDeadActive = false
        RemoveBackButton()
    end
end)

TeleportBtn.MouseButton1Click:Connect(function()
    TPFrame.Visible = not TPFrame.Visible
    if TPFrame.Visible then
        RefreshPlayerList()
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    MenuVisible = not MenuVisible
    MainFrame.Visible = MenuVisible
    if not MenuVisible then TPFrame.Visible = false end
    ToggleBtn.Text = MenuVisible and "Thien Truc" or "Ez Cheat"
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.V then
        AimbotEnabled = not AimbotEnabled
        AimbotBtn.Text = "AIMBOT: " .. (AimbotEnabled and "ON" or "OFF")
        AimbotBtn.BackgroundColor3 = AimbotEnabled and UIColors.buttonActive or UIColors.button
    end
end)

-- for mb
if IsMobile then
    local AimMobileBtn = Instance.new("TextButton", ScreenGui)
    AimMobileBtn.Size = UDim2.new(0, 70, 0, 70)
    AimMobileBtn.Position = UDim2.new(1, -90, 1, -160)
    AimMobileBtn.BackgroundColor3 = UIColors.header
    AimMobileBtn.TextColor3 = UIColors.text
    AimMobileBtn.Text = "AIM"
    AimMobileBtn.Font = Enum.Font.GothamBold
    AimMobileBtn.TextSize = 16
    AimMobileBtn.BorderSizePixel = 0
    AimMobileBtn.MouseButton1Click:Connect(function()
        AimbotEnabled = not AimbotEnabled
        AimMobileBtn.Text = AimbotEnabled and "ON" or "OFF"
        AimMobileBtn.BackgroundColor3 = AimbotEnabled and UIColors.buttonActive or UIColors.header
        AimbotBtn.Text = "AIMBOT: " .. (AimbotEnabled and "ON" or "OFF")
        AimbotBtn.BackgroundColor3 = AimbotEnabled and UIColors.buttonActive or UIColors.button
    end)
end

RunService.RenderStepped:Connect(function()
    if ESPEnabled then UpdateESP() end
    CheckAntiDead()
end)
