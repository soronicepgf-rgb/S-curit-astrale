local soronice = loadstring(game:HttpGet('https://raw.githubusercontent.com/Audinay/Cr-ation-principale-de-mon-site-internet-et-de-mes-scripts./refs/heads/main/Scriptation%20professionell%20SORONICE.COM'))()

local WindowName = "SORONICEv5 HUB"
local Window = soronice:CreateWindow({
    Name = WindowName,
    ShowDevice = true,
    ShowPing = true,
    ShowFPS = true,
    VersionTag = "V33 Update ",
    KeySystem = false, 
    KeySettings = { Title = "ACCÈS PREMIUM", LinkText = "Copier le lien", Key = "1234", GrabKeyFromSite = false, Link = "https://google.com" }
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local isPC = UserInputService.KeyboardEnabled and not UserInputService.TouchEnabled
local rockSearchDelay = isPC and 4 or 1
local rockMoveDelay = isPC and 0.5 or 0.2

-- ==========================================
-- FONCTIONS OUTILS
-- ==========================================
local function findToolSmart(character, toolName)
    local lowerTarget = string.lower(toolName)
    if character then
        for _, item in pairs(character:GetChildren()) do
            if item:IsA("Tool") and string.find(string.lower(item.Name), lowerTarget) then return item end
        end
    end
    if player.Backpack then
        for _, item in pairs(player.Backpack:GetChildren()) do
            if item:IsA("Tool") and string.find(string.lower(item.Name), lowerTarget) then return item end
        end
    end
    return nil
end

local function zeroOutCooldown(tool, valueName)
    local lowerTarget = string.lower(valueName)
    for _, item in pairs(tool:GetChildren()) do
        if string.lower(item.Name) == lowerTarget then
            if item:IsA("NumberValue") or item:IsA("IntValue") then item.Value = 0 end
        end
    end
end

local function TeleportToPosition(x, y, z)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
    end
end

-- ==========================================
-- VARIABLES GLOBALES
-- ==========================================
local autoPunchActive = false
local spinActive = false 
local freezeActive = false
local savedFreezeCFrame = nil -- On sauvegarde le CFrame complet

local bringTargetName = ""
local bringSingleActive = false
local bringAllActive = false
local originalPlayerCFrames = {} 

local ignoreTargetName = ""
local ignoreActive = false

local bringRockTarget = "TINY ROCK"
local bringSingleRockActive = false
local bringAllRocksActive = false
local originalRockCFrames = {} 

local rockList = {
    "TINY ROCK", "FROZEN ROCK", "INFERNO ROCK", "ROCK OF LEGENTS", "MUSCLE KING MOUNTAIN", "ROCHER 6"
}

-- VOS CALCULS PARFAITS INSÉRÉS ICI
local function getDistanceForRock(rockName)
    local lowerName = string.lower(rockName)
    if string.find(lowerName, "tiny") then return 12.3 end 
    if string.find(lowerName, "frozen") then return 38.6 end 
    if string.find(lowerName, "inferno") or string.find(lowerName, "ivferno") then return 40.4 end 
    if string.find(lowerName, "legents") then return 38.5 end 
    if string.find(lowerName, "muscle") then return 52.2 end 
    return 71.3 -- Fallback pour le 6ème
end

-- Fonction pour vérifier si un joueur est allié (Whitelist)
local function isWhitelisted(playerName)
    if not ignoreActive or ignoreTargetName == "" then return false end
    local ignoredNames = string.split(ignoreTargetName, "-")
    for _, ign in pairs(ignoredNames) do
        local clean = string.lower(ign):match("^%s*(.-)%s*$")
        if clean and clean ~= "" and string.find(string.lower(playerName), clean) then
            return true
        end
    end
    return false
end

-- ==========================================
-- BOUCLE FREEZE ABSOLU & SPIN (SANS PHYSIQUE GLITCHÉE)
-- ==========================================
RunService.Stepped:Connect(function(_, dt)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    
    -- On s'assure que le joueur est vivant
    if hum.Health <= 0 then return end

    if freezeActive and savedFreezeCFrame then
        -- On bloque toute vélocité pour ne pas être poussé ou mis à l'envers
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.RotVelocity = Vector3.new(0,0,0)
        
        if spinActive then
            -- Freeze + Toupie : Reste à la position exacte, mais tourne
            savedFreezeCFrame = savedFreezeCFrame * CFrame.Angles(0, math.rad(1000 * dt), 0)
            hrp.CFrame = savedFreezeCFrame
        else
            -- Freeze normal : Immobile complet
            hrp.CFrame = savedFreezeCFrame
        end
    elseif spinActive and not freezeActive then
        -- Toupie Libre : Tourne tout en marchant
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(1000 * dt), 0)
    end
end)

-- RESPAWN ANTI-MORT : Si tu meurs, on te remet en place dès que tu réapparais
player.CharacterAdded:Connect(function(newChar)
    if freezeActive and savedFreezeCFrame then
        local hrp = newChar:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            task.wait(0.5) -- Laisse le jeu te faire spawner
            hrp.CFrame = savedFreezeCFrame -- Retéléportation immédiate à ta zone de farm
        end
    end
end)

-- ==========================================
-- BOUCLE ESP (HIGHLIGHTS + BARRE DE VIE)
-- ==========================================
task.spawn(function()
    while true do
        task.wait(0.5)
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                local char = v.Character
                local hum = char.Humanoid
                
                -- Gestion du Highlight (Rouge = Ennemi, Vert = Allié)
                local hl = char:FindFirstChild("SoroniceHighlight")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "SoroniceHighlight"
                    hl.Parent = char
                end
                
                if isWhitelisted(v.Name) then
                    hl.FillColor = Color3.new(0, 1, 0) -- Vert (Allié)
                else
                    hl.FillColor = Color3.new(1, 0, 0) -- Rouge (Ennemi)
                end
                
                -- Gestion du Texte & Barre de vie au-dessus de la tête
                local head = char:FindFirstChild("Head")
                if head then
                    local bg = head:FindFirstChild("SoroniceESP_UI")
                    if not bg then
                        bg = Instance.new("BillboardGui")
                        bg.Name = "SoroniceESP_UI"
                        bg.Size = UDim2.new(4, 0, 1.5, 0)
                        bg.StudsOffset = Vector3.new(0, 2.5, 0)
                        bg.AlwaysOnTop = true
                        bg.Parent = head
                        
                        local nameLabel = Instance.new("TextLabel", bg)
                        nameLabel.Name = "NameLabel"
                        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.TextColor3 = Color3.new(1, 1, 1)
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.Font = Enum.Font.SourceSansBold
                        nameLabel.TextScaled = true
                        
                        local healthBg = Instance.new("Frame", bg)
                        healthBg.Name = "HealthBg"
                        healthBg.Size = UDim2.new(0.8, 0, 0.3, 0)
                        healthBg.Position = UDim2.new(0.1, 0, 0.6, 0)
                        healthBg.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
                        
                        local healthBar = Instance.new("Frame", healthBg)
                        healthBar.Name = "HealthBar"
                        healthBar.Size = UDim2.new(1, 0, 1, 0)
                        healthBar.BackgroundColor3 = Color3.new(0, 1, 0)
                    end
                    
                    -- Mise à jour visuelle
                    bg.NameLabel.Text = (isWhitelisted(v.Name) and "[ALLIÉ] " or "[ENNEMI] ") .. v.Name
                    bg.NameLabel.TextColor3 = isWhitelisted(v.Name) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                    
                    local healthPct = hum.Health / (hum.MaxHealth > 0 and hum.MaxHealth or 1)
                    bg.HealthBg.HealthBar.Size = UDim2.new(healthPct, 0, 1, 0)
                    bg.HealthBg.HealthBar.BackgroundColor3 = Color3.new(1 - healthPct, healthPct, 0)
                end
            end
        end
    end
end)

-- ==========================================
-- BOUCLE JOUEURS (BRING)
-- ==========================================
task.spawn(function()
    local wasPlayerActive = false
    while true do
        task.wait(0.03) 
        if bringSingleActive or bringAllActive then
            wasPlayerActive = true
            local myChar = player.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local myPos = myChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3) -- Distance frappe
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local isTarget = false
                        if not isWhitelisted(v.Name) then
                            if bringAllActive then isTarget = true
                            elseif bringSingleActive and v.Name == bringTargetName then isTarget = true end
                        end
                        
                        if isTarget then
                            if not originalPlayerCFrames[v] then originalPlayerCFrames[v] = v.Character.HumanoidRootPart.CFrame end
                            v.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                            v.Character.HumanoidRootPart.CFrame = myPos
                        else
                            if originalPlayerCFrames[v] then
                                v.Character.HumanoidRootPart.CFrame = originalPlayerCFrames[v]
                                originalPlayerCFrames[v] = nil
                            end
                        end
                    end
                end
            end
        else
            if wasPlayerActive then
                for v, origCf in pairs(originalPlayerCFrames) do
                    if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        v.Character.HumanoidRootPart.CFrame = origCf
                    end
                end
                originalPlayerCFrames = {} 
                wasPlayerActive = false
            end
        end
    end
end)

