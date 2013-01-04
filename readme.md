#Renren-Markdown
_by smilekzs_

如果你：

* 不想受人人日志中格式的束缚
* 希望像在自己的博客空间上一样，自由地写作
* 需要快速、方便地在日志中嵌入代码而不被吞格式
* ...

你可以试试我写的这个插件～

##功能：

* 使用[markdown][]创建格式优美的人人日志
* 实时预览效果，所见即所得(almost)
* 编辑日志的时候，可以**直接**编辑原来写的markdown
* 内置一些对人人日志html过滤的修正，可以解决部分排版问题

[markdown]: http://daringfireball.net/projects/markdown/

##效果：

本日志完全用renren-markdown写成

##使用说明：

renren-markdown是一个[userscript](http://userscripts.org), 主要支持如下浏览器：

* Chrome：先安装[TamperMonkey][]环境
* Safari：先安装[NinjaKit][]环境
* Firefox: 先安装[GreaseMonkey][]环境
* 其他: <sub>我可以无耻地推荐大家用Chrome么（逃</sub>

[TamperMonkey]: https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo
[NinjaKit]: http://ss-o.net/safari/extension/NinjaKit.safariextz
[GreaseMonkey]: https://addons.mozilla.org/en-US/firefox/addon/greasemonkey/

安装完成后，即可下载安装本userscript：

* [在userscripts.org上下载][us]（推荐）
* [在github上下载][gist-raw]
* 访问[gist][], 下载`renren-markdown.user.js`

然后就可以在正常人人发表/编辑日志的界面下用markdown写日志啦～

**注意: 用renren-markdown写日志的时候，原来日志编辑器中已存在的内容将被覆盖！**

[us]: http://userscripts.org/scripts/show/154555
[gist]: https://gist.github.com/4344334
[gist-raw]: https://gist.github.com/raw/4344334/782761d21920818b067cb9ec252e8245aaec1df6/renren-markdown.user.js

##一些例子

---

写：

    _abc_, *def*, __ghi__, **jkl**

得到：

_abc_, *def*, __ghi__, **jkl**

---

写：
    title
    -----

得到：

title
-----

---

分割线可以用单独一行`---`

---

贴代码：只需将代码前面用4个空格缩进即可。

以下是我的vimrc的一部分：

    " backup/swap dir
    set nobackup
    set dir=$VIM\swap

    " encoding, language, UI
    set enc=utf8
    set langmenu=en_US.utf8
    let $LANG = 'en_US.utf8'
    set guioptions=gmlrt
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

---

链接, 图片：

写：

    [link](www.renren.com)

得到：

[link](www.renren.com)

---

写：

    [![](http://s.xnimg.cn/imgpro/v6/logo.png?f=trunk)](http://www.renren.com/)
(图片是`![](...)`，嵌套链接)

得到：

[![](http://s.xnimg.cn/imgpro/v6/logo.png?f=trunk)](http://www.renren.com/)


---

更多语法见[这里](http://daringfireball.net/projects/markdown/syntax)
