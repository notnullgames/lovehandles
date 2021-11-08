local bitser = require 'bitser'

local counter = 0

function lovehandles(code)
  counter = counter + 1

  local realcode = [[
    local bitser = require 'bitser'

    function payload(args)
      ]] .. code .. [[
    end

    local _args = ...
    love.thread.getChannel('lovehandles]]..counter..[['):push(bitser.dumps(payload(bitser.loads(_args))))
  ]]

  print(realcode)
  
  local thread = love.thread.newThread(realcode)

  -- this is the initial function
  return function(...)
    thread:start(bitser.dumps(arg))
    -- this is the async callback
    return function()
      local error = thread:getError()
      local _data = love.thread.getChannel('lovehandles'..counter):pop()
      local data = nil
      if _data then
        print('DATA:' .. _data)
        data = bitser.loads(_data)
      end
      return data, error
    end
  end
end

return lovehandles