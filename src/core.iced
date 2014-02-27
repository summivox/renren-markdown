###!
core
!###

core = {}

core.inlineCss = do ->
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
    wrapper = util.wrapped rootEl
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
    return util.unwrapped rootEl # inlineCss


# convert almost every element within a container into <span>
# NOTE:
# - container itself is not converted
# - `&nbsp;` is now filtered by renren -- use `&ensp;` instead
core.spanify = do ->
  # prevent element with empty innerHTML from being stripped
  DUMMY = '<span style="display:none;">&ensp;</span>'

  # every semantic element is equivalent to <span> with
  # tagName-decided default value for `display` CSS attr
  TAG_DISP = {}
  TAG_DISP[tagName] = disp for tagName in tagNames.toUpperCase().split(', ') for [tagNames, disp] in [
    ['a', 'inline']
    ['hr', 'block']
    ['s, del', 'inline']
    ['sup, sub', 'inline']
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
    ## list
    ['ol, ul', 'block']
    ['li', 'list-item']
  ]

  # helper: recursively list all text nodes within an element
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

  # preprocess: transform elements in-place before passing down to children
  spanifyPre = (el) ->
    return if !el?
    {tagName, innerHTML, innerText, style: {cssText}} = el

    switch tagName

      when 'PRE' # simulated using HTML entities
        # remove initial newlines
        el.innerHTML = innerHTML.toString().replace(/^[\n\r]+/, '') 

        # replace all trouble-makers in-place
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

      when 'CODE' # workaround display/spanify inconsistency
        el.style.whiteSpace = 'nowrap'

      when 'S', 'DEL' # workaround firefox non-standard text-decoration impl
        el.style.textDecoration = 'line-through'

    el # spanifyPre

  # postprocess: convert `el` with its already-spanified children into <span>
  spanifyPost = (el) ->
    if !el? then return $(DUMMY)
    {tagName, innerHTML, innerText, style: {cssText}} = el
    if !(disp = TAG_DISP[tagName])? then return el

    # circumvent "empty content" filters
    innerHTML = innerHTML.trim()
    if innerText.match /^\s*$/
      innerHTML = innerHTML.replace /&nbsp;/g, '&ensp;'
    if !innerHTML then innerHTML = DUMMY

    # circumvent stripped <a> style by extra wrapping
    if tagName == 'A'
      innerHTML = """<span style="#{cssText}">#{el.outerHTML}</span>"""

    ret = document.createElement 'span'
    ret.style.cssText = util.dquote_to_squote(cssText).trim()
    ret.style.display ||= disp
    ret.innerHTML = innerHTML
    ret

  # recursively spanify a whole element tree (in-place)
  spanifyRecur = (el) ->
    return if !el?
    el = spanifyPre el

    child = el.firstElementChild
    child = spanifyRecur(child).nextElementSibling while child

    el2 = spanifyPost el
    if el != el2
      $(el).replaceWith el2
      el = el2
    el

  # (preserve original semantics: `el` itself remains untouched)
  spanify = (el) ->
    $(el).children().each -> spanifyRecur @
    el


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
