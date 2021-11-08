local bitser = require 'bitser'
local json = require 'dkjson'

local counter = 0

function lovehandles(code)
  counter = counter + 1

  local realcode = [[
local json = require 'dkjson'
local bitser = require 'bitser'

local a = {}
for _,v in pairs(arg) do
  table.insert(a, v)
end

print("THREAD: " .. json.encode(bitser.loads(a)))

function payload(args)
  ]] .. code .. [[
end

love.thread.getChannel('lovehandles]]..counter..[['):push(bitser.dumps(payload(bitser.loads(a))))]]
  
  local thread = love.thread.newThread(realcode)

  -- this is the initial function
  return function(...)
    thread:start(bitser.dumps(...))
    -- this is the async callback
    return function()
      local error = thread:getError()
      local _data = love.thread.getChannel('lovehandles'..counter):pop()
      local data = nil
      if _data then
        data = bitser.loads(_data)
        print('DATA: ' .. json.encode(data))
      end
      return data, error
    end
  end
end

return lovehandles