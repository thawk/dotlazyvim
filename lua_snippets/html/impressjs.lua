local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

return {

  -- skel impress.js template
  s({ trig = [[skel]], desc = [[impress.js template]] }, fmt([[
<!doctype html>
<html lang="zh-cmn-Hans">
	<head>
		<meta charset="UTF-8" />
		<meta name="viewport" content="width=device-width" />
		<title>@1?</title>
        <link href="../css/tachyons.min.css" rel="stylesheet" />
        <link href="../css/fonts.css" rel="stylesheet" />
        <link href="../css/classic-slides.css" rel="stylesheet" />
        <link href="../css/themes/default.css" rel="stylesheet" />
        <link href="../vendor/impress.js/css/impress-common.css" rel="stylesheet" />
        <link href="../vendor/impress.js/extras/highlight/styles/github.css" rel="stylesheet" />
	</head>
<body class="impress-not-supported">
<div class="fallback-message">
	<p>您正在使用的浏览器<b>不支持</b>impress.js需要的功能，因此只能看到简化版本。</p>
	<p>请使用最新版本的<b>Chrome</b>、<b>Safari</b>或<b>Firefox</b>浏览器以取得最佳效果。</p>
</div>

<div id="impress" class="nodebug" data-width="1920" data-height="1080" data-autoplay="0" data-max-scale="4">

<!-- title页放到其他页上面，避免在overview页面上被遮挡 -->
<section id="title" class="step slide title" data-rel-position="relative" data-x="0" data-y="0" title="标题页">
	<h1>@2?</h1>
    <p>@3?</p>
    <p><small>@4?</small></p>
</section>

<section id="@5?" class="step slide" data-rel-x="0" data-rel-y="1h" data-rotate=0>
@0?
</section>

<section id="overview" class="step slide skip" data-x="0" data-y="1.5h" data-scale=5 data-rotate=360>
	<div id="signature" class="absolute right-0 bottom-0 center">
		<p>Powered by <a href="http://impress.js.org">impress.js<sup>*</sup></a></p>
	</div>
</section>

</div> <!-- #impress -->

<div id="impress-toolbar"></div>

<div class="impress-progressbar"><div></div></div>
<div class="impress-progress"></div>

<div id="impress-help"></div>

<script src="../vendor/impress.js/extras/highlight/highlight.pack.js" charset="utf-8"></script>
<script src="../vendor/marked/marked.min.js" charset="utf-8"></script>
<script src="../vendor/impress.js/js/impress.min.js" charset="utf-8"></script>
<script src="../js/init.js" charset="utf-8"></script>
</body>
</html>

]], {
  [1] = i(1, "幻灯标题"),
  [2] = d(2, function(args, parent) return sn(nil, { i(2, args[1][1] or "") }) end, {1}),
  [3] = d(3, function(args, parent) return sn(nil, { i(3, vim.env.USER or "") }) end),
  [4] = d(4, function(args, parent) return sn(nil, { i(4, os.date("%Y-%m-%d")) }) end),
  [5] = i(5, "本步骤的名称"),
  [0] = i(0, "输入需要的内容"),
}, { delimiters = "@?", repeat_duplicates = true })),

}
