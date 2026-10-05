-- ตรวจสอบว่าเคยรันไปแล้วหรือยัง
if _G.WindUI_AlreadyLoaded then
    warn("❌ สคริปต์นี้ถูกรันไปแล้ว และอนุญาตให้รันได้แค่ 1 รอบเท่านั้น!")
    warn("💡 หากต้องการรันใหม่อีกครั้ง กรุณารีเกม (Rejoin) หรือรีเซ็ตสคริปต์ใหม่")
    return
end
_G.WindUI_AlreadyLoaded = true

local startTime = tick()

local _version = "1.6.66"
if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _version .. "/main.lua"))()

WindUI:Notify({
    Title = "WindUI Status",
    Content = "⏳ กำลังรันสคริปต์...",
    Duration = 3
})

task.wait(0.5)

local endTime = tick()
local duration = string.format("%.2f", endTime - startTime)

WindUI:Notify({
    Title = "WindUI Status",
    Content = "✅ รันเสร็จแล้ว! ใช้เวลาไป " .. duration .. " วินาที",
    Duration = 5
})

local success, Window = pcall(function()
    return WindUI:CreateWindow({
        Title = "Project Destiny [v3.0] ",
        Icon = "rbxassetid://95386367904989",
        Author = "System Online • Access Granted",
        Folder = "Destiny Hub",
        Size = UDim2.fromOffset(620, 558),
        Transparent = true,
        Theme = "Dark",
        Resizable = true,
        SideBarWidth = 200,
        HideSearchBar = false,
        ScrollBarEnabled = true,
    })
end)
Window:SetIconSize(25) 
Window:DisableTopbarButtons({ "Close", "Minimize" })
Window:Section({ Title = "Cnotrol Panel" })
local Home = Window:Tab({ Title = "Changelog !!", Icon = "clipboard-list" })
local GeneralTab = Window:Tab({ Title = "General Main", Icon = "gauge" })
Window:Divider() 
Window:Section({ Title = "Combat(PvP)" })
local CombatTab = Window:Tab({ Title = "Aimbot PvP", Icon = "swords" })
local Visuals = Window:Tab({ Title = "Visuals (ESP)", Icon = "crosshair" })
local System = Window:Tab({ Title = "System /Core", Icon = "package" })
Window:Divider() 
Window:Section({ Title = "Configuration" })
local Bounty = Window:Tab({ Title = "Bounty Hunting", Icon = "moon" })
local Config = Window:Tab({ Title = "Settings Config", Icon = "wrench" })
CombatTab:Select()

local MyConfig = Window.ConfigManager:Config("DestinyConfig")
task.spawn(function()
    task.wait()
    pcall(function() MyConfig:Load() end)
end)

Window:CreateTopbarButton("ToggleMinimize", "minimize-2", function() Window:Close() end, 5, true, 17)
Window:CreateTopbarButton("swords", "swords", function() CombatTab:Select() end, 3, true, 17)
local Group = Config:Group({})
local Progress = Config:ProgressBar({
    Title = "files...",
    Value = { Min = 0, Max = 100, Default = 0 },
    DisplayMode = "Value",
    Width = 220,
})
Group:Button({
    Title="Save",
    Desc="Save settings",
    Icon="save",
    Callback=function()
        if MyConfig and typeof(MyConfig.Save)=="function" then
            Progress:Set(30)
            task.wait(.3)
            MyConfig:Save()
            Progress:Set(70)
            task.wait(.3)
            Progress:Set(100)
            WindUI:Notify({
                Title="System Saved",
                Content="Saved successfully!",
                Icon="bell-ring",
                Duration=3
            })

            task.delay(1.5,function()
                Progress:Set(0)
            end)
        else
            WindUI:Notify({
                Title="Error",
                Content="Config not found!",
                Icon="x",
                Duration=3
            })
        end
    end
})
Group:Button({
    Title = "Reset",
    Desc = "Reset to default",
    Icon  = "rotate-ccw",
    Callback = function()
        pcall(function()
            if MyConfig and typeof(MyConfig.Delete) == "function" then
                MyConfig:Delete()
            end
        end)
        WindUI:Notify({ Title = "System Warning", Content = "Settings reset!", Icon = "bell-ring", Duration = 3 })
    end,
})


local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local C = {
    Green  = "#4ADE80",
    Amber  = "#FBBF24",
    Red    = "#F87171",
    Cyan   = "#A78BFA",
    Purple = "#C4B5FD",
    Muted  = "#9CA3BC",
    Dim    = "#3B3F58",
    White  = "#F5F3FF",
}
local function font(color, text)
    return string.format(
        '<font color="%s">%s</font>',
        color,
        text
    )
end
local executorName = "Unknown"

pcall(function()
    if type(identifyexecutor) == "function" then
        local n = identifyexecutor()
        if n then
            executorName = tostring(n)
        end
    elseif type(getexecutorname) == "function" then
        local n = getexecutorname()
        if n then
            executorName = tostring(n)
        end
    end
end)

local username = LP and LP.Name or "Unknown"
local displayName = LP and LP.DisplayName or username

local function copyToClipboard(text, label)
    local ok, err = pcall(function()
        if type(setclipboard) == "function" then
            setclipboard(text)
        else
            error("setclipboard is not available")
        end
    end)

    if not ok then
        warn("[Destiny Hub] " .. label .. " error: " .. tostring(err))
    end
end
local dashboardText = table.concat({

    string.format(
        '<b>%s</b>  %s',
        font(C.White, "SYSTEM OVERVIEW"),
        font(C.Muted, "• live")
    ),

    font(C.Dim, "━━━━━━━━━━━━━━━━━━━━"),

    string.format(
        '%s  Executor     %s',
        font(C.Cyan, "◆"),
        font(C.Cyan, "<b>" .. executorName .. "</b>")
    ),

    string.format(
        '%s  Username     %s',
        font(C.Purple, "◆"),
        font(C.White, username)
    ),

    "",

    string.format(
        '%s  Status       %s',
        font(C.Green, "◆"),
        font(C.Green, "<b>Ready</b>")
    ),

    "",

    font(C.Dim, "━━━━━━━━━━━━━━━━━━━━"),

    string.format(
        '%s <b>%s</b>%s',
        font(C.Muted, "Welcome back,"),
        font(C.White, displayName),
        font(C.Muted, ".")
    ),

    string.format(
        '%s %s',
        font(C.Muted, "Enjoy your experience with"),
        font(C.Purple, "<b>Destiny Hub</b>")
    ),

}, "\n")

Home:Paragraph({
    Title = "✦ Destiny Hub | Dashboard",
    Desc = dashboardText,

    ImageSize = 50,
    Thumbnail = "rbxassetid://101880822615713",
    ThumbnailSize = 70,

    Buttons = {
        {
            Title = "Discord",
            Callback = function()
                copyToClipboard(
                    "https://discord.gg/hUMaVECvBz",
                    "Clipboard"
                )
            end,
        },

        {
            Title = "Report",
            Callback = function()
                local report = table.concat({
                    "Destiny Hub | Dashboard",
                    "Executor: " .. executorName,
                    "Username: " .. username,
                    "Display: " .. displayName,
                    "Status: Ready",
                }, "\n")

                copyToClipboard(report, "Report")
            end,
        },
    },
})

getgenv().SavedFOVRadius = getgenv().SavedFOVRadius or getgenv().FOVRadius
getgenv().SilentAimMode = getgenv().SilentAimMode or "FOV"
getgenv().FOVRadius = getgenv().FOVRadius or 100
getgenv().MaxDistance = getgenv().MaxDistance or 1000
getgenv().SilentAimEnabled = getgenv().SilentAimEnabled ~= false and true
getgenv().ShowFOV = getgenv().ShowFOV ~= false and true
getgenv().ShowTracer = getgenv().ShowTracer ~= false and true
getgenv().CurrentTarget = nil
getgenv().FOVPositionMode = getgenv().FOVPositionMode or "Middle" 
getgenv().LockedPartName = "HumanoidRootPart"
getgenv().PredictionEnabled = getgenv().PredictionEnabled ~= false and true
getgenv().PredictionFactor = getgenv().PredictionFactor or 0.135
getgenv().CamlockEnabled = getgenv().CamlockEnabled ~= false and true

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

if LocalPlayer.PlayerGui:FindFirstChild("MobileAimbotGui") then
    LocalPlayer.PlayerGui.MobileAimbotGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileAimbotGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local FOVThemeColor = _G.FOVThemeColor or Color3.fromRGB(255, 255, 255)

local FOVUI = Instance.new("Frame")
FOVUI.Name = "FOVCircle"
FOVUI.AnchorPoint = Vector2.new(0.5, 0.5)
FOVUI.BackgroundTransparency = 1
FOVUI.Visible = false
FOVUI.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = FOVUI

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1.5
UIStroke.Color = FOVThemeColor
UIStroke.Transparency = 0.3
UIStroke.Parent = FOVUI

local CenterDot = Instance.new("Frame")
CenterDot.Name = "CenterDot"
CenterDot.AnchorPoint = Vector2.new(0.5, 0.5)
CenterDot.Position = UDim2.new(0.5, 0, 0.5, 0)
CenterDot.BackgroundColor3 = FOVThemeColor
CenterDot.BackgroundTransparency = 0.2
CenterDot.Parent = FOVUI

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = CenterDot

local Snapline = Drawing.new("Line")
Snapline.Visible = false
Snapline.Thickness = 1.5            
Snapline.Color = Color3.fromRGB(255, 255, 255) 
Snapline.Transparency = 1                
Snapline.From = Vector2.new(0, 0)        
Snapline.To = Vector2.new(0, 0)

local LastMousePosition = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

local function UpdateFOVPosition(pos)
    if not FOVUI or not FOVUI.Visible then return end
    local cachedFOVMode = tostring(getgenv().FOVPositionMode):lower()
    local viewportSize = Camera.ViewportSize
    
    local targetPos
    if cachedFOVMode:find("mouse") or cachedFOVMode:find("touch") then
        targetPos = pos or LastMousePosition
    else
        targetPos = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    end
    
    FOVUI.Position = UDim2.new(0, targetPos.X, 0, targetPos.Y)
end

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        LastMousePosition = Vector2.new(input.Position.X, input.Position.Y)
        UpdateFOVPosition(LastMousePosition)
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        LastMousePosition = Vector2.new(input.Position.X, input.Position.Y)
        UpdateFOVPosition(LastMousePosition)
    end
end)

local safeZonesFolder = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("SafeZones")
local combatCache = {}
local safeZoneCache = {}
local lastCacheClear = tick()
local lastEnemiesCheck = 0
local cachedEnemiesFolder = nil

local function getCachedEnemiesFolder()
    local now = tick()
    if now - lastEnemiesCheck > 1 then
        cachedEnemiesFolder = Workspace:FindFirstChild("Enemies")
        lastEnemiesCheck = now
    end
    return cachedEnemiesFolder
end

local function clearCacheIfNeeded()
    local now = tick()
    if now - lastCacheClear >= 1.0 then
        table.clear(combatCache)
        table.clear(safeZoneCache)
        lastCacheClear = now
    end
end

local function isPlayerInCombat(player, character)
    if not player then return false end
    if combatCache[player] ~= nil then return combatCache[player] end
    
    local pCombat = player:GetAttribute("InCombat") or player:GetAttribute("Combat") or player:GetAttribute("CombatTag")
    if pCombat == true or pCombat == 1 or pCombat == "1" then
        combatCache[player] = true
        return true
    end
    
    local combatTime = player:GetAttribute("CombatTimer") or player:GetAttribute("InCombatTime")
    if type(combatTime) == "number" and combatTime > workspace:GetServerTimeNow() then
        combatCache[player] = true
        return true
    end

    if character then
        local cCombat = character:GetAttribute("InCombat") or character:GetAttribute("Combat") or character:GetAttribute("CombatTag")
        if cCombat == true or cCombat == 1 or cCombat == "1" then
            combatCache[player] = true
            return true
        end
        local combatObj = character:FindFirstChild("InCombat") 
            or character:FindFirstChild("Combat") 
            or character:FindFirstChild("CombatTag")
            or character:FindFirstChild("PvpTag")

        if combatObj then
            combatCache[player] = true
            return true
        end
    end

    combatCache[player] = false
    return false
end

