local api, uv = vim.api, vim.loop

local m = {}

---Pretty print
function m.P(...)
  local p = { ... }
  for i = 1, select("#", ...) do
    p[i] = vim.inspect(p[i])
  end
  print(table.concat(p, ", "))
  return ...
end

---Reload module
---@param mod string
---@return any
function m.R(mod)
  assert(type(mod) == "string", "expected string")
  package.loaded[mod] = nil
  return require(mod)
end

do
  local cache = {}
  ---Replace termcodes
  ---@param s string
  ---@return string
  function m.T(s)
    assert(type(s) == "string", "expected string")
    if not cache[s] then
      cache[s] = api.nvim_replace_termcodes(s, true, false, true)
    end
    return cache[s]
  end
end

---Print message
---@param text string message
---@param hlgroup? string highlight group
---@param history? boolean save to :messages history, defaults to false
---@overload fun(chunks: { [1]: string, [2]: string }[], history?: boolean)
function m.echo(text, hlgroup, history)
  if type(text) == "string" then
    assert(hlgroup == nil or type(hlgroup) == "string", "expected string as argument #2")
    if history == nil then
      history = false
    elseif type(history) ~= "boolean" then
      error("expected boolean as argument #2")
    end
    api.nvim_echo({ { text, hlgroup } }, history, {})
  elseif type(text) == "table" then
    if hlgroup == nil then
      hlgroup = false
    elseif type(hlgroup) ~= "boolean" then
      error("expected boolean as argument #2")
    end
    api.nvim_echo(text, hlgroup, {})
  else
    error("expected string or table as argument #1")
  end
end

---Print message and save it to :messages history
---@param text string message
---@param hlgroup? string highlight group
---@overload fun(chunks: { [1]: string, [2]: string }[])
function m.echomsg(text, hlgroup)
  if type(text) == "string" then
    m.echo(text, hlgroup, true)
  else
    m.echo(text, true)
  end
end

---Pack varargs
function m.pack(...)
  return { n = select("#", ...), ... }
end

---Unpack packed varargs
---@param pack table
---@param from? integer
---@param to? integer
function m.unpack(pack, from, to)
  return unpack(pack, from or 1, to or assert(pack.n, "not a pack"))
end

---Shallow copy
---@generic T : table
---@param t T
---@return T
function m.copy(t)
  assert(type(t) == "table", "expected table")
  local copy = {}
  for k, v in pairs(t) do
    copy[k] = v
  end
  return copy
end

---Create a lookup table
---@generic T
---@param t T[]
---@return table<T, boolean>
function m.make_lookup(t)
  assert(type(t) == "table", "expected table")
  local r = {}
  for _, v in ipairs(t) do
    r[v] = true
  end
  return r
end

---Filter table in place
---@generic T
---@param t T[]
---@param f fun(T): boolean
---@return T[]
function m.filter(t, f)
  local len = #t
  local j = 1
  for i = 1, len do
    t[j], t[i] = t[i], nil
    if f(t[j]) then
      j = j + 1
    end
  end
  for i = j, len do
    t[i] = nil
  end
  return t
end

---Reverse table in place
---@generic T
---@param t T[]
---@return T[]
function m.reverse(t)
  assert(type(t) == "table", "expected table")
  local len = #t
  for i = 0, len / 2 - 1 do
    t[i + 1], t[len - i] = t[len - i], t[i + 1]
  end
  return t
end

---Reversed ipairs
---@generic T
---@param t T[]
---@return fun(): number, T
function m.rpairs(t)
  assert(type(t) == "table", "expected table")
  local i = #t
  return function()
    local k, v = i, t[i]
    i = i - 1
    if k > 0 then
      return k, v
    end
  end
end

---Everything that is not indexed by ipairs
---@generic K, V
---@param t table<K, V>
---@return fun(): K, V
function m.kpairs(t)
  assert(type(t) == "table", "expected table")

  if t[1] == nil then
    return pairs(t)
  end

  -- `#` behavior is undefined when table is not a sequence.
  -- traverse through the table to get the real length.
  local i = 1
  while t[i + 1] ~= nil do
    i = i + 1
  end

  local modf = math.modf
  local k, v
  return function()
    repeat
      k, v = next(t, k)
    until type(k) ~= "number" or k < 1 or k > i or select(2, modf(k)) ~= 0
    return k, v
  end
end

---Find index of an element in a table
---@param t table
---@param v any
---@return integer|nil
function m.indexof(t, v)
  if v ~= nil then
    for i, vv in ipairs(t) do
      if v == vv then
        return i
      end
    end
  end
end

---Create a new debounce timer
---@param ms integer
---@param fast? boolean
function m.new_debounce(ms, fast)
  assert(type(ms) == "number", "expected number as argument #1")
  assert(fast == nil or type(fast) == "boolean", "expected boolean as argument #2")

  local timer = uv.new_timer() -- rely on gc?
  ---@param func function
  return function(func, ...)
    assert(type(func) == "function", "expected function as argument #1")
    local args = m.pack(...)
    timer:stop()
    timer:start(ms, 0, function()
      timer:stop()
      if fast or not vim.in_fast_event() then
        func(m.unpack(args))
      else
        vim.schedule(function()
          func(m.unpack(args))
        end)
      end
    end)
  end
end

---Wrap function with a debounce timer
---@generic F : function
---@param func F
---@param ms integer
---@param fast? boolean
---@return F
function m.debounce_wrap(func, ms, fast)
  assert(type(func) == "function", "expected function as argument #1")
  assert(type(ms) == "number", "expected number as argument #2")
  assert(fast == nil or type(fast) == "boolean", "expected boolean as argument #3")

  local debounce = m.new_debounce(ms, fast)
  return function(...)
    debounce(func, ...)
  end
end

---Profiling
---@param ts number? timestamp
---@param msg string? message
---@return number
function m.reltime(ts, msg)
  if ts then
    local f = (uv.hrtime() - ts) / 1000000
    print(("%-20s %.3fms"):format(msg or "", f))
  end
  return uv.hrtime()
end

---Benchmark function
---@param func function
---@param count integer
---@param warmup? integer
function m.bench(func, count, warmup)
  for _ = 1, warmup or 0 do
    func()
  end
  local ts = uv.hrtime()
  for _ = 1, count do
    func()
  end
  print(("%.3fms"):format((uv.hrtime() - ts) / 1000000))
end

return m
