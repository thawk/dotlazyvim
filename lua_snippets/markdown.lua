local ls = require("luasnip")

return {

  -- skel 
  ls.snippet({ trig = [[skel]], desc = [[]] }, {
    ls.text_node("# "),
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.expand("%:t:r")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node({"", "", ""}),
    ls.insert_node(0),
    ls.text_node({"", ""}),
  }),
  -- design 设计报告
  ls.snippet({ trig = [[design]], desc = [[设计报告]] }, {
    ls.text_node("# "),
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.expand("%:t:r")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node({"", "", "## 背景", "", ""}),
    ls.insert_node(0),
    ls.text_node({"", "", "## 目标", "", "### 需求", "", "### 约束", "", "## 方案", "", "### 要点", "", "### 优点", "", "### 缺点", "", "## 建议", "", "## 实现", "", ""}),
  }),
  -- refl Reference Link
  ls.snippet({ trig = [[refl]], desc = [[Reference Link]] }, {
    ls.text_node("["),
    ls.d(1, function(args, parent)
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
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node("]["),
    ls.insert_node(2, "id"),
    ls.text_node("]"),
    ls.insert_node(0),
    ls.text_node({"", "", "["}),
    ls.function_node(function(args)
      local a = args[1][1] or ""
      if a ~= "" then return a end
      return args[2][1] or ""
    end, {2, 1}),
    ls.text_node("]: "),
    ls.insert_node(3, "url"),
    ls.text_node(" \""),
    ls.d(4, function(args, parent)
      local function __dyn_val()
        return args[1][1] or ""
      end
      return ls.sn(nil, { ls.i(4, __dyn_val()) })
    end, {3}),
    ls.text_node({"\"", ""}),
  }),

}

