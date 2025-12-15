--================== Load Fluent ==================--
local Fluent = loadstring(game:HttpGet(
    "https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"
))()

local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"
))()

local InterfaceManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"
))()

--================== Services ==================--
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

--================== Window ==================--
local Window = Fluent:CreateWindow({
    Title = "🌹ROSE HUB",
    SubTitle = "by Script Forge",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Rose",
    MinimizeKey = Enum.KeyCode.LeftControl
})

--================== Tabs ==================--
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Farm = Window:AddTab({ Title = "Auto Farm", Icon = "eye" })
}

--================== MAIN TAB ==================--

-- Game Info
local TimeInfo = Tabs.Main:AddParagraph({
    Title = "Game Time",
    Content = "Loading..."
})

local FPSInfo = Tabs.Main:AddParagraph({
    Title = "FPS",
    Content = "Loading..."
})

local PingInfo = Tabs.Main:AddParagraph({
    Title = "Ping",
    Content = "Loading..."
})

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local t = math.floor(workspace.DistributedGameTime)
            TimeInfo:SetContent(
                string.format(
                    "Hours: %d | Minutes: %d | Seconds: %d",
                    math.floor(t / 3600) % 24,
                    math.floor(t / 60) % 60,
                    t % 60
                )
            )
            FPSInfo:SetContent(tostring(math.floor(workspace:GetRealPhysicsFPS())))
            PingInfo:SetContent(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString())
        end)
    end
end)

-- Auto Rebirth
Tabs.Main:AddToggle("AutoRebirth", {
    Title = "Auto Rebirth",
    Default = false,
    Callback = function(v)
        _G.AutoRebirth = v
        task.spawn(function()
            while _G.AutoRebirth do
                pcall(function()
                    ReplicatedStorage.rEvents.rebirthEvent:FireServer("rebirthRequest")
                end)
                task.wait()
            end
        end)
    end
})

-- NoClip
Tabs.Main:AddToggle("NoClip", {
    Title = "No Clip",
    Default = false,
    Callback = function(v)
        _G.NoClip = v
    end
})

RunService.Stepped:Connect(function()
    if _G.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Speed
Tabs.Main:AddSlider("Speed", {
    Title = "Walk Speed",
    Default = 300,
    Min = 0,
    Max = 5000,
    Rounding = 0,
    Callback = function(v)
        pcall(function()
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end)
    end
})

-- Jump
Tabs.Main:AddSlider("Jump", {
    Title = "Jump Power",
    Default = 50,
    Min = 0,
    Max = 1000,
    Rounding = 0,
    Callback = function(v)
        pcall(function()
            LocalPlayer.Character.Humanoid.JumpPower = v
        end)
    end
})

-- Infinite Jump
local InfJump = false
Tabs.Main:AddToggle("InfJump", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(v)
        InfJump = v
    end
})

UserInputService.JumpRequest:Connect(function()
    if InfJump then
        pcall(function()
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end)
    end
end)

--================== AUTO FARM TAB ==================--

local locate = "City"
local orbs = "Red Orb"
local setFarm = 20

Tabs.Farm:AddDropdown("Location", {
    Title = "Select Location",
    Values = {"City", "Snow City", "Magma City", "Legends Highway", "Space", "Desert"},
    Default = "City",
    Callback = function(v)
        locate = v
    end
})

Tabs.Farm:AddDropdown("Orbs", {
    Title = "Select Orbs",
    Values = {"Red Orb", "Yellow Orb", "Gem"},
    Default = "Red Orb",
    Callback = function(v)
        orbs = v
    end
})

Tabs.Farm:AddDropdown("Mode", {
    Title = "Farm Mode",
    Values = {"Super Fast", "Fast", "Medium", "Slow"},
    Default = "Medium",
    Callback = function(v)
        if v == "Super Fast" then
            setFarm = 40
        elseif v == "Fast" then
            setFarm = 30
        elseif v == "Medium" then
            setFarm = 20
        elseif v == "Slow" then
            setFarm = 10
        end
    end
})

Tabs.Farm:AddToggle("Farm", {
    Title = "Start Auto Farm",
    Default = false,
    Callback = function(v)
        _G.Farm = v
        task.spawn(function()
            while _G.Farm do
                pcall(function()
                    for i = 1, setFarm do
                        ReplicatedStorage.rEvents.orbEvent:FireServer(
                            "collectOrb",
                            orbs,
                            locate
                        )
                    end
                end)
                task.wait()
            end
        end)
    end
})

--================== Save / Interface ==================--
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:SetFolder("ROSE_HUB")
InterfaceManager:SetFolder("ROSE_HUB")

--================== Start ==================--
Window:SelectTab(1)

Fluent:Notify({
    Title = "🌹ROSE HUB",
    Content = "by SCRIPT FORGE!",
    Duration = 10
})


--================== Credits Tab ==================--
local Credits = Window:AddTab({ 
    Title = "Credits", 
    Icon = "info" 
})

Credits:AddParagraph({
    Title = "LURA Hub",
    Content = "Script Hub desenvolvido para Legends of Speed\nInterface baseada em Fluent UI"
})

Credits:AddSection("Creator")

Credits:AddParagraph({
    Title = "Script Forge",
    Content = "Main Developer & Script Creator\nResponsible for logic, features and updates."
})

Credits:AddSection("UI Library")

Credits:AddParagraph({
    Title = "Fluent UI",
    Content = "Created by dawid\nModern, clean and animated UI library for Roblox"
})

Credits:AddSection("Community")

Credits:AddButton({
    Title = "Copy YouTube Channel",
    Description = "Copy Script Forge YouTube link",
    Callback = function()
        setclipboard("https://www.youtube.com/@SCRIPTFORGE.O")
        Fluent:Notify({
            Title = "Copied!",
            Content = "YouTube link copied to clipboard",
            Duration = 3
        })
    end
})

Credits:AddButton({
    Title = "Open YouTube Channel",
    Description = "Open Script Forge YouTube",
    Callback = function()
        pcall(function()
            game:GetService("GuiService"):OpenBrowserWindow(
                "https://www.youtube.com/@SCRIPTFORGE.O"
            )
        end)
    end
})

Credits:AddSection("Thanks")

Credits:AddParagraph({
    Title = "Special Thanks",
    Content = "Thanks to all users who support Script Forge\nMore updates coming soon!"
})

