local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

return {

  -- skel 
  s({ trig = [[skel]], desc = [[]] }, fmt([[
# @1?

@0?

]], {
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.expand("%:t:r")) }) end),
  [0] = i(0),
}, { delimiters = "@?", repeat_duplicates = true })),
  -- design 设计报告
  s({ trig = [[design]], desc = [[设计报告]] }, fmt([[
# @1?

## 背景

@0?

## 目标

### 需求

### 约束

## 方案

### 要点

### 优点

### 缺点

## 建议

## 实现


]], {
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.expand("%:t:r")) }) end),
  [0] = i(0),
}, { delimiters = "@?", repeat_duplicates = true })),
  -- refl Reference Link
  s({ trig = [[refl]], desc = [[Reference Link]] }, fmt([[
[@1?][@2?]@0?

[@x1?]: @3? "@4?"

]], {
  [1] = d(1, function(args, parent)
    local function __dyn_val()
            local sel = parent and (parent.snippet and parent.snippet.env or parent.env) and (parent.snippet and parent.snippet.env or parent.env).LS_SELECT_RAW
            if type(sel) == "table" then
              local txt = table.concat(sel, "\n")
              if txt ~= "" then return sel end
            elseif type(sel) == "string" then
              if sel ~= "" then return {sel} end
            end
            return {"Text"}
    end
    return sn(nil, { i(1, __dyn_val()) })
  end),
  [2] = i(2, "id"),
  [0] = i(0),
  x1 = f(function(args)
      local a = args[1][1] or ""
      if a ~= "" then return a end
      return args[2][1] or ""
    end, {2, 1}),
  [3] = i(3, "url"),
  [4] = d(4, function(args, parent) return sn(nil, { i(4, args[1][1] or "") }) end, {3}),
}, { delimiters = "@?", repeat_duplicates = true })),

}
