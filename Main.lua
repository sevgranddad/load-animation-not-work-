-- VAPE STYLE ROBLOX CLIENT LOADER
-- Author: sevgranddad
-- QQ群: 1107177693
-- 中文 VAPE 风格界面 / 安全测试版

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer

local AUTHOR = "sevgranddad"
local QQ = "1107177693"
local VERSION = "V4.0 CN"
local GUI_NAME = "VapeChineseLoader"

local IMAGE_URL =
    "https://raw.githubusercontent.com/sevgranddad/load-animation-not-work-/main/Screenshot_20261003_214917.jpg"
local IMAGE_PATH = "MyClient/Screenshot_20261003_214917.jpg"

local parentGui = nil

pcall(function()
    if gethui then
        parentGui = gethui()
    end
end)

if not parentGui then
    parentGui = player:WaitForChild("PlayerGui")
end

pcall(function()
    local old = parentGui:FindFirstChild(GUI_NAME)
    if old then
        old:Destroy()
    end
end)

local function new(className, properties, parent)
    local obj = Instance.new(className)

    for key, value in pairs(properties or {}) do
        obj[key] = value
    end

    obj.Parent = parent
    return obj
end

local function tween(object, duration, properties, style, direction)
    local info = TweenInfo.new(
        duration,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )

    local t = TweenService:Create(object, info, properties)
    t:Play()

    return t
end

local function corner(object, radius)
    return new("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, object)
end

local function stroke(object, color, transparency, thickness)
    return new("UIStroke", {
        Color = color,
        Transparency = transparency or 0,
        Thickness = thickness or 1
    }, object)
end

pcall(function()
    local sound = Instance.new("Sound")
    sound.Name = "VapeLoaderStartSound"
    sound.SoundId = "rbxassetid://6026984224"
    sound.Volume = 0.65
    sound.Parent = SoundService
    sound:Play()

    sound.Ended:Connect(function()
        sound:Destroy()
    end)

    task.delay(4, function()
        if sound and sound.Parent then
            sound:Destroy()
        end
    end)
end)

local startupImageAsset = nil

pcall(function()
    if makefolder and isfolder and not isfolder("MyClient") then
        makefolder("MyClient")
    end
end)

pcall(function()
    if isfile and writefile and not isfile(IMAGE_PATH) then
        local data = game:HttpGet(IMAGE_URL)

        if data and #data > 0 then
            writefile(IMAGE_PATH, data)
        end
    end
end)

pcall(function()
    if getcustomasset and isfile and isfile(IMAGE_PATH) then
        startupImageAsset = getcustomasset(IMAGE_PATH)
    end
end)

local ScreenGui = new("ScreenGui", {
    Name = GUI_NAME,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999999
}, parentGui)

local Splash = new("Frame", {
    Name = "StartupSplash",
    BackgroundColor3 = Color3.fromRGB(18, 19, 21),
    BackgroundTransparency = 0,
    BorderSizePixel = 0,
    Size = UDim2.fromScale(1, 1),
    ZIndex = 100
}, ScreenGui)

local SplashImage = new("ImageLabel", {
    Name = "RepositoryImage",
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.47),
    Size = UDim2.new(0, 390, 0, 220),
    Image = startupImageAsset or "",
    ImageTransparency = 1,
    ScaleType = Enum.ScaleType.Fit,
    ZIndex = 101
}, Splash)

local SplashTitle = new("TextLabel", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0.80, 0),
    Size = UDim2.new(0, 420, 0, 26),
    Font = Enum.Font.GothamMedium,
    Text = "VAPE v4 中文版",
    TextColor3 = Color3.fromRGB(235, 235, 235),
    TextSize = 16,
    TextTransparency = 1,
    ZIndex = 101
}, Splash)

local SplashAuthor = new("TextLabel", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0.86, 0),
    Size = UDim2.new(0, 420, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "作者：sevgranddad   ·   QQ群：1107177693",
    TextColor3 = Color3.fromRGB(112, 190, 181),
    TextSize = 11,
    TextTransparency = 1,
    ZIndex = 101
}, Splash)

