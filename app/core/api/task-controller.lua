local cartridge = require('cartridge')
local errors = require('errors')
local log = require('log')
local uuid = require('uuid')
local response = require('app.core.api.response')
local crud = require('app.core.api.crud')

local err_vshard_router = errors.new_class("Vshard routing error")

local function handle_error(req, resp, error) 
  local e = error or resp.error
  return response.internal_error(req, e)
end

local function add(req)
  local task = req:json();

  task.task_id = uuid.new()

  -- task.task_id = task.id

  local resp, error = crud.add('task_add', task, task.task_id)

  if error or resp.error then
    return handle_error(req, resp, error)
  end

  return response.json(
    req, 
    {info = "Successfully created", id = task.task_id}, 
    201
  )
end

local function getById(req)
  local task_id = req:stash('id')
  
  local resp, error = crud.get_by_id('task_get', task_id)

  if error or resp.error then
    return handle_error(req, resp, error)
  end

  return response.json(req, resp.task, 200)
end

local function update(req)
  -- local task_id = req:stash('id')
  -- local changes = req:json();
  
  -- local resp, error = crud.call(task_id, 'write', 'task_update', {task_id, changes})

  -- if error or resp.error then
  --   return handle_error(req, resp, error)
  -- end

  -- return response.json(req, resp.task, 200)
end

local function delete(req)
  return response.json(req, { info = 'delete' }, 200)
end

local function init(httpd)
  log.info('>>> json-controller.init')
  httpd:route(
    { path = '/tasks', method = 'POST', public = true}, add
  )
  httpd:route(
    { path = '/tasks/:id', method = 'GET', public = true}, getById
  )
  httpd:route(
    { path = '/tasks/:id', method = 'PUT', public = true}, update
  )
  httpd:route(
    { path = '/tasks/:id', method = 'DELETE', public = true}, delete
  )
  log.info('>>> json-controller.init ok')
end

return {
  init = init
}