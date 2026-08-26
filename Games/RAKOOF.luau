-- loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneuk/Warehouse/refs/heads/main/Games/RAKOOF.luau"))()
local RJelly = loadstring(Game:HttpGet("https://raw.githubusercontent.com/someoneuk/Warehouse/refs/heads/main/Libraries/RJelly/RJellyUI.lua"))()
local Window = RJelly:MakeWindow("Rakoof v2")

-- Services
local Lighting = game:GetService('Lighting')
local RunService = game:GetService('RunService')

local scriptwidebypass = false
local speaker = game:GetService('Players').LocalPlayer
local char = speaker.Character or speaker.CharacterAdded:Wait()
local hmd:Humanoid = char:WaitForChild('Humanoid')
speaker.CharacterAdded:Connect(function(a0: Model)
    char = a0
    hmd = a0:WaitForChild('Humanoid')
end)

local function TPto(cf:CFrame)
    scriptwidebypass = true
    for i = 1,10 do
        char:PivotTo(cf)
        task.wait(.02)
    end
    scriptwidebypass = false
end

-- Conns
local ToggleConns1 = {}
local EnvTab = Window:MakeTab('Environment')
EnvTab:MakeToggle('Fullbright',function(value:boolean)

    if value == true then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1,1,1)
        
        ToggleConns1[1] = Lighting.Changed:Connect(function(a0: string)
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.new(1,1,1)
        end)
    else
        if ToggleConns1[1] then
            ToggleConns1[1]:Disconnect()
        end

    end
end)

EnvTab:MakeToggle('Daytime',function(value:boolean)

    if value == true then
        Lighting.ClockTime = 14
        
        ToggleConns1[1] = Lighting.Changed:Connect(function(a0: string)
            Lighting.ClockTime = 14
        end)
    else
        if ToggleConns1[1] then
            ToggleConns1[1]:Disconnect()
        end

    end
end)

EnvTab:MakeToggle('Disable hour effect',function(value:boolean)
    Lighting.HourCC.Enabled = not value
    speaker.PlayerGui.HoursGui.Enabled = not value
end)

EnvTab:MakeToggle('No Fog',function(value:boolean)
    if value then
        Lighting.Atmosphere.Density = 0
        ToggleConns1[2] = Lighting.Atmosphere.Changed:Connect(function()
            Lighting.Atmosphere.Density = 0
        end)
    else
        if ToggleConns1[2] then
            ToggleConns1[2]:Disconnect()
        end
    end
end)

EnvTab:MakeToggle('Xray closets',function(value:boolean)
    if value then
        for _, v in workspace.Filter.Closets:GetDescendants() do
            if v:IsA("BasePart") then
                v.Transparency = .5
            end
        end
    else
        for _, v in workspace.Filter.Closets:GetDescendants() do
            if v:IsA("BasePart") then
                v.Transparency = 0
            end
        end
    end
end)

local TreeStore = {}
for _, v in workspace.NatureFolder.Trees:GetChildren() do
    table.insert(TreeStore, v)
end
EnvTab:MakeToggle('Hide Tree',function(value:boolean)
    if value then
        for _, v in TreeStore do
            v.Parent = nil
        end
    else
        for _, v in TreeStore do
            v.Parent = workspace.NatureFolder.Trees
        end
    end
end)

EnvTab:MakeToggle('Remove Clouds',function(value)
    workspace.Terrain.Clouds.Enabled = not value
end)

EnvTab:MakeButton('Remove Inv Barrier',function()
    for _, v in workspace:GetDescendants() do
        if v:IsA('BasePart') and string.lower(v.Name) == 'invpart' then
            v.Size = Vector3.zero
        end
    end
end)

EnvTab:MakeButton('Remove Skybox',function()
    if Lighting.NormalSky then
        Lighting.NormalSky:Destroy()
    end
end)




local PlayerTab = Window:MakeTab("Player")

local PlayerTabConns = {}


