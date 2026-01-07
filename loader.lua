-- [[ LOST HUB OFFICIAL LOADER ]] --
-- [[ TG/@losthubscript ]] --

-- Замени эту ссылку на свою RAW ссылку с GitHub
local my_github_url = "https://raw.githubusercontent.com/incognitocoded/town/main/loader.lua"

local success, content = pcall(function()
    return game:HttpGet(my_github_url)
end)

if success then
    loadstring(content)()
else
    -- Если ссылка битая или нет интернета, выдаст ошибку в консоль F9
    warn("LOST HUB: Error connecting to GitHub!")
end
