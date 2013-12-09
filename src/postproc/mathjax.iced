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
  getImg = (dataUrl, isDisplay) ->
    img = document.createElement 'img'
    img.src = dataUrl
    # display-mode math: add back centering
    if isDisplay
      $(img).wrap('<span style="display:block;width:100%;text-align:center">').parent()[0]
    else
      img

  await window.kisume.set 'mathjax', [], {
    render: (tag, cb) ->
      srcEl = document.getElementsByClassName(tag)[0]
      MathJax.Hub.Queue(
        ['Typeset', MathJax.Hub, srcEl, => cb null, @getRenderedSel srcEl]
      )
    getRenderedSel: (srcEl) ->
      j = window.MathJax.Hub.getJaxFor(srcEl)
      "\##{j.inputID}-Frame span.math"
  }, defer(err)

  handler = (el) ->
    isDisplay = el.type.match /display/
    if dataUrl = cache.get el.textContent.toString().trim()
      {
        replaceWith: getImg dataUrl, isDisplay
      }
    else
      seq = ++n
      tag = getTag(seq)
      el.classList.add tag
      {
        changed: true
        async: (el2, autocb) ->
          srcEl = $(el2).clone().appendTo($dummy)[0]
          await window.kisume.runAsync 'mathjax', 'render', tag, defer(err, renderedSel)
          if err?
            console.log 'mathjax: render error'
            console.error err
            return
          rendered = document.querySelector renderedSel
          if !(rendered instanceof Element)
            console.error "mathjax: can't find rendered math"
            return

          await core.rasterize rendered, defer(dataUrl)
          if !dataUrl
            console.error 'mathjax: rasterize error'
            return

          # delete associated elements from dummy
          $(rendered).parentsUntil($dummy).last().remove()
          $('.' + getTag(seq)).remove()

          $(el2).replaceWith(getImg(dataUrl, isDisplay))
          cache.set el2.textContent.toString().trim(), dataUrl
          return
      }
