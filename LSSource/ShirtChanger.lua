local NewShirt = nil;
local req = http_request or request or HttpPost or syn.request;
GetShirt = function()
    local shirt;
    repeat shirt = Shirts[math.random(1, #Shirts)] until shirt ~= NewShirt
    return shirt;
end

FetchXCSRF = function()
    local headers = {
        Cookie = ".ROBLOSECURITY="..cookie,
        ["content-type"] = "application/json"
    }
    local response = req({Url = "https://auth.roblox.com/v2/logout", Body = nil, Method = "POST", Headers = headers})
    return response.Headers["x-csrf-token"];
end

repeat wait() until game:IsLoaded();

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Died:Connect(function()
        local xcsrf = FetchXCSRF()
        NewShirt = GetShirt()
        local url = "https://avatar.roblox.com/v1/avatar/assets/"..tostring(NewShirt).."/wear"
        local headers = {
            Cookie = ".ROBLOSECURITY="..cookie,
            ["X-CSRF-TOKEN"] = xcsrf,
            ["content-type"] = "application/json"
        }
        local a = {Url = url, Body = nil, Method = "POST", Headers = headers}
        local res = req(a)
    end)
end)