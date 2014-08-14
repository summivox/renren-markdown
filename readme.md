# Renren-Markdown

[Markdown][]-based blog editor for http://blog.renren.com/ .

http://blog.renren.com/ uses a modified version of [TinyMCE][] as its rich-text editor, with extra server-side clean-up. This is supposed to block possible XSS attacks, but as a result, formatting is severely limited. Renren-markdown circumvents this by converting arbitrary [Markdown][], alongside with embedded [Gist][]s and MathJax into TinyMCE, with almost all formatting/styling preserved.

**NOTICE: Renren-Markdown will OVERWRITE existing content in the TinyMCE editor!**

[Markdown]: http://daringfireball.net/projects/markdown/
[Gist]: https://gist.github.com/
[TinyMCE]: http://www.tinymce.com/


## Features

* on-the-fly markdown conversion and previewing (through TinyMCE)
* retains markdown source for editing
* github markdown styling
* autolinks to gists are embedded (e.g. `https://gist.github.com/gist/4344334`)
    * markdown content in gists are automatically unwrapped
* LaTeX-like math formulae support through MathJax (**NOTE: Size limited. See below for reasons**)


## Install (userscript)

1. Install your favorite userscript environment ([GreaseMonkey][]/[TamperMonkey][]/[NinjaKit][]...)
2. <https://github.com/summivox/renren-markdown/raw/master/dist/gm/renren-markdown.user.js>

[GreaseMonkey]: https://addons.mozilla.org/en-US/firefox/addon/greasemonkey/
[TamperMonkey]: https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo
[NinjaKit]: http://ss-o.net/safari/extension/NinjaKit.safariextz


## Install (Chrome plugin)

~~Use chrome store link: https://chrome.google.com/webstore/detail/renren-markdown/iiabjaofopjooifoclbpdmffjlgbplod~~

Chrome store entry was not managed by me (although built by Grunt) and is out-of-date, so for now, use the userscript version.


## Build

Renren-markdown is built using [Grunt][].

```
npm install
grunt clean
grunt prepare
grunt
```

Chrome plugin: `dist/chrome` (unpacked)  
Userscript: `dist/gm`

[Grunt]: http://gruntjs.com/


## On MathJax support

Math is pre-rendered locally into PNG then stored within blog content as Data URI. However, as Renren server filters out references to Data URIs, renren-markdown uses a _trampoline server_ `base64-server/base64.coffee` to "convert" the Data URI to a regular image URL. I've limited the size to 8KiB (hard-coded in the server side) due to HTTP Get limitations, but this should be sufficient for normal usage.


## Revision History

(before v0.4.34: not kept)

**2014-02-27 : v1.2.0**

Core rewrite -- correctly handling corner cases in deeply-nested lists and a few other issues.

There might be some regression -- please post such occurrences in issues. Thanks.


**2013-12-10 : v1.0.0**

Major rewrite. Didn't have the time to polish it (esp. the UI) so it wasn't released. Now that the old version is mostly broke...

* lots of bugfixes (against new Renren filters)
* new (but still primitive) UI
* MathJax
* major performance improvements (lag-free editing even with "heavy" content)
* modular design (Gist & MathJax are all "plugins", see `src/postproc/*`)


**2013-04-05 : v0.5.5**

* workaround: firefox update broke compatibility


**2013-03-28 : v0.5.4**

* workaround renren blog site update


**2013-03-16 : v0.5.2**

* unified build for chrome and greasemonkey
* FIX: now circumvents blog.renren.com "@-mention" implementation bug


**2013-03-14 : v0.5.0**

* migrate to [Grunt][]
* more non-standard-browser-behavior-resistance (against FireFox)
* better css handling


**2013-03-10 : v0.4.34**

* FIX: `\t` handling (hardcoded as 8 spaces)
