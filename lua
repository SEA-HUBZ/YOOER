_G.Settings = {
    Players = {
        ["Ignore Me"] = false, -- Ignore your Character
        ["Ignore Others"] = false -- Ignore other Characters
    },
    Meshes = {
        Destroy = true, -- Destroy Meshes
        LowDetail = true -- Low detail meshes (NOT SURE IT DOES ANYTHING)
    },
    Images = {
        Invisible = true, -- Invisible Images
        LowDetail = true, -- Low detail images (NOT SURE IT DOES ANYTHING)
        Destroy = true, -- Destroy Images
    },
    ["No Particles"] = true, -- Disables all ParticleEmitter, Trail, Smoke, Fire and Sparkles
    ["No Camera Effects"] = true, -- Disables all PostEffect's (Camera/Lighting Effects)
    ["No Explosions"] = true, -- Makes Explosion's invisible
    ["No Clothes"] = true, -- Removes Clothing from the game
    ["Low Water Graphics"] = true, -- Removes Water Quality
    ["No Shadows"] = true, -- Remove Shadows
    ["Low Rendering"] = true, -- Lower Rendering
    ["Low Quality Parts"] = true -- Lower quality parts
}

local fakeHead = game.Workspace:FindFirstChild("Fake_Head")
local titansFolder = game.Workspace:FindFirstChild("Titans")

if not fakeHead then
    warn("Fake_Head not found in Workspace.")
    return
end

if not titansFolder then
    warn("Titans folder not found in Workspace.")
    return
end

-- Function to delete specific paths
local function deleteSpecificPaths()
    local paths = {
        workspace.Borders:GetChildren()[3],
        workspace.Borders.Border,
        workspace.Borders:GetChildren()[2],
        workspace.Unclimbable.Background,
        workspace.Unclimbable.Barriers,
        workspace.Unclimbable.Platforms,
        workspace.Unclimbable.Props,
        workspace.Unclimbable.Trees,
        workspace.Characters:FindFirstChild("Slamecs00Altfan5") and workspace.Characters.Slamecs00Altfan5.Dust
    }

    for _, path in ipairs(paths) do
        if path and path.Parent then
            path:Destroy()
        end
    end
end

-- Function to remove all ParticleEmitters
local function removeAllParticleEmitters()
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant:Destroy()
        end
    end
end

