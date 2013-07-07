###!
postproc/mathjax
!###

# Async process:
#   - `<script type="math/tex">` tagged in sandbox, -> injected
#   - injected calls MathJax
#   - MathJax callback injected, -> sandbox
#   - sandbox calls HTML2Canvas
#   - HTML2Canvas callback sandbox, then callback postproc manager

util.pollUntil 500, (-> ui.inited), ->
  doc = ui.el.previewDoc
  win = ui.el.previewWin

  # tag
  n = 0
  getTag = (i) -> "rrmd-pp-mathjax-#{i}"

  # transaction (keep track of each chain of async call)
  tran = []

  postproc.register 'mathjax', "script[type^='math/tex']", (el) ->
    i = n++
    tag = "rrmd-pp-mathjax-#{i}"
    el.classList.add tag
    {
      changed: true
      async: (el2, cb) ->
        win.postMessage {
          _rrmd_pp_mathjax: i
        }, win.location.origin
        tran[i] = {el, cb}
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

    # get ID of rendered math from source
    getSpanId = (srcEl) ->
      j = MathJax.Hub.getJaxFor(srcEl)
      "#{j.inputID}-Frame span.math"

    pollUntil 500, (-> MathJax?.isReady), ->
      console.log 'mathjax: ready'
      # FIXME: reduce coupling (seems mission impossible)
      previewDoc = document
        .getElementById('rrmd-ui-loader').contentDocument
        .getElementById('preview').contentDocument
      window.addEventListener 'message', handler = (e) ->
        # check validity of message
        if !e? || e.origin != window.location.origin then return
        if !(d = e.data)? || !(i = d._rrmd_pp_mathjax)? then return

        cb = -> window.postMessage {
          _rrmd_pp_mathjax_cb: i
          display_id: 
        }, window.location.origin

        sel = '.' + $rrmd$mathjax$getTag(i)
        console.log sel
        el = previewDoc.querySelector sel
        console.log el
        MathJax.Hub.Queue(
          ['Typeset', MathJax.Hub, el, ->
            console.log 'mathjax: rendered'
            console.log el.textContent
            display = document.querySelector('#' + getSpanId(el))
            cb()
          ]
        )

  # listen to injected script
  window.addEventListener 'message', handler = (e) ->
    # check validity of message
    if !e? || e.origin != window.location.origin then return
    if i = (d = e.data)?._rrmd_pp_mathjax_cb
      html2canvas [display], onrendered: (canvas) ->
        s = canvas.toDataUrl 'image/png'
        console.log 'mathjax: rasterized'
        console.log s
        cb()
