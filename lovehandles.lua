local bitser = require 'bitser'

local counter = 0

function lovehandles(code)
  -- this is the initial function
  return function(...)
    counter = counter + 1

    local realcode = [[
local bitser = require 'bitser'

local args = bitser.loads(...)

function payload()
  ]] .. code .. [[
end
love.thread.getChannel('lovehandles]]..counter..[['):push(bitser.dumps(payload()))
]]
    
    local thread = love.thread.newThread(realcode)
  
    thread:start(bitser.dumps({...}))
    local error = nil
    local data = nil
    -- this is the async callback
    return function()
      if not error then
        error = thread:getError()
      end
      if not data then
        local _data = love.thread.getChannel('lovehandles'..counter):pop()
        if _data then
          data = bitser.loads(_data)
        end
      end
      return data, error
    end
  end
end

return lovehandles