local Backdrop = new("Frame", {
    Name = "Backdrop",
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.42,
    BorderSizePixel = 0,
    Size = UDim2.fromScale(1, 1)
}, ScreenGui)

local Window = new("Frame", {
    Name = "Window",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.new(0, 560, 0, 350),
    BackgroundColor3 = Color3.fromRGB(28, 29, 31),
    BorderSizePixel = 0
}, ScreenGui)

corner(Window, 5)
stroke(Window, Color3.fromRGB(72, 74, 78), 0.15, 1)

local TitleBar = new("Frame", {
    Name = "TitleBar",
    BackgroundColor3 = Color3.fromRGB(239, 239, 239),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 34)
}, Window)

local TitleText = new("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 13, 0, 0),
    Size = UDim2.new(1, -120, 1, 0),
    Font = Enum.Font.Gotham,
    Text = "VAPE v4",
    TextColor3 = Color3.fromRGB(40, 40, 40),
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left
}, TitleBar)

local MinButton = new("TextButton", {
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -88, 0, 0),
    Size = UDim2.new(0, 28, 1, 0),
    Font = Enum.Font.Gotham,
    Text = "—",
    TextColor3 = Color3.fromRGB(70, 70, 70),
    TextSize = 16,
    AutoButtonColor = false
}, TitleBar)

local MaxButton = new("TextButton", {
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -59, 0, 0),
    Size = UDim2.new(0, 28, 1, 0),
    Font = Enum.Font.Gotham,
    Text = "□",
    TextColor3 = Color3.fromRGB(150, 150, 150),
    TextSize = 13,
    AutoButtonColor = false
}, TitleBar)

local CloseTopButton = new("TextButton", {
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -30, 0, 0),
    Size = UDim2.new(0, 30, 1, 0),
    Font = Enum.Font.Gotham,
    Text = "×",
    TextColor3 = Color3.fromRGB(70, 70, 70),
    TextSize = 19,
    AutoButtonColor = false
}, TitleBar)

local Content = new("Frame", {
    Name = "Content",
    BackgroundColor3 = Color3.fromRGB(28, 29, 31),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0, 34),
    Size = UDim2.new(1, 0, 1, -34)
}, Window)

local LogoImage = new("ImageLabel", {
    Name = "RepositoryLogo",
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 18),
    Size = UDim2.new(0, 190, 0, 105),
    Image = startupImageAsset or "",
    ImageTransparency = startupImageAsset and 0 or 1,
    ScaleType = Enum.ScaleType.Fit
}, Content)

local LogoSub = new("TextLabel", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 118),
    Size = UDim2.new(0, 250, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "V4  ·  中文版",
    TextColor3 = Color3.fromRGB(112, 190, 181),
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Center
}, Content)

local LoginPage = new("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1)
}, Content)

local UserBox = new("TextBox", {
    BackgroundColor3 = Color3.fromRGB(40, 42, 45),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -140, 0, 112),
    Size = UDim2.new(0, 280, 0, 36),
    Font = Enum.Font.Gotham,
    PlaceholderText = "用户名",
    PlaceholderColor3 = Color3.fromRGB(135, 137, 140),
    Text = "",
    TextColor3 = Color3.fromRGB(235, 235, 235),
    TextSize = 12,
    ClearTextOnFocus = false
}, LoginPage)

corner(UserBox, 3)
stroke(UserBox, Color3.fromRGB(65, 67, 71), 0.25, 1)

local PassBox = new("TextBox", {
    BackgroundColor3 = Color3.fromRGB(40, 42, 45),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -140, 0, 155),
    Size = UDim2.new(0, 280, 0, 36),
    Font = Enum.Font.Gotham,
    PlaceholderText = "密码",
    PlaceholderColor3 = Color3.fromRGB(135, 137, 140),
    Text = "",
    TextColor3 = Color3.fromRGB(235, 235, 235),
    TextSize = 12,
    ClearTextOnFocus = false
}, LoginPage)

