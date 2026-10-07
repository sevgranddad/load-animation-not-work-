--==================================================
-- VAPE STYLE LOADER
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

local IMAGE_URL =
    "https://raw.githubusercontent.com/sevgranddad/load-animation-not-work-/main/Screenshot_20261003_214917.jpg"

local IMAGE_PATH =
    "MyClient/Screenshot_20261003_214917.jpg"

local VAPE_URL =
    "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua"

--==================================================
-- CANCEL STATE
--==================================================

local cancelled = false
local minimized = false
local finished = false

--==================================================
-- DOWNLOAD IMAGE
--==================================================

if makefolder and not isfolder("MyClient") then
    pcall(function()
        makefolder("MyClient")
    end)
end

if isfile and writefile and not isfile(IMAGE_PATH) then
    pcall(function()
        local data = game:HttpGet(IMAGE_URL)

        if data then
            writefile(IMAGE_PATH, data)
        end
    end)
end

local imageAsset = nil

if getcustomasset and isfile and isfile(IMAGE_PATH) then
    pcall(function()
        imageAsset = getcustomasset(IMAGE_PATH)
    end)
end

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "VapeLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    gui.Parent = playerGui
end)

--==================================================
-- MAIN WINDOW
--==================================================

local window = Instance.new("Frame")
window.Name = "Window"
window.Size = UDim2.fromOffset(520, 300)
window.Position = UDim2.new(0.5, -260, 0.5, -150)
window.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.Parent = gui

local windowCorner = Instance.new("UICorner")
windowCorner.CornerRadius = UDim.new(0, 5)
windowCorner.Parent = window

local windowStroke = Instance.new("UIStroke")
windowStroke.Color = Color3.fromRGB(55, 55, 55)
windowStroke.Thickness = 1
windowStroke.Parent = window

local scale = Instance.new("UIScale")
scale.Scale = 1
scale.Parent = window

--==================================================
-- TITLE BAR
--==================================================

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = window

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(14, 0)
title.Size = UDim2.new(1, -150, 1, 0)
title.Font = Enum.Font.Code
title.Text = "VAPE V4"
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(235, 235, 235)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

--==================================================
-- WINDOW BUTTONS
--==================================================

local function createWindowButton(text, position, color)
    local button = Instance.new("TextButton")
    button.BackgroundTransparency = 1
    button.Position = position
    button.Size = UDim2.fromOffset(42, 38)
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextSize = 17
    button.TextColor3 = color
    button.AutoButtonColor = false
    button.Parent = titleBar

    return button
end

local minimizeButton = createWindowButton(
    "−",
    UDim2.new(1, -126, 0, 0),
    Color3.fromRGB(210, 210, 210)
)

local maximizeButton = createWindowButton(
    "□",
    UDim2.new(1, -84, 0, 0),
    Color3.fromRGB(90, 90, 90)
)

-- 最大化按钮故意禁用
maximizeButton.Active = false

local closeButton = createWindowButton(
    "×",
    UDim2.new(1, -42, 0, 0),
    Color3.fromRGB(220, 220, 220)
)

--==================================================
-- CONTENT
--==================================================

local content = Instance.new("Frame")
content.BackgroundTransparency = 1
content.Position = UDim2.fromOffset(18, 48)
content.Size = UDim2.new(1, -36, 1, -58)
content.Parent = window

--==================================================
-- IMAGE
--==================================================

local image = Instance.new("ImageLabel")
image.Name = "Preview"
image.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
image.BorderSizePixel = 0
image.Position = UDim2.fromOffset(0, 0)
image.Size = UDim2.fromOffset(210, 185)
image.ScaleType = Enum.ScaleType.Crop
image.Parent = content

local imageCorner = Instance.new("UICorner")
imageCorner.CornerRadius = UDim.new(0, 4)
imageCorner.Parent = image

if imageAsset then
    image.Image = imageAsset
end

--==================================================
-- RIGHT SIDE
--==================================================

local info = Instance.new("Frame")
info.BackgroundTransparency = 1
info.Position = UDim2.fromOffset(230, 0)
info.Size = UDim2.new(1, -230, 1, 0)
info.Parent = content

