local BaseController = require('app.core.api.base-controller')
local object = require('app.core.object')

local TaskController = object.extend(BaseController)

function TaskController:new()
  return BaseController:new('task', 'task_id', 'list_id')
end

return TaskController