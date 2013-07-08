###!
postproc/mathjax
!###


# postproc async process:
#   1. Copy math to dummy container
#   2. Pass down for rendering
#   3. Callback up for rasterization

$(PACKED_HTML['mathjax-loadscript.html']).appendTo(document.head)
$dummy = $(PACKED_HTML['mathjax-dummy.html']).appendTo(document.body)

util.pollUntil 250, (-> ui.inited), ->

  # sequence number
  n = 0
  getTag = (seq) -> "rrmd-pp-mathjax-#{seq}"

  # transaction
  tran = []

  # step 1
  postproc.register 'mathjax', "script[type^='math/tex']", (el) ->
    seq = ++n
    tag = getTag(seq)
    el.classList.add tag
    {
      changed: true
      async: (el2, cb) ->
        srcEl = $(el2).clone().appendTo($dummy)[0]
        tran[seq] = {el2, cb}
        window.postMessage {
          _rrmd_pp_mathjax: seq
        }, window.location.origin
    }

  # step 2
  util.injectFunction document, '$rrmd$pp$mathjax$getTag', getTag
  util.injectScript document, -> do ->
    ###!
    rrmd.postproc/mathjax (injected)
    !###

    getTag = $rrmd$pp$mathjax$getTag
    getRenderedSel = (srcEl) ->
      j = MathJax.Hub.getJaxFor(srcEl)
      "\##{j.inputID}-Frame span.math"

    window.addEventListener 'message', (e) ->
      # check validity of message
      if !e? || e.origin != window.location.origin then return
      if !(d = e.data)? || !(seq = d._rrmd_pp_mathjax)? then return
      srcEl = document.getElementsByClassName(getTag(seq))[0]
      MathJax.Hub.Queue(
        ['Typeset', MathJax.Hub, srcEl, ->
          console.log 'mathjax: rendered'
          console.log srcEl.textContent
          window.postMessage {
            _rrmd_pp_mathjax_cb: seq
            renderedSel: getRenderedSel srcEl
          }, window.location.origin
        ]
      )

  # step 3
  window.addEventListener 'message', (e) ->
    # check validity of message
    if !e? || e.origin != window.location.origin then return
    if !(d = e.data)? || !(seq = d._rrmd_pp_mathjax_cb)? then return

    rendered = document.querySelector d.renderedSel

    html2canvas [rendered], onrendered: (canvas) ->
      dataUrl = canvas.toDataURL('image/png')
      console.log 'mathjax: rasterized: ' + dataUrl.length
      console.log dataUrl

      img = document.createElement 'img'
      img.src = dataUrl
      $(tran[seq].el2).replaceWith(img)

      tran[seq].cb?()
      delete tran[seq]

      # TODO:
      #   display => center (with extra div)
      #   final dataUrl => emhvb.blahgeek.com/?
