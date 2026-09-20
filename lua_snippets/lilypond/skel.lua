local ls = require("luasnip")

return {

  -- skel Notes
  ls.snippet({ trig = [[skel]], desc = [[Notes]] }, {
    ls.text_node("\""),
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.expand("%:t:r")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node("Piece\" = \""),
    ls.d(2, function(args, parent)
      local function __dyn_val()
        return args[1][1] or ""
      end
      return ls.sn(nil, { ls.i(2, __dyn_val()) })
    end, {1}),
    ls.text_node({"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Opus\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Composer\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Performer\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Lyricist\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Subtitle\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("Key\" = \\Key"),
    ls.insert_node(3, "C"),
    ls.text_node({"", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("Pitches\" = \\relative "),
    ls.insert_node(4, "c''"),
    ls.text_node({"", "{", "	\\time "}),
    ls.insert_node(5, "4/4"),
    ls.text_node({"", "	\\key "}),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("[,']+", "") end, {6}),
    ls.text_node(" "),
    ls.insert_node(7, "\\major"),
    ls.text_node({"", "", "	"}),
    ls.insert_node(0),
    ls.text_node({"", "", "	\\fine", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"NotesC\" =", "{", "	\\tempo 4 = "}),
    ls.insert_node(8, "60"),
    ls.text_node({"", "", "	\\transpose "}),
    ls.insert_node(6, "c"),
    ls.text_node({" c {", "		\\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Pitches\"", "	}", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Notes\" =", "{", "	\\transpose c \\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Key\" {", "		\\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"NotesC\"", "	}", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("MelodyC\" = \\\""),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"NotesC\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("Melody\" = \\\""),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Notes\"", ""}),
  }),
  -- skel Notes with lyric
  ls.snippet({ trig = [[skel]], desc = [[Notes with lyric]] }, {
    ls.text_node("\""),
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.expand("%:t:r")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node("Piece\" = \""),
    ls.d(2, function(args, parent)
      local function __dyn_val()
        return args[1][1] or ""
      end
      return ls.sn(nil, { ls.i(2, __dyn_val()) })
    end, {1}),
    ls.text_node({"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Opus\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Composer\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Performer\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Lyricist\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Subtitle\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("Key\" = \\Key"),
    ls.insert_node(3, "C"),
    ls.text_node({"", "", "melody = \\relative "}),
    ls.insert_node(4, "c''"),
    ls.text_node({"", "{", "	\\time "}),
    ls.insert_node(5, "4/4"),
    ls.text_node({"", "	\\key "}),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("[,']+", "") end, {6}),
    ls.text_node(" "),
    ls.insert_node(7, "\\major"),
    ls.text_node({"", "", "	\\override MultiMeasureRest.expand-limit = #3", "	\\compressEmptyMeasures", "", "	%\\mark \"原调C大调\"", "", "	"}),
    ls.insert_node(0),
    ls.text_node({"", "", "	\\fine", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Pitches\" =", "{", "	<<", "		\\new Voice = \"melody\" {", "			\\tempo 4 = "}),
    ls.insert_node(8, "60"),
    ls.text_node({"", "", "			\\melody", "		}", "		\\new Lyrics=\"verse\" \\lyricsto \"melody\" {", "		}", "		\\new Lyrics=\"secondVerse\" \\lyricsto \"melody\" {", "			\\repeat unfold 4 { \\skip 1 }", "		}", "	>>", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"NotesC\" =", "{", "	\\transpose "}),
    ls.insert_node(6, "c"),
    ls.text_node({" c {", "		\\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Pitches\"", "	}", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Notes\" =", "{", "	\\transpose c \\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Key\" {", "		\\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"NotesC\"", "	}", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"MelodyC\" =", "{", "	\\transpose "}),
    ls.function_node(function(args) return args[1][1] or "" end, {6}),
    ls.text_node({" c {", "		"}),
    ls.function_node(function(args) return args[1][1] or "" end, {9}),
    ls.text_node({"", "		\\melody", "	}", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Melody\" =", "{", "	\\transpose c \\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Key\" {", "		\\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"MelodyC\"", "	}", "}", ""}),
  }),
  -- skel Parallel Notes (one staff)
  ls.snippet({ trig = [[skel]], desc = [[Parallel Notes (one staff)]] }, {
    ls.text_node("\""),
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.expand("%:t:r")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node("Piece\" = \""),
    ls.d(2, function(args, parent)
      local function __dyn_val()
        return args[1][1] or ""
      end
      return ls.sn(nil, { ls.i(2, __dyn_val()) })
    end, {1}),
    ls.text_node({"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Opus\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Composer\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Performer\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Lyricist\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Subtitle\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("Key\" = \\Key"),
    ls.insert_node(3, "C"),
    ls.text_node({"", "", "\\parallelMusic #'(melody harmony) {", "", "	\\time "}),
    ls.function_node(function(args) return args[1][1] or "" end, {3}),
    ls.text_node({"", "", "	"}),
    ls.insert_node(0),
    ls.text_node({"", "", "	\\fine", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Pitches\" =", "{", "	\\new Staff <<", "		\\tempo 4 = "}),
    ls.insert_node(4, "108"),
    ls.text_node({"", "", "		\\relative c'' \\melody", "		\\\\", "		\\relative c' \\harmony", "	>>", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Notes\" =", "{", "	\\transpose c "}),
    ls.insert_node(5, "c"),
    ls.text_node({" {", "		\\key "}),
    ls.insert_node(6, "c"),
    ls.text_node(" "),
    ls.insert_node(7, "\\major"),
    ls.text_node({"", "		\\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Pitches\"", "	}", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("Melody\" = \\\""),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Notes\"", ""}),
  }),
  -- skel Parallel Notes (1 staffs with lyric)
  ls.snippet({ trig = [[skel]], desc = [[Parallel Notes (1 staffs with lyric)]] }, {
    ls.text_node("\""),
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.expand("%:t:r")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node("Piece\" = \""),
    ls.d(2, function(args, parent)
      local function __dyn_val()
        return args[1][1] or ""
      end
      return ls.sn(nil, { ls.i(2, __dyn_val()) })
    end, {1}),
    ls.text_node({"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Opus\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Composer\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Performer\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Lyricist\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Subtitle\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("Key\" = \\Key"),
    ls.insert_node(3, "C"),
    ls.text_node({"", "", "\\parallelMusic #'(preludeM preludeH) {", "", "	\\time "}),
    ls.function_node(function(args) return args[1][1] or "" end, {3}),
    ls.text_node({"", "", "	"}),
    ls.insert_node(0),
    ls.text_node({"", "", "}", "", "\\parallelMusic #'(melody harmony) {", "", "	\\time "}),
    ls.function_node(function(args) return args[1][1] or "" end, {3}),
    ls.text_node({"", "", "", "	\\fine", "}", "", "grayVoice = {", "	\\override Accidental.color = #(x11-color 'gray50)", "	\\override Beam.color       = #(x11-color 'gray50)", "	\\override Dots.color       = #(x11-color 'gray50)", "	\\override NoteHead.color   = #(x11-color 'gray50)", "	\\override Rest.color       = #(x11-color 'gray50)", "	\\override Stem.color       = #(x11-color 'gray50)", "	\\override Tie.color        = #(x11-color 'gray50)", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Pitches\" =", "{", "	<<", "		\\new Voice = \"melody\" {", "			\\tempo 4 = "}),
    ls.insert_node(4, "60"),
    ls.text_node({"", "", "			<<", "				\\new Voice {", "					\\voiceThree", "					\\relative c'' {", "						\\preludeM", "					}", "				}", "				\\new Voice {", "					\\voiceFour", "					\\grayVoice", "					\\relative c' {", "						\\preludeH", "					}", "				}", "				{", "					\\voiceOne", "					\\relative c'' {", "						\\melody", "					}", "				}", "				\\new Voice {", "					\\voiceTwo", "					\\grayVoice", "					\\relative c' {", "						\\harmony", "					}", "				}", "			>>", "		}", "", "		\\new Lyrics=\"firstVerse\" \\lyricsto \"melody\" {", "		}", "		\\new Lyrics=\"secondVerse\" \\lyricsto \"melody\" {", "			\\repeat unfold 4 { \\skip 1 }", "		}", "	>>", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Notes\" =", "{", "	\\transpose c "}),
    ls.insert_node(5, "c"),
    ls.text_node({" {", "		\\key "}),
    ls.insert_node(6, "c"),
    ls.text_node(" "),
    ls.insert_node(7, "\\major"),
    ls.text_node({"", "		\\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Pitches\"", "	}", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Melody\" =", "{", "	<<", "		\\new Voice = \"melody\" {", "			"}),
    ls.function_node(function(args) return args[1][1] or "" end, {8}),
    ls.text_node({"", "", "			<<", "				\\new Voice {", "					\\voiceThree", "					\\relative c'' {", "						\\preludeM", "					}", "				}", "				{", "					\\voiceOne", "					\\relative c'' {", "						\\melody", "					}", "				}", "			>>", "		}", "		\\new Lyrics \\lyricsto \"melody\" {", "			\\verse", "		}", "	>>", "}", ""}),
  }),
  -- skel Parallel Notes (two staffs)
  ls.snippet({ trig = [[skel]], desc = [[Parallel Notes (two staffs)]] }, {
    ls.text_node("\""),
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.expand("%:t:r")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node("Piece\" = \""),
    ls.d(2, function(args, parent)
      local function __dyn_val()
        return args[1][1] or ""
      end
      return ls.sn(nil, { ls.i(2, __dyn_val()) })
    end, {1}),
    ls.text_node({"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Opus\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Composer\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Performer\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Lyricist\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Subtitle\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("Key\" = \\Key"),
    ls.insert_node(3, "C"),
    ls.text_node({"", "", "\\parallelMusic #'(melody harmony) {", "", "	\\time "}),
    ls.function_node(function(args) return args[1][1] or "" end, {3}),
    ls.text_node({"", "", "	"}),
    ls.insert_node(0),
    ls.text_node({"", "", "	\\fine", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Pitches\" =", "{", "	\\new Staff <<", "		\\tempo 4 = "}),
    ls.insert_node(4, "108"),
    ls.text_node({"", "", "		\\relative c'' {", "			\\melody", "		}", "		\\\\", "		\\relative c' {", "			\\grayNotes", "", "			\\harmony", "		}", "	>>", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Notes\" =", "{", "	\\transpose c "}),
    ls.insert_node(5, "c"),
    ls.text_node({" {", "		\\key "}),
    ls.insert_node(6, "c"),
    ls.text_node(" "),
    ls.insert_node(7, "\\major"),
    ls.text_node({"", "		\\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Pitches\"", "	}", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("Melody\" = \\\""),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Notes\"", ""}),
  }),
  -- skel Parallel Notes (two staffs separated)
  ls.snippet({ trig = [[skel]], desc = [[Parallel Notes (two staffs separated)]] }, {
    ls.text_node("\""),
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.expand("%:t:r")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node("Piece\" = \""),
    ls.d(2, function(args, parent)
      local function __dyn_val()
        return args[1][1] or ""
      end
      return ls.sn(nil, { ls.i(2, __dyn_val()) })
    end, {1}),
    ls.text_node({"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Opus\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Composer\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Performer\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Lyricist\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Subtitle\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("Key\" = \\Key"),
    ls.insert_node(3, "C"),
    ls.text_node({"", "", "\\parallelMusic #'(melody harmony) {", "", "	\\time "}),
    ls.function_node(function(args) return args[1][1] or "" end, {3}),
    ls.text_node({"", "", "	"}),
    ls.insert_node(0),
    ls.text_node({"", "", "	\\fine", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Pitches\" =", "{", "	\\new StaffGroup <<", "		\\new Staff {", "			\\tempo 4 = "}),
    ls.insert_node(4, "108"),
    ls.text_node({"", "", "			\\relative c'' \\melody", "		}", "		\\new Staff {", "			\\relative c' \\harmony ", "		}", "	>>", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Notes\" =", "{", "	\\transpose c "}),
    ls.insert_node(5, "c"),
    ls.text_node({" {", "		\\key "}),
    ls.insert_node(6, "c"),
    ls.text_node(" "),
    ls.insert_node(7, "\\major"),
    ls.text_node({"", "		\\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Pitches\"", "	}", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("Melody\" = \\\""),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Notes\"", ""}),
  }),
  -- skel 普通高低音部，带和弦和歌词
  ls.snippet({ trig = [[skel]], desc = [[普通高低音部，带和弦和歌词]] }, {
    ls.text_node("\""),
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.expand("%:t:r")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node("Piece\" = \""),
    ls.d(2, function(args, parent)
      local function __dyn_val()
        return args[1][1] or ""
      end
      return ls.sn(nil, { ls.i(2, __dyn_val()) })
    end, {1}),
    ls.text_node({"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Opus\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Composer\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Performer\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Lyricist\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Subtitle\" = \"\"", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("Key\" = \\Key"),
    ls.insert_node(3, "C"),
    ls.text_node({"", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("Up\" = \\relative "),
    ls.insert_node(4, "c''"),
    ls.text_node({"", "{", "	\\time "}),
    ls.insert_node(5, "4/4"),
    ls.text_node({"", "	\\key "}),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("[,']+", "") end, {6}),
    ls.text_node(" "),
    ls.insert_node(7, "\\major"),
    ls.text_node({"", "", "	"}),
    ls.insert_node(0),
    ls.text_node({"", "", "	\\fine", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("Down\" = \\relative "),
    ls.insert_node(8, "c"),
    ls.text_node({"", "{", "	\\time "}),
    ls.function_node(function(args) return args[1][1] or "" end, {5}),
    ls.text_node({"", "	\\key "}),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("[,']+", "") end, {9}),
    ls.text_node(" "),
    ls.insert_node(6),
    ls.text_node({"", "", "	"}),
    ls.function_node(function(args) return args[1][1] or "" end, {0}),
    ls.text_node({"", "", "	\\fine", "}", "", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Pitches\" =", "{", "	\\new StaffGroup <<", "		\\new Staff {", "			\\tempo 4 = "}),
    ls.insert_node(9, "108"),
    ls.text_node({"", "", "			\\relative c'' \\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Up\"", "		}", "		\\new Staff {", "			\\relative c' \\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Down\"", "		}", "	>>", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"NotesC\" =", "{", "	\\transpose "}),
    ls.function_node(function(args) return args[1][1] or "" end, {6}),
    ls.text_node({" c {", "		\\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Pitches\"", "	}", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Notes\" =", "{", "	\\transpose c \\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Key\" {", "		\\\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"NotesC\"", "	}", "}", "", "\""}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node("Melody\" = \\\""),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"Notes\"", ""}),
  }),

}

