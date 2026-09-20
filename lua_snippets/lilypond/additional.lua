local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

return {

  -- transexec 十二大调转调练习
  s({ trig = [[transexec]], desc = [[十二大调转调练习]] }, fmt([[
\version "2.23.2"

\include "../global.ily"

\header {
	title = "转调练习-@1?"
}

\include "../notes/@1?.ily"

Notes = \transpose c c {
	\"@1?Pitches"
}

\tocItem \markup "C"
\score {
	\transpose c c {
		\"Notes"
	}
	\header {
		piece = "C"
	}
}

\tocItem \markup "F"
\score {
	\transpose c f@2? {
		\"Notes"
	}
	\header {
		piece = "F"
	}
}

\pageBreak

\tocItem \markup "Bb"
\score {
	\transpose c bes, {
		\"Notes"
	}
	\header {
		piece = "Bb"
	}
}

\tocItem \markup "Eb"
\score {
	\transpose c es {
		\"Notes"
	}
	\header {
		piece = "Eb"
	}
}

\pageBreak

\tocItem \markup "Ab"
\score {
	\transpose c aes, {
		\"Notes"
	}
	\header {
		piece = "Ab"
	}
}

\tocItem \markup "Db"
\score {
	\transpose c des {
		\"Notes"
	}
	\header {
		piece = "Db"
	}
}

\pageBreak

\tocItem \markup "Gb/F#"
\score {
	\transpose c ges@2? {
		\"Notes"
	}
	\header {
		piece = "Gb/F#"
	}
}

\tocItem \markup "B"
\score {
	\transpose c b, {
		\"Notes"
	}
	\header {
		piece = "B"
	}
}

\pageBreak

\tocItem \markup "E"
\score {
	\transpose c e {
		\"Notes"
	}
	\header {
		piece = "E"
	}
}

\tocItem \markup "A"
\score {
	\transpose c a, {
		\"Notes"
	}
	\header {
		piece = "A"
	}
}

\pageBreak

\tocItem \markup "D"
\score {
	\transpose c d {
		\"Notes"
	}
	\header {
		piece = "D"
	}
}

\tocItem \markup "G"
\score {
	\transpose c g, {
		\"Notes"
	}
	\header {
		piece = "G"
	}
}

\pageBreak


]], {
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.substitute(vim.fn.expand("%:t:r"), "转调练习-", "", "")) }) end),
  [2] = i(2, ","),
}, { delimiters = "@?", repeat_duplicates = true })),

}
