local cartridge = require('cartridge')
local errors = require('errors')
local log = require('log')
local uuid = require('uuid')
local response = require('app.core.api.response')

local function add(req)
  return response.json(req, { info = 'add' }, 201)
end

local function get(req)
  return response.json(req, { info = 'get' }, 200)
end

local function getById(req)
  return response.json(req, { info = 'getById' }, 200)
end

local function update(req)
  return response.json(req, { info = 'update' }, 200)
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
    { path = '/tasks', method = 'GET', public = true}, get
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