local lastPivot = nil
PlayerTab:MakeToggle('speed hack', function(value)
    if value then
        lastPivot = nil
        
        PlayerTabConns[1] = RunService.Heartbeat:Connect(function(a0: number)
            if (char and hmd and not scriptwidebypass) then
                local currentPivot = char:GetPivot()
                
                if lastPivot and a0 > 0 then
                    local distance = (currentPivot.Position - lastPivot.Position).Magnitude
                    local currentSpeed = distance / a0
                    
                    if hmd.MoveDirection.Magnitude > 0 then
                        local clampedSpeed = math.clamp(currentSpeed, 33, 40)
                        local alpha = (clampedSpeed - 33) / (50 - 33)
                        
                        local speedMultiplier = 2.8 + (0 - 2.8) * alpha

                        char:TranslateBy(hmd.MoveDirection * speedMultiplier * a0 * 10)
                    end
                end
                
                lastPivot = currentPivot
            end
        end)
    else
        if PlayerTabConns[1] then
            PlayerTabConns[1]:Disconnect()
            PlayerTabConns[1] = nil
        end
        lastPivot = nil
    end
end)

local lastPosFrame = char:GetPivot()
local bypass = false
PlayerTab:MakeToggle('Anti-teleport',function(value)
    lastPosFrame = char:GetPivot()
    if value then
            PlayerTabConns[2] = RunService.Heartbeat:Connect(function(a0: number)
                if (lastPosFrame.Position - char:GetPivot().Position).Magnitude > 3 and not bypass and not scriptwidebypass then
                    char:PivotTo(lastPosFrame)
                    bypass = true
                    task.delay(0, function()
                        bypass = false
                    end)
                end
                lastPosFrame = char:GetPivot()
      
        end)
    else
        if PlayerTabConns[2] then
            PlayerTabConns[2]:Disconnect()
        end
    end

end)


local ESPTab = Window:MakeTab("ESP")
local function createLabel(title:string,objPos:BasePart|CFrame,target:Instance,col:Color3,dist:boolean,hp:boolean,hmd:Humanoid)
    local conns = nil
    local BillboardGui = Instance.new('BillboardGui',game:GetService('CoreGui'))
    local Label = Instance.new("TextLabel")
    Label.Parent = BillboardGui

    BillboardGui.Adornee = target
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 0
    BillboardGui.Size = UDim2.fromScale(1, 1)

    Label.Size = UDim2.fromOffset(300, 19)
    Label.Position = UDim2.fromScale(.5, .5)
    Label.AnchorPoint = Vector2.new(.5,.5)
    Label.BackgroundTransparency = 1
    Label.TextStrokeTransparency = 0
    Label.TextScaled = true
    Label.TextColor3 = col
    Label.Font = Enum.Font.Ubuntu

    conns = RunService.RenderStepped:Connect(function(a0: number)
        -- a destroyed instance keeps its variable, but loses its Parent - check that instead
        if not target or not target.Parent or (hmd and not hmd.Parent) then
            pcall(function() BillboardGui:Destroy() end)
            conns:Disconnect()
            return -- stop here, don't touch the label we just destroyed
        end

        local text = title
        if hp then
            text = text.." | HP:"..math.floor(hmd.Health)
        end
        if dist then
            text = text.." | "..math.floor((objPos.Position - workspace.CurrentCamera.CFrame.Position).Magnitude)
        end
        Label.Text = text

        task.wait(.1)
    end)

    target.Destroying:Connect(function()
        pcall(function()
            BillboardGui:Destroy()
            conns:Disconnect()
        end)
    end)
    return BillboardGui
end
local ESPConns = {
    ['coins'] = {},
    ['lootable'] = {},
    ['flare'] = {},
    ['consumable'] = {},
    ['player'] = {}
}

local billboards = {
    ['coins'] = {},
    ['scraps'] = {},
    ['flare_supply'] = {},
    ['lootable'] = {},
    ['closets'] = {},
    ['flare'] = {},
    ['fish'] = {},
    ['consumable'] = {},
    ['player'] = {}
}

ESPTab:MakeToggle("ESP Rakoof",function(value)
    if value then
        local rakoof = workspace:WaitForChild('RakoofNPC')
        local hmd = rakoof:WaitForChild('NPC')
        billboards['rakoof'] = createLabel('Rakoof', rakoof:WaitForChild('HumanoidRootPart'), rakoof,Color3.new(1,0,0), true, true, hmd)

        ESPConns[1] = workspace.ChildAdded:Connect(function(a0: Instance)
            if a0.Name == 'RakoofNPC' then
                rakoof = a0
                hmd = a0:WaitForChild('NPC')
                billboards["rakoof"] = createLabel('Rakoof', rakoof:WaitForChild('HumanoidRootPart'), rakoof,Color3.new(1,0,0), true, true, hmd)
            end
        end)
    else
        if billboards["rakoof"] then
            billboards["rakoof"]:Destroy()
        end
        ESPConns[1]:Disconnect()
    end
end)

