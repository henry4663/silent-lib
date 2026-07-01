-- ╔════════════════════════════════════════════════════════════════╗
-- ║          SILENT LIB V3 - ADVANCED UI LIBRARY                   ║
-- ║  Sistema Completo com Key System, Sliders, Toggles & Players   ║
-- ║                   +1200 LINHAS DE CÓDIGO                       ║
-- ╚════════════════════════════════════════════════════════════════╝

local SilentLib = {}
SilentLib.__index = SilentLib
SilentLib.Version = "3.0"

-- ═══════════════════════════════════════════════════════════════
-- SERVIÇOS E CONFIGURAÇÕES GLOBAIS
-- ═══════════════════════════════════════════════════════════════

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

-- Tabela global de configurações
local GLOBAL_CONFIG = {
    -- KEY SYSTEM
    SCRIPT_KEY = "SILENT_KEY_123456",
    KEY_ENABLED = true,
    KEY_COPY_MODE = false, -- Se true, não precisa copiar a chave manualmente
    
    -- CORES
    PRIMARY_COLOR = Color3.fromRGB(0, 255, 136),      -- Verde Neon
    SECONDARY_COLOR = Color3.fromRGB(30, 255, 150),   -- Verde claro
    BACKGROUND_COLOR = Color3.fromRGB(15, 15, 15),    -- Preto escuro
    SECONDARY_BG = Color3.fromRGB(20, 20, 20),        -- Preto cinza
    TERTIARY_BG = Color3.fromRGB(30, 30, 30),         -- Cinza escuro
    TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),     -- Branco
    TEXT_SECONDARY = Color3.fromRGB(150, 150, 150),   -- Cinza claro
    ACCENT_COLOR = Color3.fromRGB(255, 100, 100),     -- Vermelho
    SUCCESS_COLOR = Color3.fromRGB(100, 255, 100),    -- Verde
    WARNING_COLOR = Color3.fromRGB(255, 200, 50),     -- Amarelo
    ERROR_COLOR = Color3.fromRGB(255, 80, 80),        -- Vermelho erro
    
    -- DIMENSÕES
    WINDOW_WIDTH = 800,
    WINDOW_HEIGHT = 550,
    TAB_WIDTH = 160,
    
    -- ANIMAÇÕES
    TWEEN_SPEED = 0.2,
    TWEEN_SPEED_FAST = 0.1,
    TWEEN_SPEED_SLOW = 0.5,
}

-- ═══════════════════════════════════════════════════════════════
-- FUNÇÕES AUXILIARES
-- ═══════════════════════════════════════════════════════════════

--- Cria um elemento Roblox com propriedades
-- @param className string Nome da classe (Frame, TextLabel, etc)
-- @param properties table Propriedades do elemento
-- @return Instance Elemento criado
local function createElement(className, properties)
    local element = Instance.new(className)
    
    if properties then
        for property, value in pairs(properties) do
            pcall(function()
                element[property] = value
            end)
        end
    end
    
    return element
end

--- Cria um TextButton estilizado
-- @param parent Instance Pai do botão
-- @param props table Propriedades customizadas
-- @return TextButton Botão criado
local function createStyledButton(parent, props)
    props = props or {}
    
    local button = createElement("TextButton", {
        Parent = parent,
        Size = props.Size or UDim2.new(1, 0, 0, 35),
        Position = props.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = props.BackgroundColor or GLOBAL_CONFIG.TERTIARY_BG,
        Text = props.Text or "Botão",
        TextColor3 = props.TextColor or GLOBAL_CONFIG.TEXT_PRIMARY,
        Font = Enum.Font.GothamMedium,
        TextSize = props.TextSize or 13,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ClipsDescendants = true
    })
    
    createElement("UICorner", {
        Parent = button,
        CornerRadius = UDim.new(0, 6)
    })
    
    if props.Padding then
        createElement("UIPadding", {
            Parent = button,
            PaddingLeft = UDim.new(0, props.Padding),
            PaddingRight = UDim.new(0, props.Padding)
        })
    end
    
    return button
end

