local BaseController = require('app.core.api.base-controller')
local object = require('app.core.object')

local ListController = object.extend(BaseController)

function ListController:new()
  return BaseController:new('list', 'list_id')
end

return ListController