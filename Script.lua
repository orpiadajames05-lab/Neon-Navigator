
--// NEON NAVIGATOR V2
--// Animated Two-Point Teleport GUI
--// Place inside StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local GREEN = Color3.fromRGB(0, 255, 145)
local BG = Color3.fromRGB(18, 20, 29)
local PANEL = Color3.fromRGB(27, 30, 42)
local MUTED = Color3.fromRGB(145, 153, 170)
local WHITE = Color3.fromRGB(240, 245, 255)

local point1, point2
local nextPoint = 1
local pulseRunning = false

local function tween(object, duration, style, properties)
    local t = TweenService:Create(
        object,
        TweenInfo.new(duration, style or Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out),
        properties
    )
    t:Play()
    return t
end

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NeonNavigator"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "MainPanel"
main.Size = UDim2.fromOffset(285, 300)
main.Position = UDim2.new(0.5, -142, 0.5, -150)
main.BackgroundColor3 = BG
main.BackgroundTransparency = 1
main.BorderSizePixel = 0
main.Parent = gui

local scale = Instance.new("UIScale")
scale.Scale = 0.82
scale.Parent = main

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 75, 92)
stroke.Thickness = 1.3
stroke.Transparency = 0.2
stroke.Parent = main

--// Animated entrance
tween(scale, 0.55, Enum.EasingStyle.Back, {Scale = 1})
tween(main, 0.4, Enum.EasingStyle.Quad, {
    BackgroundTransparency = 0
})

--// Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 65)
header.BackgroundColor3 = PANEL
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local cover = Instance.new("Frame")
cover.Size = UDim2.new(1, 0, 0, 15)
cover.Position = UDim2.new(0, 0, 1, -15)
cover.BackgroundColor3 = PANEL
cover.BorderSizePixel = 0
cover.Parent = header

local function label(parent, text, size, pos, font, color)
    local obj = Instance.new("TextLabel")
    obj.BackgroundTransparency = 1
    obj.Size = size
    obj.Position = pos
    obj.Font = font or Enum.Font.Gotham
    obj.Text = text
    obj.TextColor3 = color or WHITE
    obj.TextSize = 13
    obj.Parent = parent
    return obj
end

label(header, "✦  NEON NAVIGATOR",
    UDim2.new(1, -25, 0, 25), UDim2.new(0, 16, 0, 10),
    Enum.Font.GothamBold, GREEN).TextSize = 16

label(header, "TWO-POINT TELEPORT SYSTEM",
    UDim2.new(1, -25, 0, 18), UDim2.new(0, 17, 0, 35),
    Enum.Font.GothamMedium, MUTED).TextSize = 10

--// Drag support: mouse and touch
local dragging = false
local dragStart, startPos
local dragInput

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

--// Status display
local status = label(main, "●  Waiting for positions",
    UDim2.new(1, -30, 0, 22), UDim2.new(0, 15, 0, 75),
    Enum.Font.GothamMedium, MUTED)
status.TextXAlignment = Enum.TextXAlignment.Left

--// Buttons with bounce animation
local function createButton(name, text, y, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -30, 0, 43)
    button.Position = UDim2.new(0, 15, 0, y)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = WHITE
    button.TextSize = 13
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    button.Parent = main

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent = button

    local buttonScale = Instance.new("UIScale")
    buttonScale.Parent = button

    button.MouseEnter:Connect(function()
        tween(button, 0.15, Enum.EasingStyle.Quad, {
            BackgroundTransparency = 0.08
        })
    end)

    button.MouseLeave:Connect(function()
        tween(button, 0.15, Enum.EasingStyle.Quad, {
            BackgroundTransparency = 0
        })
        tween(buttonScale, 0.15, Enum.EasingStyle.Quad, {
            Scale = 1
        })
    end)

    button.Activated:Connect(function()
        tween(buttonScale, 0.08, Enum.EasingStyle.Quad, {
            Scale = 0.94
        })
        task.delay(0.08, function()
            if buttonScale.Parent then
                tween(buttonScale, 0.3, Enum.EasingStyle.Back, {
                    Scale = 1
                })
            end
        end)
    end)

    return button
end

local set1 = createButton(
    "SetPoint1", "①   SET POSITION ONE",
    105, Color3.fromRGB(43, 53, 72)
)