--- Anima um elemento com tween
-- @param element Instance Elemento a animar
-- @param properties table Propriedades finais
-- @param speed number Velocidade da animação (opcional)
local function animateElement(element, properties, speed)
    speed = speed or GLOBAL_CONFIG.TWEEN_SPEED
    
    local tween = TweenService:Create(
        element,
        TweenInfo.new(speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    
    return tween
end

--- Obtém tabela de informações do sistema
-- @return table Informações do sistema
local function getSystemInfo()
    return {
        Players = #Players:GetPlayers(),
        MemoryUsage = math.round(Stats:FindFirstChild("MemoryUsageBytes"):GetValue() / 1024 / 1024),
        CurrentVersion = SilentLib.Version
    }
end

--- Formata um número para exibição
-- @param num number Número a formatar
-- @return string Número formatado
local function formatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(num)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE AUTENTICAÇÃO (KEY SYSTEM)
-- ═══════════════════════════════════════════════════════════════

local KeySystem = {}
KeySystem.IsVerified = false
KeySystem.AttemptCount = 0
KeySystem.MaxAttempts = 5

--- Cria a interface de autenticação
-- @return table Interface da janela de chave
function KeySystem.CreateKeyWindow()
    -- Container principal
    local screenGui = createElement("ScreenGui", {
        Name = "SilentKeySystem",
        Parent = CoreGui,
        ResetOnSpawn = false,
        DisplayOrder = 999
    })
    
    -- Fundo semi-transparente
    local backdrop = createElement("Frame", {
        Parent = screenGui,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    })
    
    -- Frame principal
    local mainFrame = createElement("Frame", {
        Name = "KeyFrame",
        Parent = backdrop,
        Position = UDim2.new(0.5, -180, 0.5, -140),
        Size = UDim2.new(0, 360, 0, 280),
        BackgroundColor3 = GLOBAL_CONFIG.BACKGROUND_COLOR,
        BorderSizePixel = 0
    })
    
    createElement("UICorner", {
        Parent = mainFrame,
        CornerRadius = UDim.new(0, 12)
    })
    
    -- Efeito de borda
    createElement("UIStroke", {
        Parent = mainFrame,
        Color = GLOBAL_CONFIG.PRIMARY_COLOR,
        Thickness = 2
    })
    
    -- Título
    createElement("TextLabel", {
        Parent = mainFrame,
        Position = UDim2.new(0, 0, 0, 15),
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        Text = "🔐 SILENT KEY SYSTEM",
        TextColor3 = GLOBAL_CONFIG.PRIMARY_COLOR,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextScaled = true
    })
    
    -- Subtítulo
    createElement("TextLabel", {
        Parent = mainFrame,
        Position = UDim2.new(0, 0, 0, 50),
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "Digite sua chave de acesso",
        TextColor3 = GLOBAL_CONFIG.TEXT_SECONDARY,
        Font = Enum.Font.GothamMedium,
        TextSize = 12
    })
    
    -- Input Box
    local inputBox = createElement("TextBox", {
        Parent = mainFrame,
        Position = UDim2.new(0, 20, 0, 80),
        Size = UDim2.new(1, -40, 0, 45),
        BackgroundColor3 = GLOBAL_CONFIG.SECONDARY_BG,
        TextColor3 = GLOBAL_CONFIG.TEXT_PRIMARY,
        PlaceholderText = "Insira a chave aqui...",
        PlaceholderColor3 = GLOBAL_CONFIG.TEXT_SECONDARY,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        BorderSizePixel = 0,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ClipsDescendants = true
    })
    
    createElement("UICorner", {
        Parent = inputBox,
        CornerRadius = UDim.new(0, 8)
    })
    
    createElement("UIPadding", {
        Parent = inputBox,
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15)
    })
    
    createElement("UIStroke", {
        Parent = inputBox,
        Color = GLOBAL_CONFIG.PRIMARY_COLOR,
        Thickness = 1,
        Transparency = 0.5
    })
    
    -- Botão Enviar
    local submitBtn = createStyledButton(mainFrame, {
        Size = UDim2.new(0.45, 0, 0, 40),
        Position = UDim2.new(0, 20, 0, 140),
        BackgroundColor = GLOBAL_CONFIG.PRIMARY_COLOR,
        Text = "ENVIAR",
        TextColor = GLOBAL_CONFIG.BACKGROUND_COLOR,
        TextSize = 14
    })
    
    -- Botão Copiar
    local copyBtn = createStyledButton(mainFrame, {
        Size = UDim2.new(0.45, 0, 0, 40),
        Position = UDim2.new(1, -160, 0, 140),
        BackgroundColor = GLOBAL_CONFIG.SECONDARY_COLOR,
        Text = "COPIAR CHAVE",
        TextColor = GLOBAL_CONFIG.BACKGROUND_COLOR,
        TextSize = 12
    })
    
    -- Label de informações
    local infoLabel = createElement("TextLabel", {
        Parent = mainFrame,
        Position = UDim2.new(0, 20, 0, 190),
        Size = UDim2.new(1, -40, 0, 50),
        BackgroundColor3 = GLOBAL_CONFIG.SECONDARY_BG,
        TextColor3 = GLOBAL_CONFIG.TEXT_SECONDARY,
        Text = "Chave: " .. GLOBAL_CONFIG.SCRIPT_KEY,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextWrapped = true,
        BorderSizePixel = 0
    })
    
    createElement("UICorner", {
        Parent = infoLabel,
        CornerRadius = UDim.new(0, 6)
    })
    
    createElement("UIPadding", {
        Parent = infoLabel,
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5)
    })
    
    -- Label de status
    local statusLabel = createElement("TextLabel", {
        Parent = mainFrame,
        Position = UDim2.new(0, 20, 1, -50),
        Size = UDim2.new(1, -40, 0, 40),
        BackgroundTransparency = 1,
        Text = "Insira uma chave válida",
        TextColor3 = GLOBAL_CONFIG.TEXT_SECONDARY,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextWrapped = true
    })
    
    return {
        gui = screenGui,
        backdrop = backdrop,
        mainFrame = mainFrame,
        inputBox = inputBox,
        submitBtn = submitBtn,
        copyBtn = copyBtn,
        statusLabel = statusLabel
    }
