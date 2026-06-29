-- [[ SILENT LIB - UI LIBRARY ]] --
local SilentLib = {}
SilentLib.__index = SilentLib

-- Serviços do Roblox
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Função auxiliar para criar elementos
local function createElement(className, properties)
    local element = Instance.new(className)
    for prop, val in pairs(properties) do
        element[prop] = val
    end
    return element
end

-- Criar a Janela Principal
function SilentLib.CreateWindow(hubName)
    local self = setmetatable({}, SilentLib)
    self.TabsList = {} -- Lista para gerenciar as abas
    
    -- ScreenGui Principal
    self.ScreenGui = createElement("ScreenGui", {
        Name = "SilentLib_" .. HttpService:GenerateGUID(false):sub(1, 8),
        Parent = CoreGui,
        ResetOnSpawn = false
    })
    
    -- Main Frame
    self.MainFrame = createElement("Frame", {
        Name = "MainFrame",
        Parent = self.ScreenGui,
        Position = UDim2.new(0.35, 0, 0.3, 0),
        Size = UDim2.new(0, 500, 0, 350),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    })
    createElement("UICorner", { Parent = self.MainFrame, CornerRadius = UDim.new(0, 8) })
    
    -- Borda Neon Verde
    local TopBorder = createElement("Frame", {
        Parent = self.MainFrame,
        Size = UDim2.new(1, 0, 0, 3),
        BackgroundColor3 = Color3.fromRGB(0, 255, 136),
        BorderSizePixel = 0
    })
    
    -- Título do Hub
    local Title = createElement("TextLabel", {
        Parent = self.MainFrame,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(0, 200, 0, 25),
        BackgroundTransparency = 1,
        Text = hubName or "SILENT HUB",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 16
    })
    
    -- Container das Abas (Sidebar Esquerda)
    self.TabContainer = createElement("Frame", {
        Parent = self.MainFrame,
        Position = UDim2.new(0, 10, 0, 45),
        Size = UDim2.new(0, 120, 1, -55),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0
    })
    createElement("UICorner", { Parent = self.TabContainer, CornerRadius = UDim.new(0, 6) })
    
    local TabLayout = createElement("UIListLayout", {
        Parent = self.TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    createElement("UIPadding", {
        Parent = self.TabContainer,
        PaddingTop = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5)
    })
    
    -- Container de Conteúdo Principal (Direita)
    self.PagesContainer = createElement("Frame", {
        Parent = self.MainFrame,
        Position = UDim2.new(0, 140, 0, 45),
        Size = UDim2.new(1, -150, 1, -55),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    
    return self
end

-- Criar Nova Aba
function SilentLib:CreateTab(tabName)
    local tabDef = {}
    local window = self -- Mantém a referência da janela principal
    
    -- Botão na Sidebar
    local TabButton = createElement("TextButton", {
        Parent = window.TabContainer,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Text = tabName or "Aba",
        TextColor3 = Color3.fromRGB(150, 150, 150),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        BorderSizePixel = 0,
        AutoButtonColor = false
    })
    createElement("UICorner", { Parent = TabButton, CornerRadius = UDim.new(0, 4) })
    
    -- Frame da Página
    local Page = createElement("Frame", {
        Parent = window.PagesContainer,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        Visible = false
    })
    createElement("UICorner", { Parent = Page, CornerRadius = UDim.new(0, 6) })
    
    local ContentLayout = createElement("UIListLayout", {
        Parent = Page,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })
    createElement("UIPadding", {
        Parent = Page,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })
    
    -- Função para alternar abas
    local function selectTab()
        for _, t in pairs(window.TabsList) do
            t.Page.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                TextColor3 = Color3.fromRGB(150, 150, 150)
            }):Play()
        end
        
        Page.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            TextColor3 = Color3.fromRGB(0, 255, 136)
        }):Play()
    end
    
    TabButton.MouseButton1Click:Connect(selectTab)
    
    tabDef.Button = TabButton
    tabDef.Page = Page
    table.insert(window.TabsList, tabDef)
    
    -- Abre automaticamente se for a primeira aba
    if #window.TabsList == 1 then
        selectTab()
    end
    
    -- Criar Botão dentro desta Aba
    function tabDef:CreateButton(text, callback)
        local callback = callback or function() end
        
        local Button = createElement("TextButton", {
            Parent = Page,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Text = text,
            TextColor3 = Color3.fromRGB(230, 230, 230),
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            BorderSizePixel = 0,
            AutoButtonColor = false
        })
        createElement("UICorner", { Parent = Button, CornerRadius = UDim.new(0, 6) })
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        end)
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            local originalColor = Button.BackgroundColor3
            Button.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
            task.wait(0.05)
            Button.BackgroundColor3 = originalColor
            pcall(callback)
        end)
    end
    
    return tabDef
end

return SilentLib
