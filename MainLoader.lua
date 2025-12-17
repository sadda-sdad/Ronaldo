-- 📄 MainLoader.lua
-- ไฟล์หลักสำหรับโหลดสคริปต์ทั้งหมด

-- โหลดการตั้งค่า
local Config = require(script.Parent.Configuration)

-- โหลดโมดูลต่างๆ
local AutoFarmSystem = require(script.Parent.CoreModules.AutoFarmSystem)
local PlayerUtils = require(script.Parent.CoreModules.PlayerUtils)
local GUI = require(script.Parent.UI.MainGUI)

-- ตัวแปรระบบ
local Loader = {}
Loader.Version = "1.0.0"
Loader.IsInitialized = false

-- ฟังก์ชันเริ่มต้นระบบ
function Loader:Initialize()
    if self.IsInitialized then
        warn("⚠️ ระบบได้เริ่มต้นไปแล้ว!")
        return
    end
    
    print("=====================================")
    print("🤖 Blox Fruits AutoFarm System")
    print("📱 Version: " .. self.Version)
    print("=====================================")
    
    -- เริ่มต้น GUI
    local mainGUI = GUI:CreateMainGUI()
    print("✅ โหลด GUI สำเร็จ")
    
    -- เริ่มต้นระบบออโต้ฟาร์ม
    -- AutoFarmSystem:Initialize()
    print("✅ โหลดระบบออโต้ฟาร์มสำเร็จ")
    
    -- แสดงข้อมูลผู้เล่น
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
