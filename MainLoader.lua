-- 📄 MainLoader.lua - ไฟล์หลักสำหรับรันสคริปต์ AutoFarm
-- รันไฟล์นี้ไฟล์เดียวใน Executor

print("🎮 Blox Fruits AutoFarm System")
print("📦 Version 2.0")

-- ลิงก์ GitHub ของคุณ
local GITHUB_URL = "https://raw.githubusercontent.com/sadda-sdad/Ronaldo/refs/heads/main/"

-- โหลดไฟล์ทั้งหมดจาก GitHub
local function LoadModule(moduleName)
    local url = GITHUB_URL .. moduleName
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url, true))()
    end)
    
    if success then
        print("✅ โหลด " .. moduleName .. " สำเร็จ")
        return result
    else
        warn("❌ ไม่สามารถโหลด " .. moduleName .. ": " .. result)
        return nil
    end
end

-- โหลดโมดูลต่างๆ
local Config = LoadModule("Configuration.lua")
local PlayerUtils = LoadModule("PlayerUtils.lua")
local AutoFarmSystem = LoadModule("AutoFarmSystem.lua")
local GUI = LoadModule("MainGUI.lua")
local Safety = LoadModule("SafetyChecks.lua")
local Updater = LoadModule("Updater.lua")

-- เริ่มต้นระบบ
if Config and PlayerUtils and AutoFarmSystem and GUI then
    -- แก้ไข AutoFarmSystem ให้ใช้งานได้จริง
    local function PatchAutoFarmSystem()
        -- เพิ่มฟังก์ชันที่ขาดไป
        function AutoFarmSystem:MoveToTarget(target)
            if target and target:FindFirstChild("HumanoidRootPart") then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    -- ใช้ Tween เพื่อเคลื่อนไหวอย่างนุ่มนวล
                    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
                    local tween = game:GetService("TweenService"):Create(
                        char.HumanoidRootPart,
                        tweenInfo,
                        {CFrame = CFrame.new(target.HumanoidRootPart.Position + Vector3.new(0, 0, 5))}
                    )
                    tween:Play()
                end
            end
        end
        
        function AutoFarmSystem:IsEnemyDead(target)
            local humanoid = target:FindFirstChild("Humanoid")
            return not humanoid or humanoid.Health <= 0
        end
        
        function AutoFarmSystem:SearchForEnemies()
            -- เคลื่อนที่ไปรอบๆ เพื่อหาศัตรู
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:MoveTo(char.HumanoidRootPart.Position + Vector3.new(
                    math.random(-50, 50),
                    0,
                    math.random(-50, 50)
                ))
            end
        end
    end
    
    -- แก้ไข GUI ให้ทำงานกับ AutoFarmSystem
    local function PatchGUI()
        -- สร้าง GUI
        local screenGui = GUI:CreateMainGUI()
        
        -- ป้องกัน GUI ถูกทำลาย
        if syn and syn.protect_gui then
            syn.protect_gui(screenGui)
        end
        
        -- หาปุ่ม Toggle ใน GUI
        local function FindToggleButton(gui)
            local mainFrame = gui:FindFirstChild("MainFrame")
            if mainFrame then
                local content = mainFrame:FindFirstChild("Content")
                if content then
                    local controlSection = content:FindFirstChild("Section_🎮 ควบคุมออโต้ฟาร์ม")
                    if controlSection then
                        return controlSection:FindFirstChild("ToggleButton")
                    end
                end
            end
            return nil
        end
        
        -- รอจน GUI สร้างเสร็จ
        game:GetService("RunService").Heartbeat:Wait()
        
        local toggleButton = FindToggleButton(screenGui)
        if toggleButton then
            -- เชื่อมปุ่มกับ AutoFarmSystem
            toggleButton.MouseButton1Click:Connect(function()
                if AutoFarmSystem.Status.IsRunning then
                    AutoFarmSystem:Stop()
                    toggleButton.Text = "▶️ เริ่มออโต้ฟาร์ม"
                    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 160, 60)
                else
                    AutoFarmSystem:Start()
                    toggleButton.Text = "⏸️ หยุดออโต้ฟาร์ม"
                    toggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
                end
            end)
        end
        
        -- ปุ่มลัดเปิด/ปิด GUI
        game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
                screenGui.Enabled = not screenGui.Enabled
            end
        end)
        
        return screenGui
    end
    
    -- แก้ไขระบบ
    PatchAutoFarmSystem()
    
    -- สร้าง GUI
    local gui = PatchGUI()
    
    print("✨ ระบบพร้อมใช้งาน!")
    print("👉 กด RightControl เพื่อแสดง/ซ่อน GUI")
    print("🎯 ปุ่มเริ่มออโต้ฟาร์มอยู่ใน GUI")
    
    -- เรียกใช้ระบบอัพเดตและความปลอดภัย
    if Safety then
        Safety:AntiBan()
    end
    
    if Updater then
        Updater:CheckForUpdates()
    end
    
else
    warn("⚠️ ไม่สามารถโหลดโมดูลสำคัญได้ กรุณาตรวจสอบลิงก์ GitHub")
end

return {
    Config = Config,
    PlayerUtils = PlayerUtils,
    AutoFarmSystem = AutoFarmSystem,
    GUI = GUI
}    -- แสดงข้อมูลผู้เล่น
    local playerData = PlayerUtils:GetPlayerData()
    print("👤 ผู้เล่น: " .. playerData.Name)
    print("📈 เลเวล: " .. playerData.Level)
    print("💰 Beli: " .. playerData.Beli)
    
    -- ตั้งค่าปุ่มลัด
    self:SetupKeybinds()
    
    self.IsInitialized = true
    print("🎉 ระบบพร้อมใช้งาน! กด " .. tostring(Config.UI.Keybind) .. " เพื่อแสดง/ซ่อน GUI")
    
    return true
end

-- ตั้งค่าปุ่มลัด
function Loader:SetupKeybinds()
    local UIS = game:GetService("UserInputService")
    local gui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("AutoFarmGUI")
    
    if gui then
        UIS.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed then
                if input.KeyCode == Config.UI.Keybind then
                    gui.Enabled = not gui.Enabled
                end
            end
        end)
    end
end

-- ฟังก์ชันช่วยเหลือ
function Loader:Help()
    print("=== คำสั่งช่วยเหลือ ===")
    print("AutoFarmSystem:Start() - เริ่มออโต้ฟาร์ม")
    print("AutoFarmSystem:Stop()  - หยุดออโต้ฟาร์ม")
    print("PlayerUtils:GetPlayerData() - ดูข้อมูลผู้เล่น")
    print("Loader:Initialize() - เริ่มต้นระบบใหม่")
end

-- เริ่มต้นระบบอัตโนมัติเมื่อโหลด
spawn(function()
    wait(3) -- รอให้เกมโหลดเสร็จ
    Loader:Initialize()
end)

return Loader
