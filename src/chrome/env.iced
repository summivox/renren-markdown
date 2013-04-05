# Copyright (c) 2013, smilekzs, xiaoyao9933 (MIT Licensed)
# compatibility layer: chrome plugin

window.rrmdEnv =
  # "unsafe window": just `window` since main script is injected
  window: window

  # XHR: use background page
  xhr: (data)->
    messagedata=""
    receiveMessage=(event)->
      console.log("rrmd: xhr: response")
      messagedata=event.data
    @window.frames[1].addEventListener("message", receiveMessage, false)
    @window.frames[0].postMessage(data.url,"*")
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
    @window.frames[1].removeEventListener("message", receiveMessage, false)
