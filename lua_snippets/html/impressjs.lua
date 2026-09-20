local ls = require("luasnip")

return {

  -- skel impress.js template
  ls.snippet({ trig = [[skel]], desc = [[impress.js template]] }, {
    ls.text_node({"<!doctype html>", "<html lang=\"zh-cmn-Hans\">", "	<head>", "		<meta charset=\"UTF-8\" />", "		<meta name=\"viewport\" content=\"width=device-width\" />", "		<title>"}),
    ls.insert_node(1, "幻灯标题"),
    ls.text_node({"</title>", "        <link href=\"../css/tachyons.min.css\" rel=\"stylesheet\" />", "        <link href=\"../css/fonts.css\" rel=\"stylesheet\" />", "        <link href=\"../css/classic-slides.css\" rel=\"stylesheet\" />", "        <link href=\"../css/themes/default.css\" rel=\"stylesheet\" />", "        <link href=\"../vendor/impress.js/css/impress-common.css\" rel=\"stylesheet\" />", "        <link href=\"../vendor/impress.js/extras/highlight/styles/github.css\" rel=\"stylesheet\" />", "	</head>", "<body class=\"impress-not-supported\">", "<div class=\"fallback-message\">", "	<p>您正在使用的浏览器<b>不支持</b>impress.js需要的功能，因此只能看到简化版本。</p>", "	<p>请使用最新版本的<b>Chrome</b>、<b>Safari</b>或<b>Firefox</b>浏览器以取得最佳效果。</p>", "</div>", "", "<div id=\"impress\" class=\"nodebug\" data-width=\"1920\" data-height=\"1080\" data-autoplay=\"0\" data-max-scale=\"4\">", "", "<!-- title页放到其他页上面，避免在overview页面上被遮挡 -->", "<section id=\"title\" class=\"step slide title\" data-rel-position=\"relative\" data-x=\"0\" data-y=\"0\" title=\"标题页\">", "	<h1>"}),
    ls.d(2, function(args, parent)
      local function __dyn_val()
        return args[1][1] or ""
      end
      return ls.sn(nil, { ls.i(2, __dyn_val()) })
    end, {1}),
    ls.text_node({"</h1>", "    <p>"}),
    ls.d(3, function(args, parent)
      local function __dyn_val()
        return vim.env.USER or ""
      end
      return ls.sn(nil, { ls.i(3, __dyn_val()) })
    end),
    ls.text_node({"</p>", "    <p><small>"}),
    ls.d(4, function(args, parent)
      local function __dyn_val()
        return os.date("%Y-%m-%d")
      end
      return ls.sn(nil, { ls.i(4, __dyn_val()) })
    end),
    ls.text_node({"</small></p>", "</section>", "", "<section id=\""}),
    ls.insert_node(5, "本步骤的名称"),
    ls.text_node({"\" class=\"step slide\" data-rel-x=\"0\" data-rel-y=\"1h\" data-rotate=0>", ""}),
    ls.insert_node(0, "输入需要的内容"),
    ls.text_node({"", "</section>", "", "<section id=\"overview\" class=\"step slide skip\" data-x=\"0\" data-y=\"1.5h\" data-scale=5 data-rotate=360>", "	<div id=\"signature\" class=\"absolute right-0 bottom-0 center\">", "		<p>Powered by <a href=\"http://impress.js.org\">impress.js<sup>*</sup></a></p>", "	</div>", "</section>", "", "</div> <!-- #impress -->", "", "<div id=\"impress-toolbar\"></div>", "", "<div class=\"impress-progressbar\"><div></div></div>", "<div class=\"impress-progress\"></div>", "", "<div id=\"impress-help\"></div>", "", "<script src=\"../vendor/impress.js/extras/highlight/highlight.pack.js\" charset=\"utf-8\"></script>", "<script src=\"../vendor/marked/marked.min.js\" charset=\"utf-8\"></script>", "<script src=\"../vendor/impress.js/js/impress.min.js\" charset=\"utf-8\"></script>", "<script src=\"../js/init.js\" charset=\"utf-8\"></script>", "</body>", "</html>", ""}),
  }),

}