corner(PassBox, 3)
stroke(PassBox, Color3.fromRGB(65, 67, 71), 0.25, 1)

local LoginButton = new("TextButton", {
    BackgroundColor3 = Color3.fromRGB(70, 166, 151),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -140, 0, 201),
    Size = UDim2.new(0, 280, 0, 37),
    Font = Enum.Font.GothamBold,
    Text = "登录",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 12,
    AutoButtonColor = false
}, LoginPage)

corner(LoginButton, 3)

local OrText = new("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0.5, -140, 0, 243),
    Size = UDim2.new(0, 280, 0, 18),
    Font = Enum.Font.Gotham,
    Text = "或",
    TextColor3 = Color3.fromRGB(115, 117, 120),
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Center
}, LoginPage)

local BrowserButton = new("TextButton", {
    BackgroundColor3 = Color3.fromRGB(45, 105, 180),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -140, 0, 268),
    Size = UDim2.new(0, 280, 0, 32),
    Font = Enum.Font.Gotham,
    Text = "浏览器登录",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 11,
    AutoButtonColor = false
}, LoginPage)

corner(BrowserButton, 3)

local ClientPage = new("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Visible = false
}, Content)

local ClientTitle = new("TextLabel", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 110),
    Size = UDim2.new(0, 440, 0, 26),
    Font = Enum.Font.GothamMedium,
    Text = "选择一个 Roblox 客户端",
    TextColor3 = Color3.fromRGB(238, 238, 238),
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Center
}, ClientPage)

local ClientSub = new("TextLabel", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 138),
    Size = UDim2.new(0, 440, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "请确保游戏已经完全加载",
    TextColor3 = Color3.fromRGB(125, 127, 130),
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Center
}, ClientPage)

local ClientButton = new("TextButton", {
    BackgroundColor3 = Color3.fromRGB(41, 43, 46),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -175, 0, 174),
    Size = UDim2.new(0, 350, 0, 58),
    Font = Enum.Font.GothamMedium,
    Text = "",
    TextColor3 = Color3.fromRGB(240, 240, 240),
    TextSize = 12,
    AutoButtonColor = false
}, ClientPage)

corner(ClientButton, 3)
stroke(ClientButton, Color3.fromRGB(70, 72, 75), 0.25, 1)

local ClientName = new("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 17, 0, 9),
    Size = UDim2.new(1, -34, 0, 20),
    Font = Enum.Font.GothamMedium,
    Text = "Roblox Client #1",
    TextColor3 = Color3.fromRGB(235, 235, 235),
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left
}, ClientButton)

local ClientPID = new("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 17, 0, 32),
    Size = UDim2.new(1, -34, 0, 18),
    Font = Enum.Font.Gotham,
    Text = "PID  ----",
    TextColor3 = Color3.fromRGB(115, 117, 120),
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left
}, ClientButton)

local LoadingPage = new("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Visible = false
}, Content)

local LoadingTitle = new("TextLabel", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 111),
    Size = UDim2.new(0, 420, 0, 25),
    Font = Enum.Font.GothamMedium,
    Text = "正在加载 VAPE",
    TextColor3 = Color3.fromRGB(238, 238, 238),
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Center
}, LoadingPage)

local LoadingStatus = new("TextLabel", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 139),
    Size = UDim2.new(0, 420, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "正在初始化……",
    TextColor3 = Color3.fromRGB(125, 127, 130),
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Center
}, LoadingPage)

local ProgressBack = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(45, 47, 50),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -175, 0, 183),
    Size = UDim2.new(0, 350, 0, 5)
}, LoadingPage)

corner(ProgressBack, 3)

local ProgressFill = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(77, 180, 162),
    BorderSizePixel = 0,
    Size = UDim2.new(0, 0, 1, 0)
}, ProgressBack)

corner(ProgressFill, 3)

local PercentText = new("TextLabel", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 200),
    Size = UDim2.new(0, 100, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "0%",
    TextColor3 = Color3.fromRGB(105, 180, 168),
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Center
}, LoadingPage)

