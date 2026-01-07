-- Замени ссылку ниже на ту, которую ты скопировал через кнопку Raw
local raw_url = "https://raw.githubusercontent.com/incognitocoded/town/main/loader.lua" 

local success, result = pcall(function()
    return game:HttpGet(raw_url)
end)

if success then
    print("LOST HUB: Скрипт успешно загружен!")
    loadstring(result)() -- Это запустит твой GUI из облака
else
    warn("Ошибка: Не удалось получить код с GitHub. Проверь ссылку!")
end
