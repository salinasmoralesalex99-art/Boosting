-- Crear UI
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BoostGUI"
screenGui.Parent = playerGui

local boostButton = Instance.new("TextButton")
boostButton.Name = "BoostButton"
boostButton.Size = UDim2.new(0, 120, 0, 50)
boostButton.Position = UDim2.new(0.5, -60, 0.8, 0)
boostButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
boostButton.Text = "Boost⚡"
boostButton.TextScaled = true
boostButton.Parent = screenGui

-- Hacer el botón movible en touch y mouse
local dragging = false
local dragInput, inputPos, framePos

local function update(input)
    local delta = input.Position - inputPos
    boostButton.Position = UDim2.new(
        0,
        framePos.X + delta.X,
        0,
        framePos.Y + delta.Y
    )
end

boostButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        inputPos = input.Position
        framePos = boostButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

boostButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Variables de Boost
local normalWalkSpeed = 16
local normalJumpPower = 50
local boostedWalkSpeed = 50
local boostedJumpPower = 150

-- Función para activar boost
local function activateBoost()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    humanoid.WalkSpeed = boostedWalkSpeed
    humanoid.JumpPower = boostedJumpPower
end

-- Función para desactivar boost
local function deactivateBoost()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    humanoid.WalkSpeed = normalWalkSpeed
    humanoid.JumpPower = normalJumpPower
end

-- Toggle Boost al tocar el botón (touch o click)
local boosted = false
boostButton.MouseButton1Click:Connect(function()
    boosted = not boosted
    if boosted then
        activateBoost()
        boostButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        deactivateBoost()
        boostButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    end
end)

-- Reset boost si muere
player.CharacterAdded:Connect(function(char)
    boosted = false
end)
