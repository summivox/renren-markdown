###!
postproc/gist
!###

do ->
  inited = false

  urlRe = 
    ///
    ^(?:(?:http|https)\://)? # http:// or https:// or omitted protocol
    gist\.github\.com/
    ([\w\/]+) # gist id (including username)
    ///
  makeUrl = (id) -> "https://gist.github.com/#{id}.js"
  testUrl = makeUrl('smilekzs/5938692')

  cssText = ""
  cssRules = null

  jsRe = -> # use new Regexp instance each pass
    ///
    ^\s*
      document\.write\(
        (.*)
      \)
    \s*$
    ///mg
  cssRe = /link\s*href=\"([^"]*)\"/
  parse = (js) ->
    nret = {cssUrl: null, cont: null}

    re = jsRe()

    cssUrlWrap = util.jsStr(re.exec(js)?[1])
    if !cssUrlWrap then return nret
    cssUrl = cssRe.exec(cssUrlWrap)?[1]
    if !cssUrl then return nret
    cont = util.jsStr(re.exec(js)?[1])
    if !cont then return nret

    {cssUrl, cont}

  # cache[id] = clone of fully processed gist DOM
  cache = {}

  $ ->
    # init: pre-fetch gist css
    await
      ((autocb) ->
        await xhr.get testUrl, defer(err, testJs)
        if err || !testJs then return false

        {cssUrl} = parse testJs
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
      console.log 'rrmd postproc/gist: fail to init'
      return

    postproc.register 'gist', 'a', (el)->
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

              {cont} = parse js
              if !cont then return false

              $cont = $(cont)
              el3 = core.spanify core.inlineCss $cont[0], cssRules

              $(el2).replaceWith(el3)
              cache[id] = el3.cloneNode(true)
              return true
          }
      else
        {changed: false}
