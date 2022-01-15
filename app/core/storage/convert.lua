local function tuple_to_table(format, tuple)
  local map = {}
  for i, v in ipairs(format) do
      map[v.name] = tuple[i]
  end
  return map
end

return {
  tuple_to_table = tuple_to_table
}