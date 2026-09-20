local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

return {

  -- skel Notes
  s({ trig = [[skel]], desc = [[Notes]] }, fmt([[
"@1?Piece" = "@2?"
"@1?Opus" = ""
"@1?Composer" = ""
"@1?Performer" = ""
"@1?Lyricist" = ""
"@1?Subtitle" = ""
"@1?Key" = \Key@3?

"@1?Pitches" = \relative @4?
{
	\time @5?
	\key @x1? @7?

	@0?

	\fine
}

"@1?NotesC" =
{
	\tempo 4 = @8?

	\transpose @6? c {
		\"@1?Pitches"
	}
}

"@1?Notes" =
{
	\transpose c \"@1?Key" {
		\"@1?NotesC"
	}
}

"@1?MelodyC" = \"@1?NotesC"
"@1?Melody" = \"@1?Notes"

]], {
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.expand("%:t:r")) }) end),
  [2] = d(2, function(args, parent) return sn(nil, { i(2, args[1][1] or "") }) end, {1}),
  [3] = i(3, "C"),
  [4] = i(4, "c''"),
  [5] = i(5, "4/4"),
  x1 = f(function(args) return (args[1][1] or ""):gsub("[,']+", "") end, {6}),
  [7] = i(7, "\\major"),
  [0] = i(0),
  [8] = i(8, "60"),
  [6] = i(6, "c"),
}, { delimiters = "@?", repeat_duplicates = true })),
  -- skel Notes with lyric
  s({ trig = [[skel]], desc = [[Notes with lyric]] }, fmt([[
"@1?Piece" = "@2?"
"@1?Opus" = ""
"@1?Composer" = ""
"@1?Performer" = ""
"@1?Lyricist" = ""
"@1?Subtitle" = ""
"@1?Key" = \Key@3?

melody = \relative @4?
{
	\time @5?
	\key @x1? @7?

	\override MultiMeasureRest.expand-limit = #3
	\compressEmptyMeasures

	%\mark "原调C大调"

	@0?

	\fine
}

"@1?Pitches" =
{
	<<
		\new Voice = "melody" {
			\tempo 4 = @8?

			\melody
		}
		\new Lyrics="verse" \lyricsto "melody" {
		}
		\new Lyrics="secondVerse" \lyricsto "melody" {
			\repeat unfold 4 { \skip 1 }
		}
	>>
}

"@1?NotesC" =
{
	\transpose @6? c {
		\"@1?Pitches"
	}
}

"@1?Notes" =
{
	\transpose c \"@1?Key" {
		\"@1?NotesC"
	}
}

"@1?MelodyC" =
{
	\transpose @6? c {
		@x2?
		\melody
	}
}

"@1?Melody" =
{
	\transpose c \"@1?Key" {
		\"@1?MelodyC"
	}
}

]], {
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.expand("%:t:r")) }) end),
  [2] = d(2, function(args, parent) return sn(nil, { i(2, args[1][1] or "") }) end, {1}),
  [3] = i(3, "C"),
  [4] = i(4, "c''"),
  [5] = i(5, "4/4"),
  x1 = f(function(args) return (args[1][1] or ""):gsub("[,']+", "") end, {6}),
  [7] = i(7, "\\major"),
  [0] = i(0),
  [8] = i(8, "60"),
  [6] = i(6, "c"),
  x2 = f(function(args) return args[1][1] or "" end, {9}),
}, { delimiters = "@?", repeat_duplicates = true })),
  -- skel Parallel Notes (one staff)
  s({ trig = [[skel]], desc = [[Parallel Notes (one staff)]] }, fmt([[
"@1?Piece" = "@2?"
"@1?Opus" = ""
"@1?Composer" = ""
"@1?Performer" = ""
"@1?Lyricist" = ""
"@1?Subtitle" = ""
"@1?Key" = \Key@3?

\parallelMusic #'(melody harmony) {

	\time @3?

	@0?

	\fine
}

"@1?Pitches" =
{
	\new Staff <<
		\tempo 4 = @4?

		\relative c'' \melody
		\\
		\relative c' \harmony
	>>
}

"@1?Notes" =
{
	\transpose c @5? {
		\key @6? @7?
		\"@1?Pitches"
	}
}

"@1?Melody" = \"@1?Notes"

]], {
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.expand("%:t:r")) }) end),
  [2] = d(2, function(args, parent) return sn(nil, { i(2, args[1][1] or "") }) end, {1}),
  [3] = i(3, "C"),
  [0] = i(0),
  [4] = i(4, "108"),
  [5] = i(5, "c"),
  [6] = i(6, "c"),
  [7] = i(7, "\\major"),
}, { delimiters = "@?", repeat_duplicates = true })),
  -- skel Parallel Notes (1 staffs with lyric)
  s({ trig = [[skel]], desc = [[Parallel Notes (1 staffs with lyric)]] }, fmt([[
"@1?Piece" = "@2?"
"@1?Opus" = ""
"@1?Composer" = ""
"@1?Performer" = ""
"@1?Lyricist" = ""
"@1?Subtitle" = ""
"@1?Key" = \Key@3?

\parallelMusic #'(preludeM preludeH) {

	\time @3?

	@0?

}

\parallelMusic #'(melody harmony) {

	\time @3?


	\fine
}

grayVoice = {
	\override Accidental.color = #(x11-color 'gray50)
	\override Beam.color       = #(x11-color 'gray50)
	\override Dots.color       = #(x11-color 'gray50)
	\override NoteHead.color   = #(x11-color 'gray50)
	\override Rest.color       = #(x11-color 'gray50)
	\override Stem.color       = #(x11-color 'gray50)
	\override Tie.color        = #(x11-color 'gray50)
}

"@1?Pitches" =
{
	<<
		\new Voice = "melody" {
			\tempo 4 = @4?

			<<
				\new Voice {
					\voiceThree
					\relative c'' {
						\preludeM
					}
				}
				\new Voice {
					\voiceFour
					\grayVoice
					\relative c' {
						\preludeH
					}
				}
				{
					\voiceOne
					\relative c'' {
						\melody
					}
				}
				\new Voice {
					\voiceTwo
					\grayVoice
					\relative c' {
						\harmony
					}
				}
			>>
		}

		\new Lyrics="firstVerse" \lyricsto "melody" {
		}
		\new Lyrics="secondVerse" \lyricsto "melody" {
			\repeat unfold 4 { \skip 1 }
		}
	>>
}

