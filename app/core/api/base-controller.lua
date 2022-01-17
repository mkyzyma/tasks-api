local uuid = require('uuid')
local cartridge = require('cartridge')

local Crud = require('app.core.api.crud')
local response = require('app.core.api.response')
local json = require("json")


local BaseController = {}

function BaseController:new(entity_name, id_name, field_for_bucket)
  local public = {}
  setmetatable(public, self)
  self.__index = self

  public.crud = Crud:new(id_name, field_for_bucket)

  function public:route_name()
    return entity_name .. 's'
  end

  function public:add_function_name()
    return entity_name .. '_add'
  end

  function public:update_function_name()
    return entity_name .. '_update'
  end

  function public:delete_function_name()
    return entity_name .. '_delete'
  end

  function public:get_by_id_function_name()
    return entity_name .. '_get'
  end

  function public:select_function_name()
    return entity_name .. '_select'
  end

  function public:handle_error(req, resp, error) 
    local e = error or resp.error
    return response.internal_error(req, e)
  end

  
  function public:init_routes() 
    local httpd = cartridge.service_get('httpd')
    
    httpd:route(
      { path = '/' .. public:route_name(), method = 'POST', public = true}, self.add
    )
    httpd:route(
      { path = '/' .. public:route_name(), method = 'GET', public = true}, self.select
    )
    httpd:route(
      { path = '/' .. public:route_name() .. '/:id', method = 'GET', public = true}, self.getById
    )
    httpd:route(
      { path = '/' .. public:route_name() .. '/:id', method = 'PUT', public = true}, self.update
    )
    httpd:route(
      { path = '/' .. public:route_name() .. '/:id', method = 'DELETE', public = true}, self.delete
    )
  end
  
  function public.add(req)
    local entity = req:json();
    entity[id_name] = uuid.new()

    local resp, error = public.crud.add(public:add_function_name(), entity)

    if error or resp.error then
      return public:handle_error(req, resp, error)
    end
  
    return response.json(req, resp[entity_name], 201)
  end

  function public.getById(req)
    local id = req:stash('id')
    
    local resp, error = public.crud.get_by_id(public:get_by_id_function_name(), id)
  
    if error or resp.error then
      return public:handle_error(req, resp, error)
    end
  
    return response.json(req, resp[entity_name], 200)
  end

  function public.select(req)
    local params = req:query_param()

    local resp, error = public.crud.get_all(public:select_function_name(), params)
    
    if error or resp.error then
      return public:handle_error(req, resp, error)
    end
  
    return response.json(req, resp[entity_name .. 's'], 200)
  end

  function public.update(req)
    local entity = req:json();
    local id = req:stash('id')
    
    local resp, error = self.crud.update(public:update_function_name(), id, entity)
  
    if error or resp.error then
      return public:handle_error(req, resp, error)
    end
  
    return response.json(req, resp[entity_name], 200)
  end

  function public.delete(req)
    local id = req:stash('id')
    
    local resp, error = self.crud.delete(public:delete_function_name(), id)
  
    if error or resp.error then
      return public:handle_error(req, resp, error)
    end
  
    return response.json(req, {info = "Successfully deleted"}, 200)
  end

  return public
end

return BaseController