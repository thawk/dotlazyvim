local ls = require("luasnip")

return {

  -- ut unittest skel
  ls.snippet({ trig = [[ut]], desc = [[unittest skel]] }, {
    ls.text_node({"#include <boost/test/unit_test.hpp>", "#include <boost/system/error_code.hpp>", "#include <turtle/mock.hpp>", "#include <"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.findfile(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") .. ".h", vim.fn.substitute(vim.fn.expand("%:p"), "\\<unittest/.*", "include/**", ""), 1), ".*\\<include/", "", "") end),
    ls.text_node({">", "", "using namespace "}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.fnamemodify(vim.fn.substitute(vim.fn.findfile(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") .. ".h", vim.fn.substitute(vim.fn.expand("%:p"), "\\<unittest/.*", "include/**", ""), 1), ".*\\<include/", "", ""), ":p:h"), "[.-]", "_", "g"), "/", "::", "g") end),
    ls.text_node({";", "using boost::system::error_code;", "", "BOOST_AUTO_TEST_SUITE(test_"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") end),
    ls.text_node({");", "", "struct Fixture", "{", "	"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
    ls.text_node(" "),
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node({";", "", "	Fixture()", "	: "}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("("),
    ls.insert_node(2),
    ls.text_node({")", "	{", "	}", "};", "", ""}),
    ls.insert_node(0),
    ls.text_node({"", "", "BOOST_AUTO_TEST_SUITE_END()", ""}),
  }),
  -- sut1 unittest for sscc::*
  ls.snippet({ trig = [[sut1]], desc = [[unittest for sscc::*]] }, {
    ls.text_node({"#include <boost/test/unit_test.hpp>", "#include <boost/system/error_code.hpp>", "#include <turtle/mock.hpp>", "#include \"../src/"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") end),
    ls.text_node({".h\"", "", "using namespace sscc"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:p:h"), "/unittest\\>", "", ""), "[.-]", "_", "g"), "^.*\\(\\(/[^/]\\+\\)\\{1}\\)$", "\\1", ""), "/", "::", "g") end),
    ls.text_node({";", "using boost::system::error_code;", "", "BOOST_AUTO_TEST_SUITE(test_"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") end),
    ls.text_node({");", "", "struct Fixture", "{", "	"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
    ls.text_node(" "),
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node({";", "", "	Fixture()", "	: "}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("("),
    ls.insert_node(2),
    ls.text_node({")", "	{", "	}", "};", "", ""}),
    ls.insert_node(0),
    ls.text_node({"", "", "BOOST_AUTO_TEST_SUITE_END()", ""}),
  }),
  -- sut2 sscc::*::*
  ls.snippet({ trig = [[sut2]], desc = [[sscc::*::*]] }, {
    ls.text_node({"#include <boost/test/unit_test.hpp>", "#include <boost/system/error_code.hpp>", "#include <turtle/mock.hpp>", "#include \"../src/"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") end),
    ls.text_node({".h\"", "", "using namespace sscc"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:p:h"), "/unittest\\>", "", ""), "[.-]", "_", "g"), "^.*\\(\\(/[^/]\\+\\)\\{2}\\)$", "\\1", ""), "/", "::", "g") end),
    ls.text_node({";", "using boost::system::error_code;", "", "BOOST_AUTO_TEST_SUITE(test_"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") end),
    ls.text_node({");", "", "struct Fixture", "{", "	"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
    ls.text_node(" "),
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node({";", "", "	Fixture()", "	: "}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("("),
    ls.insert_node(2),
    ls.text_node({")", "	{", "	}", "};", "", ""}),
    ls.insert_node(0),
    ls.text_node({"", "", "BOOST_AUTO_TEST_SUITE_END()", ""}),
  }),
  -- sut3 sscc::*::*::*
  ls.snippet({ trig = [[sut3]], desc = [[sscc::*::*::*]] }, {
    ls.text_node({"#include <boost/test/unit_test.hpp>", "#include <boost/system/error_code.hpp>", "#include <turtle/mock.hpp>", "#include \"../src/"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") end),
    ls.text_node({".h\"", "", "using namespace sscc"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:p:h"), "/unittest\\>", "", ""), "[.-]", "_", "g"), "^.*\\(\\(/[^/]\\+\\)\\{3}\\)$", "\\1", ""), "/", "::", "g") end),
    ls.text_node({";", "using boost::system::error_code;", "", "BOOST_AUTO_TEST_SUITE(test_"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") end),
    ls.text_node({");", "", "struct Fixture", "{", "	"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
    ls.text_node(" "),
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node({";", "", "	Fixture()", "	: "}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("("),
    ls.insert_node(2),
    ls.text_node({")", "	{", "	}", "};", "", ""}),
    ls.insert_node(0),
    ls.text_node({"", "", "BOOST_AUTO_TEST_SUITE_END()", ""}),
  }),
  -- tc unittest for any class
  ls.snippet({ trig = [[tc]], desc = [[unittest for any class]] }, {
    ls.text_node({"/**", " * @class "}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.fnamemodify(vim.fn.substitute(vim.fn.findfile(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") .. ".h", vim.fn.substitute(vim.fn.expand("%:p"), "\\<unittest/.*", "include/**", ""), 1), ".*\\<include/", "", ""), ":p:h"), "[.-]", "_", "g"), "/", "::", "g") end),
    ls.text_node("::"),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
    ls.text_node({"", " * @test "}),
    ls.insert_node(1),
    ls.text_node({"\\n", " * <b>输入数据：</b> "}),
    ls.insert_node(2),
    ls.text_node({"\\n", " * <b>预期输出：</b> "}),
    ls.insert_node(3),
    ls.text_node({"", " */", "BOOST_FIXTURE_TEST_CASE(Test"}),
    ls.insert_node(4),
    ls.text_node(", "),
    ls.insert_node(5, "Fixture"),
    ls.text_node({")", "{", "	"}),
    ls.insert_node(0),
    ls.text_node({"", "}", ""}),
  }),
  -- tc data-driven unittest
  ls.snippet({ trig = [[tc]], desc = [[data-driven unittest]] }, {
    ls.text_node({"/**", " * @class "}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.fnamemodify(vim.fn.substitute(vim.fn.findfile(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") .. ".h", vim.fn.substitute(vim.fn.expand("%:p"), "\\<unittest/.*", "include/**", ""), 1), ".*\\<include/", "", ""), ":p:h"), "[.-]", "_", "g"), "/", "::", "g") end),
    ls.text_node("::"),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
    ls.text_node({"", " * @test "}),
    ls.insert_node(1),
    ls.text_node({"\\n", " * <b>输入数据：</b> "}),
    ls.insert_node(2),
    ls.text_node({"\\n", " * <b>预期输出：</b> "}),
    ls.insert_node(3),
    ls.text_node({"", " */", "BOOST_DATA_TEST_CASE(Test"}),
    ls.insert_node(4),
    ls.text_node(", "),
    ls.insert_node(5, "dataset"),
    ls.text_node(", "),
    ls.insert_node(6, "param"),
    ls.text_node({")", "{", "	"}),
    ls.insert_node(0),
    ls.text_node({"", "}", ""}),
  }),
  -- tc data-driven unittest with fixture
  ls.snippet({ trig = [[tc]], desc = [[data-driven unittest with fixture]] }, {
    ls.text_node({"/**", " * @class "}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.fnamemodify(vim.fn.substitute(vim.fn.findfile(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") .. ".h", vim.fn.substitute(vim.fn.expand("%:p"), "\\<unittest/.*", "include/**", ""), 1), ".*\\<include/", "", ""), ":p:h"), "[.-]", "_", "g"), "/", "::", "g") end),
    ls.text_node("::"),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
    ls.text_node({"", " * @test "}),
    ls.insert_node(1),
    ls.text_node({"\\n", " * <b>输入数据：</b> "}),
    ls.insert_node(2),
    ls.text_node({"\\n", " * <b>预期输出：</b> "}),
    ls.insert_node(3),
    ls.text_node({"", " */", "BOOST_DATA_TEST_CASE_F("}),
    ls.insert_node(4, "Fixture"),
    ls.text_node(", Test"),
    ls.insert_node(5),
    ls.text_node(", "),
    ls.insert_node(6, "dataset"),
    ls.text_node(", "),
    ls.insert_node(7, "param"),
    ls.text_node({")", "{", "	"}),
    ls.insert_node(0),
    ls.text_node({"", "}", ""}),
  }),
  -- stc1 unittest for sscc::*
  ls.snippet({ trig = [[stc1]], desc = [[unittest for sscc::*]] }, {
    ls.text_node({"/**", " * @class sscc::"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:p:h"), "/unittest\\>", "", ""), "[.-]", "_", "g"), "^.*/\\([^/]\\+\\)$", "\\1", ""), "/", "::", "g") end),
    ls.text_node("::"),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
    ls.text_node({"", " * @test "}),
    ls.insert_node(1),
    ls.text_node({"\\n", " * <b>输入数据：</b> "}),
    ls.insert_node(2),
    ls.text_node({"\\n", " * <b>预期输出：</b> "}),
    ls.insert_node(3),
    ls.text_node({"", " */", "BOOST_FIXTURE_TEST_CASE(Test"}),
    ls.insert_node(4),
    ls.text_node({", Fixture)", "{", "	"}),
    ls.insert_node(0),
    ls.text_node({"", "}", ""}),
  }),
  -- stc2 unittest for sscc::*::*
  ls.snippet({ trig = [[stc2]], desc = [[unittest for sscc::*::*]] }, {
    ls.text_node({"/**", " * @class sscc::"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:p:h"), "/unittest\\>", "", ""), "[.-]", "_", "g"), "^.*/\\([^/]\\+/[^/]\\+\\)$", "\\1", ""), "/", "::", "g") end),
    ls.text_node("::"),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
    ls.text_node({"", " * @test "}),
    ls.insert_node(1),
    ls.text_node({"\\n", " * <b>输入数据：</b> "}),
    ls.insert_node(2),
    ls.text_node({"\\n", " * <b>预期输出：</b> "}),
    ls.insert_node(3),
    ls.text_node({"", " */", "BOOST_FIXTURE_TEST_CASE(Test"}),
    ls.insert_node(4),
    ls.text_node({", Fixture)", "{", "	"}),
    ls.insert_node(0),
    ls.text_node({"", "}", ""}),
  }),
  -- stc3 unittest for sscc::*::*::*
  ls.snippet({ trig = [[stc3]], desc = [[unittest for sscc::*::*::*]] }, {
    ls.text_node({"/**", " * @class sscc::"}),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:p:h"), "/unittest\\>", "", ""), "[.-]", "_", "g"), "^.*/\\([^/]\\+/[^/]\\+/[^/]\\+\\)$", "\\1", ""), "/", "::", "g") end),
    ls.text_node("::"),
    ls.function_node(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
    ls.text_node({"", " * @test "}),
    ls.insert_node(1),
    ls.text_node({"\\n", " * <b>输入数据：</b> "}),
    ls.insert_node(2),
    ls.text_node({"\\n", " * <b>预期输出：</b> "}),
    ls.insert_node(3),
    ls.text_node({"", " */", "BOOST_FIXTURE_TEST_CASE(Test"}),
    ls.insert_node(4),
    ls.text_node({", Fixture)", "{", "	"}),
    ls.insert_node(0),
    ls.text_node({"", "}", ""}),
  }),

}

