local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local function uuid4()
  math.randomseed(os.time() * 1000 + (vim.fn.getpid() or 0))
  return (string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", "[xy]", function(c)
    local v = c == "x" and math.random(0, 15) or math.random(8, 11)
    return string.format("%x", v)
  end))
end

return {

  -- post Jekyll post header
  s({ trig = [[post]], desc = [[Jekyll post header]] }, fmt([[
---
title: @1?
layout: single
guid: @x1?
date: @x2?
categories:
  - @2?
tags:
  - @3?
---

@0?

]], {
  [1] = i(1, "title"),
  x1 = f(function() return uuid4() end),
  x2 = f(function() return os.date("%Y-%m-%d %H:%M:%S") end),
  [2] = i(2),
  [3] = i(3),
  [0] = i(0),
}, { delimiters = "@?", repeat_duplicates = true })),
  -- /img jekyll image path completion
  s({ trig = [[/img]], desc = [[jekyll image path completion]] }, fmt([[
/@1?/@x1?/@2?

]], {
  [1] = i(1, "images"),
  x1 = f(function()
      local p = vim.split(vim.fn.expand("%:t"), "-", {plain=true})
      if #p >= 3 then return table.concat({p[1], p[2], p[3]}, "/") end
      return ""
    end),
  [2] = i(2, "file.png"),
}, { delimiters = "@?", repeat_duplicates = true })),

}
