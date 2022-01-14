local log = require('log')
local uuid = require('uuid')

-- local function task_add(task)
--   log.info('>>>> task_add')
--   log.info(task)

--   box.space.task:insert(box.space.task:frommap(task))

--   return {ok = true, error = nil}
-- end

local function task_add(task)
  log.info('>>>> task_add')
  log.info(task)

  local t = box.space.task:frommap(task);

  log.error('t: ')
  log.error(t)

  box.space.task:insert(box.space.task:frommap(task))

  log.info('>>>> insert done')

  return {ok = true, error = nil}
end

local function task_get(id) 
  log.info('>>>> task_get')
  log.info(id)
  local task = box.space.task:get(uuid.fromstr(id))
  return { task = task, error = nil }
end

local function task_update(id, changes)
  log.info('>>>> task_update')
  log.info(changes)

  local task = changes
  task.task_id = id

  box.space.task:replace(box.space.task:frommap(task))

  return {ok = true, error = nil}
end


local function init_space()
  log.info('>>>> init_space')

  -- box.schema.space.task:drop();

  local task = box.schema.space.create(
    'task',
    {
      format = {
        {name = 'bucket_id', type = 'unsigned'},
        {name = 'task_id', type = 'uuid'},
        {name = 'title', type = 'string'},
        {name = 'text', type = 'string'},
      },
      if_not_exists = true,
    }
  )

  task:create_index('primary', {
    parts = {{ field = 'task_id'}},
    if_not_exists = true,
  })

  log.info('ok')
end

local function init_globals()
  rawset(_G, 'task_add', task_add)
  rawset(_G, 'task_update', task_update)
  rawset(_G, 'task_get', task_get)
end

local function init(opts)
  if opts.is_master then
    init_space()

    box.schema.func.create('task_add', {if_not_exists = true})
    box.schema.func.create('task_update', {if_not_exists = true})
    box.schema.func.create('task_get', {if_not_exists = true})
  end

  init_globals()
end

return {
  init = init,
  task_add = task_add,
  task_update = task_update,
  task_get = task_get
}