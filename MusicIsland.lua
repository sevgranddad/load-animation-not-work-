local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local IMAGE_URL = "https://raw.githubusercontent.com/sevgranddad/load-animation-not-work-/main/Screenshot_20261003_214917.jpg"
local IMAGE_PATH = "MyClient/Screenshot_20261003_214917.jpg"
local MUSIC_URL = "https://raw.githubusercontent.com/sevgranddad/load-animation-not-work-/main/Gold%20Dust.mp3"
local MUSIC_PATH = "MyClient/Gold%20Dust.mp3"
local LYRICS_URL = "https://raw.githubusercontent.com/sevgranddad/load-animation-not-work-/main/Gold%20Dust.lrc"
local LYRICS_PATH = "MyClient/Gold%20Dust.lrc"
local VAPE_URL = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua"

local MUSIC_TITLE = "Gold Dust"
local MUSIC_SUBTITLE = "VAPE 小曲"
local DEFAULT_VOLUME = 0.75

local cancelled = false
local finished = false
local musicPlaying = false
local islandExpanded = false
local settingsOpen = false
local lyricsEnabled = true
local visualizerEnabled = true
local lyricsPosition = "Island"
local loopEnabled = false
local islandPressed = false
local currentLyricIndex = 0
local lyrics = {}
local lyricDelay = 0

local function safeCall(fn, ...)
    local ok, result = pcall(fn, ...)
    if ok then
        return result
    end
end

if makefolder and not isfolder("MyClient") then
    safeCall(function()
        makefolder("MyClient")
    end)
end

if isfile and writefile then
    if not isfile(IMAGE_PATH) then
        safeCall(function()
            local data = game:HttpGet(IMAGE_URL, true)
            if data then
                writefile(IMAGE_PATH, data)
            end
        end)
    end

    if not isfile(MUSIC_PATH) then
        safeCall(function()
            local data = game:HttpGet(MUSIC_URL, true)
            if data then
                writefile(MUSIC_PATH, data)
            end
        end)
    end

    if not isfile(LYRICS_PATH) then
        safeCall(function()
            local data = game:HttpGet(LYRICS_URL, true)
            if data then
                writefile(LYRICS_PATH, data)
            end
        end)
    end
end

local imageAsset
if getcustomasset and isfile and isfile(IMAGE_PATH) then
    imageAsset = safeCall(function()
        return getcustomasset(IMAGE_PATH)
    end)
end

local musicAsset
if getcustomasset and isfile and isfile(MUSIC_PATH) then
    musicAsset = safeCall(function()
        return getcustomasset(MUSIC_PATH)
    end)
end

local function parseTime(value)
    local min, sec = value:match("(%d+):([%d%.]+)")
    if not min then
        return nil
    end

    return tonumber(min) * 60 + tonumber(sec)
end

if readfile and isfile and isfile(LYRICS_PATH) then
    local rawLyrics = safeCall(function()
        return readfile(LYRICS_PATH)
    end)

    if rawLyrics then
        for line in rawLyrics:gmatch("[^\r\n]+") do
            local time, text = line:match("^%[([%d:.]+)%]%s*(.*)$")

            if time and text and text ~= "" then
                local seconds = parseTime(time)

                if seconds then
                    table.insert(lyrics, {
                        time = seconds,
                        text = text
                    })
                end
            end
        end

        table.sort(lyrics, function(a, b)
            return a.time < b.time
        end)
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "VapeLoaderMusic"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

safeCall(function()
    gui.Parent = playerGui
end)

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function stroke(parent, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Transparency = transparency or 0
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function tween(object, duration, properties, style, direction)
    local info = TweenInfo.new(
        duration,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )

    local t = TweenService:Create(object, info, properties)
    t:Play()

    return t
end

local function button(parent, text, size, position)
    local b = Instance.new("TextButton")
    b.BackgroundColor3 = Color3.fromRGB(35, 37, 44)
    b.BorderSizePixel = 0
    b.Size = size
    b.Position = position
    b.Font = Enum.Font.GothamMedium
    b.Text = text
    b.TextSize = 13
    b.TextColor3 = Color3.fromRGB(235, 238, 245)
    b.AutoButtonColor = false
    b.Parent = parent

    corner(b, 9)
    stroke(b, Color3.fromRGB(70, 74, 86), 0.25, 1)

    b.MouseEnter:Connect(function()
        tween(b, 0.15, {
            BackgroundColor3 = Color3.fromRGB(48, 51, 61)
        }, Enum.EasingStyle.Quad)
    end)

    b.MouseLeave:Connect(function()
        tween(b, 0.15, {
            BackgroundColor3 = Color3.fromRGB(35, 37, 44)
        }, Enum.EasingStyle.Quad)
    end)

    b.MouseButton1Down:Connect(function()
        tween(b, 0.08, {
            Size = UDim2.new(
                size.X.Scale,
                size.X.Offset - 3,
                size.Y.Scale,
                size.Y.Offset - 2
            )
        }, Enum.EasingStyle.Quad)
    end)

    b.MouseButton1Up:Connect(function()
        tween(b, 0.12, {
            Size = size
        }, Enum.EasingStyle.Back)
    end)

    return b
end

local window = Instance.new("Frame")
window.Name = "Window"
window.Size = UDim2.fromOffset(520, 300)
window.Position = UDim2.new(0.5, -260, 0.5, -150)
window.BackgroundColor3 = Color3.fromRGB(20, 21, 25)
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.Parent = gui

corner(window, 10)
stroke(window, Color3.fromRGB(75, 80, 95), 0.25, 1)

local windowScale = Instance.new("UIScale")
windowScale.Scale = 1
windowScale.Parent = window

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 26, 31)
titleBar.BorderSizePixel = 0
titleBar.Parent = window

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(15, 0)
title.Size = UDim2.new(1, -145, 1, 0)
title.Font = Enum.Font.GothamMedium
title.Text = "VAPE V4"
title.TextSize = 15
title.TextColor3 = Color3.fromRGB(235, 237, 242)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 15, 0, 20)
subtitle.Size = UDim2.new(1, -145, 0, 15)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "V4 · 中文版"
subtitle.TextSize = 9
subtitle.TextColor3 = Color3.fromRGB(125, 130, 142)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = titleBar

local minimizeButton = button(
    titleBar,
    "−",
    UDim2.fromOffset(38, 32),
    UDim2.new(1, -120, 0, 3)
)

local maximizeButton = button(
    titleBar,
    "□",
    UDim2.fromOffset(38, 32),
    UDim2.new(1, -80, 0, 3)
)

local closeButton = button(
    titleBar,
    "×",
    UDim2.fromOffset(38, 32),
    UDim2.new(1, -40, 0, 3)
)

maximizeButton.TextColor3 = Color3.fromRGB(90, 94, 105)
maximizeButton.Active = false

local content = Instance.new("Frame")
content.BackgroundTransparency = 1
content.Position = UDim2.fromOffset(18, 48)
content.Size = UDim2.new(1, -36, 1, -58)
content.Parent = window

