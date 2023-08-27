local os = require 'os'
local api = require 'api' 

local token = os.getenv('KODIK_TOKEN')
assert(token, "KODIK_TOKEN not set")

api.token = token

local vid = api.extract_video("https://kodik.info/seria/1167519/066949ab996988a81267dab0b4e0be00/720p")

p(vid)