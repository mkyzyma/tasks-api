local convert = require('app.core.storage.convert')

local uuid = require('uuid')

local function task_add(task)
  task.list_id = uuid.fromstr(task.list_id)

  box.space.task:insert(box.space.task:frommap(task))

  return { task = task, error = nil}
end

local function task_update(task)
  task.task_id = uuid.fromstr(task.task_id)
  task.list_id = uuid.fromstr(task.list_id)

  box.space.task:replace(box.space.task:frommap(task))

  return { task = task, error = nil}
end


local function task_get(id) 
  local task = box.space.task:get(uuid.fromstr(id))
  return { task = convert.tuple_to_table(box.space.task:format(), task), error = nil }
end

local function task_select(params) 
  local tasks = {}

  if params.list_id ~= nil then
    local list_id = uuid.fromstr(params.list_id)
    tasks = box.space.task.index.list_id:select({list_id})
  else
    tasks = box.space.task:select()
  end
  return { tasks = convert.tuples_to_tables(box.space.task:format(), tasks), error = nil }
end

local function task_delete(id)
  box.space.task:delete(uuid.fromstr(id))

  return {ok = true, error = nil}
end

local function init_space()
  -- box.space.task:drop()
  local task = box.schema.space.create(
    'task',
    {
      format = {
        {name = 'bucket_id', type = 'unsigned'},
        {name = 'list_id', type = 'uuid'},
        {name = 'task_id', type = 'uuid'},
        {name = 'title', type = 'string'},
        {name = 'text', type = 'string'},
        {name = 'completed', type = 'boolean'},
      },
      if_not_exists = true,
    }
  )

  task:create_index('primary', {
    parts = {{ field = 'task_id'}},
    if_not_exists = true,
  })

  task:create_index('bucket_id', {
    parts = {{ field = 'bucket_id'}},
    unique = false,
    if_not_exists = true,
  })

  task:create_index('list_id', {
    parts = {{ field = 'list_id'}},
    unique = false,
    if_not_exists = true,
  })
end

local function init_globals()
  rawset(_G, 'task_add', task_add)
  rawset(_G, 'task_update', task_update)
  rawset(_G, 'task_get', task_get)
  rawset(_G, 'task_select', task_select)
  rawset(_G, 'task_delete', task_delete)
end

local function init(opts)
  if opts.is_master then
    init_space()

    box.schema.func.create('task_add', {if_not_exists = true})
    box.schema.func.create('task_update', {if_not_exists = true})
    box.schema.func.create('task_get', {if_not_exists = true})
    box.schema.func.create('task_select', {if_not_exists = true})
    box.schema.func.create('task_delete', {if_not_exists = true})
  end

  init_globals()
end

return {
  init = init,
  task_add = task_add,
  task_update = task_update,
  task_get = task_get,
  task_delete = task_delete,
  task_select = task_select
}