-- ==========================================
-- BOUCLE ROCHERS
-- ==========================================
task.spawn(function()
    while true do
        task.wait(rockMoveDelay) 
        if bringSingleRockActive or bringAllRocksActive then
            local myChar = player.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                for obj, _ in pairs(originalRockCFrames) do
                    if obj and obj.Parent then
                        local dist = getDistanceForRock(obj.Name)
                        local myPos = myChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, -dist)
                        if obj:IsA("Model") then obj:PivotTo(myPos)
                        elseif obj:IsA("BasePart") then obj.CFrame = myPos end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    local wasRockActive = false
    while true do
        if bringSingleRockActive or bringAllRocksActive then
            wasRockActive = true
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") or obj:IsA("BasePart") then
                    local skip = false
                    if obj:IsA("BasePart") and obj.Parent and obj.Parent:IsA("Model") and originalRockCFrames[obj.Parent] then skip = true end
                    if not skip then
                        local nameLower = string.lower(obj.Name)
                        local isTarget = false
                        if bringAllRocksActive then
                            for _, rName in pairs(rockList) do
                                if string.find(nameLower, string.lower(rName)) then isTarget = true; break end
                            end
                        elseif bringSingleRockActive then
                            if string.find(nameLower, string.lower(bringRockTarget)) then isTarget = true end
                        end
                        if isTarget and not originalRockCFrames[obj] then
                            if obj:IsA("Model") then originalRockCFrames[obj] = obj:GetPivot()
                            elseif obj:IsA("BasePart") then originalRockCFrames[obj] = obj.CFrame end
                        end
                    end
                end
            end
            task.wait(rockSearchDelay) 
        else
            if wasRockActive then
                for obj, origCf in pairs(originalRockCFrames) do
                    if obj and obj.Parent then
                        if obj:IsA("Model") then obj:PivotTo(origCf)
                        elseif obj:IsA("BasePart") then obj.CFrame = origCf end
                    end
                end
                originalRockCFrames = {} 
                wasRockActive = false
            end
            task.wait(0.5)
        end
    end
