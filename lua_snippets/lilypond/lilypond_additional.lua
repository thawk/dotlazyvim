local ls = require("luasnip")

return {

  -- transexec 十二大调转调练习
  ls.snippet([[transexec]], {
    ls.text_node({"\\version \"2.23.2\"", "", "\\include \"../global.ily\"", "", "\\header {", "	title = \"转调练习-"}),
    ls.insert_node(1, ls.function_node(function() return vim.fn.substitute(vim.fn.expand("%:t:r"), "转调练习-", "", "") end)),
    ls.text_node({"\"", "}", "", "\\include \"../notes/"}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({".ily\"", "", "Notes = \\transpose c c {", "	\\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Pitches\"", "}", "", "\\tocItem \\markup \"C\"", "\\score {", "	\\transpose c c {", "		\\\"Notes\"", "	}", "	\\header {", "		piece = \"C\"", "	}", "}", "", "\\tocItem \\markup \"F\"", "\\score {", "	\\transpose c f"}),
    ls.insert_node(2, ","),
    ls.text_node({" {", "		\\\"Notes\"", "	}", "	\\header {", "		piece = \"F\"", "	}", "}", "", "\\pageBreak", "", "\\tocItem \\markup \"Bb\"", "\\score {", "	\\transpose c bes, {", "		\\\"Notes\"", "	}", "	\\header {", "		piece = \"Bb\"", "	}", "}", "", "\\tocItem \\markup \"Eb\"", "\\score {", "	\\transpose c es {", "		\\\"Notes\"", "	}", "	\\header {", "		piece = \"Eb\"", "	}", "}", "", "\\pageBreak", "", "\\tocItem \\markup \"Ab\"", "\\score {", "	\\transpose c aes, {", "		\\\"Notes\"", "	}", "	\\header {", "		piece = \"Ab\"", "	}", "}", "", "\\tocItem \\markup \"Db\"", "\\score {", "	\\transpose c des {", "		\\\"Notes\"", "	}", "	\\header {", "		piece = \"Db\"", "	}", "}", "", "\\pageBreak", "", "\\tocItem \\markup \"Gb/F#\"", "\\score {", "	\\transpose c ges"}),
    ls.function_node(function(args) return args[1][1] or "" end, {2}),
    ls.text_node({" {", "		\\\"Notes\"", "	}", "	\\header {", "		piece = \"Gb/F#\"", "	}", "}", "", "\\tocItem \\markup \"B\"", "\\score {", "	\\transpose c b, {", "		\\\"Notes\"", "	}", "	\\header {", "		piece = \"B\"", "	}", "}", "", "\\pageBreak", "", "\\tocItem \\markup \"E\"", "\\score {", "	\\transpose c e {", "		\\\"Notes\"", "	}", "	\\header {", "		piece = \"E\"", "	}", "}", "", "\\tocItem \\markup \"A\"", "\\score {", "	\\transpose c a, {", "		\\\"Notes\"", "	}", "	\\header {", "		piece = \"A\"", "	}", "}", "", "\\pageBreak", "", "\\tocItem \\markup \"D\"", "\\score {", "	\\transpose c d {", "		\\\"Notes\"", "	}", "	\\header {", "		piece = \"D\"", "	}", "}", "", "\\tocItem \\markup \"G\"", "\\score {", "	\\transpose c g, {", "		\\\"Notes\"", "	}", "	\\header {", "		piece = \"G\"", "	}", "}", "", "\\pageBreak", "", ""}),
  }, { description = [[十二大调转调练习]] }),

}