local function isInSafeZoneRadius(character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end
    if not safeZonesFolder then return false end
    
    local charPos = character.HumanoidRootPart.Position
    
    for _, zonePart in ipairs(safeZonesFolder:GetChildren()) do
        if zonePart:IsA("BasePart") then
            local zonePos = zonePart.Position
            local radius
            
            local mesh = zonePart:FindFirstChildOfClass("SpecialMesh")
            radius = mesh and (mesh.Scale.X / 2) * math.max(zonePart.Size.X, zonePart.Size.Z) or math.max(zonePart.Size.X, zonePart.Size.Z) / 2
            
            if (charPos - zonePos).Magnitude <= radius then
                return true
            end
        end
    end
    
    return false
end

local function isPlayerInSafeZone(player, character)
    if not player then return false end
    if isPlayerInCombat(player, character) then
        safeZoneCache[player] = false
        return false
    end

    if safeZoneCache[player] ~= nil then return safeZoneCache[player] end

    local inSafeZoneAttr = player:GetAttribute("SafeZone") or (character and character:GetAttribute("SafeZone"))
    local inRadius = character and isInSafeZoneRadius(character)
    local hasTempSafeZone = character and character:FindFirstChild("TempSafeZone")
    
    local result = (inSafeZoneAttr == true or inRadius or hasTempSafeZone) == true
    safeZoneCache[player] = result
    return result
end

local function ShouldIgnoreTarget(targetCharacter, targetPlayer)
    local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health <= 0 then return true end

    local enemiesFolder = getCachedEnemiesFolder()
    if enemiesFolder and targetCharacter:IsDescendantOf(enemiesFolder) then
        return false 
    end

    if not targetPlayer or targetPlayer == LocalPlayer then return true end
    if targetPlayer:GetAttribute("PvpDisabled") == true then return true end
    if isPlayerInSafeZone(targetPlayer, targetCharacter) then return true end
    
    if LocalPlayer.Team and LocalPlayer.Team.Name == "Marines" and targetPlayer.Team == LocalPlayer.Team then
        return true
    end
    
    return false
end

local cachedValidTargets = {}
local lastTargetUpdate = 0
local targetUpdateInterval = 0.2 -- ลดเวลาแคชเป้าหมายให้ลื่นขึ้นเล็กน้อยแต่ยังประหยัดแรม

local function UpdateValidTargets()
    table.clear(cachedValidTargets)  
    local mode = getgenv().TargetMode or "Both"
    
    if mode == "Both" or mode == "Players Only" then
        local players = Players:GetPlayers()
        for i = 1, #players do
            local player = players[i]
            if player ~= LocalPlayer and player.Character then
                table.insert(cachedValidTargets, player.Character)
            end
        end
    end
    
    if mode == "Both" or mode == "Enemies Only" then
        local enemiesFolder = getCachedEnemiesFolder()
        if enemiesFolder then
            local children = enemiesFolder:GetChildren()
            for i = 1, #children do
                local enemyModel = children[i]
                if enemyModel:IsA("Model") then
                    table.insert(cachedValidTargets, enemyModel)
                end
            end
        end
    end
end

local function GetAllValidTargets()
    if tick() - lastTargetUpdate >= targetUpdateInterval then
        lastTargetUpdate = tick()
        UpdateValidTargets()
    end
    return cachedValidTargets
end

local function GetReferencePosition()
    local viewportSize = Camera.ViewportSize
    local mode = tostring(getgenv().FOVPositionMode):lower()

    if mode == "mouse/touch" or mode == "mousetouch" or mode == "mouse" or mode == "touch" then
        return LastMousePosition
    end

    return Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
end

local function GetTargetInFOV(refPos)
    local ClosestTarget = nil
    local fovRadius = getgenv().FOVRadius or 100
    local ShortestDistance = (fovRadius >= 99999) and 99999 or fovRadius
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    if not myHRP then return nil end
    
    local maxDistance = getgenv().MaxDistance or 500
    local validTargets = GetAllValidTargets()
    
    for i = 1, #validTargets do
        local char = validTargets[i]
        local targetPart = char:FindFirstChild(getgenv().LockedPartName) or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
        local humanoid = char:FindFirstChildOfClass("Humanoid")

        if targetPart and humanoid and humanoid.Health > 0 then
            local targetPlayer = Players:GetPlayerFromCharacter(char)
            if not ShouldIgnoreTarget(char, targetPlayer) then
                local worldDistance = (targetPart.Position - myHRP.Position).Magnitude
                
                if worldDistance <= maxDistance then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - refPos).Magnitude
                        if distance < ShortestDistance then
                            ShortestDistance = distance
                            ClosestTarget = targetPart
                        end
                    end
                end
            end
        end
    end
    return ClosestTarget
end

getgenv().SilentAimEnabled = getgenv().SilentAimEnabled or false
getgenv().CurrentTarget = getgenv().CurrentTarget or nil

local lastTarget = nil

local function ClearOldData()
    lastTarget = nil
end

task.spawn(function()
    local function getRoot()
        local target = getgenv().CurrentTarget
        if target ~= lastTarget then
            ClearOldData()
            lastTarget = target
        end

        if target and target.Parent then
            local character = target.Parent
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if humanoid and humanoid.Health <= 0 then
                getgenv().CurrentTarget = nil
                ClearOldData()
                return nil
            end

            return character:FindFirstChild("HumanoidRootPart")
        end
        
        ClearOldData()
        return nil
    end

    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local target = getgenv().CurrentTarget
        local enabled = getgenv().SilentAimEnabled
        local args = { ... }

        if method == "FireServer" or method == "InvokeServer" then
            if self then
                local ignoredRemotes = {
                    "CommE",            
                    "RE/RegisterHit",    
                    "RE/RegisterAttack", 
                    "LeftClickRemote"    
                }
                if table.find(ignoredRemotes, self.Name) then
                    return oldNamecall(self, unpack(args))
                end
            end
        end

        if target then
            if enabled and method == "Raycast" and self == workspace then
                local targetPos = target.Position
                if targetPos and args[1] then
                    local origin = args[1]  
                    local currentDir = args[2]  
                    local distance = currentDir and currentDir.Magnitude or 1000

                    args[2] = (targetPos - origin).Unit * distance
                    return oldNamecall(self, unpack(args))
                end
            end

            if enabled or UserInputService.TouchEnabled then
                if method == "ScreenPointToRay" or method == "ViewportPointToRay" then
                    local r = getRoot()
                    if r then 
                        return Ray.new(Camera.CFrame.Position, (r.Position - Camera.CFrame.Position).Unit * 1000) 
                    end
                end
            end

            if enabled and (method == "FireServer" or method == "InvokeServer") then
                local targetPos = target.Position
                if targetPos then
                    for i = 1, #args do
                        local arg = args[i]
                        local argType = typeof(arg)
                        if argType == "Vector3" then
                            args[i] = targetPos
                        elseif argType == "CFrame" then
                            args[i] = arg - arg.Position + targetPos
                        end
                    end
                    return oldNamecall(self, unpack(args))
                end
            end
        end

        return oldNamecall(self, unpack(args))
    end))
end)


local currentUiColor = Color3.fromRGB(255, 255, 255)
local displayedUiColor = currentUiColor
local lastFOVUpdate = 0
local lastSnaplineUpdate = 0

local function clearOldData()
    getgenv().CurrentTarget = nil
end

RunService.RenderStepped:Connect(function(dt)
    if (not getgenv().SilentAimEnabled and not getgenv().CamlockEnabled) or not getgenv().ShowTracer then
        if Snapline then
            Snapline.Visible = false
        end
    end

    clearCacheIfNeeded()

    displayedUiColor = displayedUiColor:Lerp(currentUiColor, math.clamp(dt * 20, 0, 1))

    local character = LocalPlayer.Character
    if not character or not Camera then
        clearOldData()
        return
    end

    local myRoot = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    if not myRoot then
        clearOldData()
        return
    end

    local refPos = GetReferencePosition()
    local mode = getgenv().SilentAimMode

    local now = tick()
    if now - lastFOVUpdate > 0.05 then
        lastFOVUpdate = now
        
        if FOVUI then
            if mode == "360°" or mode == "180°" then
                FOVUI.Visible = false
            else
                local shouldShow = getgenv().ShowFOV == true
                FOVUI.Visible = shouldShow
                if shouldShow then
                    UpdateFOVPosition(refPos)
                    local size = (getgenv().FOVRadius or 100) * 2
                    FOVUI.Size = UDim2.new(0, size, 0, size)
                    if UIStroke then UIStroke.Color = displayedUiColor end
                end
            end
        end
    end

    if not getgenv().SilentAimEnabled and not getgenv().CamlockEnabled then
        clearOldData()
        return
    end

    local bestTarget = nil
    local shortestDistance = math.huge
    local maxDistance = getgenv().MaxDistance or 1000
    local validTargets = GetAllValidTargets()

    if mode == "360°" or mode == "180°" then
        local lookVector = Camera.CFrame.LookVector
        local cameraPos = Camera.CFrame.Position

        for i = 1, #validTargets do
            local char = validTargets[i]
            if char and char ~= character then
                local rootPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
                local humanoid = char:FindFirstChildOfClass("Humanoid")

                if rootPart and humanoid and humanoid.Health > 0 then
                    local targetPlayer = Players:GetPlayerFromCharacter(char)
                    if not ShouldIgnoreTarget(char, targetPlayer) then
                        local valid = true
                        if mode == "180°" then
                            valid = lookVector:Dot((rootPart.Position - cameraPos).Unit) > 0
                        end

                        if valid then
                            local distance = (myRoot.Position - rootPart.Position).Magnitude
                            if distance <= maxDistance and distance < shortestDistance then
                                shortestDistance = distance
                                bestTarget = rootPart
                            end
                        end
                    end
                end
            end
        end
    else
        bestTarget = GetTargetInFOV(refPos)
    end
    
    getgenv().CurrentTarget = bestTarget

   if getgenv().CamlockEnabled and bestTarget then
        local targetPart = bestTarget
        if typeof(targetPart) == "Instance" and targetPart:IsA("Model") then
            targetPart = targetPart:FindFirstChild("HumanoidRootPart") or targetPart.PrimaryPart or targetPart:FindFirstChild("Head")
        end

        if targetPart and targetPart:IsA("BasePart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
        end
    end
    if now - lastSnaplineUpdate > 0.033 then
        lastSnaplineUpdate = now
        
        if bestTarget and getgenv().ShowTracer and (getgenv().SilentAimEnabled or getgenv().CamlockEnabled) and Snapline then
            local targetPart = bestTarget
            if typeof(targetPart) == "Instance" and targetPart:IsA("Model") then
                targetPart = targetPart:FindFirstChild("HumanoidRootPart") or targetPart.PrimaryPart or targetPart:FindFirstChild("Head")
            end

            if targetPart and targetPart:IsA("BasePart") then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen and screenPos.Z > 0 then
                    local origin = getgenv().TracerOrigin or "Center"
                    local startPos

                    if origin == "Center" then
                        startPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    elseif origin == "Bottom" then
                        startPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    else
                        local myPos = Camera:WorldToViewportPoint(myRoot.Position)
                        startPos = Vector2.new(myPos.X, myPos.Y)
                    end

                    Snapline.From = startPos
                    Snapline.To = Vector2.new(screenPos.X, screenPos.Y)
                    Snapline.Color = displayedUiColor
                    Snapline.Thickness = getgenv().TracerThickness or 1
                    Snapline.Transparency = getgenv().TracerTransparency or 1
                    Snapline.Visible = true
                else
                    Snapline.Visible = false
                end
            else
                Snapline.Visible = false
            end
        else
            if Snapline then
                Snapline.Visible = false
            end
        end
    end
end)


local function initializeSkillSettings()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
local CommF = Remotes:WaitForChild("CommF_", 10)
local commE = Remotes:WaitForChild("CommE", 10)

-- Settings variables
local JumpEnabled = false
local JumpMultiplier = 1
local DashEnabled = false
local DashMultiplier = 1

local autoRaceConnection
local autoRaceV4Connection

local function GetCharacter()
    local f = Workspace:FindFirstChild("Characters")
    return (f and f:FindFirstChild(LocalPlayer.Name)) or LocalPlayer.Character
end

local function UpdateJump(h)
    h.UseJumpPower = true
    h.JumpPower = 50 * JumpMultiplier
end

local function UpdateDash(c, h, dt)
    if h.MoveDirection.Magnitude > 0 then
        c:TranslateBy(h.MoveDirection * 25 * DashMultiplier * dt)
    end
end

-- ฟังก์ชันเปิดใช้งานเผ่า (Race Ability)
local function SetAutoRaceAbility(state)
    _G.AutoRaceAbilityRunning = state

    if autoRaceConnection then
        autoRaceConnection:Disconnect()
        autoRaceConnection = nil
    end
    if not state then return end

    local last = 0
    autoRaceConnection = RunService.Heartbeat:Connect(function()
        if not _G.AutoRaceAbilityRunning then return end
        local now = tick()
        if now - last < 0.5 then return end
        last = now

        pcall(function()
            local c = LocalPlayer.Character
            if c and c:FindFirstChild("HumanoidRootPart") and commE then
                commE:FireServer("ActivateAbility")
            end
        end)
    end)
end

-- ฟังก์ชันเปิดใช้งานเผ่า V4 (Awakening)
local function SetAutoRaceV4(state)
    _G.AutoRaceV4Running = state

    if autoRaceV4Connection then
        autoRaceV4Connection:Disconnect()
        autoRaceV4Connection = nil
    end
    if not state then return end

    local last = 0
    autoRaceV4Connection = RunService.Heartbeat:Connect(function()
        if not _G.AutoRaceV4Running then return end
        local now = tick()
        if now - last < 0.1 then return end
        last = now

        pcall(function()
            local c = LocalPlayer.Character
            if not c or not c:FindFirstChild("HumanoidRootPart") then return end

            local b = LocalPlayer:FindFirstChild("Backpack")
            local a = b and b:FindFirstChild("Awakening")
            local r = a and a:FindFirstChild("RemoteFunction")
            if r then 
                r:InvokeServer(true) 
            end
        end)
    end)
end

-- BUSO CHECKER (ส่งรีโมทซ้ำๆ ทันทีหากยังไม่พบ HasBuso)
local function CheckAndEnableBuso()
    local c = GetCharacter()
    if not c then return end

    local b = c:FindFirstChild("HasBuso")
    if not b or (b:IsA("BoolValue") and not b.Value) then
        if CommF then
            pcall(function()
                CommF:InvokeServer("Buso")
            end)
        end
    end
end

-- ลูปหลักสำหรับควบคุมการเคลื่อนไหว, Dash และออร่า (เช็คฮาคิตลอดเวลาไม่มีคูลดาวน์)
RunService.RenderStepped:Connect(function(dt)
    local c = GetCharacter()
    if not c then return end

    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return end

    -- จัดการเรื่องกระโดด
    if JumpEnabled then
        UpdateJump(h)
    elseif h.JumpPower ~= 50 then
        h.JumpPower = 50
    end

    -- จัดการเรื่อง Dash
    if DashEnabled then
        UpdateDash(c, h, dt)
    end

    -- ตรวจสอบและส่งรีโมทเปิดฮาคิเกราะซ้ำๆ ทันที
    CheckAndEnableBuso()
end)
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Workspace=game:GetService("Workspace")
local LocalPlayer=Players.LocalPlayer

local ENV = getgenv() 

ENV=ENV or {}

ENV.ESPConfig=ENV.ESPConfig or {
    ShowName=false,
    ShowDistance=false,
    ShowLevel=false,
    ShowBounty=false,
    ShowHealth=false,
    ShowStatus=false,
    ShowAllTeams=true,
    Pirates=true,
    Marines=true
}

ENV.COLORS=ENV.COLORS or {
	Pirates=Color3.fromRGB(255,35,75),
	Marines=Color3.fromRGB(0,190,255),
	Neutral=Color3.fromRGB(230,230,240),
	White=Color3.fromRGB(255,255,255),
	Muted=Color3.fromRGB(170,170,190),
	HPBG=Color3.fromRGB(8,8,14),
	HPHigh=Color3.fromRGB(0,255,120),
	HPMid=Color3.fromRGB(255,220,0),
	HPLow=Color3.fromRGB(255,35,65),
	Level=Color3.fromRGB(255,220,0),
	Bounty=Color3.fromRGB(255,60,210),
	PvPOn=Color3.fromRGB(50,255,100),
	PvPOff=Color3.fromRGB(255,50,80),
	SafeZoneOn=Color3.fromRGB(0,235,255),
	SafeZoneOff=Color3.fromRGB(255,125,30),
	Combat=Color3.fromRGB(255,215,0),
	Outline=Color3.fromRGB(5,5,10)
}

local ESPConfig=ENV.ESPConfig
local ESP=ESPConfig
local C=ENV.COLORS

if ENV.__ESPCleanup then
	pcall(ENV.__ESPCleanup)
end

local Registry={}
local CachedPlayers={}
local GlobalConns={}
local SafeZones={}
local SafeZoneTime=0
local MyRoot=nil
local MyRootTime=0
local DISTANCE_INTERVAL=.2
local Update
local Remove

-- ===== OPTIMIZATION: Cache SafeZone check result =====
local safeZoneCache={}
local safeZoneCacheTime=0
local SAFEZONE_CACHE_INTERVAL=2

local function Hex(c)
	return string.format("#%02X%02X%02X",math.floor(c.R*255+.5),math.floor(c.G*255+.5),math.floor(c.B*255+.5))
end

local function Colored(t,c)
	return '<font color="'..Hex(c)..'">'..tostring(t)..'</font>'
end

local function FormatNumber(n)
	if type(n)~="number" then
		return tostring(n)
	end
	if n>=1e9 then
		return string.format("%.1fB",n/1e9)
	elseif n>=1e6 then
		return string.format("%.1fM",n/1e6)
	elseif n>=1e3 then
		return string.format("%.1fK",n/1e3)
	end
	return tostring(n)
end

local function RefreshSafeZones()
	table.clear(SafeZones)
	table.clear(safeZoneCache)

	local origin=Workspace:FindFirstChild("_WorldOrigin")
	local folder=origin and origin:FindFirstChild("SafeZones")

	if folder then
		local children=folder:GetChildren()
		for i=1,#children do
			local zone=children[i]
			if zone:IsA("BasePart") then
				local mesh=zone:FindFirstChildOfClass("SpecialMesh")
				SafeZones[#SafeZones+1]={
					Position=zone.Position,
					Radius=mesh and mesh.Scale.X*.5*math.max(zone.Size.X,zone.Size.Z) or math.max(zone.Size.X,zone.Size.Z)*.5
				}
			end
		end
	end

	SafeZoneTime=os.clock()
end

local function IsSafeZone(character)
	if not character then
		return false
	end

	local root=character:FindFirstChild("HumanoidRootPart")

	if not root then
		return false
	end

	-- ===== OPTIMIZATION: Cache result ทุก 2 วินาที =====
	if os.clock()-SafeZoneTime>=5 then
		RefreshSafeZones()
	end

	-- Check cache first
	if safeZoneCache[character] and os.clock()-safeZoneCacheTime<SAFEZONE_CACHE_INTERVAL then
		return safeZoneCache[character]
	end

	local pos=root.Position
	local result=false

	for i=1,#SafeZones do
		local zone=SafeZones[i]
		local x=pos.X-zone.Position.X
		local y=pos.Y-zone.Position.Y
		local z=pos.Z-zone.Position.Z

		if x*x+y*y+z*z<=zone.Radius*zone.Radius then
			result=true
			break
		end
	end

	safeZoneCache[character]=result
	safeZoneCacheTime=os.clock()

	return result
end

local function GetTeam(player)
	local name=player.Team and player.Team.Name or "Neutral"
	if ESP.ShowAllTeams then
		return name,C[name] or C.Neutral,true
	end
	if name=="Pirates" then
		return name,C.Pirates,ESP.Pirates==true
	end
	if name=="Marines" then
		return name,C.Marines,ESP.Marines==true
	end
	return name,C.Neutral,true
end

local levelCache={}

local function GetLevel(player)
	if levelCache[player] then
		return levelCache[player]
	end

	local data=player:FindFirstChild("Data")

	if data then
		local level=data:FindFirstChild("Level")
		if level then
			levelCache[player]=level.Value
			return level.Value
		end
	end

	local stats=player:FindFirstChild("leaderstats")

	if stats then
		local level=stats:FindFirstChild("Level")
		if level then
			levelCache[player]=level.Value
			return level.Value
		end
	end

	levelCache[player]="?"
	return "?"
end

local bountyCache={}

local function GetBounty(player)
	if bountyCache[player]~=nil then
		return bountyCache[player]
	end

	local stats=player:FindFirstChild("leaderstats")

	if not stats then
		bountyCache[player]=0
		return 0
	end

	local bounty=stats:FindFirstChild("Bounty/Honor")
	local value=bounty and bounty.Value or 0

	bountyCache[player]=value
	return value
end

local function GetStatus(player,character)
	local pvpOff=player:GetAttribute("PvpDisabled")==true

	local safe=
		player:GetAttribute("SafeZone")==true
		or character:GetAttribute("SafeZone")==true
		or IsSafeZone(character)

	local combat=
		player:GetAttribute("InCombat")==true
		or player:GetAttribute("InCombat")==1
		or player:GetAttribute("InCombat")=="1"

	return
		pvpOff and "OFF" or "ON",
		pvpOff and C.PvPOff or C.PvPOn,
		safe and "SAFE" or "NORMAL",
		safe and C.SafeZoneOn or C.SafeZoneOff,
		combat and "COMBAT" or "READY",
		combat and C.Combat or C.Muted
end

local function Label(parent,name,order,height,size)
	local label=Instance.new("TextLabel")

	label.Name=name
	label.LayoutOrder=order
	label.Size=UDim2.new(1,0,0,height)
	label.BackgroundTransparency=1
	label.RichText=true
	label.Text=""
	label.TextSize=size
	label.Font=Enum.Font.GothamBold
	label.TextColor3=C.White
	label.TextStrokeColor3=C.Outline
	label.TextStrokeTransparency=0
	label.TextXAlignment=Enum.TextXAlignment.Center
	label.TextYAlignment=Enum.TextYAlignment.Center
	label.Parent=parent

	return label
end

local function BuildUI(gui)
	local card=Instance.new("Frame")
	card.Name="Card"
	card.Size=UDim2.new(0,190,0,0)
	card.AutomaticSize=Enum.AutomaticSize.Y
	card.BackgroundTransparency=1
	card.Parent=gui

	local padding=Instance.new("UIPadding")
	padding.PaddingTop=UDim.new(0,6)
	padding.PaddingBottom=UDim.new(0,6)
	padding.PaddingLeft=UDim.new(0,8)
	padding.PaddingRight=UDim.new(0,8)
	padding.Parent=card

	local layout=Instance.new("UIListLayout")
	layout.SortOrder=Enum.SortOrder.LayoutOrder
	layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
	layout.Padding=UDim.new(0,3)
	layout.Parent=card

	local name=Label(card,"Name",1,16,12)
	local status=Label(card,"Status",2,12,9)
	local info=Label(card,"Info",3,13,10)

	local hp=Instance.new("Frame")
	hp.Name="HPBG"
	hp.LayoutOrder=4
	hp.Size=UDim2.new(1,0,0,11)
	hp.BackgroundColor3=C.HPBG
	hp.BorderSizePixel=0
	hp.ClipsDescendants=true
	hp.Parent=card

	Instance.new("UICorner",hp).CornerRadius=UDim.new(1,0)

	local fill=Instance.new("Frame")
	fill.Name="Fill"
	fill.Size=UDim2.new(1,0,1,0)
	fill.BackgroundColor3=C.HPHigh
	fill.BorderSizePixel=0
	fill.Parent=hp

	Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)

	local hpText=Instance.new("TextLabel")
	hpText.Name="HPText"
	hpText.Size=UDim2.new(1,0,1,0)
	hpText.BackgroundTransparency=1
	hpText.Text=""
	hpText.TextSize=8
	hpText.Font=Enum.Font.GothamBold
	hpText.TextColor3=C.White
	hpText.Parent=hp

	return {
		Card=card,
		Name=name,
		Status=status,
		Info=info,
		HPBG=hp,
		Fill=fill,
		HPText=hpText
	}
