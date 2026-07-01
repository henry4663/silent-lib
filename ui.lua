-- [[ SILENT LIB - UI LIBRARY V2 ]] --
local SilentLib = {}
SilentLib.__index = SilentLib

-- Serviços do Roblox
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Configurações Globais
local CONFIG = {
    SCRIPT_KEY = "SILENT_KEY_12345", -- MUDE ISSO PARA SUA CHAVE
    KEY_ENABLED = true, -- Se false, script não precisa de chave
    MAIN_COLOR = Color3.fromRGB(0, 255, 136),
    BG_COLOR = Color3.fromRGB(15, 15, 15),
    SECONDARY_BG = Color3.fromRGB(20, 20, 20),
    TEXT_COLOR = Color3.fromRGB(255, 255, 255),
    ACCENT_COLOR = Color3.fromRGB(30, 30, 30)
}

-- Função auxiliar para criar elementos
local function createElement(className, properties)
    local element = Instance.new(className)
    for prop, val in pairs(properties) do
        element[prop] = val
    end
    return element
end

-- ============== KEY SYSTEM ==============
local KeySystem = {}

function KeySystem.CreateKeyWindow()
    local keyGui = createElement("ScreenGui", {
        Name = "SilentLib_KeySystem",
        Parent = CoreGui,
        ResetOnSpawn = false
    })
    
    local mainFrame = createElement("Frame", {
        Name = "KeyFrame",
        Parent = keyGui,
        Position = UDim2.new(0.5, -150, 0.5, -100),
        Size = UDim2.new(0, 300, 0, 200),
        BackgroundColor3 = CONFIG.BG_COLOR,
        BorderSizePixel = 0
    })
    createElement("UICorner", { Parent = mainFrame, CornerRadius = UDim.new(0, 10) })
    
    -- Título
    createElement("TextLabel", {
        Parent = mainFrame,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = "🔐 SILENT KEY SYSTEM",
        TextColor3 = CONFIG.MAIN_COLOR,
        Font = Enum.Font.GothamBold,
        TextSize = 14
    })
    
    -- Input TextBox
    local inputBox = createElement("TextBox", {
        Parent = mainFrame,
        Position = UDim2.new(0, 15, 0, 50),
        Size = UDim2.new(1, -30, 0, 35),
        BackgroundColor3 = CONFIG.SECONDARY_BG,
        TextColor3 = CONFIG.TEXT_COLOR,
        PlaceholderText = "Digite sua chave aqui...",
        PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        BorderSizePixel = 0,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    createElement("UICorner", { Parent = inputBox, CornerRadius = UDim.new(0, 6) })
    createElement("UIPadding", {
        Parent = inputBox,
        PaddingLeft = UDim.new(0, 10)
    })
    
    -- Botão Enviar
    local submitBtn = createElement("TextButton", {
        Parent = mainFrame,
        Position = UDim2.new(0, 15, 0, 95),
        Size = UDim2.new(0.5, -20, 0, 35),
        BackgroundColor3 = CONFIG.MAIN_COLOR,
        Text = "ENVIAR",
        TextColor3 = CONFIG.BG_COLOR,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        BorderSizePixel = 0,
        AutoButtonColor = false
    })
    createElement("UICorner", { Parent = submitBtn, CornerRadius = UDim.new(0, 6) })
    
    -- Label de Status
    local statusLabel = createElement("TextLabel", {
        Parent = mainFrame,
        Position = UDim2.new(0, 15, 0, 145),
        Size = UDim2.new(1, -30, 0, 40),
        BackgroundTransparency = 1,
        Text = "Insira uma chave válida",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextWrapped = true
    })
    
    return {
        gui = keyGui,
        inputBox = inputBox,
        submitBtn = submitBtn,
        statusLabel = statusLabel,
        mainFrame = mainFrame
    }
end

function KeySystem.CheckKey(inputKey)
    return inputKey == CONFIG.SCRIPT_KEY
end

-- ============== SLIDER COMPONENT ==============
local SliderComponent = {}

function SliderComponent:Create(parent, name, minValue, maxValue, defaultValue, callback)
    local callback = callback or function() end
    
    local sliderContainer = createElement("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    
    -- Label
    createElement("TextLabel", {
        Parent = sliderContainer,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0.6, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = name .. ": " .. tostring(defaultValue),
        TextColor3 = CONFIG.TEXT_COLOR,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Barra do Slider
    local sliderBg = createElement("Frame", {
        Parent = sliderContainer,
        Position = UDim2.new(0, 0, 0, 25),
        Size = UDim2.new(1, 0, 0, 10),
        BackgroundColor3 = CONFIG.SECONDARY_BG,
        BorderSizePixel = 0
    })
    createElement("UICorner", { Parent = sliderBg, CornerRadius = UDim.new(0, 5) })
    
    -- Preenchimento
    local sliderFill = createElement("Frame", {
        Parent = sliderBg,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0),
        BackgroundColor3 = CONFIG.MAIN_COLOR,
        BorderSizePixel = 0
    })
    createElement("UICorner", { Parent = sliderFill, CornerRadius = UDim.new(0, 5) })
    
    -- Botão do Slider
    local sliderButton = createElement("TextButton", {
        Parent = sliderBg,
        Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -7, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        BackgroundColor3 = CONFIG.MAIN_COLOR,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false
    })
    createElement("UICorner", { Parent = sliderButton, CornerRadius = UDim.new(0, 8) })
    
    local isDragging = false
    local currentValue = defaultValue
    
    local function updateSlider(input)
        local relativeX = input.Position.X - sliderBg.AbsolutePosition.X
        local percentage = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
        currentValue = math.round(minValue + (maxValue - minValue) * percentage)
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderButton.Position = UDim2.new(percentage, -7, 0.5, -8)
        
        callback(currentValue)
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    RunService.InputChanged:Connect(function(input, processed)
        if not processed and isDragging then
            updateSlider(input)
        end
    end)
    
    RunService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    return sliderContainer
end

-- ============== TOGGLE COMPONENT ==============
local ToggleComponent = {}

function ToggleComponent:Create(parent, name, defaultState, callback)
    local callback = callback or function() end
    
    local toggleContainer = createElement("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = CONFIG.ACCENT_COLOR,
        BorderSizePixel = 0
    })
    createElement("UICorner", { Parent = toggleContainer, CornerRadius = UDim.new(0, 6) })
    
    -- Label
    createElement("TextLabel", {
        Parent = toggleContainer,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = CONFIG.TEXT_COLOR,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Toggle Button
    local toggleButton = createElement("Frame", {
        Parent = toggleContainer,
        Position = UDim2.new(1, -45, 0.5, -12),
        Size = UDim2.new(0, 40, 0, 24),
        BackgroundColor3 = defaultState and CONFIG.MAIN_COLOR or Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0
    })
    createElement("UICorner", { Parent = toggleButton, CornerRadius = UDim.new(0, 12) })
    
    -- Circle
    local toggleCircle = createElement("Frame", {
        Parent = toggleButton,
        Position = defaultState and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    })
    createElement("UICorner", { Parent = toggleCircle, CornerRadius = UDim.new(0, 10) })
    
    local state = defaultState
    
    local toggleClickArea = createElement("TextButton", {
        Parent = toggleContainer,
        Position = UDim2.new(1, -50, 0, 0),
        Size = UDim2.new(0, 50, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false
    })
    
    local function updateToggle()
        state = not state
        
        TweenService:Create(toggleButton, TweenInfo.new(0.3), {
            BackgroundColor3 = state and CONFIG.MAIN_COLOR or Color3.fromRGB(60, 60, 60)
        }):Play()
        
        TweenService:Create(toggleCircle, TweenInfo.new(0.3), {
            Position = state and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
        }):Play()
        
        callback(state)
    end
    
    toggleClickArea.MouseButton1Click:Connect(updateToggle)
    
    return toggleContainer
end

-- ============== PLAYER LIST COMPONENT ==============
local PlayerListComponent = {}

function PlayerListComponent:Create(parent, selectCallback)
    local selectCallback = selectCallback or function() end
    
    local listContainer = createElement("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 200),
        BackgroundColor3 = CONFIG.SECONDARY_BG,
        BorderSizePixel = 0
    })
    createElement("UICorner", { Parent = listContainer, CornerRadius = UDim.new(0, 6) })
    
    -- ScrollingFrame
    local scrollFrame = createElement("ScrollingFrame", {
        Parent = listContainer,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    local listLayout = createElement("UIListLayout", {
        Parent = scrollFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4)
    })
    createElement("UIPadding", {
        Parent = scrollFrame,
        PaddingTop = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5)
    })
    
    local function updatePlayerList()
        for _, child in pairs(scrollFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local playerList = Players:GetPlayers()
        
        for _, player in pairs(playerList) do
            local playerButton = createElement("TextButton", {
                Parent = scrollFrame,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = CONFIG.ACCENT_COLOR,
                Text = player.Name .. " (ID: " .. player.UserId .. ")",
                TextColor3 = CONFIG.TEXT_COLOR,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                BorderSizePixel = 0,
                AutoButtonColor = false
            })
            createElement("UICorner", { Parent = playerButton, CornerRadius = UDim.new(0, 5) })
            
            playerButton.MouseEnter:Connect(function()
                TweenService:Create(playerButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                }):Play()
            end)
            
            playerButton.MouseLeave:Connect(function()
                TweenService:Create(playerButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = CONFIG.ACCENT_COLOR
                }):Play()
            end)
            
            playerButton.MouseButton1Click:Connect(function()
                selectCallback(player)
            end)
        end
        
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
        end)
    end
    
    -- Atualizar lista quando jogadores entram/saem
    Players.PlayerAdded:Connect(updatePlayerList)
    Players.PlayerRemoving:Connect(updatePlayerList)
    
    updatePlayerList()
    
    return listContainer
end

-- ============== MAIN WINDOW ==============
function SilentLib.CreateWindow(hubName)
    local self = setmetatable({}, SilentLib)
    self.TabsList = {}
    
    local ScreenGui = createElement("ScreenGui", {
        Name = "SilentLib_" .. HttpService:GenerateGUID(false):sub(1, 8),
        Parent = CoreGui,
        ResetOnSpawn = false
    })
    
    -- Main Frame
    local MainFrame = createElement("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        Position = UDim2.new(0.35, 0, 0.3, 0),
        Size = UDim2.new(0, 600, 0, 450),
        BackgroundColor3 = CONFIG.BG_COLOR,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    })
    createElement("UICorner", { Parent = MainFrame, CornerRadius = UDim.new(0, 8) })
    
    -- Top Border
    createElement("Frame", {
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 3),
        BackgroundColor3 = CONFIG.MAIN_COLOR,
        BorderSizePixel = 0
    })
    
    -- Título
    createElement("TextLabel", {
        Parent = MainFrame,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(0, 300, 0, 25),
        BackgroundTransparency = 1,
        Text = "⚡ " .. (hubName or "SILENT HUB"),
        TextColor3 = CONFIG.TEXT_COLOR,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 16
    })
    
    -- Tab Container (Sidebar)
    self.TabContainer = createElement("Frame", {
        Parent = MainFrame,
        Position = UDim2.new(0, 10, 0, 45),
        Size = UDim2.new(0, 140, 1, -55),
        BackgroundColor3 = CONFIG.SECONDARY_BG,
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
    
    -- Content Container
    self.PagesContainer = createElement("Frame", {
        Parent = MainFrame,
        Position = UDim2.new(0, 160, 0, 45),
        Size = UDim2.new(1, -170, 1, -55),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    
    self.ScreenGui = ScreenGui
    self.MainFrame = MainFrame
    
    return self
end

-- Criar Nova Aba
function SilentLib:CreateTab(tabName)
    local tabDef = {}
    local window = self
    
    -- Tab Button
    local TabButton = createElement("TextButton", {
        Parent = window.TabContainer,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = CONFIG.ACCENT_COLOR,
        Text = tabName or "Aba",
        TextColor3 = Color3.fromRGB(150, 150, 150),
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        BorderSizePixel = 0,
        AutoButtonColor = false
    })
    createElement("UICorner", { Parent = TabButton, CornerRadius = UDim.new(0, 4) })
    
    -- Page Frame
    local Page = createElement("Frame", {
        Parent = window.PagesContainer,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = CONFIG.SECONDARY_BG,
        BorderSizePixel = 0,
        Visible = false
    })
    createElement("UICorner", { Parent = Page, CornerRadius = UDim.new(0, 6) })
    
    local ScrollFrame = createElement("ScrollingFrame", {
        Parent = Page,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    local ContentLayout = createElement("UIListLayout", {
        Parent = ScrollFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })
    createElement("UIPadding", {
        Parent = ScrollFrame,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10)
    })
    
    -- Auto-update canvas size
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end)
    
    local function selectTab()
        for _, t in pairs(window.TabsList) do
            t.Page.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = CONFIG.ACCENT_COLOR,
                TextColor3 = Color3.fromRGB(150, 150, 150)
            }):Play()
        end
        
        Page.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            TextColor3 = CONFIG.MAIN_COLOR
        }):Play()
    end
    
    TabButton.MouseButton1Click:Connect(selectTab)
    
    tabDef.Button = TabButton
    tabDef.Page = Page
    tabDef.ScrollFrame = ScrollFrame
    table.insert(window.TabsList, tabDef)
    
    if #window.TabsList == 1 then
        selectTab()
    end
    
    -- Criar Botão
    function tabDef:CreateButton(text, callback)
        local callback = callback or function() end
        
        local Button = createElement("TextButton", {
            Parent = ScrollFrame,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = CONFIG.ACCENT_COLOR,
            Text = text,
            TextColor3 = CONFIG.TEXT_COLOR,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            BorderSizePixel = 0,
            AutoButtonColor = false
        })
        createElement("UICorner", { Parent = Button, CornerRadius = UDim.new(0, 6) })
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            }):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = CONFIG.ACCENT_COLOR
            }):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            local originalColor = Button.BackgroundColor3
            Button.BackgroundColor3 = CONFIG.MAIN_COLOR
            task.wait(0.1)
            Button.BackgroundColor3 = originalColor
            pcall(callback)
        end)
        
        return Button
    end
    
    -- Criar Toggle
    function tabDef:CreateToggle(name, defaultState, callback)
        return ToggleComponent:Create(ScrollFrame, name, defaultState, callback)
    end
    
    -- Criar Slider
    function tabDef:CreateSlider(name, minValue, maxValue, defaultValue, callback)
        return SliderComponent:Create(ScrollFrame, name, minValue, maxValue, defaultValue, callback)
    end
    
    -- Criar Lista de Jogadores
    function tabDef:CreatePlayerList(selectCallback)
        return PlayerListComponent:Create(ScrollFrame, selectCallback)
    end
    
    return tabDef
end

-- ============== INICIALIZAR COM KEY SYSTEM ==============
function SilentLib.Init()
    if not CONFIG.KEY_ENABLED then
        return true -- Script funciona sem chave
    end
    
    local keyWindow = KeySystem.CreateKeyWindow()
    local verified = false
    
    keyWindow.submitBtn.MouseButton1Click:Connect(function()
        local inputKey = keyWindow.inputBox.Text
        
        if KeySystem.CheckKey(inputKey) then
            keyWindow.statusLabel.Text = "✅ Chave correta!"
            keyWindow.statusLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
            task.wait(1)
            keyWindow.gui:Destroy()
            verified = true
        else
            keyWindow.statusLabel.Text = "❌ Chave incorreta!"
            keyWindow.statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            keyWindow.inputBox.Text = ""
            task.wait(2)
            keyWindow.statusLabel.Text = "Insira uma chave válida"
            keyWindow.statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
    
    keyWindow.inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            keyWindow.submitBtn:TriggerEvent("MouseButton1Click")
        end
    end)
    
    -- Aguardar verificação
    while not verified do
        task.wait(0.1)
    end
    
    return true
end

return SilentLib