local image = Instance.new("ImageLabel")
image.BackgroundColor3 = Color3.fromRGB(28, 30, 35)
image.BorderSizePixel = 0
image.Position = UDim2.fromOffset(0, 0)
image.Size = UDim2.fromOffset(210, 185)
image.ScaleType = Enum.ScaleType.Crop
image.Parent = content

corner(image, 8)

if imageAsset then
    image.Image = imageAsset
end

local info = Instance.new("Frame")
info.BackgroundTransparency = 1
info.Position = UDim2.fromOffset(230, 0)
info.Size = UDim2.new(1, -230, 1, 0)
info.Parent = content

local loadingText = Instance.new("TextLabel")
loadingText.BackgroundTransparency = 1
loadingText.Position = UDim2.fromOffset(0, 18)
loadingText.Size = UDim2.new(1, 0, 0, 28)
loadingText.Font = Enum.Font.GothamMedium
loadingText.Text = "Loading..."
loadingText.TextSize = 18
loadingText.TextColor3 = Color3.fromRGB(235, 238, 245)
loadingText.TextXAlignment = Enum.TextXAlignment.Left
loadingText.Parent = info

local detailText = Instance.new("TextLabel")
detailText.BackgroundTransparency = 1
detailText.Position = UDim2.fromOffset(0, 51)
detailText.Size = UDim2.new(1, 0, 0, 50)
detailText.Font = Enum.Font.Code
detailText.Text = "Initializing client..."
detailText.TextSize = 12
detailText.TextColor3 = Color3.fromRGB(145, 150, 162)
detailText.TextWrapped = true
detailText.TextXAlignment = Enum.TextXAlignment.Left
detailText.TextYAlignment = Enum.TextYAlignment.Top
detailText.Parent = info

local progressBackground = Instance.new("Frame")
progressBackground.BackgroundColor3 = Color3.fromRGB(43, 45, 53)
progressBackground.BorderSizePixel = 0
progressBackground.Position = UDim2.new(0, 0, 1, -50)
progressBackground.Size = UDim2.new(1, 0, 0, 5)
progressBackground.Parent = info

corner(progressBackground, 5)

local progress = Instance.new("Frame")
progress.BackgroundColor3 = Color3.fromRGB(90, 180, 255)
progress.BorderSizePixel = 0
progress.Size = UDim2.new(0, 0, 1, 0)
progress.Parent = progressBackground

corner(progress, 5)

local percentText = Instance.new("TextLabel")
percentText.BackgroundTransparency = 1
percentText.Position = UDim2.new(0, 0, 1, -35)
percentText.Size = UDim2.new(1, 0, 0, 20)
percentText.Font = Enum.Font.Code
percentText.Text = "0%"
percentText.TextSize = 11
percentText.TextColor3 = Color3.fromRGB(115, 120, 132)
percentText.TextXAlignment = Enum.TextXAlignment.Right
percentText.Parent = info

local authorText = Instance.new("TextLabel")
authorText.BackgroundTransparency = 1
authorText.Position = UDim2.fromOffset(0, 122)
authorText.Size = UDim2.new(1, 0, 0, 40)
authorText.Font = Enum.Font.Gotham
authorText.Text = "作者: sevgranddad\nQQ群: 1107177693"
authorText.TextSize = 10
authorText.TextColor3 = Color3.fromRGB(105, 110, 122)
authorText.TextXAlignment = Enum.TextXAlignment.Left
authorText.TextYAlignment = Enum.TextYAlignment.Top
authorText.Parent = info

local dragging = false
local dragStart
local startPosition

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = window.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging
        and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then

        local delta = input.Position - dragStart

        window.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false
    end
end)

local restoreButton = button(
    gui,
    "VAPE V4",
    UDim2.fromOffset(120, 34),
    UDim2.new(0, 15, 1, -50)
)

restoreButton.Visible = false

minimizeButton.MouseButton1Click:Connect(function()
    if finished then
        return
    end

    tween(
        windowScale,
        0.28,
        {Scale = 0.88},
        Enum.EasingStyle.Back,
        Enum.EasingDirection.In
    )

    task.wait(0.18)

    window.Visible = false
    restoreButton.Visible = true
end)

restoreButton.MouseButton1Click:Connect(function()
    restoreButton.Visible = false
    window.Visible = true
    windowScale.Scale = 0.88

    tween(
        windowScale,
        0.32,
        {Scale = 1},
        Enum.EasingStyle.Back
    )
end)

local confirmOverlay = Instance.new("Frame")
confirmOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
confirmOverlay.BackgroundTransparency = 0.38
confirmOverlay.Size = UDim2.fromScale(1, 1)
confirmOverlay.Visible = false
confirmOverlay.ZIndex = 50
confirmOverlay.Parent = gui

local confirmBox = Instance.new("Frame")
confirmBox.Size = UDim2.fromOffset(380, 145)
confirmBox.Position = UDim2.new(0.5, -190, 0.5, -72)
confirmBox.BackgroundColor3 = Color3.fromRGB(28, 29, 35)
confirmBox.BorderSizePixel = 0
confirmBox.ZIndex = 51
confirmBox.Parent = confirmOverlay

corner(confirmBox, 10)
stroke(confirmBox, Color3.fromRGB(80, 84, 98), 0.25, 1)

local confirmTitle = Instance.new("TextLabel")
confirmTitle.BackgroundTransparency = 1
confirmTitle.Position = UDim2.fromOffset(18, 14)
confirmTitle.Size = UDim2.new(1, -36, 0, 25)
confirmTitle.Font = Enum.Font.GothamMedium
confirmTitle.Text = "关闭 VAPE V4？"
confirmTitle.TextSize = 16
confirmTitle.TextColor3 = Color3.fromRGB(240, 242, 248)
confirmTitle.TextXAlignment = Enum.TextXAlignment.Left
confirmTitle.ZIndex = 52
confirmTitle.Parent = confirmBox

local confirmText = Instance.new("TextLabel")
confirmText.BackgroundTransparency = 1
confirmText.Position = UDim2.fromOffset(18, 43)
confirmText.Size = UDim2.new(1, -36, 0, 42)
confirmText.Font = Enum.Font.Gotham
confirmText.Text = "脚本正在执行中。\n确定要关闭加载器吗？"
confirmText.TextSize = 12
confirmText.TextColor3 = Color3.fromRGB(170, 174, 185)
confirmText.TextWrapped = true
confirmText.TextXAlignment = Enum.TextXAlignment.Left
confirmText.TextYAlignment = Enum.TextYAlignment.Top
confirmText.ZIndex = 52
confirmText.Parent = confirmBox

local closeConfirm = button(
    confirmBox,
    "关闭",
    UDim2.fromOffset(100, 30),
    UDim2.new(1, -215, 1, -42)
)

closeConfirm.BackgroundColor3 = Color3.fromRGB(190, 48, 60)
closeConfirm.ZIndex = 52

