###!
postproc
!###

# init: (cb) -> handler
# handler: (el) -> {changed: bool, replaceWith: el2, async: (el2, cb) -> ...}

postproc = []

postproc.register = (name, sel, init) ->
  @push {
    enabled: true
    name
    sel
    init
    handler: (->) 
  }

# initialize all postprocs, callback when all finish
postproc.init = (cb) ->
  await for entry in this
    {enabled, init} = entry
    if enabled then init defer(entry.handler)
  cb?()

# run sync parts of all postprocs
# returned: function that runs all async parts, callback when all finished
postproc.run = do ->
  tag = 'rrmd-pp'
  run = (rootEl) ->
    ct = []
    for {enabled, sel, handler} in this
      if !enabled then continue
      for el in util.arrayize rootEl.querySelectorAll sel
        unless tag in el.classList
          {changed, replaceWith: el2, async} = handler el
          if changed
            el.classList.add tag
            el2 = el
          else if el2 instanceof Element
            el2.classList.add tag
            $(el).replaceWith(el2)
          if async instanceof Function
            ct.push {async, el2}
    return (cb) ->
      err = new Array ct.length
      await for {async, el2}, i in ct
        async el2, defer(err[i])
      cb?(err)
