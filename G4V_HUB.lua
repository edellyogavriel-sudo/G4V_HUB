-- G4V_HUB | LOADSTRING VERSION + INF JUMP | NO OVERLAY

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- ================= DATA =================
local Data = {
    WS = 16,
    JP = 50,
    Auto = false,
    Noclip = false,
    ESP = false,
    Rounded = true,
    RGB = false,
    InfJump = false
}

-- ================= CHARACTER =================
local function Char()
    return player.Character or player.CharacterAdded:Wait()
end

local function Hum()
    return Char():WaitForChild("Humanoid")
end

player.CharacterAdded:Connect(function()
    if Data.Auto then
        task.wait(1)
        Hum().WalkSpeed = Data.WS
        Hum().JumpPower = Data.JP
    end
end)

-- ================= INF JUMP =================
UIS.JumpRequest:Connect(function()
    if Data.InfJump then
        Hum():ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ================= GUI =================
local Gui = Instance.new("ScreenGui", game.CoreGui)

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,430,0,340)
Main.Position = UDim2.new(0.3,0,0.25,0)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2
Stroke.Color = Color3.new(1,1,1)

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0,12)

-- ================= TITLE =================
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1,0,0,35)
TitleBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1,-40,1,0)
Title.Position = UDim2.new(0,10,0,0)
Title.Text = "G4V_HUB"
Title.TextScaled = true
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local Min = Instance.new("TextButton", TitleBar)
Min.Size = UDim2.new(0,30,0,25)
Min.Position = UDim2.new(1,-35,0,5)
Min.Text = "-"
Min.BackgroundColor3 = Color3.fromRGB(50,50,50)
Min.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Min)

-- ================= TABS =================
local Tabs = Instance.new("Frame", Main)
Tabs.Position = UDim2.new(0,0,0,35)
Tabs.Size = UDim2.new(1,0,0,35)
Tabs.BackgroundTransparency = 1

local function Tab(txt,pos)
    local b = Instance.new("TextButton", Tabs)
    b.Size = UDim2.new(0.5,-6,1,-6)
    b.Position = pos
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    return b
end

local MainBtn = Tab("MAIN",UDim2.new(0,3,0,3))
local SetBtn  = Tab("SETTINGS",UDim2.new(0.5,3,0,3))

-- ================= PAGE =================
local function Page()
    local f = Instance.new("ScrollingFrame", Main)
    f.Position = UDim2.new(0,0,0,70)
    f.Size = UDim2.new(1,0,1,-70)
    f.CanvasSize = UDim2.new(0,0,0,700)
    f.ScrollBarThickness = 6
    f.BackgroundTransparency = 1
    Instance.new("UIListLayout", f).Padding = UDim.new(0,10)
    return f
end

local MainPage = Page()
local SetPage = Page()
SetPage.Visible = false

-- ================= UI MAKER =================
local function Button(p,t,cb)
    local b = Instance.new("TextButton", p)
    b.Size = UDim2.new(0.95,0,0,35)
    b.Text = t
    b.BackgroundColor3 = Color3.fromRGB(55,55,55)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
    return b
end

local function Box(p,ph)
    local b = Instance.new("TextBox", p)
    b.Size = UDim2.new(0.95,0,0,35)
    b.PlaceholderText = ph
    b.BackgroundColor3 = Color3.fromRGB(55,55,55)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    return b
end

-- ================= MAIN =================
local ws = Box(MainPage,"WalkSpeed")
Button(MainPage,"Set WalkSpeed",function()
    if tonumber(ws.Text) then
        Data.WS = tonumber(ws.Text)
        Hum().WalkSpeed = Data.WS
    end
end)

local jp = Box(MainPage,"JumpPower")
Button(MainPage,"Set JumpPower",function()
    if tonumber(jp.Text) then
        Data.JP = tonumber(jp.Text)
        Hum().JumpPower = Data.JP
    end
end)

Button(MainPage,"Toggle Auto WS + JP",function()
    Data.Auto = not Data.Auto
end)

Button(MainPage,"Toggle Infinite Jump",function()
    Data.InfJump = not Data.InfJump
end)

Button(MainPage,"Toggle Noclip",function()
    Data.Noclip = not Data.Noclip
end)

Button(MainPage,"Toggle ESP Highlight",function()
    Data.ESP = not Data.ESP
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local h = p.Character:FindFirstChildOfClass("Highlight")
            if Data.ESP and not h then
                Instance.new("Highlight",p.Character)
            elseif not Data.ESP and h then
                h:Destroy()
            end
        end
    end
end)

-- ================= SETTINGS =================
Button(SetPage,"Toggle Rounded GUI",function()
    Data.Rounded = not Data.Rounded
    Corner.CornerRadius = Data.Rounded and UDim.new(0,12) or UDim.new(0,0)
end)

Button(SetPage,"Toggle RGB Outline",function()
    Data.RGB = not Data.RGB
end)

-- ================= TAB SWITCH =================
MainBtn.MouseButton1Click:Connect(function()
    MainPage.Visible = true
    SetPage.Visible = false
end)

SetBtn.MouseButton1Click:Connect(function()
    MainPage.Visible = false
    SetPage.Visible = true
end)

-- ================= NOCLIP =================
RunService.Stepped:Connect(function()
    if Data.Noclip then
        for _,v in pairs(Char():GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ================= RGB OUTLINE =================
task.spawn(function()
    local h = 0
    while true do
        task.wait(0.03)
        if Data.RGB then
            h = (h + 1) % 360
            Stroke.Color = Color3.fromHSV(h/360,1,1)
        end
    end
end)

-- ================= MINIMIZE =================
local minimized = false
local fullSize = Main.Size

Min.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(Main,TweenInfo.new(0.3),{
        Size = minimized and UDim2.new(0,430,0,35) or fullSize
    }):Play()
    Min.Text = minimized and "+" or "-"
end)
