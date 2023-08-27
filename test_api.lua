local os = require 'os'
local api = require 'api' 

local token = os.getenv('KODIK_TOKEN')
assert(token, "KODIK_TOKEN not set")

api.token = token
local info = api.search("52034")

for _, v in ipairs(info) do
    assert(v.title == "Звёздное дитя")
    assert(v.shikimori_id == "52034")
end

print("OK")