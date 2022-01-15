local uuid = require('uuid')
local cartridge = require('cartridge')
local log = require('log')

local Crud = require('app.core.api.crud')
local response = require('app.core.api.response')


local BaseController = {}

function BaseController:new(entity_name, id_name, field_for_bucket)
  local o = {}
  setmetatable(o, self)
  self.__index = self

  local _crud = Crud:new(id_name, field_for_bucket)

  local function route_name()
    return entity_name .. 's'
  end

  local function add_function_name()
    return entity_name .. '_add'
  end

  local function update_function_name()
    return entity_name .. '_update'
  end

  local function delete_function_name()
    return entity_name .. '_delete'
  end

  local function get_by_id_function_name()
    return entity_name .. '_get'
  end

  local function handle_error(req, resp, error) 
    local e = error or resp.error
    return response.internal_error(req, e)
  end

  
  local function init_routes() 
    local httpd = cartridge.service_get('httpd')
    
    httpd:route(
      { path = '/' .. route_name(), method = 'POST', public = true}, self.add
    )
    httpd:route(
      { path = '/' .. route_name() .. '/:id', method = 'GET', public = true}, self.getById
    )
    httpd:route(
      { path = '/' .. route_name() .. '/:id', method = 'PUT', public = true}, self.update
    )
    httpd:route(
      { path = '/' .. route_name() .. '/:id', method = 'DELETE', public = true}, self.delete
    )
  end
  
  function self.add(req)
    local entity = req:json();
    entity[id_name] = uuid.new()

    log.error('!!!!')
    log.error('add')

    local resp, error = _crud.add(add_function_name(), entity)

    if error or resp.error then
      return handle_error(req, resp, error)
    end
  
    return response.json(req, resp[entity_name], 201)
  end

  function self.getById(req)
    local id = req:stash('id')
    
    local resp, error = _crud.get_by_id(get_by_id_function_name(), id)
  
    if error or resp.error then
      return handle_error(req, resp, error)
    end
  
    return response.json(req, resp[entity_name], 200)
  end

  function self.update(req)
    local entity = req:json();
    local id = req:stash('id')
    
    local resp, error = _crud.update(update_function_name(), id, entity)
  
    if error or resp.error then
      return handle_error(req, resp, error)
    end
  
    return response.json(req, resp[entity_name], 200)
  end

  function self.delete(req)
    local id = req:stash('id')
    
    local resp, error = _crud.delete(delete_function_name(), id)
  
    if error or resp.error then
      return handle_error(req, resp, error)
    end
  
    return response.json(req, {info = "Successfully deleted"}, 200)
  end

  init_routes()

  return o
end

return BaseController