local dontClose = button(
    confirmBox,
    "取消",
    UDim2.fromOffset(100, 30),
    UDim2.new(1, -105, 1, -42)
)

dontClose.ZIndex = 52

local musicPrompt = Instance.new("Frame")
musicPrompt.Name = "MusicPrompt"
musicPrompt.Size = UDim2.fromOffset(410, 172)
musicPrompt.Position = UDim2.new(0.5, -205, 0.5, -86)
musicPrompt.BackgroundColor3 = Color3.fromRGB(19, 20, 25)
musicPrompt.BorderSizePixel = 0
musicPrompt.Visible = false
musicPrompt.ZIndex = 80
musicPrompt.Parent = gui

corner(musicPrompt, 18)
stroke(musicPrompt, Color3.fromRGB(105, 145, 255), 0.22, 1)

local promptGlow = Instance.new("Frame")
promptGlow.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
promptGlow.BackgroundTransparency = 0.88
promptGlow.Size = UDim2.new(1, -10, 1, -10)
promptGlow.Position = UDim2.fromOffset(5, 5)
promptGlow.BorderSizePixel = 0
promptGlow.ZIndex = 80
promptGlow.Parent = musicPrompt

corner(promptGlow, 15)

local promptIcon = Instance.new("TextLabel")
promptIcon.BackgroundTransparency = 1
promptIcon.Position = UDim2.fromOffset(20, 18)
promptIcon.Size = UDim2.fromOffset(42, 42)
promptIcon.Font = Enum.Font.GothamBold
promptIcon.Text = "♪"
promptIcon.TextSize = 28
promptIcon.TextColor3 = Color3.fromRGB(120, 190, 255)
promptIcon.ZIndex = 82
promptIcon.Parent = musicPrompt

local promptTitle = Instance.new("TextLabel")
promptTitle.BackgroundTransparency = 1
promptTitle.Position = UDim2.fromOffset(68, 17)
promptTitle.Size = UDim2.new(1, -88, 0, 24)
promptTitle.Font = Enum.Font.GothamMedium
promptTitle.Text = "要播放 Gold Dust 吗？"
promptTitle.TextSize = 16
promptTitle.TextColor3 = Color3.fromRGB(240, 242, 248)
promptTitle.TextXAlignment = Enum.TextXAlignment.Left
promptTitle.ZIndex = 82
promptTitle.Parent = musicPrompt

local promptSub = Instance.new("TextLabel")
promptSub.BackgroundTransparency = 1
promptSub.Position = UDim2.fromOffset(68, 42)
promptSub.Size = UDim2.new(1, -88, 0, 22)
promptSub.Font = Enum.Font.Gotham
promptSub.Text = "VAPE 小曲  ·  本地客户端播放"
promptSub.TextSize = 11
promptSub.TextColor3 = Color3.fromRGB(145, 150, 164)
promptSub.TextXAlignment = Enum.TextXAlignment.Left
promptSub.ZIndex = 82
promptSub.Parent = musicPrompt

local playButton = button(
    musicPrompt,
    "▶  播放",
    UDim2.fromOffset(130, 34),
    UDim2.new(0, 20, 1, -52)
)

playButton.BackgroundColor3 = Color3.fromRGB(72, 135, 240)
playButton.ZIndex = 82

local laterButton = button(
    musicPrompt,
    "稍后",
    UDim2.fromOffset(100, 34),
    UDim2.new(0, 160, 1, -52)
)

laterButton.ZIndex = 82

local noAssetText = Instance.new("TextLabel")
noAssetText.BackgroundTransparency = 1
noAssetText.Position = UDim2.new(0, 270, 1, -51)
noAssetText.Size = UDim2.new(1, -285, 0, 38)
noAssetText.Font = Enum.Font.Gotham
noAssetText.Text = ""
noAssetText.TextSize = 9
noAssetText.TextColor3 = Color3.fromRGB(120, 125, 138)
noAssetText.TextWrapped = true
noAssetText.TextXAlignment = Enum.TextXAlignment.Left
noAssetText.ZIndex = 82
noAssetText.Parent = musicPrompt

local island = Instance.new("Frame")
island.Name = "MusicIsland"
island.Size = UDim2.fromOffset(176, 44)
island.Position = UDim2.new(0.5, -88, 0, 12)
island.BackgroundColor3 = Color3.fromRGB(12, 13, 17)
island.BorderSizePixel = 0
island.Visible = false
island.ZIndex = 100
island.Parent = gui

corner(island, 22)
stroke(island, Color3.fromRGB(80, 110, 180), 0.25, 1)

local islandScale = Instance.new("UIScale")
islandScale.Scale = 1
islandScale.Parent = island

local islandIcon = Instance.new("TextLabel")
islandIcon.BackgroundTransparency = 1
islandIcon.Position = UDim2.fromOffset(10, 6)
islandIcon.Size = UDim2.fromOffset(32, 32)
islandIcon.Font = Enum.Font.GothamBold
islandIcon.Text = "♪"
islandIcon.TextSize = 19
islandIcon.TextColor3 = Color3.fromRGB(100, 180, 255)
islandIcon.ZIndex = 102
islandIcon.Parent = island

local islandSong = Instance.new("TextLabel")
islandSong.BackgroundTransparency = 1
islandSong.Position = UDim2.fromOffset(43, 5)
islandSong.Size = UDim2.new(1, -78, 0, 17)
islandSong.Font = Enum.Font.GothamMedium
islandSong.Text = MUSIC_TITLE
islandSong.TextSize = 11
islandSong.TextColor3 = Color3.fromRGB(240, 242, 247)
islandSong.TextXAlignment = Enum.TextXAlignment.Left
islandSong.TextTruncate = Enum.TextTruncate.AtEnd
islandSong.ZIndex = 102
islandSong.Parent = island

local islandState = Instance.new("TextLabel")
islandState.BackgroundTransparency = 1
islandState.Position = UDim2.fromOffset(43, 21)
islandState.Size = UDim2.new(1, -78, 0, 14)
islandState.Font = Enum.Font.Gotham
islandState.Text = "VAPE 小曲"
islandState.TextSize = 8
islandState.TextColor3 = Color3.fromRGB(130, 136, 150)
islandState.TextXAlignment = Enum.TextXAlignment.Left
islandState.ZIndex = 102
islandState.Parent = island

local islandPlay = button(
    island,
    "Ⅱ",
    UDim2.fromOffset(28, 28),
    UDim2.new(1, -35, 0, 8)
)

islandPlay.BackgroundColor3 = Color3.fromRGB(30, 34, 42)
islandPlay.TextSize = 11
islandPlay.ZIndex = 103
islandPlay.Visible = false

local expanded = Instance.new("Frame")
expanded.BackgroundColor3 = Color3.fromRGB(15, 16, 21)
expanded.BorderSizePixel = 0
expanded.Size = UDim2.fromOffset(420, 270)
expanded.Position = UDim2.new(0.5, -210, 0, 12)
expanded.Visible = false
expanded.ZIndex = 101
expanded.Parent = gui

