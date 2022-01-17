local cartridge = require('cartridge')
local errors = require('errors')

local err_vshard_router = errors.new_class("Vshard routing error")

local Crud = {}

function Crud:new(id_name, field_for_bucket)
  local self = {}
  
  local _id_name = id_name
  local _field_for_bucket = field_for_bucket or id_name

  local function get_bucket_id(id_for_bucket)
    local router = cartridge.service_get('vshard-router').get()
    return router:bucket_id_strcrc32(id_for_bucket)
  end

  function self.add(function_name, entity)
    local router = cartridge.service_get('vshard-router').get()
    entity.bucket_id = get_bucket_id(entity[_field_for_bucket])
  
    return err_vshard_router:pcall(
      router.callrw,
      router,
      entity.bucket_id,
      function_name,
      {entity}
    )
  end
  
  function self.get_by_id(function_name, id, field_for_bucket)
    local router = cartridge.service_get('vshard-router').get()
    local bucket_id = get_bucket_id(field_for_bucket or id)
  
    return err_vshard_router:pcall(
      router.callro,
      router,
      bucket_id,
      function_name,
      {id}
    )
  end

  function self.get_all(function_name, params)
    local router = cartridge.service_get('vshard-router').get()

    
    local value_for_bucket = params[field_for_bucket] or '0';
    local bucket_id = get_bucket_id(value_for_bucket)

    return err_vshard_router:pcall(
      router.callro,
      router,
      bucket_id,
      function_name,
      {params}
    )
  end

  function self.delete(function_name, id, field_for_bucket)
    local router = cartridge.service_get('vshard-router').get()
    local bucket_id = get_bucket_id(field_for_bucket or id)
  
    return err_vshard_router:pcallrw(
      router.call,
      router,
      bucket_id,
      function_name,
      {id}
    )
  end

  function self.update(function_name, id, entity)
    entity[_id_name] = id

    local router = cartridge.service_get('vshard-router').get()
    entity.bucket_id = get_bucket_id(entity[_field_for_bucket])
  
    return err_vshard_router:pcallrw(
      router.call,
      router,
      entity.bucket_id,
      function_name,
      {entity}
    )
  end

  return self
end


return Crud