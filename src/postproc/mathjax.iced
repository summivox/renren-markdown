###!
postproc/mathjax
!###

do =>
  inited = false

  previewHtml =
    """
      <script type="text/x-mathjax-config">
      MathJax.Hub.Config({
        jax: ["input/TeX","output/HTML-CSS"],
        //extensions: ["tex2jax.js","MathMenu.js","MathZoom.js"],
        TeX: {
          extensions: ["AMSmath.js","AMSsymbols.js","noErrors.js","noUndefined.js"]
        },
        skipStartupTypeset: true
      });
      </script>
      <script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js"></script>
    """

  $ -> do (doc = ui.el.previewDoc) ->
    # add MathJax code
    $(previewHtml).appendTo(doc.head)

    # refresh hook
    util.injectScript doc, ->
      ###!
      rrmd.postproc/mathjax (injected)
      !###
      do ->
        iid = setInterval (->
          if MathJax?.isReady
            clearInterval iid
            boot()
        ), 1000
      boot = ->
        window.addEventListener 'message', (e) ->
          if !e? || e.origin != window.location.origin then return
          if !(d = e.data)? || !(seq = d._rrmd_pp_mathjax)? then return
          # TODO