corner(expanded, 20)
stroke(expanded, Color3.fromRGB(95, 125, 195), 0.22, 1)

local expandedScale = Instance.new("UIScale")
expandedScale.Scale = 0.82
expandedScale.Parent = expanded

local expandedTitle = Instance.new("TextLabel")
expandedTitle.BackgroundTransparency = 1
expandedTitle.Position = UDim2.fromOffset(18, 15)
expandedTitle.Size = UDim2.new(1, -80, 0, 22)
expandedTitle.Font = Enum.Font.GothamMedium
expandedTitle.Text = MUSIC_TITLE
expandedTitle.TextSize = 15
expandedTitle.TextColor3 = Color3.fromRGB(242, 244, 249)
expandedTitle.TextXAlignment = Enum.TextXAlignment.Left
expandedTitle.ZIndex = 103
expandedTitle.Parent = expanded

local expandedSubtitle = Instance.new("TextLabel")
expandedSubtitle.BackgroundTransparency = 1
expandedSubtitle.Position = UDim2.fromOffset(18, 37)
expandedSubtitle.Size = UDim2.new(1, -80, 0, 16)
expandedSubtitle.Font = Enum.Font.Gotham
expandedSubtitle.Text = MUSIC_SUBTITLE
expandedSubtitle.TextSize = 9
expandedSubtitle.TextColor3 = Color3.fromRGB(132, 138, 151)
expandedSubtitle.TextXAlignment = Enum.TextXAlignment.Left
expandedSubtitle.ZIndex = 103
expandedSubtitle.Parent = expanded

local expandedClose = button(
    expanded,
    "×",
    UDim2.fromOffset(30, 30),
    UDim2.new(1, -40, 0, 10)
)

expandedClose.BackgroundColor3 = Color3.fromRGB(28, 30, 37)
expandedClose.ZIndex = 104

local visualizerFrame = Instance.new("Frame")
visualizerFrame.BackgroundTransparency = 1
visualizerFrame.Position = UDim2.fromOffset(18, 64)
visualizerFrame.Size = UDim2.new(1, -36, 0, 42)
visualizerFrame.ZIndex = 103
visualizerFrame.Parent = expanded

local bars = {}

for i = 1, 18 do
    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = Color3.fromRGB(
        80 + i * 3,
        150 + math.floor(i * 1.8),
        255
    )
    bar.BorderSizePixel = 0
    bar.AnchorPoint = Vector2.new(0.5, 1)
    bar.Position = UDim2.new((i - 0.5) / 18, 0, 1, 0)
    bar.Size = UDim2.new(0, 5, 0, 8)
    bar.ZIndex = 104
    bar.Parent = visualizerFrame

    corner(bar, 4)

    bars[i] = bar
end

local progressTrack = Instance.new("Frame")
progressTrack.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
progressTrack.BorderSizePixel = 0
progressTrack.Position = UDim2.fromOffset(18, 139)
progressTrack.Size = UDim2.new(1, -36, 0, 5)
progressTrack.ZIndex = 103
progressTrack.Parent = expanded

corner(progressTrack, 5)

local progressFill = Instance.new("Frame")
progressFill.BackgroundColor3 = Color3.fromRGB(92, 175, 255)
progressFill.BorderSizePixel = 0
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.ZIndex = 104
progressFill.Parent = progressTrack

corner(progressFill, 5)

local timeLabel = Instance.new("TextLabel")
timeLabel.BackgroundTransparency = 1
timeLabel.Position = UDim2.fromOffset(18, 147)
timeLabel.Size = UDim2.fromOffset(55, 16)
timeLabel.Font = Enum.Font.Code
timeLabel.Text = "00:00"
timeLabel.TextSize = 9
timeLabel.TextColor3 = Color3.fromRGB(125, 130, 143)
timeLabel.TextXAlignment = Enum.TextXAlignment.Left
timeLabel.ZIndex = 103
timeLabel.Parent = expanded

local lengthLabel = Instance.new("TextLabel")
lengthLabel.BackgroundTransparency = 1
lengthLabel.Position = UDim2.new(1, -73, 0, 147)
lengthLabel.Size = UDim2.fromOffset(55, 16)
lengthLabel.Font = Enum.Font.Code
lengthLabel.Text = "00:00"
lengthLabel.TextSize = 9
lengthLabel.TextColor3 = Color3.fromRGB(125, 130, 143)
lengthLabel.TextXAlignment = Enum.TextXAlignment.Right
lengthLabel.ZIndex = 103
lengthLabel.Parent = expanded

local previousButton = button(
    expanded,
    "‹",
    UDim2.fromOffset(42, 32),
    UDim2.new(0.5, -98, 1, -55)
)

previousButton.ZIndex = 104

local mainPlay = button(
    expanded,
    "Ⅱ",
    UDim2.fromOffset(56, 38),
    UDim2.new(0.5, -28, 1, -58)
)

mainPlay.BackgroundColor3 = Color3.fromRGB(68, 130, 235)
mainPlay.TextSize = 14
mainPlay.ZIndex = 104

local nextButton = button(
    expanded,
    "›",
    UDim2.fromOffset(42, 32),
    UDim2.new(0.5, 56, 1, -55)
)

nextButton.ZIndex = 104

local settingsButton = button(
    expanded,
    "⚙",
    UDim2.fromOffset(42, 34),
    UDim2.new(1, -58, 1, -56)
)

settingsButton.ZIndex = 104

local lyricsPreview = Instance.new("TextLabel")
lyricsPreview.BackgroundTransparency = 1
lyricsPreview.Position = UDim2.fromOffset(18, 109)
lyricsPreview.Size = UDim2.new(1, -36, 0, 22)
lyricsPreview.Font = Enum.Font.GothamMedium
lyricsPreview.Text = "歌词等待中..."
lyricsPreview.TextSize = 10
lyricsPreview.TextColor3 = Color3.fromRGB(180, 205, 255)
lyricsPreview.TextXAlignment = Enum.TextXAlignment.Center
lyricsPreview.ZIndex = 105
lyricsPreview.Parent = expanded

local screenLyric = Instance.new("TextLabel")
screenLyric.BackgroundColor3 = Color3.fromRGB(12, 13, 17)
screenLyric.BackgroundTransparency = 0.12
screenLyric.BorderSizePixel = 0
screenLyric.Size = UDim2.new(0.86, 0, 0, 42)
screenLyric.Position = UDim2.new(0.07, 0, 0, 74)
screenLyric.Font = Enum.Font.GothamMedium
screenLyric.Text = ""
screenLyric.TextSize = 15
screenLyric.TextColor3 = Color3.fromRGB(235, 242, 255)
screenLyric.TextXAlignment = Enum.TextXAlignment.Center
screenLyric.Visible = false
screenLyric.ZIndex = 95
screenLyric.Parent = gui