end

local function ClearCharacter(entry)
	for _,connection in ipairs(entry.CharConns) do
		pcall(function()
			connection:Disconnect()
		end)
	end

	table.clear(entry.CharConns)

	if entry.Gui then
		pcall(function()
			entry.Gui:Destroy()
		end)
	end

	-- ===== OPTIMIZATION: Clear cache saat character cleared =====
	if entry.Character then
		safeZoneCache[entry.Character]=nil
	end

	entry.Gui=nil
	entry.UI=nil
	entry.Character=nil
	entry.Humanoid=nil
	entry.Head=nil
	entry.Root=nil
end

local function UpdateHealth(entry,value)
	local ui=entry.UI
	local humanoid=entry.Humanoid

	if not ui or not humanoid then
		return
	end

	local maxHealth=math.max(humanoid.MaxHealth,1)
	local health=math.clamp(tonumber(value) or 0,0,maxHealth)
	local percent=health/maxHealth

	ui.Fill.Size=UDim2.new(percent,0,1,0)

	if percent>.65 then
		ui.Fill.BackgroundColor3=C.HPHigh
	elseif percent>.3 then
		ui.Fill.BackgroundColor3=C.HPMid
	else
		ui.Fill.BackgroundColor3=C.HPLow
	end

	ui.HPText.Text=
		FormatNumber(math.floor(health))
		.." / "
		..FormatNumber(math.floor(maxHealth))
end

