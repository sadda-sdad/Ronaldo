-- 📄 MainGUI.lua
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local GUI = {}

-- สร้าง GUI หลัก
function GUI:CreateMainGUI()
    -- สร้าง ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoFarmGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- สร้าง Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 350, 0, 450)
    mainFrame.Position = UDim2.new(1, -360, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- เพิ่มความโค้งมน
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- เพิ่มเงา
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 2
    shadow.Transparency = 0.7
    shadow.Parent = mainFrame
    
    -- สร้าง Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    -- ชื่อโปรแกรม
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -50, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🤖 Blox Fruits AutoFarm"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- ปุ่มปิด
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0.5, -15)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.GothamBold
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
    end)
    closeButton.Parent = titleBar
    
    -- สร้างเนื้อหาหลัก
    self:CreateContent(mainFrame)
    
    -- ทำให้ลากได้
    self:MakeDraggable(titleBar, mainFrame)
    
    return screenGui
end

-- สร้างเนื้อหาใน GUI
function GUI:CreateContent(parentFrame)
    -- Container สำหรับเนื้อหา
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 1, -60)
    content.Position = UDim2.new(0, 10, 0, 50)
    content.BackgroundTransparency = 1
    content.Parent = parentFrame
    
    -- ส่วนที่ 1: สถานะปัจจุบัน
    local statusSection = self:CreateSection("📊 สถานะปัจจุบัน", content)
    statusSection.Position = UDim2.new(0, 0, 0, 0)
    
    -- ข้อมูลผู้เล่น
    local playerInfo = Instance.new("TextLabel")
    playerInfo.Name = "PlayerInfo"
    playerInfo.Size = UDim2.new(1, 0, 0, 25)
    playerInfo.Position = UDim2.new(0, 0, 0, 30)
    playerInfo.BackgroundTransparency = 1
    playerInfo.Text = "👤 ผู้เล่น: " .. player.Name
    playerInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
    playerInfo.TextSize = 14
    playerInfo.Font = Enum.Font.Gotham
    playerInfo.TextXAlignment = Enum.TextXAlignment.Left
    playerInfo.Parent = statusSection
    
    -- ส่วนที่ 2: ควบคุมออโต้ฟาร์ม
    local controlSection = self:CreateSection("🎮 ควบคุมออโต้ฟาร์ม", content)
    controlSection.Position = UDim2.new(0, 0, 0, 100)
    
    -- ปุ่มเริ่ม/หยุด
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(1, 0, 0, 40)
    toggleButton.Position = UDim2.new(0, 0, 0, 30)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 160, 60)
    toggleButton.Text = "▶️ เริ่มออโต้ฟาร์ม"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 16
    toggleButton.Font = Enum.Font.GothamBold
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleButton
    
    local isFarming = false
    toggleButton.MouseButton1Click:Connect(function()
        isFarming = not isFarming
        
        if isFarming then
            toggleButton.Text = "⏸️ หยุดออโต้ฟาร์ม"
            toggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
            -- เรียกฟังก์ชันเริ่มออโต้ฟาร์ม
            -- AutoFarmSystem:Start()
        else
            toggleButton.Text = "▶️ เริ่มออโต้ฟาร์ม"
            toggleButton.BackgroundColor3 = Color3.fromRGB(60, 160, 60)
            -- เรียกฟังก์ชันหยุดออโต้ฟาร์ม
            -- AutoFarmSystem:Stop()
        end
    end)
    toggleButton.Parent = controlSection
    
    -- ส่วนที่ 3: การตั้งค่า
    local settingsSection = self:CreateSection("⚙️ การตั้งค่า", content)
    settingsSection.Position = UDim2.new(0, 0, 0, 200)
    
    -- สร้าง Toggle สำหรับ AutoClick
    self:CreateToggle("🔘 คลิกอัตโนมัติ", true, settingsSection, 30)
    
    -- สร้าง Toggle สำหรับใช้สกิล
    self:CreateToggle("⚡ ใช้สกิลอัตโนมัติ", true, settingsSection, 70)
    
    -- Slider สำหรับความเร็วโจมตี
    self:CreateSlider("🐌 ความเร็วโจมตี", 0.1, 2, 0.5, settingsSection, 110)
end

-- สร้างส่วน
function GUI:CreateSection(title, parent)
    local section = Instance.new("Frame")
    section.Name = "Section_" .. title
    section.Size = UDim2.new(1, 0, 0, 150)
    section.BackgroundTransparency = 1
    section.Parent = parent
    
    -- หัวข้อส่วน
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "SectionTitle"
    sectionTitle.Size = UDim2.new(1, 0, 0, 20)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title
    sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionTitle.TextSize = 16
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Parent = section
    
    return section
