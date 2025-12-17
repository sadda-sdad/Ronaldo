-- 📄 SafetyChecks.lua
local Safety = {}

function Safety:AntiBan()
    -- ตรวจสอบว่าถูกแบนหรือไม่
    local success, message = pcall(function()
        -- โค้ดตรวจสอบ
    end)
    
    return success
end

return Safety