local function UpdateInfo(entry)
	local player=entry.Player
	local ui=entry.UI

	if not player or not ui then
		return
	end

	local teamName,teamColor,enabled=GetTeam(player)

	ui.Card.Visible=enabled

	if not enabled then
		return
	end

	ui.Name.Visible=ESP.ShowName
	ui.Status.Visible=ESP.ShowStatus
	ui.Info.Visible=ESP.ShowLevel or ESP.ShowBounty
	ui.HPBG.Visible=ESP.ShowHealth

	local distance=""

	if ESP.ShowDistance and entry.Distance then
		distance=" "..Colored(math.floor(entry.Distance).."m",C.Muted)
	end

	ui.Name.Text=
		Colored("["..string.upper(tostring(teamName)).."]",teamColor)
		.." "
		..Colored(player.DisplayName,C.White)
		..distance

	local pvp,pvpColor,safe,safeColor,combat,combatColor=
		GetStatus(player,entry.Character)

	local separator=Colored(" | ",C.Muted)

	ui.Status.Text=
		Colored("PvP ",C.Muted)
		..Colored(pvp,pvpColor)
		..separator
		..Colored(safe,safeColor)
		..separator
		..Colored(combat,combatColor)

	local info={}

	if ESP.ShowLevel then
		info[#info+1]=Colored("LVL "..tostring(entry.Level or "?"),C.Level)
	end

	if ESP.ShowBounty then
		info[#info+1]=Colored("💎 "..FormatNumber(entry.Bounty or 0),C.Bounty)
	end

	ui.Info.Text=table.concat(info,separator)
end

-- ===== OPTIMIZATION: Faster character setup =====
local function SetupCharacter(player,character)
	local entry=Registry[player]

	if not entry then
		return
	end

	entry.Token=entry.Token+1

	local token=entry.Token

	ClearCharacter(entry)

	if not character then
		return
	end

	local head
	local humanoid
	local root

	-- ===== ลดจาก 60 รอบ เป็น 30 รอบ =====
	for _=1,30 do
		if token~=entry.Token or not player.Parent or not character.Parent then
			return
		end

		head=character:FindFirstChild("Head")
		humanoid=character:FindFirstChildOfClass("Humanoid")
		root=character:FindFirstChild("HumanoidRootPart")

		if head and humanoid and root then
			break
		end

		task.wait(.05)
	end

	if not head or not humanoid or not root or token~=entry.Token then
		return
	end

	local old=head:FindFirstChild("PlayerESP")

	if old then
		old:Destroy()
	end

	local gui=Instance.new("BillboardGui")
	gui.Name="PlayerESP"
	gui.Adornee=head
	gui.Size=UDim2.fromOffset(220,110)
	gui.StudsOffset=Vector3.new(0,2.6,0)
	gui.AlwaysOnTop=true
	gui.LightInfluence=0
	gui.MaxDistance=10000000
	gui.Parent=head

	entry.Gui=gui
	entry.UI=BuildUI(gui)
	entry.Character=character
	entry.Humanoid=humanoid
	entry.Head=head
	entry.Root=root
	entry.Level=GetLevel(player)
	entry.Bounty=GetBounty(player)

	entry.CharConns[#entry.CharConns+1]=humanoid.HealthChanged:Connect(function(value)
		UpdateHealth(entry,value)
	end)

	entry.CharConns[#entry.CharConns+1]=humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
		UpdateHealth(entry,humanoid.Health)
	end)

	entry.CharConns[#entry.CharConns+1]=character.AncestryChanged:Connect(function(_,parent)
		if not parent and token==entry.Token then
			ClearCharacter(entry)
		end
	end)

	UpdateHealth(entry,humanoid.Health)
	UpdateInfo(entry)
end

local function ConnectData(entry,object)
	if not object then
		return
	end

	if object:IsA("ValueBase") then
		entry.DataConns[#entry.DataConns+1]=object:GetPropertyChangedSignal("Value"):Connect(function()
			local player=entry.Player

			if object.Name=="Level" then
				entry.Level=object.Value
				levelCache[player]=object.Value
			elseif object.Name=="Bounty/Honor" then
				entry.Bounty=object.Value
				bountyCache[player]=object.Value
			end

			if Registry[player]==entry then
				UpdateInfo(entry)
			end
		end)
	end
end

local function SetupDataConnections(entry)
	local player=entry.Player

	for _,connection in ipairs(entry.DataConns) do
		pcall(function()
			connection:Disconnect()
		end)
	end

	table.clear(entry.DataConns)

	local data=player:FindFirstChild("Data")

	if data then
		local level=data:FindFirstChild("Level")

		if level then
			entry.Level=level.Value
			levelCache[player]=level.Value
			ConnectData(entry,level)
		end
	end

	local stats=player:FindFirstChild("leaderstats")

	if stats then
		local level=stats:FindFirstChild("Level")
		local bounty=stats:FindFirstChild("Bounty/Honor")

		if level then
			entry.Level=level.Value
			levelCache[player]=level.Value
			ConnectData(entry,level)
		end

		if bounty then
			entry.Bounty=bounty.Value
			bountyCache[player]=bounty.Value
			ConnectData(entry,bounty)
		end
	end
end

Update=function(player,entry,distanceUpdate)
	if not player.Parent then
		return
	end

	local character=entry.Character
	local ui=entry.UI

	if not character or not character.Parent or not ui then
		return
	end

	if distanceUpdate then
		local root=entry.Root

		if root and MyRoot then
			entry.Distance=(MyRoot.Position-root.Position).Magnitude
		end

		UpdateInfo(entry)
	end
end

local function Create(player)
	if not player or player==LocalPlayer then
		return
	end

	local id=player.UserId

	if CachedPlayers[id] then
		return
	end

	CachedPlayers[id]=true

	local entry={
		Player=player,
		Conns={},
		CharConns={},
		DataConns={},
		Token=0,
		Distance=0,
		Level="?",
		Bounty=0
	}

	Registry[player]=entry

	SetupDataConnections(entry)

	entry.Conns[#entry.Conns+1]=player.CharacterAdded:Connect(function(character)
		task.defer(function()
			if Registry[player]==entry then
				SetupCharacter(player,character)
			end
		end)
	end)

	entry.Conns[#entry.Conns+1]=player:GetPropertyChangedSignal("Team"):Connect(function()
		UpdateInfo(entry)
	end)

	entry.Conns[#entry.Conns+1]=player:GetAttributeChangedSignal("PvpDisabled"):Connect(function()
		UpdateInfo(entry)
	end)

	entry.Conns[#entry.Conns+1]=player:GetAttributeChangedSignal("SafeZone"):Connect(function()
		UpdateInfo(entry)
	end)

	entry.Conns[#entry.Conns+1]=player:GetAttributeChangedSignal("InCombat"):Connect(function()
		UpdateInfo(entry)
	end)

	if player.Character then
		task.defer(function()
			if Registry[player]==entry then
				SetupCharacter(player,player.Character)
			end
		end)
	end
end

Remove=function(player)
	local entry=Registry[player]

	if not entry then
		return
	end

	entry.Token=entry.Token+1

	ClearCharacter(entry)

	for _,connection in ipairs(entry.Conns) do
		pcall(function()
			connection:Disconnect()
		end)
	end

	for _,connection in ipairs(entry.DataConns) do
		pcall(function()
			connection:Disconnect()
		end)
	end

	table.clear(entry.Conns)
	table.clear(entry.DataConns)

	-- ===== OPTIMIZATION: Clear cache saat player removed =====
	levelCache[player]=nil
	bountyCache[player]=nil

	Registry[player]=nil
end

GlobalConns[#GlobalConns+1]=Players.PlayerAdded:Connect(Create)
GlobalConns[#GlobalConns+1]=Players.PlayerRemoving:Connect(Remove)

for _,player in ipairs(Players:GetPlayers()) do
	Create(player)
end

RefreshSafeZones()

local distanceTimer=0

GlobalConns[#GlobalConns+1]=RunService.Heartbeat:Connect(function(dt)
	distanceTimer=distanceTimer+dt

	if distanceTimer<DISTANCE_INTERVAL then
		return
	end

	distanceTimer=0

	local character=LocalPlayer.Character
	MyRoot=character and character:FindFirstChild("HumanoidRootPart")

	if not MyRoot then
		return
	end

	for player,entry in pairs(Registry) do
		if player.Parent then
			Update(player,entry,true)
		end
	end
end)

ENV.__ESPCleanup=function()
	for _,connection in ipairs(GlobalConns) do
		pcall(function()
			connection:Disconnect()
		end)
	end

	table.clear(GlobalConns)

	for player in pairs(Registry) do
		Remove(player)
	end

	table.clear(Registry)
	table.clear(levelCache)
	table.clear(bountyCache)
	table.clear(safeZoneCache)
end


local function RefreshESP()
    for _,entry in pairs(Registry) do
        if entry.UI then
            UpdateInfo(entry)
        end
    end
end

local function AddESPToggle(title,desc,flag,key)
    -- Assume 'Visuals' exists หรือแก้ให้ match กับ UI library ของคุณ
    if Visuals and Visuals.Toggle then
        Visuals:Toggle({
            Title=title,
            Type="Checkbox",
            Desc=desc,
            Flag=flag,
            Value=ESPConfig[key] == true,
            Callback=function(state)
                ESPConfig[key]=state == true
                RefreshESP()
            end
        })
    end
end

AddESPToggle("Show Name","Displays player usernames.","ESP_Name","ShowName")
AddESPToggle("Show Distance","Shows distance to players.","ESP_Distance","ShowDistance")
AddESPToggle("Show Level","Displays player levels.","ESP_Level","ShowLevel")
AddESPToggle("Show Bounty","Shows current bounty or honor.","ESP_Bounty","ShowBounty")
AddESPToggle("Show Health","Renders health bars and percentages.","ESP_HP","ShowHealth")
AddESPToggle("Show Player Status","Displays PvP, SafeZone, and combat status.","ESP_Status","ShowStatus")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("CustomMobileTogglesStyle") then
    CoreGui.CustomMobileTogglesStyle:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomMobileTogglesStyle"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local BTN_W, BTN_H = 148, 42
local DRAG_THRESHOLD = 8

local OFF_BG = Color3.fromRGB(20,20,26)
local OFF_BG2 = Color3.fromRGB(30,30,38)
local OFF_STROKE = Color3.fromRGB(55,55,68)
local OFF_TEXT = Color3.fromRGB(170,170,185)
local OFF_TRACK = Color3.fromRGB(50,50,62)
local OFF_KNOB = Color3.fromRGB(190,190,205)
local OFF_STATUS = Color3.fromRGB(100,100,115)

local KNOB_OFF = UDim2.new(0,3,0.5,0)
local KNOB_ON = UDim2.new(1,-15,0.5,0)

local function tween(obj,time,props)
    TweenService:Create(
        obj,
        TweenInfo.new(time,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
        props
    ):Play()
end

local function createDraggableButton(text,accentColor,x,y,callback)
    local center = Vector2.new(x + BTN_W/2,y + BTN_H/2)

    local button = Instance.new("TextButton")
    button.AnchorPoint = Vector2.new(.5,.5)
    button.Size = UDim2.fromOffset(BTN_W,BTN_H)
    button.Position = UDim2.fromOffset(center.X,center.Y)
    button.BackgroundColor3 = Color3.new(1,1,1)
    button.BackgroundTransparency = .08
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Text = ""
    button.Active = true
    button.Parent = screenGui

    Instance.new("UICorner",button).CornerRadius = UDim.new(0,12)

    local scale = Instance.new("UIScale",button)

    local gradient = Instance.new("UIGradient",button)
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new(OFF_BG2,OFF_BG)

    local stroke = Instance.new("UIStroke",button)
    stroke.Color = OFF_STROKE
    stroke.Thickness = 1.5

    local bar = Instance.new("Frame",button)
    bar.AnchorPoint = Vector2.new(0,.5)
    bar.Size = UDim2.fromOffset(3,18)
    bar.Position = UDim2.new(0,8,.5,0)
    bar.BackgroundColor3 = OFF_STROKE
    bar.BorderSizePixel = 0
    Instance.new("UICorner",bar).CornerRadius = UDim.new(1,0)

    local label = Instance.new("TextLabel",button)
    label.Size = UDim2.new(1,-74,0,18)
    label.Position = UDim2.fromOffset(20,6)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = OFF_TEXT
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left

    local status = Instance.new("TextLabel",button)
    status.Size = UDim2.new(1,-74,0,12)
    status.Position = UDim2.fromOffset(20,24)
    status.BackgroundTransparency = 1
    status.Text = "OFF"
    status.TextColor3 = OFF_STATUS
    status.TextSize = 10
    status.Font = Enum.Font.GothamMedium
    status.TextXAlignment = Enum.TextXAlignment.Left

    local track = Instance.new("Frame",button)
    track.AnchorPoint = Vector2.new(0,.5)
    track.Size = UDim2.fromOffset(32,18)
    track.Position = UDim2.new(1,-42,.5,0)
    track.BackgroundColor3 = OFF_TRACK
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    Instance.new("UICorner",track).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame",track)
    knob.AnchorPoint = Vector2.new(0,.5)
    knob.Size = UDim2.fromOffset(12,12)
    knob.Position = KNOB_OFF
    knob.BackgroundColor3 = OFF_KNOB
    knob.BorderSizePixel = 0
    Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)

    local dragging = false
    local dragInput = nil
    local isDragging = false
    local dragStart
    local startCenter
    local activeState = false

    local function updateVisual(state,fire)
        state = state == true

        if activeState == state and not fire then
            return
        end

        activeState = state

        if state then
            gradient.Color = ColorSequence.new(
                accentColor:Lerp(Color3.new(0,0,0),.72),
                Color3.fromRGB(16,16,22)
            )

            tween(stroke,.2,{
                Color = accentColor,
                Thickness = 2
            })

            tween(bar,.2,{
                BackgroundColor3 = accentColor,
                Size = UDim2.fromOffset(3,26)
            })

            tween(label,.2,{
                TextColor3 = Color3.new(1,1,1)
            })

            tween(track,.2,{
                BackgroundColor3 = accentColor
            })

            tween(knob,.2,{
                Position = KNOB_ON,
                BackgroundColor3 = Color3.new(1,1,1)
            })

            tween(status,.2,{
                TextColor3 = accentColor
            })

            status.Text = "ON"
        else
            gradient.Color = ColorSequence.new(
                OFF_BG2,
                OFF_BG
            )

            tween(stroke,.2,{
                Color = OFF_STROKE,
                Thickness = 1.5
            })

            tween(bar,.2,{
                BackgroundColor3 = OFF_STROKE,
                Size = UDim2.fromOffset(3,18)
            })

            tween(label,.2,{
                TextColor3 = OFF_TEXT
            })

            tween(track,.2,{
                BackgroundColor3 = OFF_TRACK
            })

            tween(knob,.2,{
                Position = KNOB_OFF,
                BackgroundColor3 = OFF_KNOB
            })

            tween(status,.2,{
                TextColor3 = OFF_STATUS
            })

            status.Text = "OFF"
        end

        if fire and callback then
            callback(activeState)
        end
    end

    button.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        dragging = true
        isDragging = false
        dragStart = input.Position
        startCenter = center

        tween(scale,.1,{
            Scale = .95
        })

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false

                tween(scale,.12,{
                    Scale = 1
                })
            end
        end)
    end)

    button.InputChanged:Connect(function(input)
        -- แก้จาก AND เป็น OR
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input ~= dragInput or not dragging then
            return
        end

        local delta = input.Position - dragStart

        if not isDragging then
            if math.abs(delta.X) < DRAG_THRESHOLD
                and math.abs(delta.Y) < DRAG_THRESHOLD then
                return
            end

            isDragging = true
        end

        local size = Camera.ViewportSize

        local newX = math.clamp(
            startCenter.X + delta.X,
            BTN_W/2,
            size.X - BTN_W/2
        )

        local newY = math.clamp(
            startCenter.Y + delta.Y,
            BTN_H/2,
            size.Y - BTN_H/2
        )

        center = Vector2.new(newX,newY)
        button.Position = UDim2.fromOffset(newX,newY)
    end)

    button.MouseButton1Click:Connect(function()
        if isDragging then
            return
        end

        updateVisual(not activeState,true)
    end)

    return {
        Instance = button,

        Set = function(state)
            updateVisual(state,false)
        end
    }
end
local SilentAimSyncing = false
local SilentAimNotifyCooldown = false

local CombatTabToggle
local SilentAimButton

local function SetSilentAim1State(state, updateWindUI, message)
    state = state == true

    getgenv().SilentAimEnabled = state

    if not state then
        getgenv().CurrentTarget = nil
    end
    if updateWindUI
        and CombatTabToggle
        and not SilentAimSyncing then

        SilentAimSyncing = true

        pcall(function()
            if CombatTabToggle.Set then
                CombatTabToggle:Set(state)
            end
        end)

        task.defer(function()
            SilentAimSyncing = false
        end)
    end
    if SilentAimButton
        and SilentAimButton.Set then

        pcall(function()
            SilentAimButton.Set(state)
        end)
    end

    if WindUI
        and WindUI.Notify
        and not SilentAimNotifyCooldown then

        SilentAimNotifyCooldown = true

        pcall(function()
            WindUI:Notify({
                Title = "Destiny Hub",
                Content = message or (
                    state
                    and "SILENT AIM ON [LOCKED]"
                    or "SILENT AIM OFF"
                ),
                Icon = "crosshair",
                Duration = 1.5
            })
        end)

        task.delay(0.2, function()
            SilentAimNotifyCooldown = false
        end)
    end
end

CombatTabToggle = CombatTab:Toggle({
    Title = "Silent Aim",
    Desc = "Hit shots without precise crosshairs.",
    Type = "Checkbox",
    Flag = "silent_aim_toggle",

    Value = getgenv().SilentAimEnabled == true,

    Callback = function(state)
        if SilentAimSyncing then
            return
        end
        SetSilentAim1State(state, false)
    end
})

SilentAimButton = createDraggableButton(
    "Silent Aim",
    Color3.fromRGB(0,229,255),
    350,
    66,
    function(state)
        SetSilentAim1State(state, true)
    end
)

task.defer(function()
    local state = getgenv().SilentAimEnabled == true

    SilentAimSyncing = true

    if SilentAimButton and SilentAimButton.Set then
        pcall(function()
            SilentAimButton.Set(state)
        end)
    end

    if CombatTabToggle and CombatTabToggle.Set then
        pcall(function()
            CombatTabToggle:Set(state)
        end)
    end

    SilentAimSyncing = false
end)

--==================================================
-- FOLLOW SYSTEM - OPTIMIZED FOR SMOOTHNESS
--==================================================
local FollowEnabled = false
local FollowDistance = 300
local TpBehindDistance = 5
local FollowKeybind = Enum.KeyCode.E

local LERP_SPEED = 0.35 
local VELOCITY_DAMPING = 0.92 
local HEAD_OFFSET = Vector3.new(0, 2, 0) 

local currentTarget
local teleportBtn
local camlockBtn
local smoothVelocity = Vector3.new(0, 0, 0)

local function StopFollow()
    smoothVelocity = Vector3.new(0, 0, 0)
end

local function FollowTarget(targetObject)
    local targetChar = targetObject
    if targetObject:IsA("Player") then
        targetChar = targetObject.Character
    end

    if not targetChar or not targetChar.Parent then 
        StopFollow()
        return false
    end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")

    if not root or not hum or hum.Health <= 0 or not targetChar or not targetRoot or not targetHum then
        StopFollow()
        return false
    end

    if targetHum.Health <= 0 then
        StopFollow()
        return "DEAD"
    end

    if (root.Position - targetRoot.Position).Magnitude > FollowDistance then
        StopFollow()
        return false
    end

    local targetCF = targetRoot.CFrame
    local behindOffset = targetCF:VectorToWorldSpace(Vector3.new(0, 2, TpBehindDistance))
    local targetPos = targetRoot.Position + behindOffset + HEAD_OFFSET
    
    smoothVelocity = smoothVelocity * VELOCITY_DAMPING
    local smoothPos = root.Position + smoothVelocity
    local targetCFrame = CFrame.new(
        smoothPos:Lerp(targetPos, LERP_SPEED),
        targetRoot.Position + HEAD_OFFSET
    )

    root.CFrame = targetCFrame
    root.AssemblyLinearVelocity = targetRoot.AssemblyLinearVelocity * 0.95
    
    smoothVelocity = (targetPos - root.Position) * 0.1

    return true
end

local function GetClosestTarget()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local closest
    local shortest = FollowDistance
    local mode = getgenv().TargetMode or "Players Only"
    
    if mode == "Both" or mode == "Players Only" then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not ShouldIgnoreTarget(player.Character, player) then
                local tRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                
                if tRoot and hum and hum.Health > 0 then
                    local dist = (root.Position - tRoot.Position).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = player
                    end
                end
            end
        end
    end

    if mode == "Both" or mode == "Enemies Only" then
        local enemiesFolder = getCachedEnemiesFolder and getCachedEnemiesFolder() or nil
        if enemiesFolder then
            for _, enemyModel in ipairs(enemiesFolder:GetChildren()) do
                if enemyModel:IsA("Model") and not ShouldIgnoreTarget(enemyModel, nil) then
                    local tRoot = enemyModel:FindFirstChild("HumanoidRootPart")
                    local hum = enemyModel:FindFirstChildOfClass("Humanoid")
                    
                    if tRoot and hum and hum.Health > 0 then
                        local dist = (root.Position - tRoot.Position).Magnitude
                        if dist < shortest then
                            shortest = dist
                            closest = enemyModel
                        end
                    end
                end
            end
        end
    end

    return closest
end

local function SetFollowState(state, message)
    FollowEnabled = state
    currentTarget = state and GetClosestTarget() or nil
    
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if hum then
        hum.WalkSpeed = state and 0 or 16
    end

    if not state then 
        StopFollow()
    end

    if teleportBtn then 
        teleportBtn.Set(state)
    end
    
    if WindUI and WindUI.Notify then
        WindUI:Notify({
            Title = "Destiny Hub",
            Content = message or (state and "HARDCORE ON [LOCKED]" or "HARDCORE OFF"),
            Icon = state and "power" or "power-off",
            Duration = 1.5
        })
    end
end

teleportBtn = createDraggableButton("Teleport Player", Color3.fromRGB(180, 110, 255), 176, 66, function(state)
    SetFollowState(state)
end)

camlockBtn = createDraggableButton(
    "Camera Lock",
    Color3.fromRGB(0, 229, 255),
    20,
    66,
    function(state)
        getgenv().CamlockEnabled = state
        if not state then
            getgenv().CurrentTarget = nil
        end
    end
)

RunService.RenderStepped:Connect(function()
    if not FollowEnabled then return end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if not root or not hum or hum.Health <= 0 then
        SetFollowState(false, "You died!")
        return
    end

    if currentTarget then
        local targetChar = currentTarget:IsA("Player") and currentTarget.Character or currentTarget
        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")

        if not targetChar or not targetHum or targetHum.Health <= 0 then
            local action = getgenv().OnTargetDeath or "Stop"
            if action == "Switch to Next" then
                currentTarget = GetClosestTarget() -- ค้นหาตัวถัดไปต่อทันที โดยไม่สั่งปิดระบบ
            else
                SetFollowState(false, "Target died! System off.")
            end
            return
        end

        if ShouldIgnoreTarget(targetChar, currentTarget:IsA("Player") and currentTarget or nil) then
            currentTarget = GetClosestTarget()
            return
        end

        local status = FollowTarget(currentTarget)
        if status == "DEAD" then
            local action = getgenv().OnTargetDeath or "Stop"
            if action == "Switch to Next" then
                currentTarget = GetClosestTarget() -- ค้นหาตัวถัดไปต่อทันที โดยไม่สั่งปิดระบบ
            else
                SetFollowState(false, "Target died! System off.")
            end
        elseif not status then
            currentTarget = GetClosestTarget()
        end
    else
        currentTarget = GetClosestTarget()
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == FollowKeybind then
        SetFollowState(not FollowEnabled)
    end
end)


RunService.RenderStepped:Connect(function()
    local isSilentAimOn = getgenv().SilentAimEnabled == true
    local isCamlockOn = getgenv().CamlockEnabled == true
    local isFollowOn = (typeof(FollowEnabled) == "boolean" and FollowEnabled) or false

    if not isSilentAimOn and not isCamlockOn and not isFollowOn then
        getgenv().CurrentTarget = nil
        return
    end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum or hum.Health <= 0 then
        getgenv().CurrentTarget = nil
        return
    end

    local currentTargetObj = getgenv().CurrentTarget
    if currentTargetObj then
        local targetModel = currentTargetObj.Parent
        local targetHum = targetModel and targetModel:FindFirstChildOfClass("Humanoid")
        
        if not targetModel or not targetHum or targetHum.Health <= 0 then
            getgenv().CurrentTarget = nil
        end
    end
end)

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local jumpConnection = nil

System:Toggle({
    Title = "Auto Jump (PC)",
    Type = "Checkbox",
    Desc = "No cooldown.",
    Flag = "TogglePCJump",
    Value = false,
    Callback = function(state)
        if state then
            jumpConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if input.KeyCode == Enum.KeyCode.Space then
                    local character = LocalPlayer.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                    if humanoid and humanoid.Health > 0 then
                        humanoid.Jump = true
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        else
            -- ปิดการใช้งาน: ยกเลิกการเชื่อมต่อ Event
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
            end
        end
    end,
})

local toggleState = false
local soruCooldown = 0.05

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function setSoru(soruScript, on)
    pcall(function() soruScript.Enabled = on end)
    pcall(function() soruScript.Disabled = not on end)
end

local function findSoru()
    local char = player.Character
    local soruScript = char and char:FindFirstChild("Soru")
    if soruScript then return soruScript end

    local characters = workspace:FindFirstChild("Characters")
    local charFolder = characters and characters:FindFirstChild(player.Name)
    return charFolder and charFolder:FindFirstChild("Soru")
end

-- เพิ่มตัวแปรสำหรับป้องกันการสร้าง Thread ซ้อนกันเกินความจำเป็น (Debounce / Guard)
local isProcessing = false

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if toggleState and not isProcessing and method == "FireServer" and self.Name == "CommE" and args[1] == "Soru" then
        isProcessing = true
        task.spawn(function()
            local soruScript = findSoru()
            if soruScript then
                setSoru(soruScript, true)
                task.wait(soruCooldown)
                setSoru(soruScript, false)
                task.wait(soruCooldown)
                setSoru(soruScript, true)
            end
            isProcessing = false
        end)
    end

    return oldNamecall(self, ...)
end)

-- UI Toggle
local Toggle = System:Toggle({
    Title = "Instant Soru",
    Type = "Checkbox",
    Desc = "Bypass Soru Cooldown",
    Flag = "SoruToggle",

    Callback = function(state)
        toggleState = state
        if not state then
            isProcessing = false
            local soruScript = findSoru()
            if soruScript then
                setSoru(soruScript, true)
            end
        end
    end
})

System:Divider() 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local defenseProtocolEnabled = false 
local isEmergencyAscending = false

local healthTriggerThreshold = 30
local healthRecoveryThreshold = 85 
local ascentVelocity = 200  

local blockedStates = {
    Enum.HumanoidStateType.Ragdoll,  
    Enum.HumanoidStateType.FallingDown, 
    Enum.HumanoidStateType.Physics, 
    Enum.HumanoidStateType.PlatformStanding 
}
local function executeDefenseProtocol(character, humanoid, rootPart)
    if not defenseProtocolEnabled or not humanoid or humanoid.Health <= 0 or not rootPart then
        return
    end

    local maxHealth = humanoid.MaxHealth > 0 and humanoid.MaxHealth or 100
    local healthPercent = (humanoid.Health / maxHealth) * 100

    if healthPercent <= healthTriggerThreshold and not isEmergencyAscending then
        isEmergencyAscending = true
        
        pcall(function()
            humanoid.PlatformStand = true
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)

        local destination = rootPart.CFrame + Vector3.new(0, 400, 0)
        local tween = TweenService:Create(
            rootPart,
            TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
            {CFrame = destination}
        )
        tween:Play()
    end

    if isEmergencyAscending then
        pcall(function()
            humanoid.PlatformStand = true
            for _, state in ipairs(blockedStates) do
                humanoid:SetStateEnabled(state, false)
            end
        end)

        rootPart.AssemblyLinearVelocity = Vector3.new(0, ascentVelocity, 0)
        rootPart.AssemblyAngularVelocity = Vector3.zero

        local destroyHeight = workspace.FallenPartsDestroyHeight or -500
        if rootPart.Position.Y < destroyHeight + 400 then
            rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 150, 0)
        end

        if healthPercent >= healthRecoveryThreshold then
            isEmergencyAscending = false
            
            pcall(function()
                humanoid.PlatformStand = false
                for _, state in ipairs(blockedStates) do
                    humanoid:SetStateEnabled(state, true)
                end
            end)
            
            rootPart.AssemblyLinearVelocity = Vector3.zero
        end

        return
    end
