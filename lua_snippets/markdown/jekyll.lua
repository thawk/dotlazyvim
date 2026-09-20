local ls = require("luasnip")
local function uuid4()
  math.randomseed(os.time() * 1000 + (vim.fn.getpid() or 0))
  return (string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", "[xy]", function(c)
    local v = c == "x" and math.random(0, 15) or math.random(8, 11)
    return string.format("%x", v)
  end))
end

return {

  -- post Jekyll post header
  ls.snippet({ trig = [[post]], desc = [[Jekyll post header]] }, {
    ls.text_node({"---", "title: "}),
    ls.insert_node(1, "title"),
    ls.text_node({"", "layout: single", "guid: "}),
    ls.function_node(function() return uuid4() end),
    ls.text_node({"", "date: "}),
    ls.function_node(function() return os.date("%Y-%m-%d %H:%M:%S") end),
    ls.text_node({"", "categories:", "  - "}),
    ls.insert_node(2),
    ls.text_node({"", "tags:", "  - "}),
    ls.insert_node(3),
    ls.text_node({"", "---", "", ""}),
    ls.insert_node(0),
    ls.text_node({"", ""}),
  }),
  -- /img jekyll image path completion
  ls.snippet({ trig = [[/img]], desc = [[jekyll image path completion]] }, {
    ls.text_node("/"),
    ls.insert_node(1, "images"),
    ls.text_node("/"),
    ls.function_node(function()
      local p = vim.split(vim.fn.expand("%:t"), "-", {plain=true})
      if #p >= 3 then return table.concat({p[1], p[2], p[3]}, "/") end
      return ""
    end),
    ls.text_node("/"),
    ls.insert_node(2, "file.png"),
    ls.text_node({"", ""}),
  }),

}

