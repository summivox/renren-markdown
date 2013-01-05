`
// vim: nowrap
// ==UserScript==
// @name         renren-markdown
// @namespace    http://github.com/smilekzs
// @version      0.4.11
// @description  write well-formatted blogs on renren.com with markdown
// @include      *blog.renren.com/blog/*Blog*
// @include      *blog.renren.com/*Entry*
// ==/UserScript==
`

`
/*jquery*/
/*marked*/
`
rrmdStyle=
  '''
pre, code { font-size: 1em; font-family:Consolas, Inconsolata, Courier, monospace; } code { white-space:nowrap; border:1px solid #EAEAEA; background-color:#F8F8F8; border-radius:3px; display:inline; margin:0 .15em; padding:0 .3em; } pre { font-size:1em; line-height:1.2em; overflow:auto; } pre code { white-space:pre; border-radius:3px; border:1px solid #CCC; padding:.5em .7em; display: block !important; } p, blockquote, ul, ol, dl, li, table, pre { margin:1em 0; } dl { padding:0; } dl dt { font-size:1em; font-weight:700; font-style:italic; margin:1em 0 .4em; padding:0; } dl dd { margin:0 0 1em; padding:0 1em; } blockquote { border-left:4px solid #DDD; color:#777; padding:0 1em; } blockquote, q { quotes:none; } blockquote::before,  blockquote::after,  q::before,  q::after { content:none; } a:link, a:visited { color:#33e; text-decoration:none; } a:hover { color:#00f; text-shadow:1px 1px 2px #ccf; text-decoration:underline; } h1, h2, h3, h4, h5, h6 { font-weight:700; color:#000; cursor:text; position:relative; margin:1.3em 0 1em; } h1 { font-size:2.3em; } h2 { font-size:1.7em; border-bottom:1px solid #CCC; } h3 { font-size:1.5em; } h4 { font-size:1.2em; } h5 { font-size:1em; } h6 { font-size:1em; color:#777; } .shadow { box-shadow:0 5px 15px #000; } table { border-collapse:collapse; border-spacing:0; font-size:100%; font:inherit; border:0; padding:0; } tbody { border:0; margin:0; padding:0; } table tr { border:0; border-top:1px solid #CCC; background-color:#FFF; margin:0; padding:0; } table tr:nth-child(2n) { background-color:#F8F8F8; } table tr th, table tr td { border:1px solid #CCC; text-align:left; margin:0; padding:.5em 1em; } table tr th { font-weight:700; } 
  '''

JQ=jQuery

# module inlinify {

# get all text nodes without jQuery
# adapted from: http://stackoverflow.com/questions/298750/how-do-i-select-text-nodes-with-jquery
getTextNodesIn=(node)->
  textNodes = []
  whitespace = /^\s*$/

  getTextNodes=(node)->
    if node.nodeType == 3
      textNodes.push(node)
    else
      for n in node.childNodes
        getTextNodes(n)
    null

  getTextNodes(node)
  return textNodes

# get css rules from css text
getCssRules=(css)->
  doc=JQ('<iframe />').css('display', 'none').appendTo(JQ('body'))[0].contentDocument
  JQ(doc).find('head').append(JQ("<style>#{css}</style>"))
  doc.styleSheets[0].cssRules

# escape cssText to avoid single-double-quote hell
escapeCssText=(cssText)->
  cssText.replace /"/g, "'"

# inline css rules into element `el`
inlineCss=(el, cssRules)->
  jel=JQ(el)
  for rule in cssRules
    # FIXME: this works around a strange jQuery bug:
    #   jel.find(rule.selectorText).each ...
    # above code won't work
    list=jel[0]?.querySelectorAll(rule.selectorText)
    if list?
      [].slice.call(list).forEach (x)->
        x.style.cssText="#{escapeCssText rule.style.cssText};"+escapeCssText x.style.cssText
  jel

# convert everything within `el` into <span>
spanifyAll=(el)->
  jel=JQ(el)

  # clone `el` with raw span element
  spanify=(el)->
    if !el? then return JQ('<span />')
    JQ("""<span style="#{escapeCssText el.style.cssText}">#{el.innerHTML}</span>""")

  # preformatted text: replace with `&amp;` and friends
  jel.find('pre').each (i, x)->
    for text in getTextNodesIn(x)
      str=text.data.toString()
        .replace(/\&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/\ /g, '&nbsp;')
        .replace(/[\n\r\v]/g, '<br/>')
      JQ(text).replaceWith JQ("<span>#{str}</span>")
    #x.style.whiteSpace='pre'
  jel

  # workaround for td over-shrinking
  jel.find('td').each ->
    JQ(this).children().each ->
      this.style.whiteSpace||='nowrap'

  # container -> span with corresponding `display: xxx`
  # NOTE: order of operation is significant!
  [
    ['pre, code', 'inline']
    ['div, p, blockquote', 'block']
    ['h1, h2, h3, h4, h5, h6', 'block']
    ['td', 'table-cell']
    ['tr', 'table-row']
    ['tbody', 'table']
    ['table', 'block']
  ].forEach (arg)->
    ((tag, disp)->
      while x=jel.find(tag)[0]
        s=spanify(x)
        s[0].style.display||=disp
        JQ(x).replaceWith(s)
      return
    )(arg...)
    return
  

  # tags using internal span for style
  ['a'].forEach (tag)->
    jel.find(tag).each (i, x)->
      st=x.style.cssText
      x.style.cssText=''
      JQ(x).wrap("""<span style="#{escapeCssText st}"/>""")

  return