local loadingText = Instance.new("TextLabel")
loadingText.BackgroundTransparency = 1
loadingText.Position = UDim2.fromOffset(0, 20)
loadingText.Size = UDim2.new(1, 0, 0, 30)
loadingText.Font = Enum.Font.GothamMedium
loadingText.Text = "Loading..."
loadingText.TextSize = 19
loadingText.TextColor3 = Color3.fromRGB(235, 235, 235)
loadingText.TextXAlignment = Enum.TextXAlignment.Left
loadingText.Parent = info

local detailText = Instance.new("TextLabel")
detailText.BackgroundTransparency = 1
detailText.Position = UDim2.fromOffset(0, 55)
detailText.Size = UDim2.new(1, 0, 0, 50)
detailText.Font = Enum.Font.Code
detailText.Text = "Initializing..."
detailText.TextSize = 13
detailText.TextColor3 = Color3.fromRGB(150, 150, 150)
detailText.TextWrapped = true
detailText.TextXAlignment = Enum.TextXAlignment.Left
detailText.TextYAlignment = Enum.TextYAlignment.Top
detailText.Parent = info

--==================================================
-- PROGRESS BAR
--==================================================

local progressBackground = Instance.new("Frame")
progressBackground.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
progressBackground.BorderSizePixel = 0
progressBackground.Position = UDim2.new(0, 0, 1, -50)
progressBackground.Size = UDim2.new(1, 0, 0, 5)
progressBackground.Parent = info

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(1, 0)
progressCorner.Parent = progressBackground

local progress = Instance.new("Frame")
progress.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
progress.BorderSizePixel = 0
progress.Size = UDim2.new(0, 0, 1, 0)
progress.Parent = progressBackground

local progressCorner2 = Instance.new("UICorner")
progressCorner2.CornerRadius = UDim.new(1, 0)
progressCorner2.Parent = progress

local percentText = Instance.new("TextLabel")
percentText.BackgroundTransparency = 1
percentText.Position = UDim2.new(0, 0, 1, -35)
percentText.Size = UDim2.new(1, 0, 0, 20)
percentText.Font = Enum.Font.Code
percentText.Text = "0%"
percentText.TextSize = 12
percentText.TextColor3 = Color3.fromRGB(120, 120, 120)
percentText.TextXAlignment = Enum.TextXAlignment.Right
percentText.Parent = info

--==================================================
-- DRAGGING
--==================================================

local dragging = false
local dragStart
local startPosition

local function updateDrag(input)
    local delta = input.Position - dragStart

    window.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = window.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        UserInputService.InputChanged:Connect(function(changedInput)
            if dragging and changedInput == input then
                updateDrag(changedInput)
            end
        end)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false
    end
end)

--==================================================
-- MINIMIZE
--==================================================

local restoreButton = Instance.new("TextButton")
restoreButton.Name = "Restore"
restoreButton.Size = UDim2.fromOffset(120, 32)
restoreButton.Position = UDim2.new(0, 15, 1, -47)
restoreButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
restoreButton.BorderSizePixel = 0
restoreButton.Text = "VAPE V4"
restoreButton.TextSize = 13
restoreButton.Font = Enum.Font.GothamMedium
restoreButton.TextColor3 = Color3.fromRGB(220, 220, 220)
restoreButton.Visible = false
restoreButton.Parent = gui

local restoreCorner = Instance.new("UICorner")
restoreCorner.CornerRadius = UDim.new(0, 5)
restoreCorner.Parent = restoreButton

minimizeButton.MouseButton1Click:Connect(function()
    if cancelled or finished then
        return
    end

    minimized = true
    window.Visible = false
    restoreButton.Visible = true
end)

restoreButton.MouseButton1Click:Connect(function()
    if cancelled or finished then
        return
    end

    minimized = false
    restoreButton.Visible = false
    window.Visible = true
end)

--==================================================
-- CLOSE CONFIRMATION
--==================================================

local confirmOverlay = Instance.new("Frame")
confirmOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
confirmOverlay.BackgroundTransparency = 0.35
confirmOverlay.Size = UDim2.fromScale(1, 1)
confirmOverlay.Visible = false
confirmOverlay.ZIndex = 50
confirmOverlay.Parent = gui

