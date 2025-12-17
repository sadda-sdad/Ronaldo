-- 📄 AutoFarmSystem.lua
local AutoFarmSystem = {}
local Config = require(script.Parent.Parent.Configuration)
local PlayerUtils = require(script.Parent.PlayerUtils)

-- สถานะของระบบ
AutoFarmSystem.Status = {
    IsRunning = false,
    CurrentTarget = nil,
    TargetsDefeated = 0,
    StartTime = 0
}

-- เริ่มระบบออโต้ฟาร์ม
function AutoFarmSystem:Start()
    if self.Status.IsRunning then
        warn("⚠️ ระบบกำลังทำงานอยู่แล้ว!")
        return
    end
    
    print("🚀 เริ่มระบบออโต้ฟาร์ม...")
    self.Status.IsRunning = true
    self.Status.StartTime = os.time()
    self.Status.TargetsDefeated = 0
    
    -- เริ่มลูปหลัก
    self.MainLoop = game:GetService("RunService").Heartbeat:Connect(function()
        self:ProcessAutoFarm()
    end)
end

-- หยุดระบบออโต้ฟาร์ม
function AutoFarmSystem:Stop()
    if not self.Status.IsRunning then
        warn("⚠️ ระบบไม่ได้กำลังทำงาน!")
        return
    end
    
    print("⏹️ หยุดระบบออโต้ฟาร์ม...")
    self.Status.IsRunning = false
    
    if self.MainLoop then
        self.MainLoop:Disconnect()
        self.MainLoop = nil
    end
    
    self:ShowStats()
end

-- ประมวลผลออโต้ฟาร์ม
function AutoFarmSystem:ProcessAutoFarm()
    -- 1. ค้นหาศัตรู
    local target = self:FindNearestEnemy()
    
    -- 2. เคลื่อนที่ไปหาศัตรู
    if target then
        self:MoveToTarget(target)
        
        -- 3. โจมตีศัตรู
        self:AttackTarget(target)
        
        -- 4. ตรวจสอบว่าศัตรูตายแล้วหรือไม่
        if self:IsEnemyDead(target) then
            self.Status.TargetsDefeated = self.Status.TargetsDefeated + 1
        end
    else
        -- ถ้าไม่มีศัตรูในรัศมี
        self:SearchForEnemies()
    end
    
    -- หน่วงเวลาตามการตั้งค่า
    wait(Config.AutoFarm.AttackDelay)
end

-- ค้นหาศัตรูที่ใกล้ที่สุด
function AutoFarmSystem:FindNearestEnemy()
    local character = game.Players.LocalPlayer.Character
    if not character then return nil end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    
    local nearestEnemy = nil
    local nearestDistance = Config.AutoFarm.SearchRadius
    
    -- ค้นหาในโฟลเดอร์ Enemies
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            -- ตรวจสอบว่าชื่อศัตรูอยู่ในรายการที่กรองไว้
            local shouldAttack = false
            for _, filter in ipairs(Config.AutoFarm.TargetFilter) do
                if enemy.Name:find(filter) then
                    shouldAttack = true
                    break
                end
            end
            
            if shouldAttack then
                local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                if enemyRoot then
                    local distance = (humanoidRootPart.Position - enemyRoot.Position).Magnitude
                    if distance < nearestDistance then
                        nearestDistance = distance
                        nearestEnemy = enemy
                    end
                end
            end
        end
    end
    
    return nearestEnemy, nearestDistance
end

-- โจมตีศัตรู
function AutoFarmSystem:AttackTarget(target)
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- หมุนหน้าไปทางศัตรู
    local targetRoot = target:FindFirstChild("HumanoidRootPart")
    local characterRoot = character:FindFirstChild("HumanoidRootPart")
    
    if targetRoot and characterRoot then
        characterRoot.CFrame = CFrame.new(
            characterRoot.Position,
            Vector3.new(targetRoot.Position.X, characterRoot.Position.Y, targetRoot.Position.Z)
        )
    end
    
    -- โจมตี (จำลองการกดคลิก)
    if Config.Combat.AutoClick then
        mouse1click()
    end
    
    -- ใช้สกิลถ้าตั้งค่าไว้
    if Config.Combat.UseSkills then
        self:UseSkills()
    end
end

-- ใช้สกิลตามลำดับ
function AutoFarmSystem:UseSkills()
    for _, key in ipairs(Config.Combat.SkillPriority) do
        -- ส่งคีย์กด (Z, X, C, V, F)
        keypress(key)
        wait(0.1)
        keyrelease(key)
    end
end

-- แสดงสถิติ
function AutoFarmSystem:ShowStats()
    local elapsedTime = os.time() - self.Status.StartTime
    local minutes = math.floor(elapsedTime / 60)
    local seconds = elapsedTime % 60
    
    print("📊 สถิติออโต้ฟาร์ม:")
    print("   ⏱️  เวลาที่ใช้: " .. minutes .. " นาที " .. seconds .. " วินาที")
    print("   ⚔️  ศัตรูที่เอาชนะได้: " .. self.Status.TargetsDefeated)
    print("   🎯 ศัตรูต่อนาที: " .. math.floor(self.Status.TargetsDefeated / (elapsedTime/60)))
end

return AutoFarmSystem
