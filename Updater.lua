-- 📄 Updater.lua
local Updater = {}

function Updater:CheckForUpdates()
    -- ตรวจสอบเวอร์ชันใหม่
    local latestVersion = game:HttpGet("https://api.github.com/...")
    
    if latestVersion > currentVersion then
        print("🔄 มีอัพเดตใหม่! กรุณาอัพเดตสคริปต์")
    end
end

return Updater