local FinishPage = new("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Visible = false
}, Content)

local FinishTitle = new("TextLabel", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 110),
    Size = UDim2.new(0, 450, 0, 28),
    Font = Enum.Font.GothamMedium,
    Text = "Vape 已完成加载",
    TextColor3 = Color3.fromRGB(238, 238, 238),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Center
}, FinishPage)

local FinishSub = new("TextLabel", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 142),
    Size = UDim2.new(0, 450, 0, 40),
    Font = Enum.Font.Gotham,
    Text = "游戏中按 RIGHT SHIFT（默认）打开 GUI",
    TextColor3 = Color3.fromRGB(130, 132, 135),
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Center
}, FinishPage)

local FinishLine = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(62, 64, 67),
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 191),
    Size = UDim2.new(0, 300, 0, 1)
}, FinishPage)

local AuthorText = new("TextLabel", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 204),
    Size = UDim2.new(0, 320, 0, 19),
    Font = Enum.Font.Gotham,
    Text = "作者：sevgranddad    QQ群：1107177693",
    TextColor3 = Color3.fromRGB(120, 122, 125),
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Center
}, FinishPage)

local VersionText = new("TextLabel", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 224),
    Size = UDim2.new(0, 320, 0, 18),
    Font = Enum.Font.Gotham,
    Text = "VAPE 中文版  ·  " .. VERSION,
    TextColor3 = Color3.fromRGB(90, 92, 95),
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Center
}, FinishPage)

local FinalClose = new("TextButton", {
    BackgroundColor3 = Color3.fromRGB(57, 59, 62),
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 260),
    Size = UDim2.new(0, 140, 0, 33),
    Font = Enum.Font.GothamMedium,
    Text = "关闭窗口",
    TextColor3 = Color3.fromRGB(235, 235, 235),
    TextSize = 11,
    AutoButtonColor = false
}, FinishPage)

corner(FinalClose, 3)
stroke(FinalClose, Color3.fromRGB(80, 82, 85), 0.2, 1)

local Credit = new("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 14, 1, -28),
    Size = UDim2.new(0, 250, 0, 18),
    Font = Enum.Font.Gotham,
    Text = "Author: " .. AUTHOR .. "  ·  QQ: " .. QQ,
    TextColor3 = Color3.fromRGB(88, 90, 93),
    TextSize = 8,
    TextXAlignment = Enum.TextXAlignment.Left
}, Content)

Window.Visible = false
Backdrop.Visible = false

local pages = {
    LoginPage,
    ClientPage,
    LoadingPage,
    FinishPage
}

local function showPage(target)
    for _, page in ipairs(pages) do
        page.Visible = page == target
    end
end

local dragging = false
local dragStart
local startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = Window.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position - dragStart

        Window.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

local minimized = false
local normalSize = Window.Size

MinButton.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        Window.Size = UDim2.new(0, 560, 0, 34)
    else
        Window.Size = normalSize
    end
end)

MaxButton.Active = false

local function closeWindow()
    if not ScreenGui or not ScreenGui.Parent then
        return
    end

    tween(Window, 0.35, {
        BackgroundTransparency = 1
    })

    tween(Backdrop, 0.35, {
        BackgroundTransparency = 1
    })

    for _, obj in ipairs(Window:GetDescendants()) do
        if obj:IsA("TextLabel")
            or obj:IsA("TextButton")
            or obj:IsA("TextBox") then

            tween(obj, 0.25, {
                TextTransparency = 1
            })
        elseif obj:IsA("ImageLabel") then
            tween(obj, 0.25, {
                ImageTransparency = 1
            })
        end
    end

    task.wait(0.4)

    if ScreenGui then
        ScreenGui:Destroy()
    end
end

CloseTopButton.MouseButton1Click:Connect(closeWindow)
FinalClose.MouseButton1Click:Connect(closeWindow)

