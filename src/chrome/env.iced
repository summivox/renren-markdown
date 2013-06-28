# Copyright (c) 2013, smilekzs, xiaoyao9933 (MIT Licensed)
# compatibility layer: chrome plugin

# This operates within a <script> tag in target page, with real `window`
# but no free XHR access. `window.postMessage` is needed to bridge this
# with the content script (which has XHR access)

window.rrmdEnv =
  # "unsafe window": just `window`
  window: window

  # XHR: bridge
  _xhrSeq: 0
  xhr: (details)->
    if !details?.url? then return
    seq = ++@_xhrSeq
    @window.addEventListener "message", (handler = (e) ->
      res = e?.data
      if res?._xhr_cb == seq
        console.log 'xhr cb at down'
        console.log res

        @window.removeEventListener "message", handler, false
        details[res.f]? res.arg
        return
    ), false
    {
      method
      url
      headers
      data
      overrideMimeType
      password
      user
    } = details
    o = {
      _xhr: seq
      data
      headers
      method
      overrideMimeType
      password
      url
      user
    }
    [
      'onreadystatechange'
      'onabort'
      'onerror'
      'onload'
      'onloadend'
      'onloadstart'
      'onprogress'
    ].map (f) -> o[f] = details[f]?

    console.log 'xhr at down' #debug
    console.log o #debug

    @window.postMessage o, "*"