end
RunService.Heartbeat:Connect(function()
    if not defenseProtocolEnabled then return end

    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if humanoid and rootPart then
        executeDefenseProtocol(character, humanoid, rootPart)
    end
end)
local SafetyMode = System:Section({
    Title = "Safety Mode",
    Icon = "shield-alert"
})
local ShieldToggle = System:Toggle({
    Title = "Safety Mode",
    Type = "Checkbox",
    Desc = "Automatically escapes and flies up when HP is critical",
    Value = false,
    Locked = false,
    Flag = "defense_protocol_toggle",

    Callback = function(value)
        defenseProtocolEnabled = value

        if not value then
            isEmergencyAscending = false

            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local root = character:FindFirstChild("HumanoidRootPart")

                if humanoid then
                    humanoid.PlatformStand = false
                end

                if root then
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
    end
})
local HPRestoreSlider = System:Slider({
    Title = "Resume Health Percent",
    Desc = "HP percentage required to resume normal operations",

    Value = {
        Min = 20,
        Max = 80,
        Default = 30
    },

    Step = 1,
    Locked = false,
    Flag = "defense_restore_percent_slider",

    Callback = function(value)
        healthTriggerThreshold = value
    end
})


CombatTab:Toggle({
    Title = "CamLock )",
    Type = "Checkbox",
    Desc  = "Lock onto targets instantly.",
    Flag  = "camlock_toggle",
    Value = getgenv().CamlockEnabled,
    Callback = function(state)
        getgenv().CamlockEnabled = state
        if not state then
            getgenv().CurrentTarget = nil
        end
    end,
})
CombatTab:Divider() 
local FOVSection = CombatTab:Section({ 
    Title = "Targeting & FOV", 
    Icon = "crosshair" 
})
CombatTab:Dropdown({
    Title = "Silent Aim Mode",
    Desc  = "FOV, 180° or 360° aim range.",
    Flag  = "silent_aim_mode_dropdown",
    Values = { "FOV", "180°", "360°" },
    Value  = getgenv().SilentAimMode,
    Callback = function(selected)
        
        local mode = type(selected) == "table" and selected[1] or selected
        
        if getgenv().SilentAimMode == "FOV" and mode ~= "FOV" then
            getgenv().SavedFOVRadius = getgenv().FOVRadius
        end

        getgenv().SilentAimMode = mode
        
        if mode == "360°" then
            getgenv().FOVRadius = 9999 
        elseif mode == "180°" then
            getgenv().FOVRadius = 180 
        elseif mode == "FOV" then
            getgenv().FOVRadius = getgenv().SavedFOVRadius
        end
    end,
})
CombatTab:Slider({
    Title = "FOV Size",
    Desc  = "Adjust the aim FOV radius",
    Flag  = "fov_size_slider",
    Increment = 1,
    Value = {
        Min     = 50,
        Max     = 1000,
        Default = getgenv().FOVRadius
    },
    Callback = function(state)
        
        getgenv().FOVRadius = state
        
        if getgenv().SilentAimMode == "FOV" then
            getgenv().SavedFOVRadius = state
        end
    end,
})
CombatTab:Dropdown({
    Title = "FOV Position",
    Desc  = "Set the FOV position.",
    Flag  = "fov_position_dropdown",
    Values = { "Mouse/Touch", "Middle" },
    Value  = getgenv().FOVPositionMode,
    Callback = function(selected)
        local mode = type(selected) == "table" and selected[1] or selected
        getgenv().FOVPositionMode = mode
    end,
})
CombatTab:Toggle({
    Title = "Show FOV Circle",
    Type =  "Checkbox",
    Desc  = "Show or hide the FOV circle.",
    Flag  = "show_fov_toggle",
    Value = getgenv().ShowFOV,
    Callback = function(state)
        getgenv().ShowFOV = state
        if FOVUI then 
            FOVUI.Visible = state 
        end
    end,
})
CombatTab:Divider() 
local VisualsSection = CombatTab:Section({ 
    Title = "Visuals & Filters", 
    Icon = "eye" 
})
CombatTab:Toggle({
    Title = "Show Snapline",
    Type =  "Checkbox",
    Desc = "Show or hide the target snapline.",
    Flag  = "show_snapline_toggle",
    Value = getgenv().ShowTracer,
    Callback = function(state)
        getgenv().ShowTracer = state
        if not state and Snapline then
            Snapline.Visible = false
        end
    end,
})
CombatTab:Slider({
    Title = "Distance",
    Desc = "Set the maximum target distance.",
    Flag  = "max_distance_slider",
    Increment = 1,
    Value = {
        Min     = 0,
        Max     = 1200,
        Default = getgenv().MaxDistance
    },
    Callback = function(state)
        getgenv().MaxDistance = state
    end,
})
getgenv().TargetMode = "Players Only" 
CombatTab:Dropdown({
    Title = "Enemy Type",
    Desc  = "Choose Players or NPCs.",
    Flag  = "target_type_dropdown",
    Values = { "Players Only", "Enemies Only", "Both" },
    Value  = "Players Only",
    Callback = function(selected)
        local mode = type(selected) == "table" and selected[1] or selected
        getgenv().TargetMode = mode
    end,
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local modules = ReplicatedStorage:FindFirstChild("Modules")
local net = modules and modules:FindFirstChild("Net")
local registerHit = net and net:FindFirstChild("RE/RegisterHit")
local registerAttack = net and net:FindFirstChild("RE/RegisterAttack")

local fastAttackRunning = false
local connection
local lastAttackTime = 0
local attackDelay = 0.08 -- ลดลงเล็กน้อยเพื่อให้โจมตีต่อเนื่องและสมูทขึ้น

-- // ฟังก์ชันคำนวณทิศทางแบบน้ำหนักเบา //
local function GetAttackDirection(root, target)
    local direction = (target.Position - root.Position).Unit
    return Vector3.new(
        direction.X + (math.random(-5, 5)/100),
        0, 
        direction.Z + (math.random(-5, 5)/100)
    )
end

local function Attack(targetPart, tool)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not targetPart then return end

    local leftClickRemote = tool and tool:FindFirstChild("LeftClickRemote")
    local attackDir = GetAttackDirection(root, targetPart)
    
    if leftClickRemote and leftClickRemote:IsA("RemoteEvent") then
        pcall(function()
            leftClickRemote:FireServer(attackDir, 1)
        end)
    else
        if registerHit and registerAttack then
            pcall(function()
                registerHit:FireServer(targetPart, {["HitPos"] = targetPart.Position}, "211ee8ef")
                registerAttack:FireServer(0.4, 1)
            end)
        end
    end
end

local function SetFastAttack(state)
    fastAttackRunning = state

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if not state then return end

    -- ใช้ Stepped หรือ Heartbeat พร้อมระบบเช็คเวลาที่มีประสิทธิภาพ
    connection = RunService.Heartbeat:Connect(function()
        if not fastAttackRunning then return end
        
        local currentTime = tick()
        if currentTime - lastAttackTime < attackDelay then return end
        lastAttackTime = currentTime

        pcall(function()
            local char = player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            local currentTool = char:FindFirstChildOfClass("Tool")
            local rootPos = root.Position

            -- 1. ตรวจสอบ NPC (Optimize การวนลูป)
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                for _, enemy in ipairs(enemies:GetChildren()) do
                    local rootPart = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Head")
                    local hum = enemy:FindFirstChildOfClass("Humanoid")

                    if rootPart and hum and hum.Health > 0 then
                        if (rootPos - rootPart.Position).Magnitude <= 60 then
                            Attack(rootPart, currentTool)
                            return 
                        end
                    end
                end
            end

            -- 2. ตรวจสอบผู้เล่นอื่น
            for _, target in ipairs(Players:GetPlayers()) do
                if target ~= player then
                    local targetChar = target.Character
                    local rootPart = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                    local hum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")

                    if rootPart and hum and hum.Health > 0 then
                        if (rootPos - rootPart.Position).Magnitude <= 55 then
                            Attack(rootPart, currentTool)
                            return
                        end
                    end
                end
            end
        end)
    end)
end

if GeneralTab then
    local FastAttackToggle = GeneralTab:Toggle({
        Title = "Attack Aura",
        Desc = "Sword,Fruit,Combat",
        Type = "Checkbox",
        Flag = "FastAttack",
        Value = false,
        Callback = function(state)
            SetFastAttack(state)
        end,
    })
end

GeneralTab:Toggle({
    Title = "Auto Race V4",
    Desc = "Enable to activate Race V3",
    Type =  "Checkbox",
    Flag = "AutoRaceV4_Toggle",
    Value = false,
    Callback = function(state)
        SetAutoRaceV4(state)
    end,
})
GeneralTab:Toggle({
    Title = "Auto Race V3",
    Desc = "Enable to activate Race V4",
    Type =  "Checkbox",
    Flag = "AutoRaceAbility",
    Value = false,
    Callback = function(state)
        SetAutoRaceAbility(state)
    end,
})
GeneralTab:Divider() 
GeneralTab:Toggle({
    Title = "Buso Haki",
    Desc = "Enable to activate Buso Haki", -- optional
    Type =  "Checkbox",
    Flag = "AutoHakiCheck",
    Value = false,
    Callback = function(state)
        _G.AutoBusoRunning = state
        
        if state then 
            task.spawn(function()
                while _G.AutoBusoRunning do
                    pcall(function() 
                        if typeof(CheckAndEnableBuso) == "function" then
                            CheckAndEnableBuso() 
                        end
                    end)
                    task.wait(1) 
                end
            end)
        end
    end,
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommE = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommE")

local autoKenEnabled = false
local kenRunId = 0

local function CheckAndEnableKen()
    if not autoKenEnabled then return end

    local c = GetCharacter()
    if not c then return end

    if not c:FindFirstChild("Highlight") then
        pcall(function()
            CommE:FireServer("Ken", "true")
        end)
    end
end

GeneralTab:Toggle({
    Title = "Ken Haki",
    Desc = "Enable to activate Ken Haki",
    Type = "Checkbox",
    Flag = "AutoKenCheck",
    Value = false,

    Callback = function(state)
        autoKenEnabled = state
       kenRunId = kenRunId + 1

        if state then
            pcall(function()
                CommE:FireServer("Ken", "true")
            end)

            local myRun = kenRunId

            task.spawn(function()
                while autoKenEnabled and myRun == kenRunId do
                    CheckAndEnableKen()
                    task.wait(1)
                end
            end)
        else
            pcall(function()
                CommE:FireServer("Ken", "false")
            end)
        end
    end,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local IceWalkConfig = {
    GiantFloor = nil,
    FloorConnection = nil,
    FloorRunning = false,
    LastSeaLevel = nil,   
    LastHumanoid = nil,
}
local IceWalkUtils = {}
function IceWalkUtils.SetStates(hum, enabled)
    hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, enabled)
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, enabled)
end
function IceWalkUtils.Cleanup()
    if IceWalkConfig.FloorConnection then
        IceWalkConfig.FloorConnection:Disconnect()
        IceWalkConfig.FloorConnection = nil
    end
    if IceWalkConfig.GiantFloor then
        IceWalkConfig.GiantFloor:Destroy()
        IceWalkConfig.GiantFloor = nil
    end
    local hum = IceWalkConfig.LastHumanoid
    if hum and hum.Parent then
        IceWalkUtils.SetStates(hum, true)
    end
    IceWalkConfig.LastSeaLevel = nil
    IceWalkConfig.LastHumanoid = nil
end
function IceWalkUtils.GetOrCreateFloor()
    local floor = IceWalkConfig.GiantFloor
    if not floor or not floor.Parent then
        floor = Instance.new("Part")
        floor.Name = "IceWalkFloor"
        floor.Size = Vector3.new(2048, 2, 2048)
        floor.Anchored = true
        floor.CanCollide = true
        floor.CanTouch = false
        floor.CanQuery = false
        floor.CastShadow = false
        floor.Transparency = 1
        floor.Parent = Workspace
        IceWalkConfig.GiantFloor = floor
    end
    return floor
end
GeneralTab:Toggle({
    Title = "Walk On Water",
    Desc = "Enable to walk on water",
    Type =  "Checkbox",
    Flag = "IceWalk",
    Value = false,
    Callback = function(state)
        IceWalkConfig.FloorRunning = state

        if not state then
            IceWalkUtils.Cleanup()
            return
        end

        local floorPart = IceWalkUtils.GetOrCreateFloor()
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.IgnoreWater = false
        local RAY_RATE = 0.1      
        local rayElapsed = RAY_RATE 
        local DEFAULT_SEA = -2.8
        IceWalkConfig.FloorConnection = RunService.Stepped:Connect(function(_, dt)
            if not IceWalkConfig.FloorRunning then return end
            local character = LocalPlayer.Character
            if not character then return end
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local hum = character:FindFirstChildOfClass("Humanoid")
            if not rootPart or not hum then return end
            if not floorPart.Parent then
                floorPart = IceWalkUtils.GetOrCreateFloor()
            end
            if IceWalkConfig.LastHumanoid ~= hum then
                IceWalkConfig.LastHumanoid = hum
                IceWalkUtils.SetStates(hum, false)
            end
            local pos = rootPart.Position
            rayElapsed = rayElapsed + dt
            if rayElapsed >= RAY_RATE then
                rayElapsed = 0
                raycastParams.FilterDescendantsInstances = { character, floorPart }

                local result = Workspace:Raycast(
                    pos + Vector3.new(0, 30, 0),
                    Vector3.new(0, -120, 0),
                    raycastParams
                )

                if result and result.Material == Enum.Material.Water then
                    IceWalkConfig.LastSeaLevel = result.Position.Y
                end
            end
            local seaLevel = IceWalkConfig.LastSeaLevel or DEFAULT_SEA
            floorPart.Position = Vector3.new(pos.X, seaLevel - 1, pos.Z)
            if pos.Y < seaLevel + 1 and pos.Y > seaLevel - 40 then
                if hum:GetState() == Enum.HumanoidStateType.Swimming then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
                if pos.Y < seaLevel + 0.5 then
                    rootPart.CFrame = rootPart.CFrame + Vector3.new(0, (seaLevel + 4) - pos.Y, 0)
                    rootPart.AssemblyLinearVelocity = Vector3.new(
                        rootPart.AssemblyLinearVelocity.X, 0, rootPart.AssemblyLinearVelocity.Z
                    )
                end
            end
        end)
    end,
})
GeneralTab:Divider() 
GeneralTab:Toggle({
    Title = "Jump Boost",
    Desc = "Enable to activate Jump Power",
    Type =  "Checkbox",
    Flag = "JumpToggle",
    Value = false,
    Callback = function(state)
        JumpEnabled = state
    end,
})
GeneralTab:Slider({
    Title = "Jump Multiplier",
    Desc = "Multiply the Jump of the player",
    Flag = "JumpSlider",
    Increment = 0.1, 
    Value = {
        Min = 1,
        Max = 10,
        Default = 1
    },
    Callback = function(state)
        JumpMultiplier = state
    end,
})
GeneralTab:Toggle({
    Title = "Speed Boost",
    Desc = "Enable to activate Speed Boost",
    Type =  "Checkbox",
    Flag = "DashToggle",
    Value = false,
    Callback = function(state)
        DashEnabled = state
    end,
})
GeneralTab:Slider({
    Title = "Speed Multiply",
    Desc = "Multiply the speed of the player",
    Flag = "DashSlider",
    Increment = 0.1, 
    Value = {
        Min = 1,
        Max = 15,
        Default = 1
    },
    Callback = function(state)
        DashMultiplier = state
    end,
})
GeneralTab:Divider() 

getgenv().OnTargetDeath = "Stop"
GeneralTab:Dropdown({
    Title = "Select operation",
    Desc  = "Stop system or switch to next target when current dies.",
    Flag  = "target_death_dropdown",
    Values = { "Stop", "Switch to Next" },
    Value  = "Stop",
    Callback = function(selected)
        local action = type(selected) == "table" and selected[1] or selected
        getgenv().OnTargetDeath = action
    end,
})
local FollowToggle = GeneralTab:Toggle({
    Title = "Teleport",
    Desc = "Warps instantly when within range.",
    Type = "Checkbox",
    Flag = "FollowToggle",
    Value = false,
    Callback = function(state)
        SetFollowState(state, false)
    end,
})
local Keybind = GeneralTab:Keybind({
    Title = "Keybind Key",
    Desc = "Keyboard controls",
    Flag = "UIKeybind",
    Value = "E",
    Callback = function(key)
        if typeof(key) == "EnumItem" then
            FollowKeybind = key
        elseif type(key) == "string" then
            pcall(function()
                FollowKeybind = Enum.KeyCode[key]
            end)
        end
    end,
})
local Slider = GeneralTab:Slider({
    Title = "Pursuit Radius",
    Desc = "Maximum tracking range",
    Flag = "VolumeSlider",
    Increment = 1,
    Value = {
        Min = 0,
        Max = 300,
        Default = 0
    },
    Callback = function(value)
        FollowDistance = value
    end,
})
Config:Divider() 
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

getgenv().HitboxEnabled = getgenv().HitboxEnabled or true
getgenv().HitboxSize = getgenv().HitboxSize or 18
getgenv().HitboxColor = getgenv().HitboxColor or Color3.fromRGB(96, 205, 255)
getgenv().HitboxShowBox = getgenv().HitboxShowBox or true

local hitboxConnection = nil
local lastUpdateTime = 0
local UPDATE_INTERVAL = 0.5

local function resetPlayerHitbox(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head then
        local orig = head:FindFirstChild("OriginalSize")
        if orig then
            head.Size = orig.Value
            orig:Destroy()
        end

        local box = head:FindFirstChild("CustomHitboxSelectionBox")
        if box then
            box:Destroy()
        end

        head.Transparency = 0
        head.CanCollide = true
        head.CastShadow = true
    end
end

local function stopHitboxLoop()
    if hitboxConnection then
        hitboxConnection:Disconnect()
        hitboxConnection = nil
    end
end

local function startHitboxLoop()
    if hitboxConnection then return end

    hitboxConnection = RunService.Heartbeat:Connect(function()
        if not getgenv().HitboxEnabled then return end

        local now = tick()
        if now - lastUpdateTime < UPDATE_INTERVAL then return end
        lastUpdateTime = now

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                local hum = char:FindFirstChildOfClass("Humanoid")

                if hum and hum.Health > 0 then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local orig = head:FindFirstChild("OriginalSize")
                        if not orig then
                            orig = Instance.new("Vector3Value")
                            orig.Name = "OriginalSize"
                            orig.Value = head.Size
                            orig.Parent = head
                        end

                        local box = head:FindFirstChild("CustomHitboxSelectionBox")
                        if getgenv().HitboxShowBox then
                            if not box then
                                box = Instance.new("SelectionBox")
                                box.Name = "CustomHitboxSelectionBox"
                                box.Adornee = head
                                box.Parent = head
                            end
                            box.Color3 = getgenv().HitboxColor
                            box.LineThickness = 0.001
                        else
                            if box then
                                box:Destroy()
                            end
                        end

                        head.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
                        head.Transparency = 1
                        head.CanCollide = false
                        head.CastShadow = false
                    end
                else
                    resetPlayerHitbox(char)
                end
            end
        end
    end)
end

startHitboxLoop()

CombatTab:Section({ Title = "Hitbox Expander" })
CombatTab:Toggle({
    Title = "Expand Hitboxes",
    Type = "Checkbox",
    Desc = "Enlarge player hitboxes.",
    Flag = "HitboxToggle",
    Value = getgenv().HitboxEnabled,
    Callback = function(state)
        getgenv().HitboxEnabled = state

        if not state then
            stopHitboxLoop()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    resetPlayerHitbox(p.Character)
                end
            end
        else
            startHitboxLoop()
        end
    end,
})
CombatTab:Toggle({
    Title = "Show Hitbox Visual",
    Type = "Checkbox",
    Desc = "Render hitbox outlines.",
    Flag = "HitboxVisualToggle",
    Value = getgenv().HitboxShowBox,
    Callback = function(state)
        getgenv().HitboxShowBox = state

        if not state then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local head = p.Character and p.Character:FindFirstChild("Head")
                    local box = head and head:FindFirstChild("CustomHitboxSelectionBox")
                    if box then
                        box:Destroy()
                    end
                end
            end
        end
    end,
})
CombatTab:Slider({
    Title = "Hitbox Scale",
    Desc = "Adjust hitbox size multiplier.",
    Flag = "HitboxSizeSlider",
    Value = {
        Min = 0,
        Max = 50,
        Default = getgenv().HitboxSize
    },
    Increment = 1,
    Callback = function(v)
        getgenv().HitboxSize = v
    end,
})
local SettingsGroup2 = Config:Group({})
local SettingsGroup3 = Config:Group({})
local UIKeybind = Config:Keybind({
    Title = "UI Keybind",
    Flag = "UIKeybindUIKeybind", 
    Value = "",
    Callback = function(key)
        Window:Toggle()
    end
})
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local noclipConnection = nil

local function setNoclip(state)
    local character = LocalPlayer.Character
    if not character then return end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

Config:Toggle({
    Title = "Noclip",
    Type =  "Checkbox",
    Desc = "Pierce through",
    Flag = "NoclipToggle",
    Value = false,

    Callback = function(state)
        -- ป้องกัน Connection เก่าค้าง
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end

        if state then
            setNoclip(true)

            noclipConnection = RunService.Stepped:Connect(function()
                setNoclip(true)
            end)
        else
            setNoclip(false)
        end
    end,
})
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)

    if noclipConnection then
        setNoclip(true)
    end
end)
local HideShowUI = SettingsGroup2:Section({ 
    Title = "Settings 2", 
    Icon = "monitor" 
})

SettingsGroup2:Toggle({
    Title = "",
    Type =  "Checkbox",
    Flag = "ToggleCamlockUI",
    Value = true,

    Callback = function(Value)
        if camlockBtn and camlockBtn.Instance then
            camlockBtn.Instance.Visible = Value
        end
    end,
})
SettingsGroup2:Toggle({
    Title = "",
    Type =  "Checkbox",
    Flag = "ToggleTelepo1010rtUI",
    Value = true,

    Callback = function(Value)
        if teleportBtn and teleportBtn.Instance then
            teleportBtn.Instance.Visible = Value
        end
    end,
})
local HideShowUI = SettingsGroup3:Section({ 
    Title = "Settings 3", 
    Icon = "monitor" 
})
SettingsGroup3:Toggle({
    Title = "",
    Type =  "Checkbox",
    Flag = "SilentAimButtonSilentAimButton",
    Value = true,

    Callback = function(Value)
        if SilentAimButton and SilentAimButton.Instance then
            SilentAimButton.Instance.Visible = Value
        end
    end,
})

local P=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local L=P.LocalPlayer
local CG=game:GetService("CoreGui")
local old=CG:FindFirstChild("JumpButtonUI")
if old then old:Destroy() end
local G=Instance.new("ScreenGui")
G.Name="JumpButtonUI"
G.IgnoreGuiInset=true
G.Parent=CG
local B=Instance.new("TextButton")
B.Parent=G
B.Size=UDim2.fromOffset(90,90)
B.Position=UDim2.new(1,-75,1,-100)
B.AnchorPoint=Vector2.new(.5,.5)
B.BackgroundColor3=Color3.fromRGB(15,15,15)
B.Text="↑"
B.TextColor3=Color3.fromRGB(0,200,255)
B.TextSize=48
B.Font=Enum.Font.GothamBold
B.AutoButtonColor=false
Instance.new("UICorner",B).CornerRadius=UDim.new(1,0)
local dragging,dragInput,dragStart,startPos,moved
B.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1
    or i.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        moved=false
        dragStart=i.Position
        startPos=B.Position
    end
end)
B.InputChanged:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseMovement
    or i.UserInputType==Enum.UserInputType.Touch then
        dragInput=i
    end
end)
UIS.InputChanged:Connect(function(i)
    if not dragging or i~=dragInput then return end
    local d=i.Position-dragStart
    if d.Magnitude>8 then moved=true end
    B.Position=UDim2.new(
        startPos.X.Scale, startPos.X.Offset + d.X,
        startPos.Y.Scale, startPos.Y.Offset + d.Y
    )
end)
B.InputEnded:Connect(function(i)
    if i.UserInputType~=Enum.UserInputType.MouseButton1
    and i.UserInputType~=Enum.UserInputType.Touch then return end
    dragging=false
    if not moved then
        local c=L.Character
        local h=c and c:FindFirstChildOfClass("Humanoid")

        if h and h.Health>0 then
            h.Jump=true
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
    dragInput=nil
end)
SettingsGroup3:Toggle({
    Title="",
    Type="Checkbox",
    Flag="ToggleJumpUI",
    Value=true,
    Callback=function(Value)
        G.Enabled=Value==true
    end,
})
end
initializeSkillSettings()


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local localPlayer = Players.LocalPlayer
local autoBountyEnabled = false
local bountyConnection = nil
local selectedMeleeSkills = {"None"}
local selectedSwordSkills = {"None"}
local selectedFruitSkills = {"None"}
local selectedGunSkills = {"None"}

local healthTriggerThreshold = 30 
local healthRecoveryThreshold = 85 
local defenseProtocolEnabled = true 
local isEmergencyAscending = false
local cachedNearestTarget = nil
local lastTargetSearchTime = 0
local targetSearchInterval = 0.5
local selectedFaction = nil 
local teamCheckInProgress = false
local isTeamSwitchVerified = false
local teamCheckLoopRunning = false
local ascentVelocity = 300 
local playerCache = {}
local lastPlayerCacheTime = 0
local playerCacheInterval = 0.5

-- ตัวแปรสำหรับความเร็วในการบิน
local flySpeed = 210 

local function updatePlayerCache()
    local now = tick()
    if now - lastPlayerCacheTime < playerCacheInterval then
        return playerCache
    end

    lastPlayerCacheTime = now
    playerCache = Players:GetPlayers()
    return playerCache
end

local function verifyTeamSwitch()
    local player = Players.LocalPlayer
    if not player or not selectedFaction then return false end
    
    local team = player.Team
    return team and team.Name == selectedFaction
end

local function checkAndSwitchTeam()
    if teamCheckInProgress then return end

    local player = Players.LocalPlayer
    if not player or not selectedFaction then return end

    local team = player.Team
    if team and team.Name == selectedFaction then 
        isTeamSwitchVerified = true
        return 
    end

    teamCheckInProgress = true
    isTeamSwitchVerified = false

    local success, err = pcall(function()
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local remotes = replicatedStorage:WaitForChild("Remotes", 2)
        if remotes then
            local CommF = remotes:WaitForChild("CommF_", 2)
            if CommF then
                CommF:InvokeServer("SetTeam2", selectedFaction)
                task.wait(0.5)
            end
        end
    end)

    if not success and err then
        warn("[Auto Bounty] Team switch error:", err)
    end

    if verifyTeamSwitch() then
        isTeamSwitchVerified = true
    else
        isTeamSwitchVerified = false
    end

    task.wait(1)
    teamCheckInProgress = false
end

-- ฟังก์ชันกดปุ่มปกติแบบกดแล้วปล่อยทันที
local function pressKey(keyName)
    pcall(function()
        if type(keyName) == "table" then
            for k, v in pairs(keyName) do
                local targetKey = type(k) == "string" and k or v
                if targetKey and targetKey ~= "None" then
                    local keyCode = Enum.KeyCode[targetKey]
                    if keyCode then
                        VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                        task.wait(0.01)
                        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                    end
                end
            end
        elseif type(keyName) == "string" and keyName ~= "None" then
            local keyCode = Enum.KeyCode[keyName]
            if keyCode then
                VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                task.wait(0.01)
                VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
            end
        end
    end)
end

local toolTypeCache = {}
local MAX_TOOL_CACHE = 500

local function addToToolCache(toolId, typeName)
    if #toolTypeCache >= MAX_TOOL_CACHE then
        table.clear(toolTypeCache)
    end
    toolTypeCache[toolId] = typeName
end

local function checkMatch(tool, typeName)
    local toolId = tool:GetFullName()
    
    if toolTypeCache[toolId] then
        return toolTypeCache[toolId] == typeName
    end
    
    local name = tool.Name:lower()
    local tooltip = tool.ToolTip or ""
    local result = false
    
    if typeName == "Melee" then
        result = name:find("combat") or name:find("dark step") or name:find("electro") or 
                 name:find("water karate") or name:find("dragon claw") or name:find("superhuman") or 
                 name:find("death step") or name:find("sharkman karate") or name:find("electric claw") or 
                 name:find("dragon talon") or name:find("godhuman") or name:find("sanguine art")
                 
    elseif typeName == "Sword" then
        result = tooltip:lower() == "sword"
                 
    elseif typeName == "Fruit" then
        result = tooltip:lower() == "blox fruit" or tool:GetAttribute("Fruit") == true
                 
    elseif typeName == "Gun" then
        result = tooltip:lower() == "gun"
    end
    
    if result then
        addToToolCache(toolId, typeName)
    end
    
    return result
end

local function equipToolByType(toolType)
    local myChar = localPlayer.Character
    local backpack = localPlayer:FindFirstChildOfClass("Backpack")
    if not myChar then return end
    
    local humanoid = myChar:FindFirstChildOfClass("Humanoid")
    local currentTool = myChar:FindFirstChildOfClass("Tool")

    if not toolType or toolType == "" or toolType == "None" then
        if currentTool and backpack and humanoid then
            humanoid:UnequipTools()
        end
        return
    end

    if currentTool and checkMatch(currentTool, toolType) then
        return
    end

    local itemsToCheck = {}
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do 
            if item:IsA("Tool") then
                table.insert(itemsToCheck, item)
            end
        end
    end
    
    for _, item in ipairs(myChar:GetChildren()) do 
        if item:IsA("Tool") then
            table.insert(itemsToCheck, item)
        end
    end

    for _, tool in ipairs(itemsToCheck) do
        if checkMatch(tool, toolType) then
            if humanoid then
                humanoid:EquipTool(tool)
                break
            end
        end
    end
end

local function executeSkills(skillTable, toolType)
    if not skillTable or type(skillTable) ~= "table" then return end
    
    local hasValid = false
    for _, skill in ipairs(skillTable) do
        if skill ~= "None" then
            hasValid = true
            break
        end
    end
    
    if not hasValid then return end
    
    equipToolByType(toolType)
    task.wait(0.03)
    
    for _, skill in ipairs(skillTable) do
        if skill ~= "None" then
            pressKey(skill)
            task.wait(0.03)
        end
    end
end

local lastComboTime = 0
local comboCooldown = 1

local function smoothFlyTo(targetCFrame, speed, deltaTime, targetChar, distanceToTarget)
    local localPlayer = Players.LocalPlayer
    local myChar = localPlayer.Character
    if not myChar then return end

    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local humanoid = myChar:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    humanoid.PlatformStand = true

    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    local behindOffset = 3
    local behindCFrame = targetRoot.CFrame * CFrame.new(0, 0, behindOffset)
    local targetPos = behindCFrame.Position

    local currentPos = myRoot.Position
    local distance = (targetPos - currentPos).Magnitude

    local sliderDist = (Bounty and Bounty.Flags and Bounty.Flags.SafeModeDistanceSlider) or 150
    local maxDistance = math.max(sliderDist, 250)

    if distance <= maxDistance then
        myRoot.CFrame = CFrame.lookAt(
            targetPos,
            targetRoot.Position
        )

        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero

        if tick() - lastComboTime >= comboCooldown then
            lastComboTime = tick()

            task.spawn(function()
                if selectedMeleeSkills and selectedMeleeSkills[1] ~= "None" then
                    executeSkills(selectedMeleeSkills, "Melee")
                    task.wait(0.02)
                end

                if selectedSwordSkills and selectedSwordSkills[1] ~= "None" then
                    executeSkills(selectedSwordSkills, "Sword")
                    task.wait(0.02)
                end

                if selectedFruitSkills and selectedFruitSkills[1] ~= "None" then
                    executeSkills(selectedFruitSkills, "Fruit")
                    task.wait(0.02)
                end

                if selectedGunSkills and selectedGunSkills[1] ~= "None" then
                    executeSkills(selectedGunSkills, "Gun")
                end
            end)
        end

        return
    end

    if distance > 0 then
        local elevatedTargetPos = targetPos + Vector3.new(0, 60, 0)
        local direction = (elevatedTargetPos - currentPos).Unit

        local currentSpeed = speed or flySpeed
        local clampedSpeed = math.min(currentSpeed, 500)

        myRoot.AssemblyLinearVelocity = direction * clampedSpeed

        myRoot.CFrame = CFrame.lookAt(
            currentPos,
            elevatedTargetPos
        )
    end
end

local hopServersEnabled = false

local function shouldSkipTarget(targetPlayer, LocalPlayer)
    if not targetPlayer or targetPlayer == LocalPlayer then return true end
    if LocalPlayer.Team and LocalPlayer.Team.Name == "Marines" then
        if targetPlayer.Team and targetPlayer.Team.Name == "Marines" then return true end
    end
    return false
end

local function getPlayerLevel(player)
    local success, lvl = pcall(function()
        if player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") then
            return player.Data.Level.Value
        elseif player.Character and player.Character:FindFirstChild("Data") and player.Character.Data:FindFirstChild("Level") then
            return player.Character.Data.Level.Value
        end
        return nil
    end)
    return success and lvl or nil
end

local targetInteractionCount = {}
local MAX_INTERACTIONS = 3
local currentTargetPlayer = nil

local function isTargetBlocked(player)
    if not player then return true end
    return (targetInteractionCount[player.UserId] or 0) >= MAX_INTERACTIONS
end

local function setupCombatTracking()
    localPlayer.CharacterAdded:Connect(function(newChar)
        local hum = newChar:WaitForChild("Humanoid", 5)
        if hum then
            hum.Died:Connect(function()
                if currentTargetPlayer and currentTargetPlayer.Parent then
                    targetInteractionCount[currentTargetPlayer.UserId] = (targetInteractionCount[currentTargetPlayer.UserId] or 0) + 1
                end
            end)
        end
    end)

    if localPlayer.Character then
        local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function()
                if currentTargetPlayer and currentTargetPlayer.Parent then
                    targetInteractionCount[currentTargetPlayer.UserId] = (targetInteractionCount[currentTargetPlayer.UserId] or 0) + 1
                end
            end)
        end
    end

    RunService.Heartbeat:Connect(function()
        if currentTargetPlayer and currentTargetPlayer.Character then
            local targetHum = currentTargetPlayer.Character:FindFirstChildOfClass("Humanoid")
            if targetHum and targetHum.Health <= 0 then
                if not currentTargetPlayer:GetAttribute("LoggedDeath") then
                    currentTargetPlayer:SetAttribute("LoggedDeath", true)
                    targetInteractionCount[currentTargetPlayer.UserId] = (targetInteractionCount[currentTargetPlayer.UserId] or 0) + 1
                end
            elseif targetHum and targetHum.Health > 0 then
                currentTargetPlayer:SetAttribute("LoggedDeath", nil)
            end
        end
    end)
