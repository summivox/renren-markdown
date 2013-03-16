# Copyright (c) 2013, smilekzs, xiaoyao9933 (MIT Licensed)
# compatibility layer: chrome plugin

# "unsafe window": just `window` since main script is injected
window.W = window

# XHR: use background page
window.GM_xmlhttpRequest = (data)->
  messagedata=""
  receiveMessage=(event)->
    console.log("rrmd: xhr: response")
    messagedata=event.data
  W.frames[1].addEventListener("message", receiveMessage, false)
  W.frames[0].postMessage(data.url,"*")
  checkMessageReady=(cb)->
    mid=setInterval (->
      if messagedata isnt ""
        clearInterval(mid)
        cb()
    ) ,1000
  await checkMessageReady defer()
  if messagedata.substr(0,7) is "#ERROR#"
    data.onerror messagedata
  else
    data.onload {'responseText': messagedata}
  W.frames[1].removeEventListener("message", receiveMessage, false)