end)

-- ==========================================
-- BOUCLE AUTO PUNCH 
-- ==========================================
task.spawn(function()
    while true do
        if autoPunchActive then
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                local tool = findToolSmart(character, "punch")
                if tool then
                    if tool.Parent == player.Backpack then character.Humanoid:EquipTool(tool) end
                    zeroOutCooldown(tool, "attacktime")
                    tool:Activate()
                end
            end
        end
        task.wait(0.01) 
    end
end)

-- ==========================================
-- TABS & UI
-- ==========================================
local Tab1 = Window:CreateTab("AutoForm", 137079533665791)

Tab1:CreateToggle({
    Name = "❄️ Freeze Absolu (Anti-Fling & Hitbox OK)",
    CurrentValue = false,
    Callback = function(Value)
        freezeActive = Value
        local char = player.Character
        if freezeActive then
            if char and char:FindFirstChild("HumanoidRootPart") then
                -- On sauvegarde TOUT : position et orientation pour ne jamais être à l'envers
                savedFreezeCFrame = char.HumanoidRootPart.CFrame
            end
        else
            savedFreezeCFrame = nil
        end
    end,
})

Tab1:CreateToggle({
    Name = "🌪️ True Beyblade (360 Spin Ultime)",
    CurrentValue = false,
    Callback = function(Value) spinActive = Value end,
})