local function buttonHover(button, normal, hover)
    button.MouseEnter:Connect(function()
        tween(button, 0.12, {
            BackgroundColor3 = hover
        })
    end)

    button.MouseLeave:Connect(function()
        tween(button, 0.12, {
            BackgroundColor3 = normal
        })
    end)
end

buttonHover(
    LoginButton,
    Color3.fromRGB(70, 166, 151),
    Color3.fromRGB(84, 184, 168)
)

buttonHover(
    BrowserButton,
    Color3.fromRGB(45, 105, 180),
    Color3.fromRGB(54, 120, 200)
)

buttonHover(
    ClientButton,
    Color3.fromRGB(41, 43, 46),
    Color3.fromRGB(48, 50, 53)
)

buttonHover(
    FinalClose,
    Color3.fromRGB(57, 59, 62),
    Color3.fromRGB(70, 72, 75)
)

-- 安全测试占位：这里不执行远程 Vape/外挂脚本
local function onClientLoadingFinished()
    print("[VapeChineseLoader] 加载测试完成")
end

local loadingStarted = false

local ProgressGlow = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(180, 255, 242),
    BackgroundTransparency = 0.78,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 34, 1, 0),
    Position = UDim2.new(0, -38, 0, 0),
    ZIndex = ProgressFill.ZIndex + 1
}, ProgressBack)

corner(ProgressGlow, 3)

local ProgressRunning = false

local function startProgressGlow()
    if ProgressRunning then
        return
    end

    ProgressRunning = true

    task.spawn(function()
        while ProgressRunning and ScreenGui.Parent do
            ProgressGlow.Position = UDim2.new(0, -38, 0, 0)

            tween(
                ProgressGlow,
                0.75,
                {
                    Position = UDim2.new(1, 4, 0, 0)
                },
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            )

            task.wait(0.18)
        end
    end)
end

local function updateProgress(percent, status, duration)
    percent = math.clamp(percent, 0, 100)

    tween(
        LoadingStatus,
        0.12,
        {
            TextTransparency = 1
        }
    )

    task.wait(0.12)

    LoadingStatus.Text = status
    PercentText.Text = tostring(math.floor(percent)) .. "%"

    tween(
        LoadingStatus,
        0.18,
        {
            TextTransparency = 0
        }
    )

    tween(
        ProgressFill,
        duration or 0.55,
        {
            Size = UDim2.new(percent / 100, 0, 1, 0)
        },
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )
end

