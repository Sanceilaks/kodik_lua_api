local api = require "api"
local os = require 'os'

local token = os.getenv('KODIK_TOKEN')
assert(token, "KODIK_TOKEN not set")

api.token = token
local info = api.search("52034")[1]
local ep = info.seasons['1'].episodes['1']

local info = api.player_url_info('https:' .. ep)

assert(info.hash)
assert(info.type == 'seria' or info.type == 'serial')

print("OK")