end

--- Verifica se a chave está correta
-- @param inputKey string Chave inserida
-- @return boolean True se correta
function KeySystem.VerifyKey(inputKey)
    return inputKey == GLOBAL_CONFIG.SCRIPT_KEY
end

--- Copia a chave para a área de transferência
function KeySystem.CopyKey()
    setclipboard(GLOBAL_CONFIG.SCRIPT_KEY)
end

--- Mostra mensagem de erro
-- @param label TextLabel Label para mostrar mensagem
-- @param message string Mensagem
local function showError(label, message)
    label.Text = message
    label.TextColor3 = GLOBAL_CONFIG.ERROR_COLOR
    
    task.wait(3)
    
    label.Text = "Insira uma chave válida"
    label.TextColor3 = GLOBAL_CONFIG.TEXT_SECONDARY
end

--- Mostra mensagem de sucesso
-- @param label TextLabel Label para mostrar mensagem
-- @param message string Mensagem
local function showSuccess(label, message)
    label.Text = message
    label.TextColor3 = GLOBAL_CONFIG.SUCCESS_COLOR
end

--- Inicializa o sistema de chaves
-- @return boolean True se verificado
function KeySystem.Init()
    if not GLOBAL_CONFIG.KEY_ENABLED then
        KeySystem.IsVerified = true
        return true
    end
    
    local keyWindow = KeySystem.CreateKeyWindow()
    
    keyWindow.copyBtn.MouseButton1Click:Connect(function()
        KeySystem.CopyKey()
        showSuccess(keyWindow.statusLabel, "✅ Chave copiada!")
        task.wait(2)
        keyWindow.statusLabel.Text = "Insira uma chave válida"
        keyWindow.statusLabel.TextColor3 = GLOBAL_CONFIG.TEXT_SECONDARY
    end)
    
    keyWindow.submitBtn.MouseButton1Click:Connect(function()
        local inputKey = keyWindow.inputBox.Text
        
        if KeySystem.VerifyKey(inputKey) then
            showSuccess(keyWindow.statusLabel, "✅ Acesso concedido!")
            task.wait(1.5)
            keyWindow.gui:Destroy()
            KeySystem.IsVerified = true
        else
            KeySystem.AttemptCount = KeySystem.AttemptCount + 1
            
            if KeySystem.AttemptCount >= KeySystem.MaxAttempts then
                showError(keyWindow.statusLabel, "❌ Tentativas excedidas!")
                task.wait(3)
                keyWindow.gui:Destroy()
                return
            end
            
            showError(keyWindow.statusLabel, 
                "❌ Chave inválida! ("..KeySystem.AttemptCount.."/"..KeySystem.MaxAttempts..")")
            keyWindow.inputBox.Text = ""
        end
    end)
    
    keyWindow.inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            keyWindow.submitBtn:TriggerEvent("MouseButton1Click")
        end
    end)
    
    while not KeySystem.IsVerified and KeySystem.AttemptCount < KeySystem.MaxAttempts do
        task.wait(0.1)
    end
    
    return KeySystem.IsVerified