local autoWeightActive = false
Tab1:CreateToggle({
    Name = "💪 Auto Muscle (Weight No Cooldown)",
    CurrentValue = false,
    Callback = function(Value)
        autoWeightActive = Value
        if autoWeightActive then
            task.spawn(function()
                while autoWeightActive do
                    local char = player.Character
                    if char and char:FindFirstChild("Humanoid") then
                        local tool = findToolSmart(char, "weight")
                        if tool then
                            if tool.Parent == player.Backpack then char.Humanoid:EquipTool(tool) end
                            zeroOutCooldown(tool, "reptime")
                            tool:Activate()
                        end
                    end
                    task.wait(0.01) 
                end
            end)
        end
    end,
})

Tab1:CreateToggle({
    Name = "👊 Auto Punch (No Cooldown)",
    CurrentValue = false,
    Callback = function(Value) autoPunchActive = Value end,
})

local Tab2 = Window:CreateTab("Téléportation", 104689322606609)
local locations = {
    ["Base une"] = {x = 3.784, y = 9.031, z = 176.69},
    ["Base deux safe"] = {x = -40.777, y = 11.73, z = 1855.154},
    ["Base trois blood"] = {x = -2558.26, y = 17.854, z = -410.588},
    ["Base quatre people"] = {x = 2194.13, y = 16.957, z = 1073.512},
    ["Base cinq orange"] = {x = -6705.628, y = 16.638, z = -1285.84},
    ["Base légende"] = {x = 4652.192, y = 999.758, z = -3906.662},
    ["Base seven legendary"] = {x = -8753.05, y = 25.347, z = 2386.89},
    ["Communauté people ville"] = {x = -8569.865, y = 28.217, z = -5661.357}
}
local currentSelection = "Base une"
Tab2:CreateDropdown({
    Name = "Sélectionner une Destination",
    Options = {"Base une", "Base deux safe", "Base trois blood", "Base quatre people", "Base cinq orange", "Base légende", "Base seven legendary", "Communauté people ville"},
    CurrentOption = "Base une",
    Callback = function(Option) currentSelection = Option end,
})
Tab2:CreateButton({
    Name = "🚀 Se Téléporter",
    Callback = function()
        local pos = locations[currentSelection]
        if pos then TeleportToPosition(pos.x, pos.y, pos.z) end
    end,
})

local Tab3 = Window:CreateTab("Combat Mode", 114586072621018)
local function GetPlayerNames()
    local names = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player then table.insert(names, v.Name) end
    end
    if #names == 0 then table.insert(names, "Aucun autre joueur") end
    return names
end