end

task.spawn(setupCombatTracking)

local function findNearestTarget(LocalPlayer, myRoot, myLevel)
    local now = tick()

    if now - lastTargetSearchTime < targetSearchInterval then
        return cachedNearestTarget
    end

    lastTargetSearchTime = now

    if not myRoot or not myRoot.Parent then
        cachedNearestTarget = nil
        currentTargetPlayer = nil
        return nil
    end

    local nearestTargetRoot = nil
    local nearestTargetChar = nil
    local nearestTargetPlayer = nil
    local shortestDistance = math.huge

    local playerList = updatePlayerCache()

    for _, targetPlayer in ipairs(playerList) do
        if targetPlayer ~= LocalPlayer
            and not shouldSkipTarget(targetPlayer, LocalPlayer)
            and not isTargetBlocked(targetPlayer) then

            local char = targetPlayer.Character

            if char and not ShouldIgnoreTarget(char, targetPlayer) then
                local targetRoot = char:FindFirstChild("HumanoidRootPart")
                local targetHum = char:FindFirstChildOfClass("Humanoid")

                if targetRoot and targetHum and targetHum.Health > 0 then

                    local inSafeZone = false
                    pcall(function()
                        if isPlayerInSafeZone then
                            inSafeZone = isPlayerInSafeZone(targetPlayer, char)
                        end
                    end)

                    if not inSafeZone then
                        local pvpDisabled =
                            targetPlayer:GetAttribute("PvpDisabled") == true
                            or char:GetAttribute("PvpDisabled") == true

                        if not pvpDisabled then
                            local targetLevel = getPlayerLevel(targetPlayer)
                            local isLevelValid = true

                            if type(myLevel) == "number"
                                and type(targetLevel) == "number" then

                                isLevelValid =
                                    math.abs(myLevel - targetLevel) <= 700
                            end

                            if isLevelValid then
                                local distance =
                                    (targetRoot.Position - myRoot.Position).Magnitude

                                if distance <= 15000
                                    and distance < shortestDistance then

                                    shortestDistance = distance
                                    nearestTargetRoot = targetRoot
                                    nearestTargetChar = char
                                    nearestTargetPlayer = targetPlayer
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    currentTargetPlayer = nearestTargetPlayer

    if nearestTargetPlayer then
        cachedNearestTarget = {
            root = nearestTargetRoot,
            char = nearestTargetChar,
            distance = shortestDistance,
            player = nearestTargetPlayer
        }
    else
        cachedNearestTarget = nil
    end

    return cachedNearestTarget
