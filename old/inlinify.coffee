# assume jQuery
JQ=jQuery

# get all text nodes without JQUERY
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

# inline css rules into element `el`
inlineCss=(el, cssRules)->
  jel=JQ(el)
  for rule in cssRules
    jel.find(rule.selectorText).each (i, x)->
      x.style.cssText="#{rule.style.cssText};"+x.style.cssText

# convert everything within `el` into <span>
spanifyAll=(el)->
  jel=JQ(el)

  # clone `el` with raw span element
  spanify=(el)->
    if !el? then return JQ('<span />')
    JQ("""<span style="#{el.style.cssText}">#{el.innerHTML}</span>""")

  # preformatted text: replace with `&nbsp;` and friends
  jel.find('pre').each (i, x)->
    for text in getTextNodesIn(x)
      str=text.data.toString()
        .replace(/\&/g, '&amp;')
        .replace(/\ /g, '&nbsp;')
        .replace(/[\n\r\v]/g, '<br/>')
      JQ(text).replaceWith JQ("<span>#{str}</span>")

  # container -> span with corresponding `display: xxx`
  # NOTE: order of operation is significant!
  [
    ['pre, code', 'inline']
    ['div, p, blockquote', 'block']
    ['td', 'table-cell']
    ['tr', 'table-row']
    ['tbody', 'table']
    ['table', 'block']
    ['h1, h2, h3, h4, h5, h6', 'inline']
  ].forEach (arg)->
    ((tag, disp)->
      while x=jel.find(tag)[0]
        s=spanify(x)
        s[0].style.display||=disp
        JQ(x).replaceWith(s)
      return
    )(arg...)
    return

  # container with special function -> use span for style
  ['a'].forEach (tag)->
    JQ(tag).each (i, x)->
      st=x.style.cssText
      x.style.cssText=''
      JQ(x).wrap('<span />').parent()[0].style.cssText=st

  return

testCss=''' pre, code { font-size: 0.85em; font-family: Consolas, Inconsolata, Courier, monospace; } code { margin: 0 0.15em; padding: 0 0.3em; white-space: nowrap; border: 1px solid #EAEAEA; background-color: #F8F8F8; border-radius: 3px; display: inline; /* adam-p: added to fix Yahoo block display */ } pre { font-size: 1em; line-height: 1.2em; overflow: auto; } pre code { white-space: pre; border-radius: 3px; border: 1px solid #CCC; padding: 0.5em 0.7em; } ul, ol { } p, blockquote, ul, ol, dl, li, table, pre { margin: 1em 0; } dl { padding: 0; } dl dt { font-size: 1em; font-weight: bold; font-style: italic; padding: 0; margin: 1em 0 0.4em; } dl dd { margin: 0 0 1em; padding: 0 1em; } blockquote { border-left: 4px solid #DDD; padding: 0 1em; color: #777; } blockquote, q { quotes: none; } blockquote::before, blockquote::after, q::before, q::after { content: none; } a:link, a:visited { color: #33e; text-decoration: none; } a:hover { color: #00f; text-shadow: 1px 1px 2px #ccf; text-decoration: underline; } h1, h2, h3, h4, h5, h6 { margin: 1.3em 0 1em; padding-top: 1em; font-weight: bold; color: black; cursor: text; position: relative; } h1 { font-size: 2.3em; } h2 { font-size: 1.7em; border-bottom: 1px solid #CCC; } h3 { font-size: 1.5em; } h4 { font-size: 1.2em; } h5 { font-size: 1em; } h6 { font-size: 1em; color: #777; } .shadow { box-shadow:0 5px 15px #000; } table { padding: 0; border-collapse: collapse; border-spacing: 0; font-size: 100%; font: inherit; border: 0; } tbody { margin: 0; padding: 0; border: 0; } table tr { border: 0; border-top: 1px solid #CCC; background-color: white; margin: 0; padding: 0; } table tr:nth-child(2n) { background-color: #F8F8F8; } table tr th, table tr td { border: 1px solid #CCC; text-align: left; margin: 0; padding: 0.5em 1em; } table tr th { font-weight: bold; } '''

#inlineCss document, getCssRules(testCss)
inlineCss document, document.styleSheets[0].cssRules
spanifyAll document
