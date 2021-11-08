local add_path = require('vendor.lovehandles.add_path')

-- these are needed for lovehandles & my thread
add_path('vendor/bitser')
add_path('vendor/luajit-request')
add_path('vendor/dkjson')

-- don't need to do this, but it makes the require nicer
add_path('vendor/lovehandles')
local lovehandles = require('lovehandles')

-- this is just for outputting readable objects to console
local json = require('dkjson')

-- this sets up any other code, in a thread
local req = lovehandles([[
  local req = require("luajit-request")
  local json = require("dkjson")
  local r = req.send(args[1], args[2] or {})
  if r and r.body then
    return json.decode(r.body)
  end
]])

-- this holds a reference to the async thread
local get_people

-- this holds the people object, once the request is finished (between update() and draw())
local people = {}

function love.load()
  -- start the request, return immediately
  get_people = req('https://swapi.dev/api/people')
end

function love.update(dt)
  local _people, error = get_people()
  if _people and not error then
    people = _people.results
  end
end

local screen_width = love.graphics.getWidth()
local screen_height = love.graphics.getHeight()


function love.draw()
  if #people == 0 then
    love.graphics.printf("Getting first page of Star Wars characters...", 10, (screen_height/2) - 6, screen_width, "center")
  end
  for i, person in pairs(people) do
    local y = (i-1) * 50
    love.graphics.printf("name: " .. person["name"], 10, 10 + y, screen_width, "left")
    love.graphics.printf("gender: " .. person["gender"], 10, 24 + y, screen_width, "left")
    love.graphics.printf("birth year: " .. person["birth_year"], 10, 38 + y, screen_width, "left")
  end
end
