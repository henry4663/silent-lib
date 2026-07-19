-- Evita duplicar a UI se executar o script de novo
if game.CoreGui:FindFirstChild("MeuCustomHub") then
    game.CoreGui.MeuCustomHub:Destroy()
end

-- ==========================================
-- ESTRUTURA PRINCIPAL DA UI
-- ==========================================
local MeuCustomHub = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local TopCorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

-- Configurações da ScreenGui
MeuCustomHub.Name = "MeuCustomHub"
MeuCustomHub.Parent = game.CoreGui
MeuCustomHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Janela Principal (MainFrame)
MainFrame.Name = "MainFrame"
MainFrame.Parent = MeuCustomHub
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Fundo Grafite Escuro
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true -- Ativa a função nativa de arrastar a janela

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Barra Superior (TopBar)
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.Size = UDim2.new(1, 0, 0, 40)

TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

-- Título do Hub
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "MEU CUSTOM HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Botão de Fechar (X)
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TopBar
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -35, 0, 7)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
CloseBtn.TextSize = 18

CloseBtn.MouseButton1Click:Connect(function()
    MeuCustomHub:Destroy()
end)

-- Container dos Botões/Funções
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.Size = UDim2.new(1, -20, 1, -60)

UIListLayout.Parent = ContentFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10) -- Espaçamento de 10px entre os botões

-- ==========================================
-- FUNÇÃO PARA CRIAR BOTÕES RAPIDAMENTE
-- ==========================================
local function CriarBotao(texto, funcao)
    local Botao = Instance.new("TextButton")
    local BotaoCorner = Instance.new("UICorner")
    
    Botao.Name = texto .. "Btn"
    Botao.Parent = ContentFrame
    Botao.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Botao.Size = UDim2.new(1, 0, 0, 40) -- Largura total, altura 40
    Botao.Font = Enum.Font.GothamSemibold
    Botao.Text = texto
    Botao.TextColor3 = Color3.fromRGB(230, 230, 230)
    Botao.TextSize = 14
    
    BotaoCorner.CornerRadius = UDim.new(0, 6)
    BotaoCorner.Parent = Botao
    
    -- Efeito visual ao passar o mouse (Hover)
    Botao.MouseEnter:Connect(function()
        Botao.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    Botao.MouseLeave:Connect(function()
        Botao.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end)
    
    -- Gatilho da função
    Botao.MouseButton1Click:Connect(funcao)
end

-- ==========================================
-- ADICIONANDO AS FUNÇÕES DO SEU HUB
-- ==========================================

-- Botão 1: Velocidade
CriarBotao("Aumentar Velocidade (WalkSpeed)", function()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 100
    end
end)

-- Botão 2: Pulo
CriarBotao("Super Pulo (JumpPower)", function()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.UseJumpPower = true
        player.Character.Humanoid.JumpPower = 150
    end
end)

-- Botão 3: Resetar Personagem
CriarBotao("Resetar Velocidade/Pulo", function()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
        player.Character.Humanoid.JumpPower = 50
    end
end)
