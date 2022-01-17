local convert = require('app.core.storage.convert')

local uuid = require('uuid')

local function list_add(list)
  box.space.list:insert(box.space.list:frommap(list))

  return { list = list, error = nil}
end

local function list_update(list)
  list.list_id = uuid.fromstr(list.list_id)

  box.space.list:replace(box.space.list:frommap(list))

  return { list = list, error = nil}
end


local function list_get(id) 
  local list = box.space.list:get(uuid.fromstr(id))
  return { list = convert.tuple_to_table(box.space.list:format(), list), error = nil }
end

local function list_select(params) 
  local lists = box.space.list:select(params)
  return { lists = convert.tuples_to_tables(box.space.list:format(), lists), error = nil }
end

local function list_delete(id)
  box.space.list:delete(uuid.fromstr(id))

  return {ok = true, error = nil}
end

local function init_space()
  -- box.space.list:drop()
  local list = box.schema.space.create(
    'list',
    {
      format = {
        {name = 'bucket_id', type = 'unsigned'},
        {name = 'list_id', type = 'uuid'},
        {name = 'title', type = 'string'},
        {name = 'text', type = 'string'},
      },
      if_not_exists = true,
    }
  )

  list:create_index('primary', {
    parts = {{ field = 'list_id'}},
    if_not_exists = true,
  })

  list:create_index('bucket_id', {
    parts = {{ field = 'bucket_id'}},
    unique = false,
    if_not_exists = true,
  })

  list:create_index('list_id', {
    parts = {{ field = 'list_id'}},
    unique = false,
    if_not_exists = true,
  })
end

local function init_globals()
  rawset(_G, 'list_add', list_add)
  rawset(_G, 'list_update', list_update)
  rawset(_G, 'list_get', list_get)
  rawset(_G, 'list_delete', list_delete)
  rawset(_G, 'list_select', list_select)
end

local function init(opts)
  if opts.is_master then
    init_space()

    box.schema.func.create('list_add', {if_not_exists = true})
    box.schema.func.create('list_update', {if_not_exists = true})
    box.schema.func.create('list_get', {if_not_exists = true})
    box.schema.func.create('list_delete', {if_not_exists = true})
    box.schema.func.create('list_select', {if_not_exists = true})
  end

  init_globals()
end

return {
  init = init,
  list_add = list_add,
  list_update = list_update,
  list_get = list_get,
  list_delete = list_delete,
  list_select = list_select
}