getgenv().RunService = game:GetService("RunService")

while not game:IsLoaded() do
    RunService.RenderStepped:Wait()
end

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
    
    getgenv().Print = function(title, text, duration)
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end
end)

task.spawn(function()
    if workspace:FindFirstChild("Climbable") then
        workspace.Climbable:Destroy()
        workspace.Unclimbable.Background:Destroy()
        workspace.Unclimbable.Trees:Destroy()
        workspace.Unclimbable.Tree_Colliders:Destroy()
        workspace.Unclimbable.Props:Destroy()
        
        for _, Part in ipairs(game:GetDescendants()) do
            if Part:IsA("ParticleEmitter") then
                Part:Destroy()
            elseif Part:FindFirstAncestor("Lighting") then
                Part:Destroy()
            end
            task.wait(0.01)
        end
    end
end)

function Init()
    task.spawn(function()
        while true do
            if not Titans or not HumanoidRootPart then return end

            for _, titan in ipairs(Titans:GetChildren()) do
                if titan:IsA("Model") then
                    for _, part in ipairs(titan:GetDescendants()) do
                        if part:IsA("BasePart") then
                            if part.Name == "Nape" then
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

    task.spawn(function()
        while true do
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
    queueteleport("loadstring(game:HttpGet('https://pastebin.com/raw/Z6BhbujS'))()")
end

-- Initialize the script
Init()
