local cartridge = require('cartridge')
local errors = require('errors')

local err_httpd = errors.new_class("httpd error")
local TaskController = require('app.core.api.task-controller')

local function init(opts)
  local httpd = cartridge.service_get('httpd')

  if not httpd then
      return nil, err_httpd:new("not found")
  end

  TaskController:new()

  return true;
end

return {
  role_name = 'api',
  init = init,
  dependencies = {'cartridge.roles.vshard-router'},
}
