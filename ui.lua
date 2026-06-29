-- [[ SILENT LIB - UI LIBRARY ]] --
local SilentLib = {}
SilentLib.__index = SilentLib

-- Serviços do Roblox
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService") -- Corrigido: adicionado o serviço aqui

-- Função para criar elementos facilmente
local function createElement(className, properties)
    local element = Instance.new(className)
    for prop, val in pairs(properties) do
        element[prop] = val
    end
    return element
end

-- Criar a Janela Principal (Main Window)
function SilentLib.CreateWindow(hubName)
    local self = setmetatable({}, SilentLib)
    
    -- ScreenGui Principal (Protegida contra detecção simples)
    self.ScreenGui = createElement("ScreenGui", {
        Name = "SilentLib_" .. HttpService:GenerateGUID(false):sub(1, 8),
        Parent = CoreGui,
        ResetOnSpawn = false
    })
    
    -- Main Frame (Design Cyberpunk/Dark)
    self.MainFrame = createElement("Frame", {
        Name = "MainFrame",
        Parent = self.ScreenGui,
        Position = UDim2.new(0.35, 0, 0.3, 0),
        Size = UDim2.new(0, 500, 0, 350),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15), -- Fundo bem escuro
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    })
    
    -- Borda superior (Accent Neon)
    local TopBorder = createElement("Frame", {
        Parent = self.MainFrame,
        Size = UDim2.new(1, 0, 0, 3),
        BackgroundColor3 = Color3.fromRGB(0, 255, 136), -- Verde Neon
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
    
    -- Container das Abas (Sidebar)
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
    
    -- Container do Conteúdo
    self.ContentContainer = createElement("Frame", {
        Parent = self.MainFrame,
        Position = UDim2.new(0, 140, 0, 45),
        Size = UDim2.new(1, -150, 1, -55),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0
    })
    
    createElement("UICorner", { Parent = self.ContentContainer, CornerRadius = UDim.new(0, 6) })
    
    local ContentLayout = createElement("UIListLayout", {
        Parent = self.ContentContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })
    createElement("UIPadding", {
        Parent = self.ContentContainer,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })
    
    createElement("UICorner", { Parent = self.MainFrame, CornerRadius = UDim.new(0, 8) })
    
    return self
end

-- Criar Botão (Button Element)
function SilentLib:CreateButton(text, callback)
    local callback = callback or function() end
    
    local Button = createElement("TextButton", {
        Parent = self.ContentContainer,
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
    
    -- Efeitos Animados
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

return SilentLib
