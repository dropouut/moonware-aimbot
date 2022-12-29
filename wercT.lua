--[[
███╗   ███╗ ██████╗  ██████╗ ███╗   ██╗██╗    ██╗ █████╗ ██████╗ ███████╗
████╗ ████║██╔═══██╗██╔═══██╗████╗  ██║██║    ██║██╔══██╗██╔══██╗██╔════╝
██╔████╔██║██║   ██║██║   ██║██╔██╗ ██║██║ █╗ ██║███████║██████╔╝█████╗  
██║╚██╔╝██║██║   ██║██║   ██║██║╚██╗██║██║███╗██║██╔══██║██╔══██╗██╔══╝  
██║ ╚═╝ ██║╚██████╔╝╚██████╔╝██║ ╚████║╚███╔███╔╝██║  ██║██║  ██║███████╗
╚═╝     ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
                               
edited: 12/3
developers:
Sin Interactions


]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Holding = false

getgenv().AimbotEnabled = true
getgenv().TeamCheck = false
getgenv().AimPart = "Head"
getgenv().Sensitivity = 0
getgenv().CircleSides = 64
getgenv().CircleColor = Color3.fromRGB(255, 255, 255)
getgenv().CircleTransparency = 0
getgenv().CircleRadius = 80
getgenv().CircleFilled = false
getgenv().CircleVisible = true
getgenv().CircleThickness = 0

local FOVCIRCLE = Drawing.new("Circle")
FOVCIRCLE.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCIRCLE.Radius = getgenv().CircleRadius
FOVCIRCLE.Filled = getgenv().CircleFilled
FOVCIRCLE.Color = getgenv().CircleColor
FOVCIRCLE.Visible = getgenv().CircleVisible
FOVCIRCLE.Transparency = getgenv().CircleTransparency
FOVCIRCLE.NumSides = getgenv().CircleSides
FOVCIRCLE.Thickness = getgenv().CircleThickness

local function get_closest_player()
    local maxdist = getgenv().CircleRadius
    local Target = nil

    for _, v in next, Players:GetPlayers() do 
        if v.Name ~= LocalPlayer.Name then
            if getgenv().TeamCheck == true then
                if v.Team ~= LocalPlayer.Team then
                    if v.Character ~= nil then
                        if v.Character:FindFirstChild("HumanoidRootPart")  ~= nil then
                            if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
                                local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
                                local vectordist = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                                
                                if vectordist < maxdist then
                                    Target = v
                                end
                            end
                        end
                    end
                end
            else
                if v.Character ~= nil then
                    if v.Character:FindFirstChild("HumanoidRootPart")  ~= nil then
                        if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
                            local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
                            local vectordist = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                        
                            if vectordist < maxdist then
                                Target = v
                            end
                        end
                    end
                end
            end
        end
    end
    return Target
end


local gui = Library:Create{
    Name = "Shindai",
    Size = UDim2.fromOffset(600, 400),
    Theme = Library.Themes.Dark,
    Link = "https://github.com/dropouut/shindai"
}

local Tab = gui:Tab{
    Icon = "",
    Name = "General"
}

Tab:Button{
	Name = "Bypass Kick",
	Description = "Bypass Kick",
	Callback = function() 
	    local Client = game.GetService(game, "Players").LocalPlayer

        local namecall = nil
        namecall = hookmetamethod(game, "__namecall", function(self, ...)
        local NamecallMethod, Parameters = (getnamecallmethod or get_namecall_method)(), {...};
           
        if NamecallMethod == "Kick" and self == Client then
            return
        end
           
        return namecall(self, unpack(Parameters));
        end)
	end
}

local Tab2 = gui:Tab{
    Icon = "",
    Name = "Aimbot"
}

-- Team check
Tab2:Toggle{
    Name = "TeamCheck",
    StartingState = false,
    Description = "Team Checking",
    Callback = function(state)
        if state == true then
            getgenv().TeamCheck = true
        else
            getgenv().TeamCheck = false
        end
        
    end
}

-- Main aimbot
Tab2:Toggle{
    Name = "Aimbot",
    StartingState = false,
    Description = "yeah",
    Callback = function(state)
        if state == true then
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton2 then
                    Holding = true
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton2 then
                    Holding = false
                end
            end)

            RunService.RenderStepped:Connect(function()
                FOVCIRCLE.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                FOVCIRCLE.Radius = getgenv().CircleRadius
                FOVCIRCLE.Filled = getgenv().CircleFilled
                FOVCIRCLE.Color = getgenv().CircleColor
                FOVCIRCLE.Visible = getgenv().CircleVisible
                FOVCIRCLE.Transparency = 1
                FOVCIRCLE.NumSides = getgenv().CircleSides
                FOVCIRCLE.Thickness = getgenv().CircleThickness

                if Holding == true and getgenv().AimbotEnabled == true then
                    TweenService:Create(Camera, TweenInfo.new(getgenv().Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, get_closest_player().Character[getgenv().AimPart].Position)}):Play()
                end
            end)
        end
    end
}

-- Aimpart
Tab2:TextBox{
    Name = "AimPart",
    Callback = function(text)
        if text == "Head" or text == "Torso" or text == "LeftArm" or text == "RightArm" or text == "LeftLeg" or text == "RightLeg" then
            getgenv().AimPart = text
        else
            gui:Notification{
                Title = "Error",
                Text = "No part to aim on specified.",
                Duration = 5
            }
        end 
    end
}

Tab2:ColorPicker{
    Style = Library.ColorPickerStyles.Legacy,
    Callback = function(color)
        getgenv().CircleColor = Color3.new(color)
    end
}


Tab2:Toggle{
    Name = "Circle filled",
    StartingState = false,
    Description = "yeah",
    Callback = function(state)
        if state == true then
            getgenv().CircleFilled = true
        else
            getgenv().CircleFilled = false
        end
    end
}
