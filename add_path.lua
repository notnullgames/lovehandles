-- add to love's require-path
local function add_path(path)
  if(love.system.getOS() ~= "Web") then
    love.filesystem.setCRequirePath(path.."/??;??"..';'..love.filesystem.getCRequirePath())
  end
  love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ';' .. path.."/?.lua;"..path.."/?/init.lua")
end

return add_path