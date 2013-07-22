###!
postproc/mathjax
!###

# postproc async process:
#   1. Copy math to dummy container
#   2. Pass down for rendering
#   3. Callback up for rasterization

# MathJax loads rather slowly, but is independent from other processes,
# so we may load it immediately after page loads
$ -> $(PACKED_HTML['mathjax-loadscript.html']).appendTo(document.head)

postproc.register 'mathjax', "script[type^='math/tex']", (autocb) ->

  # create dummy container
  $dummy = $(PACKED_HTML['mathjax-dummy.html']).appendTo(document.body)

  # sequence number
  n = 0
  getTag = (seq) -> "rrmd-pp-mathjax-#{seq}"

  # cache
  cache = new Lru 100 # TODO: settable

  # image from dataUrl
  getImg = (dataUrl, isDisplay, cached) ->
    img = document.createElement 'img'
    img.src = dataUrl
    # display-mode math: add back centering
    if isDisplay
      $(img).wrap('<span style="display:block;width:100%;text-align:center">').parent()[0]
    else
      img

  await Kisume window, defer(kisume)
  await kisume.set 'mathjax', {
    render: (tag, cb) ->
      srcEl = document.getElementsByClassName(tag)[0]
      MathJax.Hub.Queue(
        ['Typeset', MathJax.Hub, srcEl, -> cb null, @mathjax.getRenderedSel srcEl]
      )
    getRenderedSel: (srcEl) ->
      j = window.MathJax.Hub.getJaxFor(srcEl)
      "\##{j.inputID}-Frame span.math"
  }, defer(err)

  handler = (el) ->
    isDisplay = el.type.match /display/
    if dataUrl = cache.get el.textContent.toString().trim()
      {
        replaceWith: getImg dataUrl, isDisplay, true
      }
    else
      seq = ++n
      tag = getTag(seq)
      el.classList.add tag
      {
        changed: true
        async: (el2, cb) ->
          srcEl = $(el2).clone().appendTo($dummy)[0]
          kisume.runAsync 'mathjax', 'render', (err, renderedSel) ->
            if err?
              console.log 'mathjax: render error'
              console.log err
              return

            rendered = document.querySelector renderedSel
            if !(rendered instanceof Element)
              console.log "mathjax: can't find rendered math"
              cb?()
              return

            core.rasterize rendered, (dataUrl) ->
              if !dataUrl
                console.log 'mathjax: rasterize error'
                return

              # delete associated elements from dummy
              $(rendered).parentsUntil($dummy).last().remove()
              $('.' + getTag(seq)).remove()

              $(el2).replaceWith(getImg(dataUrl, isDisplay))
              cache.set el2.textContent.toString().trim(), dataUrl
              cb?()
              return # core.rasterize
            return # kisume.runAsync
          return # async
      }
