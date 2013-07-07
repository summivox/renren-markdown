###!
tinymce
!###

tinymce = {}

# bridge calls to the TinyMCE editor instance
# example: tinymce.call 'setContent', '...', (err, ret) -> console.log ret
tinymce.call = do ->
  n = 0
  call = (method, arg..., cb) ->
    seq = ++n
    window.addEventListener 'message', handler = (e) ->
      if !e? || e.origin != window.location.origin then return
      if (d = e.data)?._rrmd_tinymce_cb == seq
        cb? d.err, d.ret
        window.removeEventListener 'message', handler
    try
      window.postMessage {
        _rrmd_tinymce: seq
        method, arg
      }, window.location.origin
    catch err
      # TODO: error -> UI
      console.log 'RRMD: tinymce.call error'
      cb? err, null

tinymce.init = ->
  util.injectFunction document, 'pollUntil', util.pollUntil
  util.injectScript document, ->
    ###!
    rrmd.tinymce (injected)
    !###

    # bootstrap
    editor = null
    pollUntil 500, (-> editor = window.tinymce?.editors?[0]), ->
      window.$rrmd$tinymce = editor
      init()

    init = ->
      window.addEventListener 'message', handler = (e) ->
        # check validity of message
        if !e? || e.origin != window.location.origin then return
        if !(d = e.data)? || !(seq = d._rrmd_tinymce)? then return

        # workaround: interference from @-mention
        if editor.mention then editor.mention.disabled = true

        # bridge the call
        cb = (err, ret) ->
          window.postMessage {
            _rrmd_tinymce_cb: seq
            err, ret
          }, window.location.origin
        try
          cb null, editor[d.method].apply(editor, d.arg)
        catch err
          cb err, null
