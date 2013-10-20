###!
core
!###

core = {}

core.inlineCss = do ->
  # workaround: attribute of root element not selected
  wrapped = (el) -> $(el).wrap('<span>').parent()[0]
  unwrapped = (el) -> $(el).unwrap()[0]

  # workaround: non-standard css attributes / values
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
    wrapper = wrapped rootEl
    for r in rules
      {selectorText: sel, style} = r
      for el in util.arrayize wrapper.querySelectorAll sel
        for key in style
          if !valid(key) then continue
          key = prune(key)
          curr = read(   style, key)
          prev = read(el.style, key)
          if canOverride(curr, prev)
            el.style.setProperty(key, curr.val, curr.pri)
    return unwrapped rootEl # inlineCss

# convert almost every element within a container into <span>
# NOTE:
# - container itself is not converted
# - `&nbsp;` is now filtered by renren -- use `&ensp;` instead
core.spanify = do ->
  # prevent element with empty innerHTML from being stripped
  dummy = '<span style="display:none;">&ensp;</span>'

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
      # first remove initial linebreaks
      el.innerHTML = el.innerHTML.toString().replace(/^[\n\r]+/, '')
      for t, i in getTextNodes el
        t2 = document.createElement 'span'
        t2.innerHTML = t.data.toString()
          .replace(/\&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/\t/g, '        ') # tab stop hardcoded to 8
          .replace(/\ /g, '&ensp;')
          .replace(/[\n\r]/g, '<br/>')
        $(t).replaceWith(t2)
      # finally remove "whitespace: pre" setting
      el.style.whiteSpace = ''

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
      ['hr', 'block']
      ['s, del', 'inline']
      ['pre', 'block']
      ['code', 'inline']
      ['div, p, blockquote, q, article', 'block']
      ['h1, h2, h3, h4, h5, h6', 'block']
      ## table
      ['td, th', 'table-cell']
      ['tr', 'table-row']
      ['caption', 'table-caption']
      ['col', 'table-column']
      ['col-group', 'table-column-group']
      ['thead', 'table-header-group']
      ['tbody', 'table-row-group']
      ['tfoot', 'table-footer-group']
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

  core.embed = (s) -> """
    <span style="display:none;"><br/>
      <br/>== powered by renren-markdown ==
      <br/><span style="background-image:url('#{tag}')">#{util.str_to_b64(s)}</span>
      <br/>
    </span>
  """

  core.unembed = (h) ->
    h = h?.trim()
    if !h then return ''
    for el in $(h).find("span[style*='#{tag}']")
      b64 = el.innerHTML?.trim()
      if !b64 then continue
      try return util.b64_to_str b64
      catch e then continue
    return ''

# rasterize an element and return data URL of the image
core.rasterize = (el, cb) ->
  if !(el instanceof Element) then return cb? null
  html2canvas [el], onrendered: (canvas) ->
    cb? canvas.toDataURL 'image/png'

core.relayDataUrl = do ->
  re = /data:([^;])+;base64,([\w\+\/\=]+)/
  prefix = 'http://emhvb.blahgeek.com/?'
  relayDataUrl = (dataUrl) ->
    if m = dataUrl.match re
      b64 = m[2]
      dataUrl = prefix + b64
    dataUrl

core.relayAllImg = (rootEl) ->
  for el in util.arrayize rootEl.querySelectorAll "img[src^='data']"
    el.src = core.relayDataUrl el.src
