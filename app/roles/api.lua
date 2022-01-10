local cartridge = require('cartridge')
local errors = require('errors')
local log = require('log')

local err_httpd = errors.new_class("httpd error")
local task_controller = require('app.core.api.task-controller')

local function init(opts)
  local httpd = cartridge.service_get('httpd')

  if not httpd then
      return nil, err_httpd:new("not found")
  end

  task_controller.init(httpd)

  return true;
end

return {
  role_name = 'api',
  init = init,
  dependencies = {'cartridge.roles.vshard-router'},
}
