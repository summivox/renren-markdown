###!
core
!###

core = {}

# get augmented css rules from css source
# "augmented":
#   comma-separated selectors with same body => multiple rules
#   rules sorted by specificity (high -> low) then index (last -> first)
#   (later rules don't override earlier rules unless `!important`)
core.getAugCssRules = do ->
  # augment css rules
  aug = (rules) ->
    ret = []
    idx = 0
    rules.forEach (r) ->
      for {selector, specificity} in getSpecificity r.selectorText
        idx = ret.push {
          selectorText: selector
          style: r.style
          specificity
          idx
        }
      return # forEach
    ret.sort (a, b) ->
      for i in [0..2]
        if (c = b.specificity[i] - a.specificity[i])
          return c
      return b.idx - i.idx # stable sort

  # use iframe to get original css rules
  iframe = do ->
    n = 0
    iframe = ->
      """<iframe
        id="rrmd_iframe_#{n++}"
        style="position:fixed; left: -10px; width: 1px; height: 1px;"
      />"""

  getAugCssRules = (css, cb) ->
    doc = $(iframe()).appendTo('body')[0].contentDocument
    $(doc).ready ->
      doc.write """<style type="text/css">#{css}</style>"""
      cb? aug util.arrayize doc.styleSheets[0].cssRules

core.inlineCss = do ->
  # workaround: non-standard entries
  valid = (s) -> s && s[0] != '-'
  prune = (s) ->
    if (m = s.match /^(.*)-value$/) && s != 'drop-initial-value'
      return m[1]
    return s

  read = (style, key) ->
    val: style.getPropertyValue(key)?.trim()
    pri: style.getPropertyPriority(key)?.trim()
  canOverride = (curr, prev) ->
    # prev.val | prev.pri | curr.pri
    # 0          0          ?        => 1 (no old value => yes)
    # 0          1          ?        => ? (invalid)
    # 1          1          ?        => 0 (old important => no)
    # 1          0          1        => 1 (old important, new important => yes)
    valid(curr.val) && (!prev.val || (!prev.pri && curr.pri))

  inlineCss = (rootEl, rules) ->
    for r in rules
      {selectorText: sel, style} = r
      for el in util.arrayize rootEl.querySelectorAll sel
        for key in style
          if !valid(key) then continue
          key = prune(key)
          curr = read(   style, key)
          prev = read(el.style, key)
          if canOverride(curr, prev)
            el.style.setProperty(key, curr.val, curr.pri)
    return rootEl # inlineCss

# convert almost every element within a container into <span>
# NOTE: container itself is not converted
core.spanify = do ->
  # prevent element with empty innerHTML from being stripped
  dummy = '<span style="display: none;">&nbsp;</span>'

  getTextNodes = (rootEl) ->
    ret = []
    find = (node) ->
      if node.nodeType == 3
        ret.push node
      else
        for n in node.childNodes
          find n
      return
    find rootEl
    ret

  # single element => span
  getSpan = (el) ->
    if !el? then return $(dummy)
    ret = document.createElement 'span'

    # special: <pre>-formatting
    if el.tagName == 'PRE'
      for t in getTextNodes el
        t2 = document.createElement 'span'
        t2.innerHTML = t.data.toString()
          .replace(/\&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/\t/g, '        ') # tab stop hardcoded to 8
          .replace(/\ /g, '&nbsp;')
          .replace(/(?!^)[\n\r]/g, '<br/>') # NOTE: initial \n does not count
        $(t).replaceWith(t2)

    cssText = util.dquote_to_squote el.style.cssText # prevent single-double-quote hell
    cont = el.innerHTML.trim() || dummy
    ret.style.cssText = cssText
    ret.innerHTML = cont
    ret # getSpan

  # FIXME: switch to bottom-up tree traversal
  spanify = (rootEl) ->
    if !rootEl? then return

    # workaround firefox non-standard text-decoration impl
    for el in rootEl.querySelectorAll 's, del'
      el.style.textDecoration = 'line-through'

    # elem => span with "display: xxx"
    for [sel, disp] in [
      ['pre', 'block']
      ['code', 'inline']
      ['s, del', 'inline']
      ['div, p, blockquote, q, article', 'block']
      ['h1, h2, h3, h4, h5, h6', 'block']
      ['hr', 'block']
      ['td, th', 'table-cell']
      ['tr', 'table-row']
      ['tbody, thead, tfoot', 'table-row-group']
      ['table', 'table']
    ]
      while (x = rootEl.querySelector sel)
        s = getSpan x
        s.style.display ||= disp
        $(x).replaceWith(s)

    # style on <a> is pruned, so restore by wrapping
    for el in util.arrayize rootEl.querySelectorAll 'a'
      cssText = util.dquote_to_squote el.style.cssText # same as above
      el.style.cssText = ''
      $(el).wrap("""<span style="#{cssText}" />""")

    return rootEl # spanify

# (hidden) message embedded into blog
do ->
  tag = 'http://dummy/$rrmd$'

  core.embed = (s) ->
    """<span style="display:none;">
      <br/> == begin renren-markdown source ==
      <br/> <span style="background-image:url('#{tag}')">#{util.str_to_b64(s)}</span>
      <br/> == end renren-markdown source ==
    </div>"""

  core.unembed = (h) ->
    h = h?.trim()
    if !h then return ''
    for el in $(h).find("span[style*='#{tag}']")
      b64 = el.innerHTML?.trim()
      if !b64 then continue
      try return util.b64_to_str b64
      catch e then continue
    return ''
