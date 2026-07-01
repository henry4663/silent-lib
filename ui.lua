-- SILENT LIB V3 CLIENT SCRIPT - COPIA E COLA NO LOCALSCRIPT
-- ============================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIGURAÇÃO GLOBAL
local CONFIG = {
    KEY = "SILENT_KEY_123456",
    KEY_ENABLED = true,
    
    PRIMARY = Color3.fromRGB(0, 255, 136),
    SECONDARY = Color3.fromRGB(30, 255, 150),
    BG = Color3.fromRGB(15, 15, 15),
    BG2 = Color3.fromRGB(20, 20, 20),
    BG3 = Color3.fromRGB(30, 30, 30),
    TEXT = Color3.fromRGB(255, 255, 255),
    TEXT2 = Color3.fromRGB(150, 150, 150),
    RED = Color3.fromRGB(255, 100, 100),
    GREEN = Color3.fromRGB(100, 255, 100),
    
    WIDTH = 800,
    HEIGHT = 550,
    TAB_WIDTH = 160,
}

local UI = {}

-- FUNÇÕES BÁSICAS
local function NewElement(class, props)
    local elem = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            pcall(function() elem[k] = v end)
        end
    end
    return elem
end

local function Animate(elem, props, speed)
    speed = speed or 0.2
    local tween = TweenService:Create(elem, TweenInfo.new(speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function NewButton(parent, text, color, callback)
    local btn = NewElement("TextButton", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = color or CONFIG.BG3,
        Text = text,
        TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        BorderSizePixel = 0,
        AutoButtonColor = false
    })
    NewElement("UICorner", {Parent = btn, CornerRadius = UDim.new(0, 6)})
    
    btn.MouseEnter:Connect(function()
        Animate(btn, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
    end)
    
    btn.MouseLeave:Connect(function()
        Animate(btn, {BackgroundColor3 = color or CONFIG.BG3})
    end)
    
    btn.MouseButton1Click:Connect(function()
        Animate(btn, {BackgroundColor3 = CONFIG.PRIMARY}, 0.1)
        if callback then pcall(callback) end
        task.wait(0.1)
        Animate(btn, {BackgroundColor3 = color or CONFIG.BG3}, 0.1)
    end)
    
    return btn
end

-- KEY SYSTEM
local KeySystem = {}
KeySystem.Verified = false
KeySystem.Attempts = 0

function KeySystem:ShowWindow()
    local gui = NewElement("ScreenGui", {Name = "KeyGui", Parent = CoreGui, ResetOnSpawn = false, DisplayOrder = 999})
    
    local backdrop = NewElement("Frame", {
        Parent = gui, Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.5, BorderSizePixel = 0
    })
    
    local frame = NewElement("Frame", {
        Parent = backdrop, Position = UDim2.new(0.5, -180, 0.5, -140),
        Size = UDim2.new(0, 360, 0, 280), BackgroundColor3 = CONFIG.BG, BorderSizePixel = 0
    })
    NewElement("UICorner", {Parent = frame, CornerRadius = UDim.new(0, 12)})
    NewElement("UIStroke", {Parent = frame, Color = CONFIG.PRIMARY, Thickness = 2})
    
    NewElement("TextLabel", {
        Parent = frame, Position = UDim2.new(0, 0, 0, 15), Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1, Text = "🔐 SILENT KEY SYSTEM", TextColor3 = CONFIG.PRIMARY,
        Font = Enum.Font.GothamBold, TextSize = 18
    })
    
    NewElement("TextLabel", {
        Parent = frame, Position = UDim2.new(0, 0, 0, 50), Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1, Text = "Digite sua chave", TextColor3 = CONFIG.TEXT2, Font = Enum.Font.GothamMedium, TextSize = 12
    })
    
    local input = NewElement("TextBox", {
        Parent = frame, Position = UDim2.new(0, 20, 0, 80), Size = UDim2.new(1, -40, 0, 45),
        BackgroundColor3 = CONFIG.BG2, TextColor3 = CONFIG.TEXT, PlaceholderText = "Insira a chave...",
        Font = Enum.Font.GothamMedium, TextSize = 14, BorderSizePixel = 0
    })
    NewElement("UICorner", {Parent = input, CornerRadius = UDim.new(0, 8)})
    NewElement("UIPadding", {Parent = input, PaddingLeft = UDim.new(0, 15)})
    
    local btnEnviar = NewButton(frame, "ENVIAR", CONFIG.PRIMARY, nil)
    btnEnviar.Size = UDim2.new(0.45, 0, 0, 40)
    btnEnviar.Position = UDim2.new(0, 20, 0, 140)
    btnEnviar.TextColor3 = CONFIG.BG
    
    local btnCopiar = NewButton(frame, "COPIAR", CONFIG.SECONDARY, nil)
    btnCopiar.Size = UDim2.new(0.45, 0, 0, 40)
    btnCopiar.Position = UDim2.new(1, -160, 0, 140)
    btnCopiar.TextColor3 = CONFIG.BG
    
    local info = NewElement("TextLabel", {
        Parent = frame, Position = UDim2.new(0, 20, 0, 190), Size = UDim2.new(1, -40, 0, 50),
        BackgroundColor3 = CONFIG.BG2, TextColor3 = CONFIG.TEXT2, Text = "Chave: " .. CONFIG.KEY,
        Font = Enum.Font.GothamMedium, TextSize = 11, TextWrapped = true, BorderSizePixel = 0
    })
    NewElement("UICorner", {Parent = info, CornerRadius = UDim.new(0, 6)})
    
    local status = NewElement("TextLabel", {
        Parent = frame, Position = UDim2.new(0, 20, 1, -50), Size = UDim2.new(1, -40, 0, 40),
        BackgroundTransparency = 1, Text = "Insira uma chave válida", TextColor3 = CONFIG.TEXT2,
        Font = Enum.Font.GothamMedium, TextSize = 12, TextWrapped = true
    })
    
    btnCopiar.MouseButton1Click:Connect(function()
        setclipboard(CONFIG.KEY)
        status.Text = "✅ Chave copiada!"
        status.TextColor3 = CONFIG.GREEN
        task.wait(2)
        status.Text = "Insira uma chave válida"
        status.TextColor3 = CONFIG.TEXT2
    end)
    
    btnEnviar.MouseButton1Click:Connect(function()
        if input.Text == CONFIG.KEY then
            status.Text = "✅ Acesso concedido!"
            status.TextColor3 = CONFIG.GREEN
            task.wait(1)
            gui:Destroy()
            self.Verified = true
        else
            self.Attempts = self.Attempts + 1
            if self.Attempts >= 5 then
                status.Text = "❌ Tentativas excedidas!"
                status.TextColor3 = CONFIG.RED
                task.wait(2)
                gui:Destroy()
                return
            end
            status.Text = "❌ Inválida! (" .. self.Attempts .. "/5)"
            status.TextColor3 = CONFIG.RED
            input.Text = ""
        end
    end)
    
    input.FocusLost:Connect(function(enter)
        if enter then btnEnviar:TriggerEvent("MouseButton1Click") end
    end)
    
    while not self.Verified and self.Attempts < 5 do
        task.wait(0.1)
    end
    
    return self.Verified
end

-- COMPONENTES
local Toggle = {}
function Toggle:Create(parent, name, default, callback)
    local container = NewElement("Frame", {
        Parent = parent, Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = CONFIG.BG3, BorderSizePixel = 0
    })
    NewElement("UICorner", {Parent = container, CornerRadius = UDim.new(0, 6)})
    
    NewElement("TextLabel", {
        Parent = container, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(1, -70, 1, 0),
        BackgroundTransparency = 1, Text = name, TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })
    
    local bg = NewElement("Frame", {
        Parent = container, Position = UDim2.new(1, -55, 0.5, -12), Size = UDim2.new(0, 50, 0, 24),
        BackgroundColor3 = default and CONFIG.PRIMARY or Color3.fromRGB(60, 60, 60), BorderSizePixel = 0
    })
    NewElement("UICorner", {Parent = bg, CornerRadius = UDim.new(0, 12)})
    
    local circle = NewElement("Frame", {
        Parent = bg, Position = default and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2),
        Size = UDim2.new(0, 20, 0, 20), BackgroundColor3 = CONFIG.TEXT, BorderSizePixel = 0
    })
    NewElement("UICorner", {Parent = circle, CornerRadius = UDim.new(0, 10)})
    
    local click = NewElement("TextButton", {
        Parent = container, Position = UDim2.new(1, -60, 0, 0), Size = UDim2.new(0, 60, 1, 0),
        BackgroundTransparency = 1, Text = "", BorderSizePixel = 0, AutoButtonColor = false
    })
    
    local state = default
    click.MouseButton1Click:Connect(function()
        state = not state
        Animate(bg, {BackgroundColor3 = state and CONFIG.PRIMARY or Color3.fromRGB(60, 60, 60)})
        Animate(circle, {Position = state and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)})
        if callback then pcall(callback, state) end
    end)
    
    return {Container = container, GetState = function() return state end}
