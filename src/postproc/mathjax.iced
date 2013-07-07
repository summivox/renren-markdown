###!
postproc/mathjax
!###

# Async process:
#   - stash postproc callback
#   - `<script type="math/tex">` tagged in sandbox, message injected
#   - injected calls MathJax, callback: message sandbox
#   - sandbox calls HTML2Canvas, callback: postproc callback

util.pollUntil 250, (-> ui.inited), ->
  doc = ui.el.previewDoc
  win = ui.el.previewWin

  # tag
  n = 0
  getTag = (seq) -> "rrmd-pp-mathjax-#{seq}"

  # keep track of callbacks
  callback = []

  postproc.register 'mathjax', "script[type^='math/tex']", (el) ->
    seq = n++
    tag = "rrmd-pp-mathjax-#{seq}"
    el.classList.add tag
    {
      changed: true
      async: (el2, cb) ->
        win.postMessage {
          _rrmd_pp_mathjax: seq
        }, win.location.origin
        callback[seq] = cb
    }

  # NOTE: We could have embedded MathJax loader directly into `ui-preview.html` but
  # I've always considered this a plugin, so I don't want to mix it with the core.
  $(PACKED_HTML['mathjax-loadscript.html']).appendTo(doc.head)

  util.injectFunction doc, '$rrmd$mathjax$getTag', getTag
  util.injectFunction doc, 'pollUntil', util.pollUntil
  util.injectScript doc, ->
    ###!
    rrmd.postproc/mathjax (injected)
    !###

    debugger

    # get ID of rendered math from source
    getRenderedId = (srcEl) ->
      j = MathJax.Hub.getJaxFor(srcEl)
      "#{j.inputID}-Frame span.math"

    pollUntil 500, (->
      ret = MathJax?.isReady
      console.log ret
      ret
    ), ->
      console.log 'mathjax: ready'
      # FIXME: reduce coupling (seems mission impossible)
      previewDoc = document
        .getElementById('rrmd-ui-loader').contentDocument
        .getElementById('preview').contentDocument
      window.addEventListener 'message', handler = (e) ->
        # check validity of message
        if !e? || e.origin != window.location.origin then return
        if !(d = e.data)? || !(seq = d._rrmd_pp_mathjax)? then return

        sel = '.' + $rrmd$mathjax$getTag(seq)
        el = previewDoc.querySelector sel

        MathJax.Hub.Queue(
          ['Typeset', MathJax.Hub, el, ->
            console.log 'mathjax: rendered'
            console.log el.textContent
            window.postMessage {
              _rrmd_pp_mathjax_cb: seq
              renderedId: getRenderedId el
            }, window.location.origin
          ]
        )

  # listen to injected script
  win.addEventListener 'message', handler = (e) ->
    # check validity of message
    if !e? || e.origin != win.location.origin then return
    if !(seq = (d = e.data)?._rrmd_pp_mathjax_cb)?
      rendered = doc.getElementById d.renderedId
      # name seems strange -- this is the "rasterize" step
      html2canvas [rendered], onrendered: (canvas) ->
        dataUrl = canvas.toDataUrl 'image/png'
        console.log 'mathjax: rasterized'
        console.log dataUrl
        # TODO: do something with dataUrl
        callback[seq]?()
