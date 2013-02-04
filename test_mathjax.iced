# module inlinify {

# get all text nodes without jQuery
# adapted from: http://stackoverflow.com/questions/298750/how-do-i-select-text-nodes-with-jquery
getTextNodesIn=(node)->
  textNodes = []
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
  doc=JQ('<iframe />').css('display', 'none').appendTo('body')[0].contentDocument
  JQ(doc).find('head').append("<style>#{css}</style>")
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
        x.style.cssText=(escapeCssText rule.style.cssText)+';'+(escapeCssText x.style.cssText)
  jel

# convert everything within `el` into <span>
spanifyAll=(el)->
  jel=JQ(el)

  # clone `el` with raw span element
  spanify=(el)->
    if !el? then return JQ('<span />')
    JQ("""<span style="#{escapeCssText el.style.cssText}">#{el.innerHTML}</span>""")

  # preformatted text: replace with `&amp;` and friends
  jel.find('pre').each ->
    for text in getTextNodesIn(this)
      str=text.data.toString()
        .replace(/\&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/\ /g, '&nbsp;')
        .replace(/[\n\r\v]/g, '<br/>')
      JQ(text).replaceWith("<span>#{str}</span>")
    #this.style.whiteSpace='pre'
  jel

  # workaround for td over-shrinking
  jel.find('td').children().each ->
    this.style.whiteSpace||='nowrap'

  # container -> span with corresponding `display: xxx`
  # NOTE: order of operation is significant!
  [
    ['pre, code', 'inline']
    ['s, del', 'inline'] # use stylesheet instead
    ['div, p, blockquote', 'block']
    ['h1, h2, h3, h4, h5, h6', 'block']
    ['td', 'table-cell'] # table family
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
    jel.find(tag).each ->
      st=this.style.cssText
      this.style.cssText=''
      JQ(this).wrap("""<span style="#{escapeCssText st}"/>""")

  return

# } //module inlinify