"@1?Notes" =
{
	\transpose c @5? {
		\key @6? @7?
		\"@1?Pitches"
	}
}

"@1?Melody" =
{
	<<
		\new Voice = "melody" {
			@x1?

			<<
				\new Voice {
					\voiceThree
					\relative c'' {
						\preludeM
					}
				}
				{
					\voiceOne
					\relative c'' {
						\melody
					}
				}
			>>
		}
		\new Lyrics \lyricsto "melody" {
			\verse
		}
	>>
}

]], {
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.expand("%:t:r")) }) end),
  [2] = d(2, function(args, parent) return sn(nil, { i(2, args[1][1] or "") }) end, {1}),
  [3] = i(3, "C"),
  [0] = i(0),
  [4] = i(4, "60"),
  [5] = i(5, "c"),
  [6] = i(6, "c"),
  [7] = i(7, "\\major"),
  x1 = f(function(args) return args[1][1] or "" end, {8}),
}, { delimiters = "@?", repeat_duplicates = true })),
  -- skel Parallel Notes (two staffs)
  s({ trig = [[skel]], desc = [[Parallel Notes (two staffs)]] }, fmt([[
"@1?Piece" = "@2?"
"@1?Opus" = ""
"@1?Composer" = ""
"@1?Performer" = ""
"@1?Lyricist" = ""
"@1?Subtitle" = ""
"@1?Key" = \Key@3?

\parallelMusic #'(melody harmony) {

	\time @3?

	@0?

	\fine
}

"@1?Pitches" =
{
	\new Staff <<
		\tempo 4 = @4?

		\relative c'' {
			\melody
		}
		\\
		\relative c' {
			\grayNotes

			\harmony
		}
	>>
}

"@1?Notes" =
{
	\transpose c @5? {
		\key @6? @7?
		\"@1?Pitches"
	}
}

"@1?Melody" = \"@1?Notes"

]], {
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.expand("%:t:r")) }) end),
  [2] = d(2, function(args, parent) return sn(nil, { i(2, args[1][1] or "") }) end, {1}),
  [3] = i(3, "C"),
  [0] = i(0),
  [4] = i(4, "108"),
  [5] = i(5, "c"),
  [6] = i(6, "c"),
  [7] = i(7, "\\major"),
}, { delimiters = "@?", repeat_duplicates = true })),
  -- skel Parallel Notes (two staffs separated)
  s({ trig = [[skel]], desc = [[Parallel Notes (two staffs separated)]] }, fmt([[
"@1?Piece" = "@2?"
"@1?Opus" = ""
"@1?Composer" = ""
"@1?Performer" = ""
"@1?Lyricist" = ""
"@1?Subtitle" = ""
"@1?Key" = \Key@3?

\parallelMusic #'(melody harmony) {

	\time @3?

	@0?

	\fine
}

"@1?Pitches" =
{
	\new StaffGroup <<
		\new Staff {
			\tempo 4 = @4?

			\relative c'' \melody
		}
		\new Staff {
			\relative c' \harmony 
		}
	>>
}

"@1?Notes" =
{
	\transpose c @5? {
		\key @6? @7?
		\"@1?Pitches"
	}
}

"@1?Melody" = \"@1?Notes"

]], {
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.expand("%:t:r")) }) end),
  [2] = d(2, function(args, parent) return sn(nil, { i(2, args[1][1] or "") }) end, {1}),
  [3] = i(3, "C"),
  [0] = i(0),
  [4] = i(4, "108"),
  [5] = i(5, "c"),
  [6] = i(6, "c"),
  [7] = i(7, "\\major"),
}, { delimiters = "@?", repeat_duplicates = true })),
  -- skel 普通高低音部，带和弦和歌词
  s({ trig = [[skel]], desc = [[普通高低音部，带和弦和歌词]] }, fmt([[
"@1?Piece" = "@2?"
"@1?Opus" = ""
"@1?Composer" = ""
"@1?Performer" = ""
"@1?Lyricist" = ""
"@1?Subtitle" = ""
"@1?Key" = \Key@3?

"@1?Up" = \relative @4?
{
	\time @5?
	\key @x1? @7?

	@0?

	\fine
}

"@1?Down" = \relative @8?
{
	\time @5?
	\key @x2? @6?

	@0?

	\fine
}


"@1?Pitches" =
{
	\new StaffGroup <<
		\new Staff {
			\tempo 4 = @9?

			\relative c'' \"@1?Up"
		}
		\new Staff {
			\relative c' \"@1?Down"
		}
	>>
}

"@1?NotesC" =
{
	\transpose @6? c {
		\"@1?Pitches"
	}
}

"@1?Notes" =
{
	\transpose c \"@1?Key" {
		\"@1?NotesC"
	}
}

"@1?Melody" = \"@1?Notes"

]], {
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.expand("%:t:r")) }) end),
  [2] = d(2, function(args, parent) return sn(nil, { i(2, args[1][1] or "") }) end, {1}),
  [3] = i(3, "C"),
  [4] = i(4, "c''"),
  [5] = i(5, "4/4"),
  x1 = f(function(args) return (args[1][1] or ""):gsub("[,']+", "") end, {6}),
  [7] = i(7, "\\major"),
  [0] = i(0),
  [8] = i(8, "c"),
  x2 = f(function(args) return (args[1][1] or ""):gsub("[,']+", "") end, {9}),
  [6] = i(6),
  [9] = i(9, "108"),
}, { delimiters = "@?", repeat_duplicates = true })),

}