end

local Slider = {}
function Slider:Create(parent, name, min, max, default, callback)
    default = math.clamp(default, min, max)
    
    local container = NewElement("Frame", {Parent = parent, Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 1, BorderSizePixel = 0})
    
    local label = NewElement("TextLabel", {
        Parent = container, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1, Text = name .. ": " .. math.round(default), TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local bg = NewElement("Frame", {
        Parent = container, Position = UDim2.new(0, 0, 0, 30), Size = UDim2.new(1, 0, 0, 12),
        BackgroundColor3 = CONFIG.BG2, BorderSizePixel = 0
    })
    NewElement("UICorner", {Parent = bg, CornerRadius = UDim.new(0, 6)})
    
    local percent = (default - min) / (max - min)
    local fill = NewElement("Frame", {
        Parent = bg, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(percent, 0, 1, 0),
        BackgroundColor3 = CONFIG.PRIMARY, BorderSizePixel = 0
    })
    NewElement("UICorner", {Parent = fill, CornerRadius = UDim.new(0, 6)})
    
    local btn = NewElement("TextButton", {
        Parent = bg, Position = UDim2.new(percent, -8, 0.5, -8), Size = UDim2.new(0, 16, 0, 16),
        BackgroundColor3 = CONFIG.PRIMARY, Text = "", BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 10
    })
    NewElement("UICorner", {Parent = btn, CornerRadius = UDim.new(0, 8)})
    
    local dragging = false
    local value = default
    
    btn.MouseButton1Down:Connect(function() dragging = true end)
    
    UserInputService.InputChanged:Connect(function(input, processed)
        if dragging and not processed then
            local x = math.clamp(input.Position.X - bg.AbsolutePosition.X, 0, bg.AbsoluteSize.X)
            local p = x / bg.AbsoluteSize.X
            value = math.round(min + (max - min) * p)
            label.Text = name .. ": " .. value
            fill.Size = UDim2.new(p, 0, 1, 0)
            btn.Position = UDim2.new(p, -8, 0.5, -8)
            if callback then pcall(callback, value) end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return {Container = container, GetValue = function() return value end}
end

local PlayerList = {}
function PlayerList:Create(parent, callback)
    local container = NewElement("Frame", {
        Parent = parent, Size = UDim2.new(1, 0, 0, 250),
        BackgroundColor3 = CONFIG.BG2, BorderSizePixel = 0
    })
    NewElement("UICorner", {Parent = container, CornerRadius = UDim.new(0, 6)})
    
    NewElement("TextLabel", {
        Parent = container, Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 20),
        BackgroundTransparency = 1, Text = "👥 Jogadores Online", TextColor3 = CONFIG.PRIMARY,
        Font = Enum.Font.GothamBold, TextSize = 12
    })
    
    local scroll = NewElement("ScrollingFrame", {
        Parent = container, Position = UDim2.new(0, 5, 0, 30), Size = UDim2.new(1, -10, 1, -35),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 6, CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    local layout = NewElement("UIListLayout", {Parent = scroll, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    
    local function update()
        for _, child in pairs(scroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        for _, p in pairs(Players:GetPlayers()) do
            local btn = NewButton(scroll, "👤 " .. p.Name .. " (ID: " .. p.UserId .. ")", CONFIG.BG3, function()
                if callback then pcall(callback, p) end
            end)
        end
        
        task.wait(0.1)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
        end)
    end
    
    Players.PlayerAdded:Connect(update)
    Players.PlayerRemoving:Connect(update)
    update()
    
    return container
end

-- JANELA PRINCIPAL
function UI:CreateWindow(title)
    local self = setmetatable({}, {__index = UI})
    self.Tabs = {}
    
    local gui = NewElement("ScreenGui", {Name = "Hub", Parent = CoreGui, ResetOnSpawn = false, DisplayOrder = 100})
    
    local frame = NewElement("Frame", {
        Parent = gui, Position = UDim2.new(0.3, 0, 0.2, 0),
        Size = UDim2.new(0, CONFIG.WIDTH, 0, CONFIG.HEIGHT),
        BackgroundColor3 = CONFIG.BG, BorderSizePixel = 0, Active = true, Draggable = true
    })
    NewElement("UICorner", {Parent = frame, CornerRadius = UDim.new(0, 10)})
    
    NewElement("Frame", {Parent = frame, Size = UDim2.new(1, 0, 0, 4), BackgroundColor3 = CONFIG.PRIMARY, BorderSizePixel = 0})
    
    local header = NewElement("Frame", {
        Parent = frame, Position = UDim2.new(0, 0, 0, 4), Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = CONFIG.BG2, BorderSizePixel = 0
    })
    
    NewElement("TextLabel", {
        Parent = header, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1, Text = "⚡ " .. (title or "SILENT HUB"), TextColor3 = CONFIG.PRIMARY,
        Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center
    })
    
    local close = NewButton(header, "✕", CONFIG.RED, function()
        Animate(frame, {Transparency = 1})
        task.wait(0.2)
        gui:Destroy()
    end)
    close.Size = UDim2.new(0, 40, 1, 0)
    close.Position = UDim2.new(1, -45, 0, 0)
    
    self.TabContainer = NewElement("Frame", {
        Parent = frame, Position = UDim2.new(0, 10, 0, 55), Size = UDim2.new(0, CONFIG.TAB_WIDTH, 1, -65),
        BackgroundColor3 = CONFIG.BG2, BorderSizePixel = 0
    })
    NewElement("UICorner", {Parent = self.TabContainer, CornerRadius = UDim.new(0, 8)})
    
    local tabLayout = NewElement("UIListLayout", {Parent = self.TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    NewElement("UIPadding", {Parent = self.TabContainer, PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})
    
    self.ContentContainer = NewElement("Frame", {
        Parent = frame, Position = UDim2.new(0, CONFIG.TAB_WIDTH + 20, 0, 55),
        Size = UDim2.new(1, -(CONFIG.TAB_WIDTH + 30), 1, -65), BackgroundTransparency = 1, BorderSizePixel = 0
    })
    
    self.Gui = gui
    self.Frame = frame
    
    return self
end

function UI:CreateTab(name)
    local tab = {}
    
    local btn = NewButton(self.TabContainer, name, CONFIG.BG3, nil)
    btn.TextScaled = true
    
    local page = NewElement("Frame", {
        Parent = self.ContentContainer, Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = CONFIG.BG2, BorderSizePixel = 0, Visible = false
    })
    NewElement("UICorner", {Parent = page, CornerRadius = UDim.new(0, 8)})
    
    local scroll = NewElement("ScrollingFrame", {
        Parent = page, Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 6, CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    local layout = NewElement("UIListLayout", {Parent = scroll, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
    NewElement("UIPadding", {Parent = scroll, PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)})
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    local function selectTab()
        for _, t in pairs(self.Tabs) do
            t.Page.Visible = false
            Animate(t.Button, {BackgroundColor3 = CONFIG.BG3, TextColor3 = CONFIG.TEXT2})
        end
        page.Visible = true
        Animate(btn, {BackgroundColor3 = CONFIG.PRIMARY, TextColor3 = CONFIG.BG})
    end
    
    btn.MouseButton1Click:Connect(selectTab)
    
    tab.Button = btn
    tab.Page = page
    tab.Scroll = scroll
    
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then selectTab() end
    
    function tab:CreateButton(text, callback)
        return NewButton(scroll, text, CONFIG.BG3, callback)
    end
    
    function tab:CreateToggle(name, default, callback)
        return Toggle:Create(scroll, name, default or false, callback)
    end
    
    function tab:CreateSlider(name, min, max, default, callback)
        return Slider:Create(scroll, name, min, max, default or min, callback)
    end
    
    function tab:CreatePlayerList(callback)
        return PlayerList:Create(scroll, callback)
    end
    
    function tab:CreateLabel(text)
        local lbl = NewElement("TextLabel", {
            Parent = scroll, Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1, Text = text, TextColor3 = CONFIG.TEXT,
            Font = Enum.Font.GothamMedium, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left
        })
        return lbl
    end
    
    function tab:AddSpacing(height)
        NewElement("Frame", {Parent = scroll, Size = UDim2.new(1, 0, 0, height or 10), BackgroundTransparency = 1, BorderSizePixel = 0})
    end
    
    return tab
end

function UI:Notify(title, msg, duration)
    duration = duration or 3
    local notif = NewElement("Frame", {
        Name = "Notif", Parent = CoreGui, Position = UDim2.new(1, -320, 1, -80),
        Size = UDim2.new(0, 300, 0, 70), BackgroundColor3 = CONFIG.BG2, BorderSizePixel = 0
    })
    NewElement("UICorner", {Parent = notif, CornerRadius = UDim.new(0, 8)})
    NewElement("UIStroke", {Parent = notif, Color = CONFIG.PRIMARY, Thickness = 2})
    
    NewElement("TextLabel", {
        Parent = notif, Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 25),
        BackgroundTransparency = 1, Text = "📢 " .. title, TextColor3 = CONFIG.PRIMARY,
        Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
    })
    
    NewElement("TextLabel", {
        Parent = notif, Position = UDim2.new(0, 10, 0, 30), Size = UDim2.new(1, -20, 1, -35),
        BackgroundTransparency = 1, Text = msg, TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.GothamMedium, TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left
    })
    
    task.wait(duration)
    Animate(notif, {Transparency = 1})
    task.wait(0.2)
    notif:Destroy()
end

-- INICIAR
task.wait(1)

print("🟢 SILENT HUB INICIANDO...")

if CONFIG.KEY_ENABLED then
    if not KeySystem:ShowWindow() then
        print("❌ ACESSO NEGADO")
        return
    end
end

print("✅ ACESSO CONCEDIDO")

local window = UI:CreateWindow("SILENT HUB V3.0")

-- ABA HOME
local home = window:CreateTab("🏠 Home")
home:CreateLabel("Bem-vindo ao SILENT HUB!")
home:CreateLabel("Script pronto para usar")
home:AddSpacing()
home:CreateButton("📋 Ver Jogadores", function()
    local count = #Players:GetPlayers()
    print("Total de jogadores: " .. count)
    UI:Notify("Jogadores", "Total: " .. count .. " online")
end)

-- ABA CONTROLES
local ctrl = window:CreateTab("⚙️ Controles")
ctrl:CreateLabel("Controles e Configurações")
ctrl:AddSpacing()

local toggle1 = ctrl:CreateToggle("Ativar Função", false, function(state)
    print("Função:", state)
    UI:Notify("Toggle", state and "✅ Ativado" or "❌ Desativado")
end)

ctrl:AddSpacing()

local slider1 = ctrl:CreateSlider("Velocidade", 1, 100, 50, function(value)
    print("Velocidade:", value)
end)

-- ABA JOGADORES
local players_tab = window:CreateTab("👥 Jogadores")
players_tab:CreateLabel("Clique em um jogador:")
players_tab:AddSpacing()
players_tab:CreatePlayerList(function(p)
    print("Selecionado: " .. p.Name)
    UI:Notify("Seleção", "Você escolheu: " .. p.Name)
end)

-- ABA INFO
local info = window:CreateTab("ℹ️ Info")
info:CreateLabel("📊 Informações")
info:AddSpacing()
info:CreateLabel("Versão: 3.0")
info:CreateLabel("Jogadores: " .. #Players:GetPlayers())
info:CreateLabel("Key System: " .. (CONFIG.KEY_ENABLED and "Ativo" or "Inativo"))

print("✅ INTERFACE CRIADA COM SUCESSO!")
