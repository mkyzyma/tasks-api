local BaseController = require('app.core.api.base-controller')

local TaskController = {}

function TaskController:new()
  local o = BaseController:new('task', 'task_id', nil)
  setmetatable(o, self)
  self.__index = self
  return o
end

return TaskController