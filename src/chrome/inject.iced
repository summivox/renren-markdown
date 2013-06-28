# Copyright (c) 2013, smilekzs, xiaoyao9933 (MIT Licensed)
# compatibility layer: chrome plugin

# This operates in the "content script" domain, with free XHR access
# but fake `window`. Main script is injected into a <script> tag in
# the target page then run. See `env.iced` for details.

inject = (name) ->
  s = document.createElement 'script'
  s.src = chrome.extension.getURL 'js/' + name
  document.head.appendChild s

checkPageReady = (cb) ->
  tid=setInterval (->
    if document?.body?
      clearInterval(tid)
      cb()
  ), 250
await checkPageReady defer()

inject 'renren-markdown.chrome.js'

# XHR bridge
window.addEventListener "message", (handler = (e) ->
  if e.origin != "http://blog.renren.com" then return
  o = e.data
  if o?._xhr?
    xhr = new XMLHttpRequest()
    [
      'onreadystatechange'
      'onabort'
      'onerror'
      'onload'
      'onloadend'
      'onloadstart'
      'onprogress'
    ].map (f) ->
      if o[f]
        xhr[f] = (progress) ->
          if !(progress?.target) then return
          {
            lengthComputable
            loaded
            total
          } = progress
          {
            readyState
            responseHeaders
            responseText
            status
            statusText
          } = progress.target
          window.postMessage {
            _xhr_cb: o._xhr
            f
            arg: {
              lengthComputable
              loaded
              total
              readyState
              responseHeaders
              responseText
              status
              statusText
            }
          }, "*"
    xhr.open o.method, o.url, true, o.user, o.password
    xhr.send o.data
), false
