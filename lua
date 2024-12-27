-- Define global services
getgenv().RunService = game:GetService("RunService")

-- Wait until the game is fully loaded
while not game:IsLoaded() do
    RunService.RenderStepped:Wait()
end

-- Initialize essential game services and components
task.spawn(function()
    getgenv().StarterGui = game:GetService("StarterGui")
    getgenv().Lighting = game:GetService("Lighting")
    getgenv().ReplicatedStorage = game:GetService("ReplicatedStorage")

    getgenv().Titans = workspace:WaitForChild("Titans")
    getgenv().Remotes = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Remotes")
    getgenv().Player = game.Players.LocalPlayer
    getgenv().Character = Player.Character or Player.CharacterAdded:Wait()
    getgenv().Humanoid = Character:WaitForChild("Humanoid")
    getgenv().HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Notification utility function
    getgenv().Print = function(title, text, duration)
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end
end)

-- Cleanup unnecessary parts in the workspace
task.spawn(function()
    local unclimbable = workspace:FindFirstChild("Unclimbable")
    if workspace:FindFirstChild("Climbable") then
        workspace.Climbable:Destroy()
        
        if unclimbable then
            for _, child in ipairs({"Background", "Trees", "Tree_Colliders", "Props"}) do
                if unclimbable:FindFirstChild(child) then
                    unclimbable[child]:Destroy()
                end
            end
        end

        -- Remove ParticleEmitters and lighting-specific parts
        for _, part in ipairs(game:GetDescendants()) do
            if part:IsA("ParticleEmitter") then
                part:Destroy()
            elseif part:FindFirstAncestor("Lighting") then
                part:Destroy()
            end
            task.wait(0.01)
        end
    end
end)

-- Core initialization function
function Init()
    -- Titan manipulation logic
    task.spawn(function()
        while true do
            if not Titans or not HumanoidRootPart then return end

            for _, titan in ipairs(Titans:GetChildren()) do
                if titan:IsA("Model") then
                    for _, part in ipairs(titan:GetDescendants()) do
                        if part:IsA("BasePart") then
                            if part.Name == "Nape" then
                                -- Align the Nape to the HumanoidRootPart
                                part.Position = HumanoidRootPart.Position
                                part.CFrame = HumanoidRootPart.CFrame
                            end
                            part.CanCollide = false
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)

    -- Remote invocation for skills and retry logic
    task.spawn(function()
        while true do
            if not Remotes then return end

            Remotes.GET:InvokeServer("S_Skills", "Usage", "23")
            task.wait(0.02)
            Remotes.GET:InvokeServer("S_Skills", "Usage", "14")
            task.wait(0.05)
            Remotes.GET:InvokeServer("Functions", "Retry", "Add")
            task.wait(5)
        end
    end)
end

-- Queue teleport functionality
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
if queueteleport then
    queueteleport("loadstring(game:HttpGet("https://raw.githubusercontent.com/SEA-HUBZ/YOOER/main/lua",true))()")
end

-- Initialize the script
Init()
