local add_path = require('vendor.lovehandles.add_path')

-- these are needed for lovehandles & my thread
add_path('vendor/bitser')
add_path('vendor/luajit-request')
add_path('vendor/lovehandles')
add_path('vendor/dkjson')

local lovehandles = require('lovehandles')

-- this sets up any other code, in a thread
local req = lovehandles([[
  local r = require("luajit-request")
  local url, options = ...
  return r.send(url, options)
]])

-- this holds a reference to the async thread
local google

function love.load()
  -- start the request, return immediately
  google = req('https://google.com', {})
end

function love.update(dt)
  local output, error = google()
  if output and not error then
    -- do something with text of the page
    print(output)
  end
end