ESPTab:MakeToggle('ESP Players',function(value)
    if value then
        for _, plr in game.Players:GetPlayers() do
            if plr == game.Players.LocalPlayer then continue end

            if plr.Character then
                local hmd = plr.Character:FindFirstChildOfClass("Humanoid")
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if hmd and root then
                    local billboard = createLabel(plr.Name, root, root, Color3.fromRGB(255, 255, 255), false, true, hmd)
                    billboard.Enabled = true
                    table.insert(billboards['player'],billboard)
                end
            end

            table.insert(ESPConns['player'], plr.CharacterAdded:Connect(function(char)
                local hmd = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hmd and root then
                    local billboard = createLabel(plr.Name, root, root, Color3.fromRGB(255, 255, 255), false, true, hmd)
                    billboard.Enabled = true
                    table.insert(billboards['player'],billboard)
                end
            end))
        end

        table.insert(ESPConns['player'], game.Players.PlayerAdded:Connect(function(plr)
            table.insert(ESPConns['player'], plr.CharacterAdded:Connect(function(char)
                local hmd = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hmd and root then
                    local billboard = createLabel(plr.Name, root, root, Color3.fromRGB(255, 255, 255), false, true, hmd)
                    billboard.Enabled = true
                    table.insert(billboards['player'],billboard)
                end
            end))
        end))
    else
        for _, v in billboards['player'] do
            v:Destroy()
        end
        for _, v in ESPConns['player'] do
            v:Disconnect()
        end
    end
end)

ESPTab:MakeToggle("ESP Coins",function(value)

    if value then

        for _, v:MeshPart in workspace.Filter.Givers.Coin:GetChildren() do

            if v.Name == "CoinGiver" then

                local billboard = createLabel("Coin", v.CFrame, v, Color3.fromRGB(255,222,50), false, false, nil)
                billboard.Enabled = v.ProximityPrompt.Enabled

                table.insert(billboards['coins'],billboard)
                table.insert(ESPConns['coins'], v.ProximityPrompt.Changed:Connect(function()
                    billboard.Enabled = v.ProximityPrompt.Enabled
                end))
            end



        end


    else

        for i, v in billboards['coins'] do
            v:Destroy()
        end
        for i, v in ESPConns['coins'] do
            v:Disconnect()
        end

    end

end)

ESPTab:MakeToggle('ESP Scraps',function(value)

    if value then
        for _, v in workspace.Filter.ScrapMetals:GetChildren() do
            local billboard = createLabel(v.Name, v:GetPivot(), v, Color3.fromRGB(108, 88, 75), false, false, false)

            table.insert(billboards['scraps'],billboard)

            local conns = nil
            conns = v.Destroying:Connect(function()
                billboard['scraps'][billboard] = nil
                conns:Disconnect()
            end)

            billboard.Destroying:Connect(function()
                conns:Disconnect()
            end)

        end
        ESPConns[2] = workspace.Filter.ScrapMetals.ChildAdded:Connect(function(v)
            local billboard = createLabel(v.Name, v:GetPivot(), v, Color3.fromRGB(108, 88, 75), false, false, false)
            table.insert(billboards['scraps'],billboard)
        end)
    else
        for _, v in billboards['scraps'] do
            v:Destroy()
        end

        ESPConns[2]:Disconnect()
    end

end)

ESPTab:MakeToggle('ESP Supply',function(value)

    if value then
        for _, v in workspace.PlaceableToolsFolder.Flare:GetChildren() do
            local billboard = createLabel(v.Name, v:GetPivot(), v, Color3.fromRGB(182, 126, 89), false, false, false)

            table.insert(billboards['flare_supply'],billboard)

            local conns = nil
            conns = v.Destroying:Connect(function()
                billboard['flare_supply'][billboard] = nil
                conns:Disconnect()
            end)

            billboard.Destroying:Connect(function()
                conns:Disconnect()
            end)

        end
        ESPConns[3] = workspace.PlaceableToolsFolder.Flare.ChildAdded:Connect(function(v)
            local billboard = createLabel(v.Name, v:GetPivot(), v, Color3.fromRGB(182, 126, 89), false, false, false)
            table.insert(billboards['flare_supply'],billboard)
        end)
    else
        for _, v in billboards['flare_supply'] do
            v:Destroy()
        end

        ESPConns[3]:Disconnect()
    end

end)