# } //module inlinify


# module getGist {

getGist=(id, cb)->
  gistJsRes=null
  await GM_xmlhttpRequest {
    url: "https://gist.github.com/#{id}.js"
    method: 'GET'
    onload: defer(gistJsRes)
    onerror: (err)->cb err; throw err
  }
  gistJs=gistJsRes.responseText

  cssUrl=gistJs.match(/link href=\\"([^"]*)\\"/)?[1]
  if !cssUrl
    err=Error("can't find gist css")
    cb err; throw err

  gistCssRes=null
  await GM_xmlhttpRequest {
    url: cssUrl
    method: 'GET'
    onload: defer(gistCssRes)
    onerror: (err)->cb err; throw err
  }
  gistCss=gistCssRes.responseText

  i1=gistJs.indexOf("\n")
  i1=gistJs.indexOf("('", i1)+1
  i2=gistJs.lastIndexOf(")")

  if i1>0 && i2>0
    gistHtml=eval(gistJs.substring(i1, i2))
  else
    err=Error("can't find gist content")
    cb err; throw err

  cb(null, gistCss, gistHtml)

unsafeWindow.gistManager=gistManager=
  saved: {}
  cssRules: null
  get: (id, cb)->
    if @saved[id]? then return cb null, @saved[id]
    err=null; gistCss=''; gistHtml=''
    await getGist id, defer(err, gistCss, gistHtml)
    if err?
      cb err; throw err
    else
      if !cssRules? then cssRules=getCssRules(gistCss)
      el=JQ(gistHtml).wrap('<span />').parent().css('display', 'none').appendTo JQ('body')
      inlineCss el, cssRules
      spanifyAll el
      el.css('display', '')
      cb null, @saved[id]=el 

# } //module getGist


# module rrmd {

# encode & embed markdown source into generated html

str_to_b64=(str)->window.btoa unescape encodeURIComponent str
b64_to_str=(b64)->decodeURIComponent escape window.atob b64

embed=(h, md)->
  h+"""<span style="visibility: hidden; display: block; height: 0; background-image: url('http://dummy/$rrmd$')">#{str_to_b64(md)}</span>"""

unembed=(h)->
  list=JQ(h).find('span').filter(->this.style.backgroundImage.match /\$rrmd\$/)
  b64=list[0]?.innerHTML
  if !b64? then b64=''
  try return b64_to_str(b64)
  catch e then return ''

mceReadyQ=(cb)->
  tid=setInterval (->
    if unsafeWindow.tinymce?.editors?[0]?
      clearInterval(tid)
      cb()
  ), 1000

await mceReadyQ defer()

unsafeWindow.rrmd=rrmd=
  options:
    pollingPeriod: 500
    embedGistQ: true

  init: ->
    @editor=unsafeWindow.tinymce.editors[0]
    @ui.init()
    @ui.area.val(unembed @editor.getContent())
    @ui.area.bind 'input', (e)=>
      if @tid? then clearTimeout @tid
      @tid=setTimeout (=>
        err=null; html=''
        await @conv defer(err, html)
        if err? then throw err
        @editor.setContent(html)
      ), @options.pollingPeriod

  ui:
    html:
      """
      <div id="rrmd_wrapper" style="margin: 0em 0em 1em 0em">
        <textarea id="rrmd_area" style="font-family: Consolas, 'Inconsolata', 'Courier New', 'Monospace';" placeholder="Type markdown _here_!"></textarea>
      </div>
      """
    init:->
      JQ('#editor_tbl').before(@html)
      @area=JQ('#rrmd_area')

      # fix "offset blog title input"
      JQ('#title_bg')[0]?.style.cssText='position: inherit !important; width: 100%'
      JQ('#title')[0]?.style.cssText='width: 98%'
      JQ('#editor_ifr')[0]?.contentDocument.body.style.paddingTop="0px"

  style: getCssRules(rrmdStyle)
  engine: (md)->
    el=JQ(marked(md)).wrapAll('<span />').parent()
    inlineCss el, @style
    spanifyAll el
    el

  conv: (cb)->
    md=@ui.area.val()
    el=@engine(md)
    if @options.embedGistQ
      re=/^(?:(?:http|https)\:\/\/)?gist.github.com\/(\w+)/
      for a in JQ(el).find('a').toArray()
        if (match=a.href.match(re))? && a.href==a.innerHTML
          id=match[1]
          err=null; gist=''
          await gistManager.get id, defer(err, gist)
          if err?
            cb err; throw err
          JQ(a).replaceWith(gist)
    hmd=embed(el.wrapAll('<span />').parent().html()||'', md)
    cb null, hmd

rrmd.init()

# } //module rrmd