local set2 = createButton(
    "SetPoint2", "②   SET POSITION TWO",
    156, Color3.fromRGB(43, 53, 72)
)

local teleport = createButton(
    "Teleport", "LOCK BOTH POSITIONS FIRST",
    213, Color3.fromRGB(48, 52, 63)
)
teleport.TextColor3 = MUTED

label(main, "CLICK TO ALTERNATE BETWEEN SAVED POINTS",
    UDim2.new(1, -20, 0, 20), UDim2.new(0, 10, 0, 266),
    Enum.Font.GothamMedium, MUTED).TextSize = 9

--// Flash overlay
local flash = Instance.new("Frame")
flash.Name = "TeleportFlash"
flash.Size = UDim2.fromScale(1, 1)
flash.BackgroundColor3 = GREEN
flash.BackgroundTransparency = 1
flash.BorderSizePixel = 0
flash.ZIndex = 20
flash.Parent = gui

local function teleportFlash()
    flash.BackgroundTransparency = 0.35
    tween(flash, 0.35, Enum.EasingStyle.Quad, {
        BackgroundTransparency = 1
    })
end

--// Character helper
local function getRoot()
    local character = player.Character
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end

--// Neon pulse
local function startNeonPulse()
    if pulseRunning then return end
    pulseRunning = true

    task.spawn(function()
        while pulseRunning and point1 and point2 do
            local a = tween(stroke, 0.7, Enum.EasingStyle.Sine, {
                Transparency = 0.05,
                Thickness = 2.5
            })
            a.Completed:Wait()

            if not pulseRunning or not point1 or not point2 then
                break
            end

            local b = tween(stroke, 0.7, Enum.EasingStyle.Sine, {
                Transparency = 0.4,
                Thickness = 1.3
            })
            b.Completed:Wait()
        end

        pulseRunning = false
    end)
end

--// Update visual state
local function updateUI()
    if point1 and point2 then
        teleport.BackgroundColor3 = GREEN
        teleport.TextColor3 = Color3.fromRGB(10, 22, 20)
        teleport.Text = nextPoint == 1
            and "↗  TELEPORT TO POINT ONE"
            or "↗  TELEPORT TO POINT TWO"

        status.Text = "●  SYSTEM READY"
        status.TextColor3 = GREEN
        stroke.Color = GREEN
        startNeonPulse()
    else
        pulseRunning = false
        teleport.BackgroundColor3 = Color3.fromRGB(48, 52, 63)
        teleport.TextColor3 = MUTED
        teleport.Text = "LOCK BOTH POSITIONS FIRST"

        status.Text = point1 and "●  Point 1 saved · Need Point 2"
            or point2 and "●  Point 2 saved · Need Point 1"
            or "●  Waiting for positions"

        status.TextColor3 = MUTED
        stroke.Color = Color3.fromRGB(60, 75, 92)
        stroke.Transparency = 0.2
        stroke.Thickness = 1.3
    end
end

--// Save Point 1
set1.Activated:Connect(function()
    local root = getRoot()
    if not root then
        status.Text = "●  Character not available"
        return
    end

    point1 = root.CFrame
    set1.Text = "✓   POSITION ONE SAVED"

    tween(set1, 0.2, Enum.EasingStyle.Quad, {
        BackgroundColor3 = Color3.fromRGB(25, 100, 75)
    })

    updateUI()
end)

--// Save Point 2
set2.Activated:Connect(function()
    local root = getRoot()
    if not root then
        status.Text = "●  Character not available"
        return
    end

    point2 = root.CFrame
    set2.Text = "✓   POSITION TWO SAVED"

    tween(set2, 0.2, Enum.EasingStyle.Quad, {
        BackgroundColor3 = Color3.fromRGB(25, 100, 75)
    })

    updateUI()
end)

--// Alternate teleport
teleport.Activated:Connect(function()
    if not point1 or not point2 then return end

    local root = getRoot()
    if not root then
        status.Text = "●  Character not available"
        return
    end

    if nextPoint == 1 then
        root.CFrame = point1
        nextPoint = 2
    else
        root.CFrame = point2
        nextPoint = 1
    end

    teleportFlash()
    updateUI()
end)

updateUI()
