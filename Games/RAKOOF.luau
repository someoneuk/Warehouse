-- loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneuk/Warehouse/refs/heads/main/Games/RAKOOF.luau"))()
local RJelly = loadstring(Game:HttpGet("https://raw.githubusercontent.com/someoneuk/Warehouse/refs/heads/main/Libraries/RJelly/RJellyUI.lua"))()
local Window = RJelly:MakeWindow("Rakoof lol")

-- Services
local Lighting = game:GetService('Lighting')
local RunService = game:GetService('RunService')

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
    Lighting.HourCC.Enabled = value
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
local speaker = game:GetService('Players').LocalPlayer
local char = speaker.Character or speaker.CharacterAdded:Wait()
local hmd:Humanoid = char:WaitForChild('Humanoid')
speaker.CharacterAdded:Connect(function(a0: Model)
    char = a0
    hmd = a0:WaitForChild('Humanoid')
end)


local lastPivot = nil
PlayerTab:MakeToggle('speed hack', function(value)
    if value then
        lastPivot = nil
        
        PlayerTabConns[1] = RunService.Heartbeat:Connect(function(a0: number)
            if char and hmd then
                local currentPivot = char:GetPivot()
                
                if lastPivot and a0 > 0 then
                    local distance = (currentPivot.Position - lastPivot.Position).Magnitude
                    local currentSpeed = distance / a0
                    
                    if hmd.MoveDirection.Magnitude > 0 then
                        local clampedSpeed = math.clamp(currentSpeed, 33, 50)
                        local alpha = (clampedSpeed - 33) / (50 - 33)
                        
                        local speedMultiplier = 2.4 + (0 - 2.4) * alpha

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
local scriptwidebypass = false
PlayerTab:MakeToggle('Anti-teleport',function(value)
    lastPosFrame = char:GetPivot()
    if value then
            PlayerTabConns[2] = RunService.RenderStepped:Connect(function(a0: number)
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
local function createLabel(title:string,objPos:BasePart,target:Instance,col:Color3,dist:boolean,hp:boolean,hmd:Humanoid)
    local conns = nil
    local BillboardGui = Instance.new('BillboardGui',game:GetService('CoreGui'))
    local Label = Instance.new("TextLabel")
    Label.Parent = BillboardGui
    
    BillboardGui.Adornee = target
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 0
    BillboardGui.Size = UDim2.fromScale(1, 1)

    Label.Size = UDim2.fromOffset(300, 20)
    Label.Position = UDim2.fromScale(.5, .5)
    Label.AnchorPoint = Vector2.new(.5,.5)
    Label.BackgroundTransparency = 1
    Label.TextScaled = true
    Label.TextColor3 = col
    Label.Font = Enum.Font.Ubuntu

    conns = RunService.RenderStepped:Connect(function(a0: number)
        if target == nil or hmd == nil then pcall(function()BillboardGui:Destroy(); conns:Disconnect() end)end
        Label.Text = ""
        Label.Text = title
        if hp then
            Label.Text = Label.Text.." | HP:"..math.floor(hmd.Health)
        end
        if dist then
            Label.Text = Label.Text.." | "..math.floor((objPos.Position - workspace.CurrentCamera.CFrame.Position).Magnitude)
        end
    end)

    target.Destroying:Connect(function()
        pcall(function(...)
            BillboardGui:Destroy()
            conns:Disconnect()
        end)
    end)
    return BillboardGui
end

local ESPConns = {}

local rakoofBillboard = nil
ESPTab:MakeToggle("ESP Rakoof",function(value)
    if value then
        local rakoof = workspace:WaitForChild('RakoofNPC')
        local hmd = rakoof:WaitForChild('NPC')
        rakoofBillboard = createLabel('Rakoof', rakoof:WaitForChild('HumanoidRootPart'), rakoof,Color3.fromHSV(0.155102, 1, 0.960784), true, true, hmd)

        ESPConns[1] = workspace.ChildAdded:Connect(function(a0: Instance)
            if a0.Name == 'RakoofNPC' then
                rakoof = a0
                hmd = a0:WaitForChild('NPC')
                rakoofBillboard = createLabel('Rakoof', rakoof:WaitForChild('HumanoidRootPart'), rakoof,Color3.fromHSV(0.155102, 1, 0.960784), true, true, hmd)
            end
        end)
    else
        if rakoofBillboard then
            rakoofBillboard:Destroy()
        end
        ESPConns[1]:Disconnect()
    end
end)



local TPTab = Window:MakeTab("Teleport")
local function TPto(cf:CFrame)
    scriptwidebypass = true
    for i = 1,10 do
        char:PivotTo(cf)
        task.wait(.02)
    end
    scriptwidebypass = false
end

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