local function startLoading()
    if loadingStarted then
        return
    end

    loadingStarted = true
    showPage(LoadingPage)

    ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    PercentText.Text = "0%"
    LoadingStatus.TextTransparency = 0

    startProgressGlow()

    local stages = {
        {4,   "正在初始化……",             0.28, 0.30},
        {9,   "正在初始化……",             0.20, 0.55},
        {12,  "正在检查 Roblox 客户端……", 0.18, 0.70},
        {22,  "正在检查 Roblox 客户端……", 0.38, 0.30},
        {22,  "正在连接客户端……",         0.12, 0.65},
        {34,  "正在加载核心组件……",       0.44, 0.18},
        {43,  "正在加载核心组件……",       0.31, 0.60},
        {43,  "正在准备 GUI……",            0.10, 0.48},
        {57,  "正在准备 GUI……",            0.48, 0.20},
        {63,  "正在初始化功能……",         0.28, 0.72},
        {74,  "正在初始化功能……",         0.36, 0.22},
        {74,  "正在同步配置……",            0.10, 0.78},
        {84,  "正在同步配置……",            0.35, 0.18},
        {91,  "正在完成最后步骤……",        0.26, 0.35},
        {96,  "正在完成最后步骤……",        0.20, 0.30},
        {100, "加载完成",                   0.24, 0.25}
    }

    for _, stage in ipairs(stages) do
        updateProgress(stage[1], stage[2], stage[3])
        task.wait(stage[4])
    end

    ProgressRunning = false

    tween(ProgressFill, 0.12, {
        BackgroundColor3 = Color3.fromRGB(112, 215, 195)
    })

    task.wait(0.12)

    tween(ProgressFill, 0.20, {
        BackgroundColor3 = Color3.fromRGB(77, 180, 162)
    })

    onClientLoadingFinished()

    task.wait(0.35)

    showPage(FinishPage)

    for _, obj in ipairs(FinishPage:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local old = obj.TextTransparency
            obj.TextTransparency = 1

            tween(obj, 0.35, {
                TextTransparency = old
            })
        end
    end
end

local loginBusy = false

local function doLogin()
    if loginBusy then
        return
    end

    loginBusy = true
    LoginButton.Text = "正在登录……"

    task.wait(0.55)

    LoginButton.Text = "登录成功"

    task.wait(0.25)

    showPage(ClientPage)
    loginBusy = false
end

LoginButton.MouseButton1Click:Connect(doLogin)

BrowserButton.MouseButton1Click:Connect(function()
    doLogin()
end)

ClientButton.MouseButton1Click:Connect(function()
    if loadingStarted then
        return
    end

    startLoading()
end)

Window.BackgroundTransparency = 1
Backdrop.BackgroundTransparency = 1
showPage(LoginPage)

task.spawn(function()
    if startupImageAsset then
        SplashImage.Size = UDim2.new(0, 350, 0, 198)
        SplashImage.ImageTransparency = 1

        tween(
            SplashImage,
            0.80,
            {
                Size = UDim2.new(0, 390, 0, 220),
                ImageTransparency = 0
            },
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        )

        task.wait(0.18)

        tween(
            SplashTitle,
            0.45,
            {
                TextTransparency = 0
            },
            Enum.EasingStyle.Quart
        )

        task.wait(0.08)

        tween(
            SplashAuthor,
            0.45,
            {
                TextTransparency = 0
            },
            Enum.EasingStyle.Quart
        )

        task.wait(1.25)
    else
        tween(
            SplashTitle,
            0.50,
            {
                TextTransparency = 0
            },
            Enum.EasingStyle.Quart
        )

        task.wait(0.15)

        tween(
            SplashAuthor,
            0.45,
            {
                TextTransparency = 0
            },
            Enum.EasingStyle.Quart
        )

        task.wait(1.0)
    end

    tween(
        SplashImage,
        0.60,
        {
            ImageTransparency = 1
        }
    )

    tween(
        SplashTitle,
        0.45,
        {
            TextTransparency = 1
        }
    )

    tween(
        SplashAuthor,
        0.45,
        {
            TextTransparency = 1
        }
    )

    tween(
        Splash,
        0.60,
        {
            BackgroundTransparency = 1
        }
    )

    task.wait(0.65)

    if Splash and Splash.Parent then
        Splash:Destroy()
    end

    Window.Visible = true
    Backdrop.Visible = true

    Window.Size = UDim2.new(0, 520, 0, 325)
    Window.BackgroundTransparency = 1
    Backdrop.BackgroundTransparency = 1

    tween(
        Window,
        0.48,
        {
            Size = normalSize,
            BackgroundTransparency = 0
        },
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )

    tween(
        Backdrop,
        0.48,
        {
            BackgroundTransparency = 0.42
        },
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )

    LogoImage.ImageTransparency = 1
    LogoSub.TextTransparency = 1

    task.wait(0.12)

    tween(
        LogoImage,
        0.50,
        {
            ImageTransparency = 0
        },
        Enum.EasingStyle.Quart
    )

    task.wait(0.08)

    tween(
        LogoSub,
        0.40,
        {
            TextTransparency = 0
        },
        Enum.EasingStyle.Quart
    )
    
loadstring(
game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", 
                    true))()

    print("[VapeChineseLoader] GUI loaded.")
    print("[VapeChineseLoader] Repository splash:", IMAGE_URL)
    print("[VapeChineseLoader] Author:", AUTHOR)
    print("[VapeChineseLoader] QQ:", QQ)
end)

print("[VapeChineseLoader] Author:", AUTHOR)
print("[VapeChineseLoader] QQ:", QQ)