local PlayerDropdown = Tab3:CreateDropdown({
    Name = "Sélectionner un Joueur (Cible)",
    Options = GetPlayerNames(),
    CurrentOption = GetPlayerNames()[1] or "",
    Callback = function(Option) bringTargetName = Option end,
})
Tab3:CreateButton({
    Name = "🔄 Actualiser la cible",
    Callback = function() PlayerDropdown:Refresh(GetPlayerNames(), true) end,
})
Tab3:CreateToggle({
    Name = "🎯 Ramener le joueur sélectionné",
    CurrentValue = false,
    Callback = function(Value)
        bringSingleActive = Value
        if Value then bringAllActive = false end 
    end,
})
Tab3:CreateToggle({
    Name = "💀 Ramener TOUS LES JOUEURS (ALL)",
    CurrentValue = false,
    Callback = function(Value)
        bringAllActive = Value
        if Value then bringSingleActive = false end 
    end,
})
Tab3:CreateInput({
    Name = "Whitelist (Sépare par un tiret '-')",
    PlaceholderText = "Ex: joueur1-joueur2-joueur3",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) ignoreTargetName = Text end,
})
Tab3:CreateToggle({
    Name = "🛡️ Activer la Whitelist",
    CurrentValue = false,
    Callback = function(Value) ignoreActive = Value end,
})
Tab3:CreateToggle({
    Name = "👊 Auto Punch (Tabasser la cible)",
    CurrentValue = false,
    Callback = function(Value) autoPunchActive = Value end,
})

local Tab4 = Window:CreateTab("Mode Farm Go", 137079533665791)
Tab4:CreateSlider({
    Name = "📏 Gérer ma Hauteur (Sûre)",
    Range = {0, 50},
    Increment = 1,
    Suffix = " Hauteur",
    CurrentValue = 2,
    Callback = function(Value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            -- Hauteur plafonnée pour éviter les bugs
            player.Character.Humanoid.HipHeight = Value
        end
    end,
})
Tab4:CreateDropdown({
    Name = "Sélectionner un Rocher",
    Options = rockList,
    CurrentOption = "TINY ROCK",
    Callback = function(Option) bringRockTarget = Option end,
})
Tab4:CreateToggle({
    Name = "🪨 Ramener le rocher sélectionné",
    CurrentValue = false,
    Callback = function(Value)
        bringSingleRockActive = Value
        if Value then bringAllRocksActive = false end
    end,
})
Tab4:CreateToggle({
    Name = "⛰️ Ramener TOUS LES ROCHERS (ALL)",
    CurrentValue = false,
    Callback = function(Value)
        bringAllRocksActive = Value
        if Value then bringSingleRockActive = false end
    end,
})
Tab4:CreateToggle({
    Name = "👊 Auto Punch (Casser le rocher)",
    CurrentValue = false,
    Callback = function(Value) autoPunchActive = Value end,
})

local Tab5 = Window:CreateTab("Stats Joueurs", 134567891234)
local statsParagraph = Tab5:CreateParagraph({
    Title = "Données du Joueur", 
    Content = "Sélectionne un joueur pour lire ses statistiques (Gemmes, Force, Vitesse, Trophées...)."
})

local function refreshStats(playerName)
    local target = Players:FindFirstChild(playerName)
    if target then
        local statsText = ""
        local foldersToSearch = {"leaderstats", "Stats", "Data", "playerStats", "hiddenStats"}
        for _, folderName in pairs(foldersToSearch) do
            local folder = target:FindFirstChild(folderName)
            if folder then
                for _, stat in pairs(folder:GetChildren()) do
                    if stat:IsA("ValueBase") then 
                        statsText = statsText .. "🔹 " .. stat.Name .. " : " .. tostring(stat.Value) .. "\n"
                    end
                end
            end
        end
        if statsText == "" then statsText = "⚠️ Stats introuvables." end
        statsParagraph:Set({Title = "📊 Stats de " .. playerName, Content = statsText})
    else
        statsParagraph:Set({Title = "Erreur", Content = "Joueur introuvable ou déconnecté."})
    end
end

local StatsDropdown = Tab5:CreateDropdown({
    Name = "Sélectionner un Joueur",
    Options = GetPlayerNames(),
    CurrentOption = GetPlayerNames()[1] or "",
    Callback = function(Option) refreshStats(Option) end,
})
Tab5:CreateButton({
    Name = "🔄 Actualiser la liste et les stats",
    Callback = function() 
        StatsDropdown:Refresh(GetPlayerNames(), true)
        if StatsDropdown.CurrentOption ~= "" then refreshStats(StatsDropdown.CurrentOption) end
    end,
})
