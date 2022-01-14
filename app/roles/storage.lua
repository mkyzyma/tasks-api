local task_storage = require('app.core.storage.task-storage')

local function init(opts)
  task_storage.init(opts)
  return true
end


return {
  role_name = 'storage',
  init = init,
  utils = {
    task_add = task_storage.task_add,
    task_update = task_storage.task_update,
  },
  dependencies = {'cartridge.roles.vshard-storage'},
}