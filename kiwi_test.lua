local kiwi = require'kiwi'
local now = require'time'.clock

local script = [[
vars x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20
x1 >= 1
x2 >= 1 + x1
x3 >= 1 + x2
x4 >= 1 + x3
x5 >= 1 + x4
x6 >= 1 + x5
x7 >= 1 + x6
x8 >= 1 + x7
x9 >= 1 + x8
x10 >= 1 + x9
x11 >= 1 + x10
x12 >= 1 + x11
x13 >= 1 + x12
x14 >= 1 + x13
x15 >= 1 + x14
x16 >= 1 + x15
x17 >= 1 + x16
x18 >= 1 + x17
x19 >= 1 + x18
x20 <= 1 + x19
]]

function string.startswith(str1, str2)
  return string.sub(str1, 1, string.len(str2)) == str2
end

local vars = {}
local cns = {}
local solver = kiwi.solver()

-- parse 'script'
for line in script:gmatch("([^\n]+)") do
  if line:startswith("vars ") then
    local parts = {}
    line:gsub("([^ \t\f]+)", function (c) parts[#parts+1] = c end)
    for i = 2, #parts, 1 do
      local var = kiwi.variable(parts[i])
      vars[#vars+1] = var
      vars[parts[i]] = var
    end
  else
    cns[#cns+1] = kiwi.parse_constraint(vars, line)
  end
end
for i, cn in ipairs(cns) do
  solver:add_constraint(cn)
end

solver:add_edit_variable(vars.x1, kiwi.strength.medium)
--solver:add_edit_variable(vars.x20, 0)
--solver:suggest_value(vars.x20, 0)

local n = 100000
print(('starting benchmark (%d iterations)'):format(n))
local start = now()
for i = 1, n do
  solver:suggest_value(vars.x1, i)
  solver:update_variables()
end
print(vars.x1)
print(vars.x2)
print(vars.x19)
print(vars.x20)
local stop = now()
print(('solved in %fms'):format((stop-start)*1000/n))