end

local PlayerGui = localPlayer:WaitForChild("PlayerGui")
local combatUI

local function findCombatUI()
    if combatUI and combatUI.Parent then
        return combatUI
    end

    combatUI = nil

    for _, obj in ipairs(PlayerGui:GetDescendants()) do
        if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox"))
            and not obj:GetFullName():find("Settings")
            and not obj:GetFullName():find("HUDButtonBar") then

            if string.lower(obj.Text or ""):find("in combat", 1, true) then
                combatUI = obj
                break
            end
        end
    end

    return combatUI
end

local function isPlayerInCombat2()
    local ui = findCombatUI()
    return ui ~= nil and ui.Parent ~= nil and ui.Visible == true
end

local function handleDefenseProtocol(myChar, rootPart, charHumanoid, deltaTime)
    if not defenseProtocolEnabled or charHumanoid.Health <= 0 then return false end

    local maxHp = charHumanoid.MaxHealth > 0 and charHumanoid.MaxHealth or 100
    local hpPercent = (charHumanoid.Health / maxHp) * 100

    if hpPercent <= healthTriggerThreshold or isEmergencyAscending then
        if not isEmergencyAscending then
            isEmergencyAscending = true
        end

        charHumanoid.PlatformStand = true
        local pos = rootPart.Position
        
        local newY = pos.Y + (ascentVelocity * deltaTime)
        rootPart.CFrame = CFrame.new(pos.X, newY, pos.Z)

        rootPart.AssemblyLinearVelocity = Vector3.zero
        rootPart.AssemblyAngularVelocity = Vector3.zero

        if charHumanoid.Health < (maxHp * (healthRecoveryThreshold / 100)) then
            return true 
        end

        isEmergencyAscending = false
        charHumanoid.PlatformStand = false
        rootPart.AssemblyLinearVelocity = Vector3.zero
        rootPart.AssemblyAngularVelocity = Vector3.zero
        return false
    end

    return false
