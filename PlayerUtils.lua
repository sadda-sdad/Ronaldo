-- 📄 PlayerUtils.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local PlayerUtils = {}

-- ฟังก์ชันดึงข้อมูลผู้เล่นปัจจุบัน
function PlayerUtils:GetPlayerData()
    local data = {}
    
    -- ดึงข้อมูลพื้นฐาน
    data.Name = player.Name
    data.Level = self:GetPlayerLevel()
    data.Beli = self:GetPlayerBeli()
    data.Fruits = self:GetPlayerFruits()
    
    return data
end

-- ฟังก์ชันดึงเลเวลผู้เล่น
function PlayerUtils:GetPlayerLevel()
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local level = leaderstats:FindFirstChild("Level")
        return level and level.Value or 1
    end
    return 1
end

-- ฟังก์ชันดึงเงิน Beli
function PlayerUtils:GetPlayerBeli()
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local beli = leaderstats:FindFirstChild("Beli")
        return beli and beli.Value or 0
    end
    return 0
end

-- ฟังก์ชันดึงผลไม้ที่ครอบครอง
function PlayerUtils:GetPlayerFruits()
    local fruits = {}
    local backpack = player:WaitForChild("Backpack")
    
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name:find("Fruit") then
            table.insert(fruits, item.Name)
        end
    end
    
    return fruits
end

return PlayerUtils
