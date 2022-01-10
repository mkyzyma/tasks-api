local log = require('log')

local function task_add(task)
  box.space.json:insert(box.space.task:frommap(task))

  return {ok = true, error = nil}
end


local function init_space()
  log.info('>>>> init_space')
  local task = box.schema.space.create(
    'task',
    {
      format = {
        {name = 'bucket_id', type = 'unsigned'},
        {name = 'task_id', type = 'uuid'},
        {name = 'title', type = 'string'},
        {name = 'text', type = 'string'}
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
end

local function init(opts)
  if opts.is_master then
    init_space()

    box.schema.func.create('task_add', {if_not_exists = true})
  end

  init_globals()
end

return {
  init = init,
  task_add = task_add,
}