ESPTab:MakeToggle("ESP Flare",function(value)
    if value == true then
        for _, v in workspace.Filter.Givers.Flare:GetDescendants() do
            if v:IsA("ProximityPrompt") then
                local model = v:FindFirstAncestorWhichIsA('Model')
                local billboard = createLabel(model.Name, model:GetPivot(), model, Color3.fromRGB(224, 78, 134), false, false, nil)
                billboard.Enabled = v.Enabled

                table.insert(billboards['flare'],billboard)
                
                table.insert(ESPConns['flare'], v.Changed:Connect(function()
                    billboard.Enabled = v.Enabled
                end))
            end
        end
    else
        for i, v in billboards['flare'] do
            v:Destroy()
        end
        for i, v in ESPConns['flare'] do
            v:Disconnect()
        end
    end
end)

ESPTab:MakeToggle("ESP Lootable",function(value)
    if value == true then
        for _, v in workspace.Filter.Lootable:GetDescendants() do
            print(v:GetFullName())
            if v:IsA("ProximityPrompt") then
                print('yes')
                local model = v:FindFirstAncestorWhichIsA('Model')
                local billboard = createLabel(model.Name, model:GetPivot(), model, Color3.fromRGB(42, 151, 51), false, false, nil)
                billboard.Enabled = v.Enabled

                table.insert(billboards['lootable'],billboard)
                
                table.insert(ESPConns['lootable'], v.Changed:Connect(function()
                    billboard.Enabled = v.Enabled
                end))
            end
        end
    else
        for i, v in billboards['lootable'] do
            v:Destroy()
        end
        for i, v in ESPConns['lootable'] do
            v:Disconnect()
        end
    end
end)

ESPTab:MakeToggle("ESP Closets", function(value)
    if value then
        for _, v in workspace.Filter.Closets:GetChildren() do
            local billboard = createLabel(v.Name, v:GetPivot(), v, Color3.new(.6,.6,.6), true, false, false)

            table.insert(billboards['closets'],billboard)
        end
    else
        for _, v in billboards['closets'] do
            v:Destroy()
        end
    end
end)

ESPTab:MakeToggle('ESP Fish',function(value)

    if value then
        for _, v in workspace.Filter.Givers.Fish:GetChildren() do
            local billboard = createLabel(v.Name, v:GetPivot(), v, Color3.fromRGB(77, 191, 226), false, false, false)

            table.insert(billboards['fish'],billboard)

            local conns = nil
            conns = v.Destroying:Connect(function()
                billboard['fish'][billboard] = nil
                conns:Disconnect()
            end)

            billboard.Destroying:Connect(function()
                conns:Disconnect()
            end)

        end
        ESPConns[4] = workspace.Filter.Givers.Fish.ChildAdded:Connect(function(v)
            local billboard = createLabel(v.Name, v:GetPivot(), v, Color3.fromRGB(77, 191, 226), false, false, false)
            table.insert(billboards['fish'],billboard)
        end)
    else
        for _, v in billboards['fish'] do
            v:Destroy()
        end

        ESPConns[4]:Disconnect()
    end

end)

ESPTab:MakeToggle('ESP Consumables',function(value)
    local consumablelist = {
        "Burger",
        "Chips",
        "Coffee",
        "Slushie",
        "Taco"
    }
    if value then
        for _, v in workspace.Givers:GetDescendants() do
            if v:IsA("ProximityPrompt") then
                local folder = v:FindFirstAncestorWhichIsA('Folder')
                if folder and table.find(consumablelist, folder.Name) then
                    local billboard = createLabel(folder.Name, v.Parent, v.Parent, Color3.fromRGB(255, 136, 0), false, false, nil)
                    billboard.Enabled = v.Enabled

                    table.insert(billboards['consumable'], billboard)
                    table.insert(ESPConns['consumable'], v.Changed:Connect(function()
                        billboard.Enabled = v.Enabled
                    end))
                end
            end
        end
    else
        for _, v in billboards['consumable'] do
            v:Destroy()
        end
        for _, v in ESPConns['consumable'] do
            v:Disconnect()
        end
        table.clear(billboards['consumable'])
        table.clear(ESPConns['consumable'])
    end
end)