-- Function to make Titans invisible
local function makeTitansInvisible()
    for _, titan in ipairs(titansFolder:GetChildren()) do
        if titan:IsA("Model") then
            for _, part in ipairs(titan:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1 -- Make the part invisible
                    part.CanCollide = false -- Disable collision
                end
            end
        end
    end
end

-- Update Titans' Nape part position and size
game:GetService("RunService").Heartbeat:Connect(function()
    for _, titan in ipairs(titansFolder:GetChildren()) do
        local hitboxes = titan:FindFirstChild("Hitboxes")
        if hitboxes then
            local hit = hitboxes:FindFirstChild("Hit")
            if hit then
                local nape = hit:FindFirstChild("Nape")
                if nape and nape:IsA("Part") then
                    nape:PivotTo(fakeHead.CFrame)
                    nape.Size = Vector3.new(10000, 10000, 10000)
                end
            end
        end
    end
end)

-- Execute all the functions
deleteSpecificPaths()
removeAllParticleEmitters()
makeTitansInvisible()

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local MaterialService = game:GetService("MaterialService")
local ME = Players.LocalPlayer
local CanBeEnabled = {"ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles"}

local function PartOfCharacter(Instance)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= ME and player.Character and Instance:IsDescendantOf(player.Character) then
            return true
        end
    end
    return false
end

local function DescendantOfIgnore(Instance)
    for _, v in pairs(_G.Ignore or {}) do
        if Instance:IsDescendantOf(v) then
            return true
        end
    end
    return false
end

local function CheckIfBad(Instance)
    if not Instance:IsDescendantOf(Players) 
        and ((_G.Settings.Players["Ignore Others"] and not PartOfCharacter(Instance)) or not _G.Settings.Players["Ignore Others"])
        and ((_G.Settings.Players["Ignore Me"] and ME.Character and not Instance:IsDescendantOf(ME.Character)) or not _G.Settings.Players["Ignore Me"])
        and ((_G.Settings.Players["Ignore Tools"] and not Instance:IsA("BackpackItem") and not Instance:FindFirstAncestorWhichIsA("BackpackItem")) or not _G.Settings.Players["Ignore Tools"])
        and (not DescendantOfIgnore(Instance)) then

        if Instance:IsA("DataModelMesh") then
            if _G.Settings.Meshes.NoMesh and Instance:IsA("SpecialMesh") then Instance.MeshId = "" end
            if _G.Settings.Meshes.Destroy or _G.Settings["No Meshes"] then Instance:Destroy() end

        elseif Instance:IsA("FaceInstance") then
            if _G.Settings.Images.Invisible then Instance.Transparency, Instance.Shiny = 1, 1 end
            if _G.Settings.Images.LowDetail then Instance.Shiny = 1 end
            if _G.Settings.Images.Destroy then Instance:Destroy() end

        elseif Instance:IsA("ShirtGraphic") then
            if _G.Settings.Images.Invisible then Instance.Graphic = "" end
            if _G.Settings.Images.Destroy then Instance:Destroy() end

        elseif table.find(CanBeEnabled, Instance.ClassName) then
            if _G.Settings["Invisible Particles"] then Instance.Enabled = false end
            if _G.Settings["No Particles"] then Instance:Destroy() end

        elseif Instance:IsA("PostEffect") and _G.Settings["No Camera Effects"] then
            Instance.Enabled = false

        elseif Instance:IsA("Explosion") then
            if _G.Settings["Smaller Explosions"] then Instance.BlastPressure, Instance.BlastRadius = 1, 1 end
            if _G.Settings["Invisible Explosions"] then Instance.BlastPressure, Instance.BlastRadius, Instance.Visible = 1, 1, false end
            if _G.Settings["No Explosions"] then Instance:Destroy() end

        elseif Instance:IsA("Clothing") or Instance:IsA("SurfaceAppearance") or Instance:IsA("BaseWrap") then
            if _G.Settings["No Clothes"] then Instance:Destroy() end

        elseif Instance:IsA("BasePart") and not Instance:IsA("MeshPart") then
            if _G.Settings["Low Quality Parts"] then
                Instance.Material = Enum.Material.Plastic
                Instance.Reflectance = 0
            end

        elseif Instance:IsA("MeshPart") then
            if _G.Settings["Low Quality MeshParts"] then
                Instance.RenderFidelity = 2
                Instance.Reflectance = 0
                Instance.Material = Enum.Material.Plastic
            end
            if _G.Settings.MeshParts.Destroy then Instance:Destroy() end

        elseif Instance:IsA("TextLabel") and Instance:IsDescendantOf(workspace) then
            if _G.Settings.TextLabels.LowerQuality then
                Instance.Font = Enum.Font.SourceSans
                Instance.TextScaled = false
                Instance.TextSize = 14
            end
            if _G.Settings.TextLabels.Invisible then Instance.Visible = false end
            if _G.Settings.TextLabels.Destroy then Instance:Destroy() end

        elseif Instance:IsA("Model") and _G.Settings["Low Quality Models"] then
            Instance.LevelOfDetail = 1
        end
    end
end

-- FPS Cap
if _G.Settings["FPS Cap"] then
    local fpsValue = tonumber(_G.Settings["FPS Cap"]) or 1e6
    if setfpscap then setfpscap(fpsValue) end
end

-- Terrain Optimization
if _G.Settings["Low Water Graphics"] then
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        Terrain.WaterWaveSize, Terrain.WaterWaveSpeed, Terrain.WaterReflectance, Terrain.WaterTransparency = 0, 0, 0, 0
        if sethiddenproperty then sethiddenproperty(Terrain, "Decoration", false) end
    end
end

-- Lighting Optimization
if _G.Settings["No Shadows"] then
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.ShadowSoftness = 0
    if sethiddenproperty then sethiddenproperty(Lighting, "Technology", 2) end
end

-- Render Settings
if _G.Settings["Low Rendering"] then
    settings().Rendering.QualityLevel = 1
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
end

-- Reset Materials
if _G.Settings["Reset Materials"] then
    for _, material in pairs(MaterialService:GetChildren()) do
        material:Destroy()
    end
    MaterialService.Use2022Materials = false
end

-- Descendant Checking
game.DescendantAdded:Connect(function(value)
    task.wait(0.02)
    CheckIfBad(value)
end)

local Descendants = game:GetDescendants()
for i, v in pairs(Descendants) do
    CheckIfBad(v)
    if i % (_G.WaitPerAmount or 500) == 0 then
        task.wait(0.02)
    end
end

-- Additional task.spawn for server invocations
task.spawn(function()
    while true do
        game:GetService("ReplicatedStorage").Assets.Remotes.GET:InvokeServer("S_Skills", "Usage", "23")
        task.wait(0.02)
        game:GetService("ReplicatedStorage").Assets.Remotes.GET:InvokeServer("S_Skills", "Usage", "14")
        task.wait(0.02)
        game:GetService("ReplicatedStorage").Assets.Remotes.GET:InvokeServer("Functions", "Retry", "Add")
        task.wait(0.02)
    end
end)

-- Add the queueteleport and loadstring logic with updated link
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport

if queueteleport then
    queueteleport("loadstring(game:HttpGet("https://raw.githubusercontent.com/SEA-HUBZ/YOOER/main/lua",true))()")
end
