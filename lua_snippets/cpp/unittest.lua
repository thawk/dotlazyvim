local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

return {

  -- ut unittest skel
  s({ trig = [[ut]], desc = [[unittest skel]] }, fmt([[
#include <boost/test/unit_test.hpp>
#include <boost/system/error_code.hpp>
#include <turtle/mock.hpp>
#include <@x1?>

using namespace @x2?;
using boost::system::error_code;

BOOST_AUTO_TEST_SUITE(test_@x3?);

struct Fixture
{
	@x4? @1?;

	Fixture()
	: @1?(@2?)
	{
	}
};

@0?

BOOST_AUTO_TEST_SUITE_END()

]], {
  x1 = f(function() return vim.fn.substitute(vim.fn.findfile(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") .. ".h", vim.fn.substitute(vim.fn.expand("%:p"), "\\<unittest/.*", "include/**", ""), 1), ".*\\<include/", "", "") end),
  x2 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.fnamemodify(vim.fn.substitute(vim.fn.findfile(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") .. ".h", vim.fn.substitute(vim.fn.expand("%:p"), "\\<unittest/.*", "include/**", ""), 1), ".*\\<include/", "", ""), ":p:h"), "[.-]", "_", "g"), "/", "::", "g") end),
  x3 = f(function() return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") end),
  x4 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "")) }) end),
  [2] = i(2),
  [0] = i(0),
}, { delimiters = "@?", repeat_duplicates = true })),
  -- sut1 unittest for sscc::*
  s({ trig = [[sut1]], desc = [[unittest for sscc::*]] }, fmt([[
#include <boost/test/unit_test.hpp>
#include <boost/system/error_code.hpp>
#include <turtle/mock.hpp>
#include "../src/@x1?.h"

using namespace sscc@x2?;
using boost::system::error_code;

BOOST_AUTO_TEST_SUITE(test_@x3?);

struct Fixture
{
	@x4? @1?;

	Fixture()
	: @1?(@2?)
	{
	}
};

@0?

BOOST_AUTO_TEST_SUITE_END()

]], {
  x1 = f(function() return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") end),
  x2 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:p:h"), "/unittest\\>", "", ""), "[.-]", "_", "g"), "^.*\\(\\(/[^/]\\+\\)\\{1}\\)$", "\\1", ""), "/", "::", "g") end),
  x3 = f(function() return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") end),
  x4 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "")) }) end),
  [2] = i(2),
  [0] = i(0),
}, { delimiters = "@?", repeat_duplicates = true })),
  -- sut2 sscc::*::*
  s({ trig = [[sut2]], desc = [[sscc::*::*]] }, fmt([[
#include <boost/test/unit_test.hpp>
#include <boost/system/error_code.hpp>
#include <turtle/mock.hpp>
#include "../src/@x1?.h"

using namespace sscc@x2?;
using boost::system::error_code;

BOOST_AUTO_TEST_SUITE(test_@x3?);

struct Fixture
{
	@x4? @1?;

	Fixture()
	: @1?(@2?)
	{
	}
};

@0?

BOOST_AUTO_TEST_SUITE_END()

]], {
  x1 = f(function() return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") end),
  x2 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:p:h"), "/unittest\\>", "", ""), "[.-]", "_", "g"), "^.*\\(\\(/[^/]\\+\\)\\{2}\\)$", "\\1", ""), "/", "::", "g") end),
  x3 = f(function() return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") end),
  x4 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "")) }) end),
  [2] = i(2),
  [0] = i(0),
}, { delimiters = "@?", repeat_duplicates = true })),
  -- sut3 sscc::*::*::*
  s({ trig = [[sut3]], desc = [[sscc::*::*::*]] }, fmt([[
#include <boost/test/unit_test.hpp>
#include <boost/system/error_code.hpp>
#include <turtle/mock.hpp>
#include "../src/@x1?.h"

using namespace sscc@x2?;
using boost::system::error_code;

BOOST_AUTO_TEST_SUITE(test_@x3?);

struct Fixture
{
	@x4? @1?;

	Fixture()
	: @1?(@2?)
	{
	}
};

@0?

BOOST_AUTO_TEST_SUITE_END()

]], {
  x1 = f(function() return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") end),
  x2 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:p:h"), "/unittest\\>", "", ""), "[.-]", "_", "g"), "^.*\\(\\(/[^/]\\+\\)\\{3}\\)$", "\\1", ""), "/", "::", "g") end),
  x3 = f(function() return vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") end),
  x4 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "")) }) end),
  [2] = i(2),
  [0] = i(0),
}, { delimiters = "@?", repeat_duplicates = true })),
  -- tc unittest for any class
  s({ trig = [[tc]], desc = [[unittest for any class]] }, fmt([[
/**
 * @class ^x1&::^x2&
 * @test ^1&\n
 * <b>输入数据：</b> ^2&\n
 * <b>预期输出：</b> ^3&
 */
BOOST_FIXTURE_TEST_CASE(Test^4&, ^5&)
{
	^0&
}

]], {
  x1 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.fnamemodify(vim.fn.substitute(vim.fn.findfile(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") .. ".h", vim.fn.substitute(vim.fn.expand("%:p"), "\\<unittest/.*", "include/**", ""), 1), ".*\\<include/", "", ""), ":p:h"), "[.-]", "_", "g"), "/", "::", "g") end),
  x2 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
  [1] = i(1),
  [2] = i(2),
  [3] = i(3),
  [4] = i(4),
  [5] = i(5, "Fixture"),
  [0] = i(0),
}, { delimiters = "^&", repeat_duplicates = true })),
  -- tc data-driven unittest
  s({ trig = [[tc]], desc = [[data-driven unittest]] }, fmt([[
/**
 * @class ^x1&::^x2&
 * @test ^1&\n
 * <b>输入数据：</b> ^2&\n
 * <b>预期输出：</b> ^3&
 */
BOOST_DATA_TEST_CASE(Test^4&, ^5&, ^6&)
{
	^0&
}

]], {
  x1 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.fnamemodify(vim.fn.substitute(vim.fn.findfile(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") .. ".h", vim.fn.substitute(vim.fn.expand("%:p"), "\\<unittest/.*", "include/**", ""), 1), ".*\\<include/", "", ""), ":p:h"), "[.-]", "_", "g"), "/", "::", "g") end),
  x2 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
  [1] = i(1),
  [2] = i(2),
  [3] = i(3),
  [4] = i(4),
  [5] = i(5, "dataset"),
  [6] = i(6, "param"),
  [0] = i(0),
}, { delimiters = "^&", repeat_duplicates = true })),
  -- tc data-driven unittest with fixture
  s({ trig = [[tc]], desc = [[data-driven unittest with fixture]] }, fmt([[
/**
 * @class ^x1&::^x2&
 * @test ^1&\n
 * <b>输入数据：</b> ^2&\n
 * <b>预期输出：</b> ^3&
 */
BOOST_DATA_TEST_CASE_F(^4&, Test^5&, ^6&, ^7&)
{
	^0&
}

]], {
  x1 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.fnamemodify(vim.fn.substitute(vim.fn.findfile(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\?", "", "") .. ".h", vim.fn.substitute(vim.fn.expand("%:p"), "\\<unittest/.*", "include/**", ""), 1), ".*\\<include/", "", ""), ":p:h"), "[.-]", "_", "g"), "/", "::", "g") end),
  x2 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
  [1] = i(1),
  [2] = i(2),
  [3] = i(3),
  [4] = i(4, "Fixture"),
  [5] = i(5),
  [6] = i(6, "dataset"),
  [7] = i(7, "param"),
  [0] = i(0),
}, { delimiters = "^&", repeat_duplicates = true })),
  -- stc1 unittest for sscc::*
  s({ trig = [[stc1]], desc = [[unittest for sscc::*]] }, fmt([[
/**
 * @class sscc::^x1&::^x2&
 * @test ^1&\n
 * <b>输入数据：</b> ^2&\n
 * <b>预期输出：</b> ^3&
 */
BOOST_FIXTURE_TEST_CASE(Test^4&, Fixture)
{
	^0&
}

]], {
  x1 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:p:h"), "/unittest\\>", "", ""), "[.-]", "_", "g"), "^.*/\\([^/]\\+\\)$", "\\1", ""), "/", "::", "g") end),
  x2 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
  [1] = i(1),
  [2] = i(2),
  [3] = i(3),
  [4] = i(4),
  [0] = i(0),
}, { delimiters = "^&", repeat_duplicates = true })),
  -- stc2 unittest for sscc::*::*
  s({ trig = [[stc2]], desc = [[unittest for sscc::*::*]] }, fmt([[
/**
 * @class sscc::^x1&::^x2&
 * @test ^1&\n
 * <b>输入数据：</b> ^2&\n
 * <b>预期输出：</b> ^3&
 */
BOOST_FIXTURE_TEST_CASE(Test^4&, Fixture)
{
	^0&
}

]], {
  x1 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:p:h"), "/unittest\\>", "", ""), "[.-]", "_", "g"), "^.*/\\([^/]\\+/[^/]\\+\\)$", "\\1", ""), "/", "::", "g") end),
  x2 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
  [1] = i(1),
  [2] = i(2),
  [3] = i(3),
  [4] = i(4),
  [0] = i(0),
}, { delimiters = "^&", repeat_duplicates = true })),
  -- stc3 unittest for sscc::*::*::*
  s({ trig = [[stc3]], desc = [[unittest for sscc::*::*::*]] }, fmt([[
/**
 * @class sscc::^x1&::^x2&
 * @test ^1&\n
 * <b>输入数据：</b> ^2&\n
 * <b>预期输出：</b> ^3&
 */
BOOST_FIXTURE_TEST_CASE(Test^4&, Fixture)
{
	^0&
}

]], {
  x1 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:p:h"), "/unittest\\>", "", ""), "[.-]", "_", "g"), "^.*/\\([^/]\\+/[^/]\\+/[^/]\\+\\)$", "\\1", ""), "/", "::", "g") end),
  x2 = f(function() return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:t:r"), "^test_\\(.\\)", "\\u\\1", ""),"_\\(.\\)","\\u\\1","g") end),
  [1] = i(1),
  [2] = i(2),
  [3] = i(3),
  [4] = i(4),
  [0] = i(0),
}, { delimiters = "^&", repeat_duplicates = true })),

}