corner(screenLyric, 18)
stroke(screenLyric, Color3.fromRGB(85, 125, 210), 0.45, 1)

local settingsBackdrop = Instance.new("TextButton")
settingsBackdrop.Name = "SettingsBackdrop"
settingsBackdrop.Text = ""
settingsBackdrop.AutoButtonColor = false
settingsBackdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
settingsBackdrop.BackgroundTransparency = 0.55
settingsBackdrop.BorderSizePixel = 0
settingsBackdrop.Size = UDim2.fromScale(1, 1)
settingsBackdrop.Visible = false
settingsBackdrop.ZIndex = 118
settingsBackdrop.Parent = gui

local settingsPanel = Instance.new("Frame")
settingsPanel.Size = UDim2.fromOffset(360, 318)
settingsPanel.Position = UDim2.new(0.5, -180, 0.5, -159)
settingsPanel.BackgroundColor3 = Color3.fromRGB(18, 19, 24)
settingsPanel.BorderSizePixel = 0
settingsPanel.Visible = false
settingsPanel.ZIndex = 120
settingsPanel.Parent = gui

corner(settingsPanel, 16)
stroke(settingsPanel, Color3.fromRGB(90, 120, 190), 0.3, 1)

local settingsScale = Instance.new("UIScale")
settingsScale.Scale = 0.88
settingsScale.Parent = settingsPanel

local settingsTitle = Instance.new("TextLabel")
settingsTitle.BackgroundTransparency = 1
settingsTitle.Position = UDim2.fromOffset(16, 12)
settingsTitle.Size = UDim2.new(1, -50, 0, 22)
settingsTitle.Font = Enum.Font.GothamMedium
settingsTitle.Text = "音乐设置"
settingsTitle.TextSize = 14
settingsTitle.TextColor3 = Color3.fromRGB(238, 241, 247)
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.ZIndex = 121
settingsTitle.Parent = settingsPanel

local settingsClose = button(
    settingsPanel,
    "×",
    UDim2.fromOffset(30, 30),
    UDim2.new(1, -38, 0, 7)
)

settingsClose.ZIndex = 122

local lyricsToggle = button(
    settingsPanel,
    "歌词：开启",
    UDim2.fromOffset(150, 34),
    UDim2.fromOffset(16, 50)
)

lyricsToggle.ZIndex = 122

local visualizerToggle = button(
    settingsPanel,
    "可视化：开启",
    UDim2.fromOffset(150, 34),
    UDim2.fromOffset(174, 50)
)

visualizerToggle.ZIndex = 122

local positionLabel = Instance.new("TextLabel")
positionLabel.BackgroundTransparency = 1
positionLabel.Position = UDim2.fromOffset(16, 91)
positionLabel.Size = UDim2.new(1, -32, 0, 18)
positionLabel.Font = Enum.Font.Gotham
positionLabel.Text = "歌词位置"
positionLabel.TextSize = 10
positionLabel.TextColor3 = Color3.fromRGB(145, 150, 162)
positionLabel.TextXAlignment = Enum.TextXAlignment.Left
positionLabel.ZIndex = 122
positionLabel.Parent = settingsPanel

local islandPosButton = button(
    settingsPanel,
    "灵动岛",
    UDim2.fromOffset(100, 32),
    UDim2.fromOffset(16, 120)
)

local topPosButton = button(
    settingsPanel,
    "屏幕上方",
    UDim2.fromOffset(100, 32),
    UDim2.fromOffset(126, 120)
)

local centerPosButton = button(
    settingsPanel,
    "屏幕中央",
    UDim2.fromOffset(100, 32),
    UDim2.fromOffset(236, 120)
)

islandPosButton.ZIndex = 122
topPosButton.ZIndex = 122
centerPosButton.ZIndex = 122

local volumeLabel = Instance.new("TextLabel")
volumeLabel.BackgroundTransparency = 1
volumeLabel.Position = UDim2.fromOffset(16, 157)
volumeLabel.Size = UDim2.fromOffset(50, 20)
volumeLabel.Font = Enum.Font.Gotham
volumeLabel.Text = "音量"
volumeLabel.TextSize = 10
volumeLabel.TextColor3 = Color3.fromRGB(145, 150, 162)
volumeLabel.TextXAlignment = Enum.TextXAlignment.Left
volumeLabel.ZIndex = 122
volumeLabel.Parent = settingsPanel

local volumeTrack = Instance.new("Frame")
volumeTrack.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
volumeTrack.BorderSizePixel = 0
volumeTrack.Position = UDim2.fromOffset(64, 164)
volumeTrack.Size = UDim2.fromOffset(190, 5)
volumeTrack.ZIndex = 122
volumeTrack.Parent = settingsPanel

corner(volumeTrack, 5)

local volumeFill = Instance.new("Frame")
volumeFill.BackgroundColor3 = Color3.fromRGB(90, 175, 255)
volumeFill.BorderSizePixel = 0
volumeFill.Size = UDim2.new(DEFAULT_VOLUME, 0, 1, 0)
volumeFill.ZIndex = 123
volumeFill.Parent = volumeTrack

corner(volumeFill, 5)

local volumeValue = Instance.new("TextLabel")
volumeValue.BackgroundTransparency = 1
volumeValue.Position = UDim2.fromOffset(260, 154)
volumeValue.Size = UDim2.fromOffset(25, 20)
volumeValue.Font = Enum.Font.Code
volumeValue.Text = "75%"
volumeValue.TextSize = 9
volumeValue.TextColor3 = Color3.fromRGB(175, 180, 192)
volumeValue.ZIndex = 122
volumeValue.Parent = settingsPanel

local delayLabel = Instance.new("TextLabel")
delayLabel.BackgroundTransparency = 1
delayLabel.Position = UDim2.fromOffset(16, 190)
delayLabel.Size = UDim2.fromOffset(80, 20)
delayLabel.Font = Enum.Font.Gotham
delayLabel.Text = "歌词延迟"
delayLabel.TextSize = 10
delayLabel.TextColor3 = Color3.fromRGB(145, 150, 162)
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.ZIndex = 122
delayLabel.Parent = settingsPanel

local delayTrack = Instance.new("Frame")
delayTrack.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
delayTrack.BorderSizePixel = 0
delayTrack.Position = UDim2.fromOffset(78, 197)
delayTrack.Size = UDim2.fromOffset(150, 5)
delayTrack.ZIndex = 122
delayTrack.Parent = settingsPanel

corner(delayTrack, 5)

local delayFill = Instance.new("Frame")
delayFill.BackgroundColor3 = Color3.fromRGB(90, 175, 255)
delayFill.BorderSizePixel = 0
delayFill.Size = UDim2.new(0.5, 0, 1, 0)
delayFill.ZIndex = 123
delayFill.Parent = delayTrack

corner(delayFill, 5)