local confirmBox = Instance.new("Frame")
confirmBox.Size = UDim2.fromOffset(380, 145)
confirmBox.Position = UDim2.new(0.5, -190, 0.5, -72)
confirmBox.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
confirmBox.BorderSizePixel = 0
confirmBox.ZIndex = 51
confirmBox.Parent = confirmOverlay

local confirmCorner = Instance.new("UICorner")
confirmCorner.CornerRadius = UDim.new(0, 5)
confirmCorner.Parent = confirmBox

local confirmTitle = Instance.new("TextLabel")
confirmTitle.BackgroundTransparency = 1
confirmTitle.Position = UDim2.fromOffset(18, 14)
confirmTitle.Size = UDim2.new(1, -36, 0, 25)
confirmTitle.Font = Enum.Font.GothamMedium
confirmTitle.Text = "Close VAPE V4?"
confirmTitle.TextSize = 16
confirmTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
confirmTitle.TextXAlignment = Enum.TextXAlignment.Left
confirmTitle.ZIndex = 52
confirmTitle.Parent = confirmBox

local confirmText = Instance.new("TextLabel")
confirmText.BackgroundTransparency = 1
confirmText.Position = UDim2.fromOffset(18, 43)
confirmText.Size = UDim2.new(1, -36, 0, 42)
confirmText.Font = Enum.Font.Gotham
confirmText.Text =
    "The script is being injected.\nAre you sure you want to close it?"
confirmText.TextSize = 13
confirmText.TextColor3 = Color3.fromRGB(170, 170, 170)
confirmText.TextWrapped = true
confirmText.TextXAlignment = Enum.TextXAlignment.Left
confirmText.TextYAlignment = Enum.TextYAlignment.Top
confirmText.ZIndex = 52
confirmText.Parent = confirmBox

local closeConfirm = Instance.new("TextButton")
closeConfirm.Size = UDim2.fromOffset(100, 30)
closeConfirm.Position = UDim2.new(1, -215, 1, -42)
closeConfirm.BackgroundColor3 = Color3.fromRGB(190, 45, 45)
closeConfirm.BorderSizePixel = 0
closeConfirm.Text = "Close"
closeConfirm.TextSize = 13
closeConfirm.Font = Enum.Font.GothamMedium
closeConfirm.TextColor3 = Color3.fromRGB(255, 255, 255)
closeConfirm.ZIndex = 52
closeConfirm.Parent = confirmBox

local closeConfirmCorner = Instance.new("UICorner")
closeConfirmCorner.CornerRadius = UDim.new(0, 4)
closeConfirmCorner.Parent = closeConfirm

local dontClose = Instance.new("TextButton")
dontClose.Size = UDim2.fromOffset(100, 30)
dontClose.Position = UDim2.new(1, -105, 1, -42)
dontClose.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dontClose.BorderSizePixel = 0
dontClose.Text = "Don't Close"
dontClose.TextSize = 13
dontClose.Font = Enum.Font.GothamMedium
dontClose.TextColor3 = Color3.fromRGB(220, 220, 220)
dontClose.ZIndex = 52
dontClose.Parent = confirmBox

local dontCloseCorner = Instance.new("UICorner")
dontCloseCorner.CornerRadius = UDim.new(0, 4)
dontCloseCorner.Parent = dontClose

--==================================================
-- CLOSE ANIMATION
--==================================================

local function closeLoader()
    if cancelled then
        return
    end

    cancelled = true
    finished = true

    confirmOverlay.Visible = false
    restoreButton.Visible = false
    window.Visible = true

    local closeInfo = TweenInfo.new(
        0.32,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    )

    TweenService:Create(
        scale,
        closeInfo,
        {Scale = 0.82}
    ):Play()

    for _, object in ipairs(window:GetDescendants()) do

        if object:IsA("Frame") then

            TweenService:Create(
                object,
                closeInfo,
                {BackgroundTransparency = 1}
            ):Play()

        elseif object:IsA("TextLabel") or object:IsA("TextButton") then

            TweenService:Create(
                object,
                closeInfo,
                {
                    TextTransparency = 1,
                    BackgroundTransparency = 1
                }
            ):Play()

        elseif object:IsA("ImageLabel") then

            TweenService:Create(
                object,
                closeInfo,
                {
                    ImageTransparency = 1,
                    BackgroundTransparency = 1
                }
            ):Play()

        elseif object:IsA("UIStroke") then

            TweenService:Create(
                object,
                closeInfo,
                {
                    Transparency = 1
                }
            ):Play()
        end
    end

    task.wait(0.35)

    if gui then
        gui:Destroy()
    end
