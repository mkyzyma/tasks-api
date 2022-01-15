local Object = {}

local function extend (parent)
  local child = {}
  setmetatable(child,{__index = parent})
  return child
end

return {
  extend = extend
}