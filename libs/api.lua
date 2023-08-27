local corohttp = require 'coro-http'
local json = require 'json'
local b64 = require 'base64'

---@class KodikTranslation
---@field id string
---@field title string
---@field type string

---@class KodikSeason
---@field link string
---@field title string
---@field episodes table

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
---@field quality Quality
---@field camrip boolean
---@field lgbt boolean
---@field blocked_countries string[]
---@field blocked_seasons string[]
---@field created_at string
---@field updated_at string
---@field seasons table<string, KodikSeason>
---@field screenshots string[]

---@alias Quality
---| '"360"'
---| '"480"'
---| '"720"' # most common
---| '"1080"' # rare

---@class KodikUrlInfo
---@field url string
---@field protocol string
---@field host string
---@field type string
---@field id string
---@field hash string
---@field quality Quality

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

---@param url string
---@return KodikUrlInfo
function api.player_url_info(url)
    ---@type string, string, string, string, string, string
    local protocol, host, type, id, hash, quality 
        = url:match("^([^:]+)://([a-z0-9]+%.[a-z]+)/([a-z]+)/(%d+)/([0-9a-z]+)/(%d+p)$")
    return {
        url = url,
        protocol = protocol,
        host = host,
        type = type,
        id = id,
        hash = hash,
        quality = quality
    }
end

---@return string[]
---@param url string kodik seria url
function api.extract_video(url)
    ---@param link string
    local function decode(link)
        local zc = utf8.codepoint('Z')

        ---@param s string
        local function replacer(s)
            local ec = utf8.codepoint(s)
            return utf8.char((ec <= zc and 90 or 122 ) >= ec + 13 and ec + 13 or ec + 13 - 26)
        end
        
        local finalstr = string.gsub(link, "%a", replacer)
        local len = #finalstr
        if len % 4 ~= 0 then 
            finalstr = finalstr .. string.rep("=", 4 - len % 4) 
        end

        return b64.decode(finalstr)
    end

    local linkinfo = api.player_url_info(url)

    local _, body = corohttp.request('POST', ("%s://%s/gvi?id=%s&hash=%s&token=%s&type=%s")
        :format(linkinfo.protocol, linkinfo.host, linkinfo.id, linkinfo.hash, api.token, linkinfo.type))
    local jsonbody = assert(json.decode(body))

    ---@type string[]
    local out = {}
    for _, v in pairs(jsonbody.links) do
        for _, v2 in pairs(v) do
            table.insert(out, decode(v2.src))
        end
    end

    return out
end

return api