end

closeButton.MouseButton1Click:Connect(function()
    if cancelled or finished then
        return
    end

    confirmOverlay.Visible = true
end)

dontClose.MouseButton1Click:Connect(function()
    confirmOverlay.Visible = false
end)

closeConfirm.MouseButton1Click:Connect(function()
    closeLoader()
end)

--==================================================
-- LOADING SYSTEM
--==================================================

local function setProgress(value, status, detail)
    if cancelled then
        return false
    end

    value = math.clamp(value, 0, 100)

    percentText.Text = tostring(math.floor(value)) .. "%"

    loadingText.Text = status
    detailText.Text = detail

    TweenService:Create(
        progress,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad),
        {
            Size = UDim2.new(value / 100, 0, 1, 0)
        }
    ):Play()

    return true
end

local stages = {
    {
        percent = 10,
        text = "Loading...",
        detail = "Initializing client..."
    },
    {
        percent = 25,
        text = "Loading...",
        detail = "Preparing interface..."
    },
    {
        percent = 40,
        text = "Loading...",
        detail = "Downloading resources..."
    },
    {
        percent = 55,
        text = "Loading...",
        detail = "Preparing image assets..."
    },
    {
        percent = 70,
        text = "Loading...",
        detail = "Checking configuration..."
    },
    {
        percent = 82,
        text = "Loading...",
        detail = "Preparing modules..."
    },
    {
        percent = 92,
        text = "Loading...",
        detail = "Almost finished..."
    },
    {
        percent = 100,
        text = "Load Successful",
        detail = "给我三连给我三连."
    }
}

--==================================================
-- 15 SECOND STAGED LOADING
--==================================================

task.spawn(function()

    for i, stage in ipairs(stages) do

        if cancelled then
            return
        end

        setProgress(
            stage.percent,
            stage.text,
            stage.detail
        )

        -- 每一段停顿，让加载看起来是分阶段进行
        if i < #stages then

            local waitTime = 15 / (#stages - 1)

            local elapsed = 0

            while elapsed < waitTime do

                if cancelled then
                    return
                end

                task.wait(0.1)
                elapsed = elapsed + 0.1
            end
        end
    end

    if cancelled then
        return
    end

    finished = true

    task.wait(1)

    if cancelled then
        return
    end

    --==================================================
    -- NORMAL FADE OUT
    --==================================================

    local fadeInfo = TweenInfo.new(
        1.2,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )

    for _, object in ipairs(window:GetDescendants()) do

        if object:IsA("Frame") then

            TweenService:Create(
                object,
                fadeInfo,
                {
                    BackgroundTransparency = 1
                }
            ):Play()

        elseif object:IsA("TextLabel") then

            TweenService:Create(
                object,
                fadeInfo,
                {
                    TextTransparency = 1
                }
            ):Play()

        elseif object:IsA("ImageLabel") then

            TweenService:Create(
                object,
                fadeInfo,
                {
                    ImageTransparency = 1
                }
            ):Play()

        elseif object:IsA("UIStroke") then

            TweenService:Create(
                object,
                fadeInfo,
                {
                    Transparency = 1
                }
            ):Play()
        end
    end

    task.wait(1.3)

    if cancelled then
        return
    end

    gui:Destroy()

    --==================================================
    -- LOAD VAPE V4
    --==================================================

    task.wait(0.2)

    if cancelled then
        return
    end

    pcall(function()

        local source = game:HttpGet(
            VAPE_URL,
            true
        )

        if cancelled then
            return
        end

        local execute = loadstring(source)

        if execute and not cancelled then
            execute()
        end

    end)

end)
