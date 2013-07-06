###!
xhr
!###

if !window.GM_xmlhttpRequest?
  if chrome?.extension?
    window.GM_xmlhttpRequest = (o) ->
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
            o[f] {
              lengthComputable
              loaded
              total
              readyState
              responseHeaders
              responseText
              status
              statusText
            }
      xhr.open o.method, o.url, true, o.user, o.password
      xhr.send o.data
  else
    window.GM_xmlhttpRequest = ->
      throw new Error 'GM_xmlhttpRequest missing'

# shortcuts

xhr = {}

xhr.get = (url, cb) ->
  _cb = (e) ->
    if e.status == 200
      cb(null, e.responseText)
    else
      cb(e.status)
  GM_xmlhttpRequest {
    method: 'GET'
    url: url
    onload: _cb
    onerror: _cb
  }
