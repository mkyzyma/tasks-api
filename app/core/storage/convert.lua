local function tuple_to_table(format, tuple)
  local map = {}
  for i, v in ipairs(format) do
      map[v.name] = tuple[i]
  end
  return map
end

local function tuples_to_tables(format, tuples)
  local result = {}

  for i, v in ipairs(tuples) do
    result[i] = tuple_to_table(format, v)
  end

  return result;
end

return {
  tuple_to_table = tuple_to_table,
  tuples_to_tables = tuples_to_tables
}