local TPTab = Window:MakeTab("Teleport")


TPTab:MakeButton("Safe place",function()
    TPto(CFrame.new(500.091766, 93.9051666, 405.541443, 0.307300508, -0.0322867483, -0.951064825, 0.104542375, 0.994520426, 1.69426203e-05, 0.945852876, -0.0994317606, 0.308991969))
end)

TPTab:MakeButton("Archery",function()
    TPto(CFrame.new(-265.548126, 4.79999924, 240.989182, 0.179392651, 6.5642678e-09, -0.983777583, -3.12982209e-08, 1, 9.65256319e-10, 0.983777583, 3.06173256e-08, 0.179392651))
end)

TPTab:MakeButton("Shop",function()
    TPto(CFrame.new(-308.619446, 5.1999979, -378.68042, -0.998971283, -8.80571704e-09, -0.0453468189, -8.82592932e-09, 1, 2.45513138e-10, 0.0453468189, 6.45488385e-10, -0.998971283))
end)

TPTab:MakeButton("Park safe house",function()
    TPto(CFrame.new(34.1640358, 20.0272026, -368.495728, -0.999996245, -2.17308873e-08, 0.00274723046, -2.17716156e-08, 1, -1.4795229e-08, -0.00274723046, -1.48549848e-08, -0.999996245))
end)

TPTab:MakeButton("Survivor safe house",function()
    TPto(CFrame.new(366.43808, 26.0025711, -332.829193, -0.31053853, 3.2713821e-08, 0.950560808, 1.05547912e-07, 1, 6.61417934e-11, -0.950560808, 1.00350249e-07, -0.31053853))
end)

TPTab:MakeButton("Bathroom",function()
    TPto(CFrame.new(261.683563, 53.1856422, -104.185371, 0.821596146, 5.43714407e-08, 0.570069969, -5.12155083e-08, 1, -2.15639808e-08, -0.570069969, -1.147954e-08, 0.821596146))
end)

TPTab:MakeButton("Power station",function()
    TPto(CFrame.new(376.141388, 9.31251144, 260.006226, -0.016835032, 1.67780581e-08, -0.99985826, -1.56117758e-10, 1, 1.67830656e-08, 0.99985826, 4.3863907e-10, -0.016835032))
end)

TPTab:MakeButton("Park trash",function()
    TPto(CFrame.new(346.01889, 16.6485825, 6.52108192, -0.0965822116, -4.07427265e-08, -0.995325029, 1.92586818e-08, 1, -4.28028777e-08, 0.995325029, -2.33026434e-08, -0.0965822116))
end)

TPTab:MakeButton("Statue",function()
    TPto(CFrame.new(45.9216118, 31.635004, -4.06504917, -0.992623031, -5.47873258e-09, 0.121241696, -5.98060312e-09, 1, -3.77552967e-09, -0.121241696, -4.47277637e-09, -0.992623031))
end)

TPTab:MakeButton("Fountain",function()
    TPto(CFrame.new(-157.653854, 18.1484776, 49.5339928, -0.335663259, -3.16137139e-09, -0.941982031, 4.24507274e-09, 1, -4.86876184e-09, 0.941982031, -5.63304692e-09, -0.335663259))
end)


local InfoTab = Window:MakeTab("Info")
local GameTimeLabel = InfoTab:MakeLabel("Game time : 0")
local PowerTimeLabel = InfoTab:MakeLabel("Power time : 0")

RunService.RenderStepped:Connect(function(a0: number)
    GameTimeLabel:ChangeLabel("Game time : "..game.ReplicatedStorage.Values.GameTimer.Value)
    PowerTimeLabel:ChangeLabel("Power time : "..game.ReplicatedStorage.Values.PowerTimer.Value)
    task.wait(1)
end)

-- add mro game compatiblity
for _, v:ProximityPrompt in workspace.Filter.Closets:GetDescendants() do
    if v:IsA('ProximityPrompt') then
        v.Triggered:Connect(function(a0: Player)
            scriptwidebypass = true
            task.delay(3, function()
                scriptwidebypass = false
            end)
        end)
    end
end
