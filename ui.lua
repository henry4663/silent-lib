if game.CoreGui:FindFirstChild("PureHubTemplate") then
    game.CoreGui.PureHubTemplate:Destroy()
end

local PureHubTemplate = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local TopCorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local Sidebar = Instance.new("Frame")
local UIListLayoutBase = Instance.new("UIListLayout")
local Container = Instance.new("Frame")

-- Configurações Base
PureHubTemplate.Name = "PureHubTemplate"
PureHubTemplate.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = PureHubTemplate
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 500, 0, 320)

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Barra Superior
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
TopBar.Size = UDim2.new(1, 0, 0, 35)

TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "SCRIPT HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TopBar
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 75, 75)
CloseBtn.TextSize = 14

CloseBtn.MouseButton1Click:Connect(function()
    PureHubTemplate:Destroy()
end)

-- Lateral (Onde ficam os botões de alternar abas)
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.Size = UDim2.new(0, 130, 1, -35)

UIListLayoutBase.Parent = Sidebar
UIListLayoutBase.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutBase.Padding = UDim.new(0, 4)

-- Container Principal (Onde o conteúdo de cada aba aparece)
Container.Name = "Container"
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 140, 0, 45)
Container.Size = UDim2.new(1, -150, 1, -55)

-- ==========================================
-- SISTEMA DE CRIAR ABAS E FUNÇÕES INTERNAS
-- ==========================================
local currentTab = nil

local function CriarAba(nomeAba)
    -- Botão da Aba na Sidebar
    local TabBtn = Instance.new("TextButton")
    local TabBtnCorner = Instance.new("UICorner")
    
    TabBtn.Name = nomeAba .. "TabBtn"
    TabBtn.Parent = Sidebar
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.Size = UDim2.new(1, -10, 0, 32)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.Text = nomeAba
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.TextSize = 13
    
    TabBtnCorner.CornerRadius = UDim.new(0, 4)
    TabBtnCorner.Parent = TabBtn
    
    -- Frame de conteúdo interno da Aba
    local TabPage = Instance.new("ScrollingFrame")
    local PageLayout = Instance.new("UIListLayout")
    
    TabPage.Name = nomeAba .. "Page"
    TabPage.Parent = Container
    TabPage.BackgroundTransparency = 1
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.Visible = false
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPage.ScrollBarThickness = 2
    
    PageLayout.Parent = TabPage
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 6)
    
    -- Alternar visibilidade
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do
            if v:IsA("ScrollingFrame") then v.Visible = false end
        end
        for _, v in pairs(Sidebar:GetChildren()) do
            if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(180, 180, 180) end
        end
        TabPage.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    if currentTab == nil then
        TabPage.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentTab = nomeAba
    end

    -- Retorna funções para você colocar elementos dentro desta aba específica
    local Elementos = {}
    
    function Elementos:AdicionarBotao(texto, callback)
        local Btn = Instance.new("TextButton")
        local BtnCorner = Instance.new("UICorner")
        
        Btn.Size = UDim2.new(1, -5, 0, 35)
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Btn.Font = Enum.Font.Gotham
        Btn.Text = texto
        Btn.TextColor3 = Color3.fromRGB(235, 235, 235)
        Btn.TextSize = 13
        Btn.Parent = TabPage
        
        BtnCorner.CornerRadius = UDim.new(0, 4)
        BtnCorner.Parent = Btn
        
        Btn.MouseButton1Click:Connect(callback)
    end
    
    return Elementos
end

-- ==========================================
-- SISTEMA DE ARRASTAR A JANELA (DRAG)
-- ==========================================
local UIS = game:GetService("UserInputService")
local dragToggle, dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragToggle then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