local delayValue = Instance.new("TextLabel")
delayValue.BackgroundTransparency = 1
delayValue.Position = UDim2.fromOffset(232, 188)
delayValue.Size = UDim2.fromOffset(52, 20)
delayValue.Font = Enum.Font.Code
delayValue.Text = "0.00s"
delayValue.TextSize = 9
delayValue.TextColor3 = Color3.fromRGB(175, 180, 192)
delayValue.ZIndex = 122
delayValue.Parent = settingsPanel

local delayHint = Instance.new("TextLabel")
delayHint.BackgroundTransparency = 1
delayHint.Position = UDim2.fromOffset(16, 263)
delayHint.Size = UDim2.new(1, -32, 0, 16)
delayHint.Font = Enum.Font.Gotham
delayHint.Text = "左侧提前 · 右侧延后 · 范围 ±5 秒"
delayHint.TextSize = 8
delayHint.TextColor3 = Color3.fromRGB(105, 110, 122)
delayHint.TextXAlignment = Enum.TextXAlignment.Left
delayHint.ZIndex = 122
delayHint.Parent = settingsPanel

local loopButton = button(
    settingsPanel,
    "循环：关闭",
    UDim2.fromOffset(150, 32),
    UDim2.fromOffset(16, 282)
)

loopButton.ZIndex = 122

local lyricsHint = Instance.new("TextLabel")
lyricsHint.BackgroundTransparency = 1
lyricsHint.Position = UDim2.fromOffset(176, 282)
lyricsHint.Size = UDim2.fromOffset(165, 30)
lyricsHint.Font = Enum.Font.Gotham
lyricsHint.Text = "支持 .lrc 时间轴歌词"
lyricsHint.TextSize = 8
lyricsHint.TextColor3 = Color3.fromRGB(105, 110, 122)
lyricsHint.TextXAlignment = Enum.TextXAlignment.Right
lyricsHint.ZIndex = 122
lyricsHint.Parent = settingsPanel

local function updatePositionButtons()
    islandPosButton.BackgroundColor3 =
        lyricsPosition == "Island"
        and Color3.fromRGB(65, 105, 185)
        or Color3.fromRGB(35, 37, 44)

    topPosButton.BackgroundColor3 =
        lyricsPosition == "Top"
        and Color3.fromRGB(65, 105, 185)
        or Color3.fromRGB(35, 37, 44)

    centerPosButton.BackgroundColor3 =
        lyricsPosition == "Center"
        and Color3.fromRGB(65, 105, 185)
        or Color3.fromRGB(35, 37, 44)
end

updatePositionButtons()

local sound = Instance.new("Sound")
sound.Name = "GoldDust_Local"
sound.Volume = DEFAULT_VOLUME
sound.Looped = false
sound.Parent = SoundService

if musicAsset then
    sound.SoundId = musicAsset
    noAssetText.Text = "本地音频已就绪"
else
    noAssetText.Text = "当前执行环境不支持本地音频\n请使用支持 getcustomasset 的环境"
    playButton.BackgroundColor3 = Color3.fromRGB(55, 58, 67)
end

local function formatTime(value)
    value = math.max(0, value or 0)

    local minutes = math.floor(value / 60)
    local seconds = math.floor(value % 60)

    return string.format("%02d:%02d", minutes, seconds)
end

local function findLyric(position)
    local index = 0

    for i, item in ipairs(lyrics) do
        if position >= item.time then
            index = i
        else
            break
        end
    end

    return index
end

local function updateLyric(position)
    if not lyricsEnabled then
        return
    end

    local adjustedPosition = math.max(
        0,
        position + lyricDelay
    )

    local index = findLyric(adjustedPosition)

    if index == currentLyricIndex
        and lyricsPosition == "Island" then
        return
    end

    currentLyricIndex = index

    local currentText = ""
    local previousText = ""
    local nextText = ""

    if index > 0 and lyrics[index] then
        currentText = lyrics[index].text
    elseif #lyrics == 0 then
        currentText = "未找到歌词时间轴"
    else
        currentText = "♪"
    end

    if index > 1 and lyrics[index - 1] then
        previousText = lyrics[index - 1].text
    end

    if index > 0 and lyrics[index + 1] then
        nextText = lyrics[index + 1].text
    end

    if lyricsPosition == "Island" then
        lyricsPreview.Visible = true
        lyricsPreview.Text = currentText
        screenLyric.Visible = false
    else
        lyricsPreview.Visible = false
        screenLyric.Visible = musicPlaying and lyricsEnabled

        if musicPlaying then
            screenLyric.Text = currentText
            screenLyric.TextTransparency = 1

            if lyricsPosition == "Center" then
                screenLyric.Position =
                    UDim2.new(0.5, -260, 0.55, 0)

                tween(
                    screenLyric,
                    0.3,
                    {
                        TextTransparency = 0
                    },
                    Enum.EasingStyle.Back
                )
            else
                screenLyric.Position =
                    UDim2.new(0.5, -260, 0, 62)

                tween(
                    screenLyric,
                    0.3,
                    {
                        TextTransparency = 0,
                        Position = UDim2.new(
                            0.5,
                            -260,
                            0,
                            72
                        )
                    },
                    Enum.EasingStyle.Back
                )
            end

            if nextText ~= "" then
                task.spawn(function()
                    task.wait(0.3)

                    if musicPlaying
                        and lyricsEnabled
                        and currentLyricIndex == index then

                        screenLyric.Text = currentText
                    end
                end)
            end
        end
    end
end

local function setLyricsPosition(position)
    lyricsPosition = position

    updatePositionButtons()

    if position == "Island" then
        screenLyric.Visible = false
        lyricsPreview.Visible = true

        if currentLyricIndex > 0
            and lyrics[currentLyricIndex] then

            lyricsPreview.Text =
                lyrics[currentLyricIndex].text
        else
            lyricsPreview.Text = "♪"
        end
    else
        lyricsPreview.Visible = false
        screenLyric.Visible =
            musicPlaying and lyricsEnabled

        if position == "Top" then
            screenLyric.Position =
                UDim2.new(0.07, 0, 0, 74)
        else
            screenLyric.Position =
                UDim2.new(0.07, 0, 0.55, 0)
        end

        updateLyric(sound.TimePosition)
    end
end

local function updateMusicButtons()
    local icon = musicPlaying and "Ⅱ" or "▶"

    islandPlay.Text = icon
    mainPlay.Text = icon

    islandState.Text =
        musicPlaying
        and "正在播放 · " .. MUSIC_SUBTITLE
        or "已暂停 · " .. MUSIC_SUBTITLE
end

local function showIsland()
    island.Visible = true

    islandScale.Scale = 0.2

    island.Position =
        UDim2.new(0.5, -88, 0, 12)

    tween(
        islandScale,
        0.45,
        {Scale = 1},
        Enum.EasingStyle.Back
    )

    tween(
        island,
        0.45,
        {
            Position = UDim2.new(
                0.5,
                -88,
                0,
                12
            )
        },
        Enum.EasingStyle.Back
    )
