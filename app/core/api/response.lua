local function json_response(req, json, status) 
    local resp = req:render({json = json})
    resp.status = status
    return resp
end

local function internal_error_response(req, error)
    local resp = json_response(req, {
        info = "Internal error",
        error = error
    }, 500)
    return resp
end

return {
  json = json_response,
  internal_error = internal_error_response,
}