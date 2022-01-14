local log = require('log')
local cartridge = require('cartridge')
local errors = require('errors')

local err_vshard_router = errors.new_class("Vshard routing error")

-- TODO add functions for add, update and get
-- local function call(id, mode, function_name, arg_list)
--   log.info('>>>>> call');

--   local router = cartridge.service_get('vshard-router').get()
--   local bucket_id = router:bucket_id_strcrc32(id)

--   if mode == 'write' then
--     arg_list.bucket_id = bucket_id
--   end

--   log.info('>>>>> arg list');
--   log.info(arg_list);


--   return err_vshard_router:pcall(
--     router.call,
--     router,
--     bucket_id,
--     mode,
--     function_name,
--     {arg_list}
--   )
-- end

local function get_bucket_id(id, id_for_bucket)
  log.error('--------------------------')
  log.error(id or id_for_bucket)
  log.error('--------------------------')
  local router = cartridge.service_get('vshard-router').get()
  return router:bucket_id_strcrc32(id_for_bucket or id)
end

local function add(function_name, entity, id_for_bucket)
  log.info('>>>>> caller.add');

  local router = cartridge.service_get('vshard-router').get()
  entity.bucket_id = router:bucket_id_strcrc32(id_for_bucket)

  log.info('>>>>> entity');
  log.info(entity);

  return err_vshard_router:pcall(
    router.call,
    router,
    entity.bucket_id,
    'write',
    function_name,
    {entity}
  )
end

local function get_by_id(function_name, id, id_for_bucket)
  log.info('>>>>> caller.get_by_id');

  local router = cartridge.service_get('vshard-router').get()
  local bucket_id = get_bucket_id(id, id_for_bucket)

  log.info('>>>>> bucket_id');
  log.info(bucket_id);

  return err_vshard_router:pcall(
    router.call,
    router,
    bucket_id,
    'read',
    function_name,
    {id}
  )
end

return {
  add = add,
  get_by_id = get_by_id,
}