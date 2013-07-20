###!
postproc/gist
!###

postproc.register 'gist', 'a', (autocb) ->

  # gist URL
  urlRe =
    ///
    ^(?:(?:http|https)\://)? # http:// or https:// or omitted protocol
    gist\.github\.com/
    ([\w\/]+) # gist id (including username)
    ///
  makeUrl = (id) -> "https://gist.github.com/#{id}.js"
  testUrl = makeUrl('smilekzs/5938692')

  # gist styling (remotely loaded)
  cssText = ""
  cssRules = null

  # extract information from js
  getCssUrl = (js) ->
    if m = js.match /link.*href=\"([^"]*)\"/
      return m[1]
    else return null
  getContent = do ->
    n = 0
    getContent = (js, cb) ->
      ifr = core.makeIframe "rrmd-pp-gist-#{++n}", (doc) ->
        doc.write """<script>#{js}</script>"""
        cb? doc.body.innerHTML

  # cache[id] = clone of fully processed gist DOM
  cache = {}

  # init: get gist CSS
  inited = false
  await
    ((autocb) ->
      await xhr.get testUrl, defer(err, testJs)
      if err || !testJs then return false

      cssUrl = getCssUrl testJs
      if !cssUrl then return false

      await xhr.get cssUrl, defer(err, _cssText)
      if err || !_cssText then return false
      cssText = _cssText # use the one in the closure

      await core.getAugCssRules cssText, defer(_cssRules)
      cssRules = _cssRules # ditto

      return true
    )(defer(inited))

  if !inited
    # TODO: report error
    console.log 'gist: fail to init'
    return ->
      console.log 'gist: dead'
      {changed: false}

  return handler = (el) ->
    if el.href.trim() == el.innerHTML.trim() && m = el.href.match urlRe
      id = m[1]
      if (cachedEl = cache[id])?
        {replaceWith: cachedEl.cloneNode(true)}
      else
        {
          changed: true
          async: (el2, autocb) ->
            await xhr.get makeUrl(id), defer(err, js)
            if err || !js then return false

            await getContent js, defer(cont)
            if !cont then return false

            $cont = $(cont)

            # workaround: line numbers should not wrap
            $cont.find('.gist-data').each -> @style.whiteSpace||='nowrap'

            el3 = core.spanify core.inlineCss $cont[0], cssRules
            $(el2).replaceWith(el3)
            cache[id] = el3.cloneNode(true)
            return true
        }
    else # if href== && match
      {changed: false}
