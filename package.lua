  return {
    name = "kodik_lua_api",
    version = "0.0.1",
    description = "Kodik Lua API",
    tags = { "lua", "lit", "luvit" },
    license = "MIT",
    author = { name = "voidptr_t" },
    homepage = "https://github.com/SanceiLaks/kodik_lua_api",
    dependencies = {
      "creationix/coro-http",
      "creationix/base64"
    },
    files = {
      "libs/api.lua",
      "!test*",
    }
  }
  