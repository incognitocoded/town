-- [[ LOST HUB LOADER V1 ]] --
-- [[ TG/@losthubscript ]] --

local raw_url = "ВСТАВЬ_СЮДА_RAW_ССЫЛКУ" 

-- Проверка и запуск
local success, result = pcall(function()
    return game:HttpGet(raw_url)
end)

if success then
    -- Логика блокировки меню при движении слайдера
    -- (Эта часть уже встроена в основной скрипт V1, который ты залил на GitHub)
    loadstring(result)()
else
    print("Error loading script from GitHub")
end
