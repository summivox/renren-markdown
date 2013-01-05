injectScriptRaw=(doc, src)->
  scriptEl=doc.createElement('script')
  scriptEl.innerHTML=src
  doc.head.appendChild(scriptEl)

inlinify=(range)->
  doc=range.ownerDocument

  dup=(a)->[].slice.call(a)
  dupJoin=(as...)->
    r=[]
    for a in as
      r=r.concat dup a
    r

  spanify=(el)->
    s=doc.createElement('span')
    if el?
      s.innerHTML=el.innerHTML
      s.style.cssText=el.style.cssText
    s

  textify=(text)->
    s=spanify()
    s.innerHTML=text
    s.firstChild

  replaceWith=(come, go)->
    go.parentNode.replaceChild(come, go)

  insertInto=(inner, outer)->
    outer.innerHTML=inner.outerHTML

  #ref: http://stackoverflow.com/questions/298750/how-do-i-select-text-nodes-with-jquery
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

  for rule in doc.styleSheets[0].cssRules
    for elem in dup range.querySelectorAll(rule.selectorText)
      elem.style.cssText+=";#{rule.style.cssText}"
        
  # div -> span block
  while (div=range.getElementsByTagName('div')?[0])?
    s=spanify(div)
    if div.style.display=='' then s.style.display='block'
    replaceWith(s, div)

  # pre -> span &nbsp;
  while (pre=range.getElementsByTagName('pre')?[0])?
    s=spanify(pre)
    for text in getTextNodesIn(s)
      #nText=spanify()
      #nText.innerHTML=text.data.replace(/\ /g, '&nbsp;')
      nText=textify(text.data.replace(/\ /g, '&nbsp;'))
      replaceWith(nText, text)
    replaceWith(s, pre)

  # a -> span
  for a in dup range.getElementsByTagName('a')
    s=spanify(a)
    a.style.cssText=''
    insertInto(s, a)

  # table family
  for td in dup range.getElementsByTagName('td')
    s=spanify(td)
    s.style.display='table-cell'
    replaceWith(s, td)

  for tr in dup range.getElementsByTagName('tr')
    s=spanify(tr)
    s.style.display='table-row'
    replaceWith(s, tr)

  for table in dup range.getElementsByTagName('table')
    s=spanify(table.firstElementChild) # tbody
    s.style.display='table'
    replaceWith(s, table)

ifr=document.createElement('iframe')
ifr.style.display='none'
document.body.appendChild(ifr)
cd=ifr.contentDocument
cd.head.innerHTML=document.head.innerHTML
cd.body.innerHTML=document.body.innerHTML

debugger
inlinify(cd.body)
document.body.innerHTML=cd.body.innerHTML
