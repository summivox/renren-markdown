###!
postproc/mathjax
!###

do =>

  n = 0
  getTag = (i) -> "rrmd-pp-mathjax-#{i}"

  $ ->
    $(PACKED_HTML['mathjax-loadscript.html']).appendTo(document.head)
    util.injectFunction document, '$rrmd$mathjax$getTag', getTag
    util.injectFunction document, 'pollUntil', util.pollUntil
    util.injectScript document, ->
      ###!
      rrmd.postproc/mathjax (injected)
      !###
      src_to_display = (srcEl) ->
        j = MathJax.Hub.getJaxFor(srcEl)
        document.querySelector "\##{j.inputID}-Frame span.math"

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
          }, window.location.origin

          sel = '.' + $rrmd$mathjax$getTag(i)
          console.log sel
          el = previewDoc.querySelector sel
          console.log el
          MathJax.Hub.Queue(
            ['Typeset', MathJax.Hub, el, ->
              console.log 'mathjax: rendered'
              console.log el.textContent
              display = src_to_display el
              html2canvas [display], onrendered: (canvas) ->
                s = canvas.toDataUrl 'image/png'
                console.log 'mathjax: rasterized'
                console.log s
                cb()
            ]
          )

    # one handler for all callbacks
    # distinguished by sequence number
    callbacks = []
    window.addEventListener 'message', handler = (e) ->
      # check validity of message
      if !e? || e.origin != window.location.origin then return
      if i = (d = e.data)?._rrmd_pp_mathjax_cb
        callbacks[i]?(true)
        delete callbacks[i]

    postproc.register 'mathjax', "script[type^='math/tex']", (el) ->
      i = n++
      tag = "rrmd-pp-mathjax-#{i}"
      el.classList.add tag 
      {
        changed: true
        async: (el2, cb) ->
          window.postMessage {
            _rrmd_pp_mathjax: i
          }, window.location.origin
          callbacks[i] = cb
      }
