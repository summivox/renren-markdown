###!
core
!###

core = {}

# get css rules from css source
# FIXME: use template engine
core.getCssRules = do ->
  n = 0
  ifr = -> """<iframe
    id="rrmd_iframe_#{n++}"
    style="position:fixed; left: -10px; width: 1px; height: 1px;"
  />"""
  getCssRules = (css, cb) ->
    doc = $(ifr()).appendTo('body')[0].contentDocument
    $(doc).ready ->
      doc.write """<style type="text/css">#{css}</style>"""
      cb? util.arrayize doc.styleSheets[0].cssRules
    return

core.inlineCss = do ->
  # specificity comparison
  cmp = (a, b) ->
    switch
      when a<b then -1
      when a>b then +1
      else 0
  cmpSpec = (a, b) ->
    for i in [0, 1, 2]
      if (c = cmp a[i], b[i])
        return c
    return 0

  # workaround: non-standard properties
  valid = (s) -> s && s[0] != '-'
  prune = (s) ->
    if (m = s.match /^(.*)-value$/) && s != 'drop-initial-value'
      return m[1]
    return s

  # comma-separated selectors => multiple rules with same body
  expandRules = (rules) ->
    ret = []
    rules.forEach (r) ->
      for {selector, specificity} in getSpecificity r.selectorText
        ret.push {
          selector
          specificity
          style: r.style
        }
    ret

  inlineCss = (rootEl, rules) ->
    expandRules(rules)
      .sort (a, b) ->
        cmpSpec a.specificity, b.specificity
      .reverse()
      .forEach (r) ->
        {selector: sel, style} = r
        util.arrayize(rootEl.querySelectorAll(sel)).forEach (el) ->
          for key in style
            if !valid(key) then continue
            key = prune(key)
            value = style.getPropertyValue(key).trim()
            if !valid(value) then continue
            orig = el.style.getPropertyValue(key)
            if !orig then el.style.setProperty(key, value, '')
          return # forEach (el)
        return # forEach (r)
    return rootEl # inlineCss

# convert almost every element within a container into <span>
# NOTE: container itself is not converted
core.spanify = do ->
  # prevent element with empty innerHTML from being stripped
  dummy = '<span style="display: none;">&nbsp;</span>'

  getTextNodes = (el) ->
    ret = []
    find = (node) ->
      if node.nodeType == 3
        ret.push node
      else
        for n in node.childNodes
          find n
      return
    find el
    ret

  # single element => span
  getSpan = (el) ->
    ret = document.createElement 'span'
    if !el? then return ret

    # special: <pre>-formatting
    if el.tagName == 'PRE'
      for t in getTextNodes el
        cont = t.data.toString()
          .replace(/\&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/\t/g, '        ') # FIXME: tab stop hardcoded to 8
          .replace(/\ /g, '&nbsp;')
          .replace(/(?!^)[\n\r]/g, '<br/>') # NOTE: initial \n does not count
        $(t).replaceWith("<span>#{cont}</span>")

    cssText = util.dq2sq el.style.cssText # prevent single-double-quote hell
    cont = el.innerHTML.trim() || dummy
    ret.style.cssText = cssText
    ret.innerHTML = cont
    ret # getSpan

  spanify = (el) ->
    if !el? then return
    $el = $(el)

    # workaround firefox non-standard text-decoration impl
    $el.find('s, del').each ->
      @style.textDecoration = 'line-through'

    # elem => span with "display: xxx"
    [
      ['pre, code', 'inline']
      ['s, del', 'inline']
      ['div, p, blockquote, q, article', 'block']
      ['h1, h2, h3, h4, h5, h6', 'block']
      ['hr', 'block']
      ['td, th', 'table-cell']
      ['tr', 'table-row']
      ['tbody, thead, tfoot', 'table-row-group']
      ['table', 'table']
    ].forEach (arg) ->
      ((sel, disp) ->
        while (x = $el.find(sel)[0])
          s = getSpan x
          s.style.display ||= disp
          $(x).replaceWith(s)
        return
      )(arg...)
      return # forEach (arg)

    # style on <a> is pruned, so restore by wrapping
    $el.find('a').each ->
      cssText = util.dq2sq @style.cssText # same as above
      @style.cssText = ''
      $(this).wrap("""<span style="#{cssText}" />""")

    return el
