local corohttp = require 'coro-http'
local json = require 'json'

---@class KodikTranslation
---@field id string
---@field title string
---@field type string

---@class KodikSeason
---@field link string
---@field title string
---@field episodes string[]

---@class KodikSerialInfo
---@field id string
---@field link string
---@field title string
---@field title_orig string
---@field other_title string
---@field translation KodikTranslation
---@field year string
---@field last_season string
---@field last_episode string
---@field episodes_count string
---@field kinopoisk_id string
---@field imdb_id string
---@field worldart_link string
---@field shikimori_id string
---@field quality string
---@field camrip boolean
---@field lgbt boolean
---@field blocked_countries string[]
---@field blocked_seasons string[]
---@field created_at string
---@field updated_at string
---@field seasons KodikSeason[]
---@field screenshots string[]

local api = {
    token = "",
}
---search for translations by shikimori_id
---@param shikimori_id string
---@return KodikSerialInfo[]
function api.search(shikimori_id)
    assert(api.token, "Token is not set")
    local _, body = corohttp.request('GET', 
        ("https://kodikapi.com/search?token=%s&shikimori_id=%s&with_seasons=true&with_episodes=true"):format(api.token, shikimori_id))
    local data = assert(json.decode(body))
    return assert(data.results, "No results found")
end

return api