end

-- สร้าง Toggle Switch
function GUI:CreateToggle(label, defaultValue, parent, yPosition)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle_" .. label
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.Position = UDim2.new(0, 0, 0, yPosition)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    -- ข้อความ
    local labelText = Instance.new("TextLabel")
    labelText.Name = "Label"
    labelText.Size = UDim2.new(0.7, 0, 1, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(220, 220, 220)
    labelText.TextSize = 14
    labelText.Font = Enum.Font.Gotham
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = toggleFrame
    
    -- Toggle Button
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 50, 0, 24)
    toggleButton.Position = UDim2.new(1, -50, 0.5, -12)
    toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(60, 160, 60) or Color3.fromRGB(80, 80, 80)
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleButton
    
    -- วงกลมใน Toggle
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "ToggleCircle"
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    toggleCircle.Position = UDim2.new(defaultValue and 1 or 0, -20, 0.5, -10)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 10)
    circleCorner.Parent = toggleCircle
    
    -- Animation สำหรับ Toggle
    local isToggled = defaultValue
    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isToggled = not isToggled
            
            -- Animation
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(toggleCircle, tweenInfo, {
                Position = UDim2.new(isToggled and 1 or 0, isToggled and -20 or -20, 0.5, -10)
            })
            
            toggleButton.BackgroundColor3 = isToggled and Color3.fromRGB(60, 160, 60) or Color3.fromRGB(80, 80, 80)
            
            tween:Play()
            
            -- บันทึกการตั้งค่า
            -- Config:SaveSetting(label, isToggled)
        end
    end)
    
    toggleCircle.Parent = toggleButton
    toggleButton.Parent = toggleFrame
end

-- สร้าง Slider
function GUI:CreateSlider(label, minValue, maxValue, defaultValue, parent, yPosition)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider_" .. label
    sliderFrame.Size = UDim2.new(1, 0, 0, 40)
    sliderFrame.Position = UDim2.new(0, 0, 0, yPosition)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    -- ข้อความ
    local labelText = Instance.new("TextLabel")
    labelText.Name = "Label"
    labelText.Size = UDim2.new(1, 0, 0, 20)
    labelText.BackgroundTransparency = 1
    labelText.Text = label .. ": " .. defaultValue
    labelText.TextColor3 = Color3.fromRGB(220, 220, 220)
    labelText.TextSize = 14
    labelText.Font = Enum.Font.Gotham
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = sliderFrame
    
    -- Slider Bar
    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "SliderBar"
    sliderBar.Size = UDim2.new(1, 0, 0, 6)
    sliderBar.Position = UDim2.new(0, 0, 0, 25)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 3)
    barCorner.Parent = sliderBar
    
    -- Slider Fill
    local fillPercentage = (defaultValue - minValue) / (maxValue - minValue)
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new(fillPercentage, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(60, 160, 60)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill
    
    -- Slider Button
    local sliderButton = Instance.new("Frame")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new(fillPercentage, -10, 0.5, -10)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = sliderButton
    
    -- Slider Logic
    local isDragging = false
    local currentValue = defaultValue
    
    local function updateSlider(xPosition)
        local relativeX = math.clamp(xPosition, 0, sliderBar.AbsoluteSize.X)
        local percentage = relativeX / sliderBar.AbsoluteSize.X
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderButton.Position = UDim2.new(percentage, -10, 0.5, -10)
        
        currentValue = minValue + (maxValue - minValue) * percentage
        labelText.Text = label .. ": " .. string.format("%.2f", currentValue)
        
        -- บันทึกการตั้งค่า
        -- Config:SaveSetting(label, currentValue)
    end
    
    -- Mouse Events
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X - sliderBar.AbsolutePosition.X)
        end
    end)
    
    -- Click on bar
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input.Position.X - sliderBar.AbsolutePosition.X)
        end
    end)
    
    sliderFill.Parent = sliderBar
    sliderButton.Parent = sliderBar
    sliderBar.Parent = sliderFrame
end

-- ทำให้ GUI ลากได้
function GUI:MakeDraggable(dragPart, mainFrame)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            mainFrame.Position = UDim2.new(
                framePos.X.Scale, 
                framePos.X.Offset + delta.X,
                framePos.Y.Scale, 
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

return GUI