end

local function collapseExpanded()
    if not islandExpanded then
        return
    end

    islandExpanded = false
    settingsOpen = false

    settingsPanel.Visible = false

    expandedScale.Scale = 1

    tween(
        expandedScale,
        0.25,
        {Scale = 0.82},
        Enum.EasingStyle.Back,
        Enum.EasingDirection.In
    )

    task.wait(0.18)

    expanded.Visible = false
    island.Visible = true

    islandScale.Scale = 0.82

    tween(
        islandScale,
        0.32,
        {Scale = 1},
        Enum.EasingStyle.Back
    )
end

local function expandIsland()
    if islandExpanded then
        collapseExpanded()
        return
    end

    islandExpanded = true

    island.Visible = false
    expanded.Visible = true

    expandedScale.Scale = 0.78

    tween(
        expandedScale,
        0.38,
        {Scale = 1},
        Enum.EasingStyle.Back
    )
end

local function openSettings()
    if settingsOpen then
        return
    end

    settingsOpen = true

    settingsBackdrop.Visible = true
    settingsPanel.Visible = true

    settingsScale.Scale = 0.82

    tween(
        settingsBackdrop,
        0.22,
        {
            BackgroundTransparency = 0.55
        },
        Enum.EasingStyle.Quad
    )

    tween(
        settingsScale,
        0.35,
        {Scale = 1},
        Enum.EasingStyle.Back
    )
end

local function closeSettings()
    if not settingsOpen then
        return
    end

    settingsOpen = false

    tween(
        settingsScale,
        0.2,
        {
            Scale = 0.82
        },
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    )

    tween(
        settingsBackdrop,
        0.2,
        {
            BackgroundTransparency = 1
        },
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    )

    task.wait(0.2)

    settingsPanel.Visible = false
    settingsBackdrop.Visible = false
end

island.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        islandPressed = true
    end
end)

island.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        if islandPressed then
            expandIsland()
        end

        islandPressed = false
    end
end)

expandedClose.MouseButton1Click:Connect(function()
    if settingsOpen then
        closeSettings()
    else
        collapseExpanded()
    end
end)

mainPlay.MouseButton1Click:Connect(function()
    if musicPlaying then
        sound:Pause()
        musicPlaying = false
    else
        if sound.TimeLength > 0
            and sound.TimePosition >= sound.TimeLength then

            sound.TimePosition = 0
        end

        if sound.TimePosition == 0 then
            sound:Play()
        else
            sound:Resume()
        end

        musicPlaying = true
    end

    updateMusicButtons()
end)

islandPlay.MouseButton1Click:Connect(function()
    if musicPlaying then
        sound:Pause()
        musicPlaying = false
    else
        if sound.TimeLength > 0
            and sound.TimePosition >= sound.TimeLength then

            sound.TimePosition = 0
        end

        if sound.TimePosition == 0 then
            sound:Play()
        else
            sound:Resume()
        end

        musicPlaying = true
    end

    updateMusicButtons()
end)

previousButton.MouseButton1Click:Connect(function()
    sound.TimePosition = 0
    currentLyricIndex = 0

    if not musicPlaying then
        sound:Play()
        musicPlaying = true
    end

    updateMusicButtons()
end)

nextButton.MouseButton1Click:Connect(function()
    sound.TimePosition = 0
    currentLyricIndex = 0

    if not musicPlaying then
        sound:Play()
        musicPlaying = true
    end

    updateMusicButtons()
end)

settingsButton.MouseButton1Click:Connect(function()
    if settingsOpen then
        closeSettings()
    else
        openSettings()
    end
end)

settingsClose.MouseButton1Click:Connect(function()
    closeSettings()
end)

settingsBackdrop.MouseButton1Click:Connect(function()
    closeSettings()
end)

lyricsToggle.MouseButton1Click:Connect(function()
    lyricsEnabled = not lyricsEnabled

    lyricsToggle.Text =
        lyricsEnabled
        and "歌词：开启"
        or "歌词：关闭"

    if not lyricsEnabled then
        screenLyric.Visible = false
        lyricsPreview.Visible = false
        lyricsPreview.Text = ""
    else
        lyricsPreview.Visible =
            lyricsPosition == "Island"

        updateLyric(sound.TimePosition)
    end
end)

visualizerToggle.MouseButton1Click:Connect(function()
    visualizerEnabled = not visualizerEnabled

    visualizerToggle.Text =
        visualizerEnabled
        and "可视化：开启"
        or "可视化：关闭"

    visualizerFrame.Visible = visualizerEnabled
end)

islandPosButton.MouseButton1Click:Connect(function()
    setLyricsPosition("Island")
end)

topPosButton.MouseButton1Click:Connect(function()
    setLyricsPosition("Top")
end)

centerPosButton.MouseButton1Click:Connect(function()
    setLyricsPosition("Center")

    screenLyric.Position =
        UDim2.new(0.5, -260, 0.55, 0)
end)

local delayDragging = false

local function setLyricDelayFromX(x)
    local left = delayTrack.AbsolutePosition.X
    local width = delayTrack.AbsoluteSize.X

    local value = math.clamp(
        (x - left) / width,
        0,
        1
    )

    lyricDelay = (value * 10) - 5

    delayFill.Size =
        UDim2.new(value, 0, 1, 0)

    local sign =
        lyricDelay > 0
        and "+"
        or ""

    delayValue.Text =
        string.format(
            "%s%.2fs",
            sign,
            lyricDelay
        )

    currentLyricIndex = -1

    updateLyric(sound.TimePosition)
end

delayTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        delayDragging = true

        setLyricDelayFromX(
            input.Position.X
        )
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if delayDragging
        and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then

        setLyricDelayFromX(
            input.Position.X
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        delayDragging = false
    end
end)

loopButton.MouseButton1Click:Connect(function()
    loopEnabled = not loopEnabled

    sound.Looped = loopEnabled

    loopButton.Text =
        loopEnabled
        and "循环：开启"
        or "循环：关闭"
end)

local volumeDragging = false

local function setVolumeFromX(x)
    local left = volumeTrack.AbsolutePosition.X
    local width = volumeTrack.AbsoluteSize.X

    local value = math.clamp(
        (x - left) / width,
        0,
        1
    )

    sound.Volume = value

    volumeFill.Size =
        UDim2.new(value, 0, 1, 0)

    volumeValue.Text =
        tostring(math.floor(value * 100)) .. "%"
end

volumeTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        volumeDragging = true

        setVolumeFromX(
            input.Position.X
        )
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if volumeDragging
        and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then

        setVolumeFromX(
            input.Position.X
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        volumeDragging = false
    end
end)

sound.Ended:Connect(function()
    if loopEnabled then
        return
    end

    musicPlaying = false
    updateMusicButtons()
end)

local renderConnection