end

local function runAutoBounty(deltaTime)
    if not autoBountyEnabled or not isTeamSwitchVerified then
        return
    end

    local myChar = localPlayer.Character
    if not myChar then return end

    local rootPart = myChar:FindFirstChild("HumanoidRootPart")
    local charHumanoid = myChar:FindFirstChildOfClass("Humanoid")
    if not rootPart or not charHumanoid then return end

    if handleDefenseProtocol(myChar, rootPart, charHumanoid, deltaTime) then
        return
    end

    local myLevel = getPlayerLevel(localPlayer)
    local targetData = findNearestTarget(localPlayer, rootPart, myLevel)

    local nearestTargetRoot = targetData and targetData.root
    local nearestTargetChar = targetData and targetData.char
    local shortestDistance = targetData and targetData.distance or math.huge

    if nearestTargetRoot and nearestTargetChar and charHumanoid.Health > 0 and shortestDistance <= 10000 then
        pcall(function()
            smoothFlyTo(nearestTargetRoot.CFrame, flySpeed, deltaTime, nearestTargetChar, shortestDistance)
        end)
        return
    end

    if not hopServersEnabled then return end
    if isPlayerInCombat2() then return end

    for i = 1, 30 do
        if not autoBountyEnabled or not hopServersEnabled or isEmergencyAscending or isPlayerInCombat2() then
            return
        end
        
        local checkTarget = findNearestTarget(localPlayer, rootPart, myLevel)
        if checkTarget and checkTarget.root and checkTarget.distance <= 10000 then
            return
        end
        
        task.wait(0.3)
    end

    local browserGui = localPlayer.PlayerGui:WaitForChild("ServerBrowser")
    browserGui.Enabled = true

    task.wait(1)

    while autoBountyEnabled and hopServersEnabled do
        if isEmergencyAscending or isPlayerInCombat2() then
            browserGui.Enabled = false
            return
        end

        local nData = findNearestTarget(localPlayer, rootPart, myLevel)
        if nData and nData.root and nData.distance <= 10000 then
            browserGui.Enabled = false
            return
        end

        local frame = browserGui:FindFirstChild("Frame", true)
        if frame then
            for _, i in ipairs(frame:GetDescendants()) do
                if not autoBountyEnabled or not hopServersEnabled or isEmergencyAscending then
                    browserGui.Enabled = false
                    return
                end

                local checkDuringJoin = findNearestTarget(localPlayer, rootPart, myLevel)
                if checkDuringJoin and checkDuringJoin.root and checkDuringJoin.distance <= 10000 then
                    browserGui.Enabled = false
                    return
                end

                if i:IsA("TextButton") and (i.Text == "Join" or i.Name == "JoinButton") then
                    if firesignal then
                        firesignal(i.MouseButton1Click)
                    end
                    task.wait(0.3)
                elseif i:IsA("ScrollingFrame") then
                    i.CanvasPosition = i.CanvasPosition + Vector2.new(0, 150)
                end
            end
        end

        task.wait(1)
    end

    browserGui.Enabled = false
end

local Toggle = Bounty:Toggle({
    Title = "Auto Bounty",
    Type = "Checkbox",
    Desc = "Auto-hunt up to 30M",
    Flag = "AutoBounty_Toggle",
    Callback = function(state)
        autoBountyEnabled = state

        if bountyConnection then
            bountyConnection:Disconnect()
            bountyConnection = nil
        end

        if autoBountyEnabled then
            isTeamSwitchVerified = false  
            lastTargetSearchTime = 0
            cachedNearestTarget = nil
            
            teamCheckLoopRunning = true
            task.spawn(function()
                while autoBountyEnabled and teamCheckLoopRunning do
                    if selectedFaction then
                        if not verifyTeamSwitch() then
                            checkAndSwitchTeam()
                        else
                            isTeamSwitchVerified = true
                        end
                    end
                    task.wait(2)
                end
            end)
            
            bountyConnection = RunService.Heartbeat:Connect(function(deltaTime)
                runAutoBounty(deltaTime)
            end)
        else
            teamCheckLoopRunning = false
            pcall(function()
                local browserGui = localPlayer.PlayerGui:FindFirstChild("ServerBrowser")
                if browserGui then browserGui.Enabled = false end
            end)
            if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
                localPlayer.Character.Humanoid.PlatformStand = false
            end
        end
    end
})

local ToggleHop = Bounty:Toggle({
    Title = "Hop Servers",
    Type = "Checkbox", 
    Desc = "Switch to another server.",
    Flag = "HopServers_Toggle",
    Default = false,
    Callback = function(state)
        hopServersEnabled = state
    end
})

local TogglePvP = Bounty:Toggle({
    Title = "Enable PvP",
    Type = "Checkbox",
    Desc = "Enable PvP mode at all times.",
    Flag = "Toggle_EnablePvP",
    Default = false,
    Callback = function(state)
        _G.EnablePvPLoop = state
        
        if state then
            task.spawn(function()
                while _G.EnablePvPLoop do
                    local args = {"EnablePvp"}
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
                    end)
                    task.wait(2)
                end
            end)
        end
    end
})

local DropdownMyFaction = Bounty:Dropdown({
    Title = "Auto Team",
    Desc = "Select a team",
    Values = {"Marines", "Pirates"},
    Multi = false,
    Locked = false,
    Flag = "my_faction_select",
    Callback = function(selected)
        selectedFaction = selected
        if autoBountyEnabled and selectedFaction then
            checkAndSwitchTeam()
        end
    end
})

local UtilitySection = Bounty:Section({ 
    Title = "Settings Skills", 
    Icon = "settings" 
})
Bounty:Divider() 

local SliderFlySpeed = Bounty:Slider({
    Title = "Fly Speed",
    Desc = "Adjust movement speed while flying to targets",
    Value = {
        Min = 50,
        Max = 350,
        Default = 210
    },
    Step = 5,
    Flag = "FlySpeed_Slider",
    Callback = function(value)
        flySpeed = value
    end
})

local DropdownMelee = Bounty:Dropdown({
    Title = "Melee",
    Desc = "Select Melee skills ",
    Values = {"Z", "X", "C"},
    Multi = true,
    AllowNone = true,
    Flag = "melee_skill_multi",
    Callback = function(selected)
        selectedMeleeSkills = selected
    end
})

local DropdownSword = Bounty:Dropdown({
    Title = "Sword",
    Desc = "Select Sword skills",
    Values = {"Z", "X"},
    Multi = true,
    AllowNone = true,
    Flag = "sword_skill_multi",
    Callback = function(selected)
        selectedSwordSkills = selected
    end
})

local DropdownFruit = Bounty:Dropdown({
    Title = "Fruit",
    Desc = "Select Blox Fruit skills ",
    Values = {"Z", "X", "C", "V", "F"},
    Multi = true,
    AllowNone = true,
    Flag = "fruit_skill_multi",
    Callback = function(selected)
        selectedFruitSkills = selected
    end
})

local DropdownGun = Bounty:Dropdown({
    Title = "Gun",
    Desc = "Select Gun skills ",
    Values = {"Z", "X"},
    Multi = true,
    AllowNone = true,
    Flag = "gun_skill_multi",
    Callback = function(selected)
        selectedGunSkills = selected
    end
})

RunService.RenderStepped:Connect(function()
    if not autoBountyEnabled then
        cachedNearestTarget = nil
        currentTargetPlayer = nil
        return
    end

    local char = localPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum or hum.Health <= 0 then
        cachedNearestTarget = nil
        currentTargetPlayer = nil
        return
    end

    if currentTargetPlayer and currentTargetPlayer.Character then
        local targetHum = currentTargetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not targetHum or targetHum.Health <= 0 then
            cachedNearestTarget = nil
            currentTargetPlayer = nil
        end
    end
end)