end

-- ═══════════════════════════════════════════════════════════════
-- COMPONENTES DE INTERFACE
-- ═══════════════════════════════════════════════════════════════

--- Componente de Toggle
local ToggleComponent = {}

function ToggleComponent:Create(parent, name, defaultState, callback)
    callback = callback or function() end
    
    local toggleContainer = createElement("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = GLOBAL_CONFIG.TERTIARY_BG,
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    
    createElement("UICorner", {
        Parent = toggleContainer,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Label
    createElement("TextLabel", {
        Parent = toggleContainer,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -70, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = GLOBAL_CONFIG.TEXT_PRIMARY,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })
    
    -- Toggle Background
    local toggleBg = createElement("Frame", {
        Parent = toggleContainer,
        Position = UDim2.new(1, -55, 0.5, -12),
        Size = UDim2.new(0, 50, 0, 24),
        BackgroundColor3 = defaultState and GLOBAL_CONFIG.PRIMARY_COLOR or Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0
    })
    
    createElement("UICorner", {
        Parent = toggleBg,
        CornerRadius = UDim.new(0, 12)
    })
    
    -- Toggle Circle
    local toggleCircle = createElement("Frame", {
        Parent = toggleBg,
        Position = defaultState and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = GLOBAL_CONFIG.TEXT_PRIMARY,
        BorderSizePixel = 0
    })
    
    createElement("UICorner", {
        Parent = toggleCircle,
        CornerRadius = UDim.new(0, 10)
    })
    
    -- Click Area
    local clickArea = createElement("TextButton", {
        Parent = toggleContainer,
        Position = UDim2.new(1, -60, 0, 0),
        Size = UDim2.new(0, 60, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false
    })
    
    local state = defaultState
    
    local function updateToggle()
        state = not state
        
        animateElement(toggleBg, {
            BackgroundColor3 = state and GLOBAL_CONFIG.PRIMARY_COLOR or Color3.fromRGB(60, 60, 60)
        })
        
        animateElement(toggleCircle, {
            Position = state and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
        })
        
        pcall(callback, state)
    end
    
    clickArea.MouseButton1Click:Connect(updateToggle)
    
    return {
        Container = toggleContainer,
        GetState = function() return state end,
        SetState = function(newState)
            if newState ~= state then
                updateToggle()
            end
        end
    }
end

--- Componente de Slider
local SliderComponent = {}

function SliderComponent:Create(parent, name, minValue, maxValue, defaultValue, callback)
    callback = callback or function() end
    defaultValue = math.clamp(defaultValue, minValue, maxValue)
    
    local sliderContainer = createElement("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    
    -- Label com valor
    local labelText = createElement("TextLabel", {
        Parent = sliderContainer,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = name .. ": " .. tostring(math.round(defaultValue)),
        TextColor3 = GLOBAL_CONFIG.TEXT_PRIMARY,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Barra de fundo
    local sliderBg = createElement("Frame", {
        Parent = sliderContainer,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 0, 12),
        BackgroundColor3 = GLOBAL_CONFIG.SECONDARY_BG,
        BorderSizePixel = 0
    })
    
    createElement("UICorner", {
        Parent = sliderBg,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Barra de preenchimento
    local percentComplete = (defaultValue - minValue) / (maxValue - minValue)
    
    local sliderFill = createElement("Frame", {
        Parent = sliderBg,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(percentComplete, 0, 1, 0),
        BackgroundColor3 = GLOBAL_CONFIG.PRIMARY_COLOR,
        BorderSizePixel = 0
    })
    
    createElement("UICorner", {
        Parent = sliderFill,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Botão do slider
    local sliderButton = createElement("TextButton", {
        Parent = sliderBg,
        Position = UDim2.new(percentComplete, -8, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        BackgroundColor3 = GLOBAL_CONFIG.PRIMARY_COLOR,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ZIndex = 10
    })
    
    createElement("UICorner", {
        Parent = sliderButton,
        CornerRadius = UDim.new(0, 8)
    })
    
    local isDragging = false
    local currentValue = defaultValue
    
    local function updateSlider(input)
        local relativeX = math.clamp(
            input.Position.X - sliderBg.AbsolutePosition.X,
            0,
            sliderBg.AbsoluteSize.X
        )
        
        local percentage = relativeX / sliderBg.AbsoluteSize.X
        currentValue = math.round(minValue + (maxValue - minValue) * percentage)
        
        labelText.Text = name .. ": " .. tostring(currentValue)
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderButton.Position = UDim2.new(percentage, -8, 0.5, -8)
        
        pcall(callback, currentValue)
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if isDragging and not gameProcessed then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    return {
        Container = sliderContainer,
        GetValue = function() return currentValue end,
        SetValue = function(newValue)
            newValue = math.clamp(newValue, minValue, maxValue)
            currentValue = newValue
            local percentage = (currentValue - minValue) / (maxValue - minValue)
            labelText.Text = name .. ": " .. tostring(currentValue)
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderButton.Position = UDim2.new(percentage, -8, 0.5, -8)
            pcall(callback, currentValue)
        end
    }
end

--- Componente de Lista de Jogadores
local PlayerListComponent = {}

function PlayerListComponent:Create(parent, selectCallback)
    selectCallback = selectCallback or function() end
    
    local listContainer = createElement("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 250),
        BackgroundColor3 = GLOBAL_CONFIG.SECONDARY_BG,
        BorderSizePixel = 0
    })
    
    createElement("UICorner", {
        Parent = listContainer,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Título
    createElement("TextLabel", {
        Parent = listContainer,
        Position = UDim2.new(0, 10, 0, 5),
        Size = UDim2.new(1, -20, 0, 20),
        BackgroundTransparency = 1,
        Text = "👥 Jogadores Online",
        TextColor3 = GLOBAL_CONFIG.PRIMARY_COLOR,
        Font = Enum.Font.GothamBold,
        TextSize = 12
    })
    
    -- ScrollingFrame
    local scrollFrame = createElement("ScrollingFrame", {
        Parent = listContainer,
        Position = UDim2.new(0, 5, 0, 30),
        Size = UDim2.new(1, -10, 1, -35),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    local listLayout = createElement("UIListLayout", {
        Parent = scrollFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    -- Função para atualizar lista
    local function updatePlayerList()
        for _, child in pairs(scrollFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local playerList = Players:GetPlayers()
        
        for _, player in pairs(playerList) do
            local playerButton = createStyledButton(scrollFrame, {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor = GLOBAL_CONFIG.TERTIARY_BG,
                Text = "👤 " .. player.Name .. " (ID: " .. player.UserId .. ")",
                TextSize = 12
            })
            
            playerButton.MouseEnter:Connect(function()
                animateElement(playerButton, {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                })
            end)
            
            playerButton.MouseLeave:Connect(function()
                animateElement(playerButton, {
                    BackgroundColor3 = GLOBAL_CONFIG.TERTIARY_BG
                })
            end)
            
            playerButton.MouseButton1Click:Connect(function()
                animateElement(playerButton, {
                    BackgroundColor3 = GLOBAL_CONFIG.PRIMARY_COLOR
                }, GLOBAL_CONFIG.TWEEN_SPEED_FAST)
                
                task.wait(GLOBAL_CONFIG.TWEEN_SPEED_FAST)
                
                animateElement(playerButton, {
                    BackgroundColor3 = GLOBAL_CONFIG.TERTIARY_BG
                }, GLOBAL_CONFIG.TWEEN_SPEED_FAST)
                
                pcall(selectCallback, player)
            end)
        end
        
        task.wait(0.1)
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
        end)
    end
    
    -- Conexões de atualização
    Players.PlayerAdded:Connect(updatePlayerList)
    Players.PlayerRemoving:Connect(updatePlayerList)
    
    updatePlayerList()
    
    return {
        Container = listContainer,
        Refresh = updatePlayerList
    }
end

--- Componente de Input TextBox
local TextInputComponent = {}

function TextInputComponent:Create(parent, placeholder, callback)
    callback = callback or function() end
    
    local inputContainer = createElement("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = GLOBAL_CONFIG.SECONDARY_BG,
        BorderSizePixel = 0
    })
    
    createElement("UICorner", {
        Parent = inputContainer,
        CornerRadius = UDim.new(0, 6)
    })
    
    local textBox = createElement("TextBox", {
        Parent = inputContainer,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = GLOBAL_CONFIG.TEXT_PRIMARY,
        PlaceholderText = placeholder or "Digite aqui...",
        PlaceholderColor3 = GLOBAL_CONFIG.TEXT_SECONDARY,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        BorderSizePixel = 0,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false
    })
    
    createElement("UIPadding", {
        Parent = textBox,
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12)
    })
    
    textBox.FocusLost:Connect(function()
        pcall(callback, textBox.Text)
    end)
    
    return {
        Container = inputContainer,
        GetText = function() return textBox.Text end,
        SetText = function(text) textBox.Text = text end,
        Clear = function() textBox.Text = "" end
    }
end

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE JANELAS PRINCIPAL
-- ═══════════════════════════════════════════════════════════════

--- Cria a janela principal
function SilentLib.CreateWindow(hubName)
    local self = setmetatable({}, SilentLib)
    self.TabsList = {}
    self.Components = {}
    self.IsOpen = true
    
    -- Screen GUI
    local screenGui = createElement("ScreenGui", {
        Name = "SilentLib_Window_" .. HttpService:GenerateGUID(false):sub(1, 8),
        Parent = CoreGui,
        ResetOnSpawn = false,
        DisplayOrder = 100
    })
    
    -- Main Frame
    local mainFrame = createElement("Frame", {
        Name = "MainWindow",
        Parent = screenGui,
        Position = UDim2.new(0.3, 0, 0.2, 0),
        Size = UDim2.new(0, GLOBAL_CONFIG.WINDOW_WIDTH, 0, GLOBAL_CONFIG.WINDOW_HEIGHT),
        BackgroundColor3 = GLOBAL_CONFIG.BACKGROUND_COLOR,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        ClipsDescendants = true
    })
    
    createElement("UICorner", {
        Parent = mainFrame,
        CornerRadius = UDim.new(0, 10)
    })
    
    -- Top Border/Line
    createElement("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 4),
        BackgroundColor3 = GLOBAL_CONFIG.PRIMARY_COLOR,
        BorderSizePixel = 0
    })
    
    -- Header
    local headerFrame = createElement("Frame", {
        Parent = mainFrame,
        Position = UDim2.new(0, 0, 0, 4),
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = GLOBAL_CONFIG.SECONDARY_BG,
        BorderSizePixel = 0
    })
    
    createElement("TextLabel", {
        Parent = headerFrame,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = "⚡ " .. (hubName or "SILENT HUB") .. " v" .. SilentLib.Version,
        TextColor3 = GLOBAL_CONFIG.PRIMARY_COLOR,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })
    
    -- Botão Fechar
    local closeBtn = createStyledButton(headerFrame, {
        Size = UDim2.new(0, 40, 1, 0),
        Position = UDim2.new(1, -45, 0, 0),
        BackgroundColor = GLOBAL_CONFIG.ACCENT_COLOR,
        Text = "✕",
        TextColor = GLOBAL_CONFIG.TEXT_PRIMARY,
        TextSize = 16
    })
    
    closeBtn.MouseButton1Click:Connect(function()
        self.IsOpen = false
        animateElement(mainFrame, {
            Transparency = 1
        }, GLOBAL_CONFIG.TWEEN_SPEED)
        
        task.wait(GLOBAL_CONFIG.TWEEN_SPEED)
        screenGui:Destroy()
    end)
    
    -- Tab Container (Sidebar)
    self.TabContainer = createElement("Frame", {
        Parent = mainFrame,
        Position = UDim2.new(0, 10, 0, 55),
        Size = UDim2.new(0, GLOBAL_CONFIG.TAB_WIDTH, 1, -65),
        BackgroundColor3 = GLOBAL_CONFIG.SECONDARY_BG,
        BorderSizePixel = 0
    })
    
    createElement("UICorner", {
        Parent = self.TabContainer,
        CornerRadius = UDim.new(0, 8)
    })
    
    local tabLayout = createElement("UIListLayout", {
        Parent = self.TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    createElement("UIPadding", {
        Parent = self.TabContainer,
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8)
    })
    
    -- Pages Container
    self.PagesContainer = createElement("Frame", {
        Parent = mainFrame,
        Position = UDim2.new(0, GLOBAL_CONFIG.TAB_WIDTH + 20, 0, 55),
        Size = UDim2.new(1, -(GLOBAL_CONFIG.TAB_WIDTH + 30), 1, -65),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    
    self.ScreenGui = screenGui
    self.MainFrame = mainFrame
    self.HeaderFrame = headerFrame
    
    return self
end

--- Cria uma nova aba
function SilentLib:CreateTab(tabName)
    local tabDef = {}
    local window = self
    
    -- Tab Button
    local tabButton = createStyledButton(window.TabContainer, {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor = GLOBAL_CONFIG.TERTIARY_BG,
        Text = tabName or "Tab",
        TextSize = 12
    })
    
    tabButton.TextScaled = true
    
    -- Page Frame
    local page = createElement("Frame", {
        Parent = window.PagesContainer,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = GLOBAL_CONFIG.SECONDARY_BG,
        BorderSizePixel = 0,
        Visible = false
    })
    
    createElement("UICorner", {
        Parent = page,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- ScrollingFrame
    local scrollFrame = createElement("ScrollingFrame", {
        Parent = page,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    local contentLayout = createElement("UIListLayout", {
        Parent = scrollFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })
    
    createElement("UIPadding", {
        Parent = scrollFrame,
        PaddingTop = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12)
    })
    
    -- Atualizar tamanho do canvas
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y)
    end)
    
    -- Função para selecionar aba
    local function selectTab()
        for _, t in pairs(window.TabsList) do
            t.Page.Visible = false
            animateElement(t.Button, {
                BackgroundColor3 = GLOBAL_CONFIG.TERTIARY_BG,
                TextColor3 = GLOBAL_CONFIG.TEXT_SECONDARY
            })
        end
        
        page.Visible = true
        animateElement(tabButton, {
            BackgroundColor3 = GLOBAL_CONFIG.PRIMARY_COLOR,
            TextColor3 = GLOBAL_CONFIG.BACKGROUND_COLOR
        })
    end
    
    tabButton.MouseButton1Click:Connect(selectTab)
    
    -- Adicionar à lista
    tabDef.Button = tabButton
    tabDef.Page = page
    tabDef.ScrollFrame = scrollFrame
    tabDef.ContentLayout = contentLayout
    
    table.insert(window.TabsList, tabDef)
    
    -- Auto-select first tab
    if #window.TabsList == 1 then
        selectTab()
    end
    
    -- ═════════════════════════════════════════════════════════════
    -- MÉTODOS DA ABA
    -- ═════════════════════════════════════════════════════════════
    
    function tabDef:CreateButton(text, callback, settings)
        settings = settings or {}
        callback = callback or function() end
        
        local button = createStyledButton(scrollFrame, {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor = settings.Color or GLOBAL_CONFIG.TERTIARY_BG,
            Text = text,
            TextSize = 13
        })
        
        button.MouseEnter:Connect(function()
            animateElement(button, {
                BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            })
        end)
        
        button.MouseLeave:Connect(function()
            animateElement(button, {
                BackgroundColor3 = settings.Color or GLOBAL_CONFIG.TERTIARY_BG
            })
        end)
        
        button.MouseButton1Click:Connect(function()
            animateElement(button, {
                BackgroundColor3 = GLOBAL_CONFIG.PRIMARY_COLOR
            }, GLOBAL_CONFIG.TWEEN_SPEED_FAST)
            
            pcall(callback)
            
            task.wait(GLOBAL_CONFIG.TWEEN_SPEED_FAST)
            animateElement(button, {
                BackgroundColor3 = settings.Color or GLOBAL_CONFIG.TERTIARY_BG
            }, GLOBAL_CONFIG.TWEEN_SPEED_FAST)
        end)
        
        return button
    end
    
    function tabDef:CreateToggle(name, defaultState, callback)
        return ToggleComponent:Create(scrollFrame, name, defaultState or false, callback)
    end
    
    function tabDef:CreateSlider(name, minValue, maxValue, defaultValue, callback)
        return SliderComponent:Create(scrollFrame, name, minValue, maxValue, defaultValue or minValue, callback)
    end
    
    function tabDef:CreatePlayerList(selectCallback)
        return PlayerListComponent:Create(scrollFrame, selectCallback)
    end
    
    function tabDef:CreateLabel(text)
        local label = createElement("TextLabel", {
            Parent = scrollFrame,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = GLOBAL_CONFIG.TEXT_PRIMARY,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        return label
    end
    
    function tabDef:CreateDivider()
        local divider = createElement("Frame", {
            Parent = scrollFrame,
            Size = UDim2.new(1, 0, 0, 2),
            BackgroundColor3 = GLOBAL_CONFIG.PRIMARY_COLOR,
            BorderSizePixel = 0
        })
        
        return divider
    end
    
    function tabDef:CreateTextInput(placeholder, callback)
        return TextInputComponent:Create(scrollFrame, placeholder, callback)
    end
    
    function tabDef:AddSpacing(height)
        createElement("Frame", {
            Parent = scrollFrame,
            Size = UDim2.new(1, 0, 0, height or 10),
            BackgroundTransparency = 1,
            BorderSizePixel = 0
        })
    end
    
    return tabDef
end

--- Adiciona uma notificação
function SilentLib.Notify(title, message, duration)
    duration = duration or 3
    
    local notification = createElement("Frame", {
        Name = "Notification",
        Parent = CoreGui,
        Position = UDim2.new(1, -320, 1, -80),
        Size = UDim2.new(0, 300, 0, 70),
        BackgroundColor3 = GLOBAL_CONFIG.SECONDARY_BG,
        BorderSizePixel = 0
    })
    
    createElement("UICorner", {
        Parent = notification,
        CornerRadius = UDim.new(0, 8)
    })
    
    createElement("UIStroke", {
        Parent = notification,
        Color = GLOBAL_CONFIG.PRIMARY_COLOR,
        Thickness = 2
    })
    
    createElement("TextLabel", {
        Parent = notification,
        Position = UDim2.new(0, 10, 0, 5),
        Size = UDim2.new(1, -20, 0, 25),
        BackgroundTransparency = 1,
        Text = "📢 " .. title,
        TextColor3 = GLOBAL_CONFIG.PRIMARY_COLOR,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    createElement("TextLabel", {
        Parent = notification,
        Position = UDim2.new(0, 10, 0, 30),
        Size = UDim2.new(1, -20, 1, -35),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = GLOBAL_CONFIG.TEXT_PRIMARY,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })
    
    task.wait(duration)
    animateElement(notification, {Transparency = 1})
    task.wait(GLOBAL_CONFIG.TWEEN_SPEED)
    notification:Destroy()
end

-- ═══════════════════════════════════════════════════════════════
-- INICIALIZAÇÃO DO SISTEMA
-- ═══════════════════════════════════════════════════════════════

function SilentLib.Initialize()
    if not KeySystem.Init() then
        error("Key system verification failed!")
        return false
    end
    
    return true
end

function SilentLib.GetConfig()
    return GLOBAL_CONFIG
end

function SilentLib.SetConfig(key, value)
    GLOBAL_CONFIG[key] = value
end

return SilentLib