renderConnection = RunService.RenderStepped:Connect(function()
    if not gui.Parent then
        if renderConnection then
            renderConnection:Disconnect()
        end

        return
    end

    if sound.IsPlaying then
        local length = sound.TimeLength
        local position = sound.TimePosition

        timeLabel.Text =
            formatTime(position)

        lengthLabel.Text =
            formatTime(length)

        if length > 0 then
            progressFill.Size =
                UDim2.new(
                    math.clamp(
                        position / length,
                        0,
                        1
                    ),
                    0,
                    1,
                    0
                )
        end

        updateLyric(position)

        if visualizerEnabled then
            local loudness =
                math.clamp(
                    sound.PlaybackLoudness / 350,
                    0,
                    1
                )

            for i, bar in ipairs(bars) do
                local wave =
                    math.sin(
                        os.clock() * 7
                        + i * 0.72
                    ) * 0.14

                local height =
                    math.clamp(
                        7
                        + loudness
                        * 34
                        * (
                            0.55
                            + math.abs(
                                math.sin(i * 0.8)
                            )
                        )
                        + wave * 15,
                        5,
                        46
                    )

                bar.Size =
                    UDim2.new(
                        0,
                        5,
                        0,
                        height
                    )
            end
        end
    else
        for i, bar in ipairs(bars) do
            local idle =
                7
                + math.abs(
                    math.sin(
                        os.clock() * 2 + i
                    )
                ) * 3

            bar.Size =
                UDim2.new(
                    0,
                    5,
                    0,
                    idle
                )
        end
    end
end)

local function closeLoader()
    if cancelled then
        return
    end

    cancelled = true

    confirmOverlay.Visible = false
    restoreButton.Visible = false

    tween(
        windowScale,
        0.35,
        {Scale = 0.78},
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.In
    )

    for _, object in ipairs(window:GetDescendants()) do
        if object:IsA("Frame") then
            tween(
                object,
                0.3,
                {
                    BackgroundTransparency = 1
                },
                Enum.EasingStyle.Quad
            )

        elseif object:IsA("TextLabel")
            or object:IsA("TextButton") then

            tween(
                object,
                0.3,
                {
                    TextTransparency = 1,
                    BackgroundTransparency = 1
                },
                Enum.EasingStyle.Quad
            )

        elseif object:IsA("ImageLabel") then
            tween(
                object,
                0.3,
                {
                    ImageTransparency = 1,
                    BackgroundTransparency = 1
                },
                Enum.EasingStyle.Quad
            )

        elseif object:IsA("UIStroke") then
            tween(
                object,
                0.3,
                {
                    Transparency = 1
                },
                Enum.EasingStyle.Quad
            )
        end
    end

    task.wait(0.38)

    sound:Stop()

    gui:Destroy()
end

closeButton.MouseButton1Click:Connect(function()
    if cancelled then
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

local function setProgress(value, status, detail)
    if cancelled then
        return false
    end

    value = math.clamp(value, 0, 100)

    percentText.Text =
        tostring(math.floor(value)) .. "%"

    loadingText.Text = status
    detailText.Text = detail

    tween(
        progress,
        0.38,
        {
            Size = UDim2.new(
                value / 100,
                0,
                1,
                0
            )
        },
        Enum.EasingStyle.Quint
    )

    return true
end

local stages = {
    {
        percent = 8,
        text = "Loading...",
        detail = "Initializing client..."
    },

    {
        percent = 19,
        text = "Loading...",
        detail = "Preparing interface..."
    },

    {
        percent = 34,
        text = "Loading...",
        detail = "Downloading resources..."
    },

    {
        percent = 49,
        text = "Loading...",
        detail = "Preparing image assets..."
    },

    {
        percent = 64,
        text = "Loading...",
        detail = "Checking configuration..."
    },

    {
        percent = 78,
        text = "Loading...",
        detail = "Preparing modules..."
    },

    {
        percent = 91,
        text = "Loading...",
        detail = "Almost finished..."
    },

    {
        percent = 100,
        text = "Load Successful",
        detail = "VAPE V4 中文版准备完成"
    }
}

local function animatePromptIn()
    musicPrompt.Visible = true

    musicPrompt.Size =
        UDim2.fromOffset(350, 146)

    musicPrompt.Position =
        UDim2.new(
            0.5,
            -175,
            0.5,
            -73
        )

    local s =
        musicPrompt:FindFirstChildOfClass(
            "UIScale"
        )

    if not s then
        s = Instance.new("UIScale")
        s.Parent = musicPrompt
    end

    s.Scale = 0.72

    tween(
        s,
        0.42,
        {Scale = 1},
        Enum.EasingStyle.Back
    )

    tween(
        musicPrompt,
        0.42,
        {
            Size = UDim2.fromOffset(410, 172),
            Position = UDim2.new(
                0.5,
                -205,
                0.5,
                -86
            )
        },
        Enum.EasingStyle.Back
    )
end

local function animatePromptOut()
    local s =
        musicPrompt:FindFirstChildOfClass(
            "UIScale"
        )

    if s then
        tween(
            s,
            0.25,
            {Scale = 0.7},
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.In
        )
    end

    tween(
        musicPrompt,
        0.25,
        {
            Size = UDim2.fromOffset(300, 120)
        },
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.In
    )

    task.wait(0.27)

    musicPrompt.Visible = false
end

local function startMusic()
    if not musicAsset then
        return false
    end

    sound.TimePosition = 0
    currentLyricIndex = -1

    sound:Play()

    musicPlaying = true

    updateMusicButtons()

    animatePromptOut()

    island.Visible = false

    task.wait(0.08)

    showIsland()

    return true
end

playButton.MouseButton1Click:Connect(function()
    startMusic()
end)

laterButton.MouseButton1Click:Connect(function()
    animatePromptOut()
end)

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

        if i < #stages then
            local waitTime =
                15 / (#stages - 1)

            local elapsed = 0

            while elapsed < waitTime do
                if cancelled then
                    return
                end

                task.wait(0.1)

                elapsed += 0.1
            end
        end
    end

    if cancelled then
        return
    end

    finished = true

    task.wait(0.7)

    local fadeInfo =
        TweenInfo.new(
            0.85,
            Enum.EasingStyle.Quint,
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
                    ImageTransparency = 1,
                    BackgroundTransparency = 1
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

    tween(
        windowScale,
        0.85,
        {Scale = 0.92},
        Enum.EasingStyle.Quint
    )

    task.wait(0.9)

    window.Visible = false

    animatePromptIn()

    local waited = 0

    while musicPrompt.Visible
        and waited < 30 do

        if cancelled then
            return
        end

        task.wait(0.1)

        waited += 0.1
    end

    if musicPrompt.Visible then
        animatePromptOut()
    end

    if cancelled then
        return
    end

    task.wait(0.25)

    safeCall(function()
        local source =
            game:HttpGet(
                VAPE_URL,
                true
            )

        if cancelled then
            return
        end

        local execute =
            loadstring(source)

        if execute
            and not cancelled then

            execute()
        end
    end)
end)
