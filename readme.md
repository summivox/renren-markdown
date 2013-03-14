# Renren-Markdown

[Markdown][] and [Gist][] support for http://blog.renren.com/ .

http://blog.renren.com/ uses a modified version of [TinyMCE][] as its rich-text editor, with extra server-side clean-up. This is supposed to block possible XSS attacks, but as a result, formatting is severely limited. Renren-markdown circumvents this by converting arbitrary [Markdown][], alongside with embedded [Gist][]s, into TinyMCE, with almost all formatting/styling preserved. 

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
* renren emoticons through image syntax (e.g. `![(mb)]()`)


## Install (userscript)

1. Install your favorite userscript environment ([GreaseMonkey][]/[TamperMonkey][]/[NinjaKit][]...)
2. http://userscripts.org/scripts/show/154555

[GreaseMonkey]: https://addons.mozilla.org/en-US/firefox/addon/greasemonkey/
[TamperMonkey]: https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo
[NinjaKit]: http://ss-o.net/safari/extension/NinjaKit.safariextz


## Install (Chrome plugin)

TBD


## Build

Renren-markdown is built using [Grunt][].

```
npm install
grunt clean
grunt prepare
grunt gm
```

[Grunt]: http://gruntjs.com/


## Revision History

(before v0.4.34: not kept)


**2013-03-14 : v0.5.0**

* migrate to [Grunt][]
* more non-standard-browser-behavior-resistance (against FireFox)
* better css handling


**2013-03-10 : v0.4.34**

* FIX: `\t` handling (hardcoded as 8 spaces)
