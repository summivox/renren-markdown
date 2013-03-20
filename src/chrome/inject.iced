# Copyright (c) 2013, xiaoyao9933 (MIT Licensed)
# Inject the renren-markdown js into web and listen the event.

inject = (name, callback) ->
  s = document.createElement 'script'
  s.src = chrome.extension.getURL 'js/' + name
  document.head.appendChild s

receiveMessage = (event)->
  if (event.origin != "http://blog.renren.com")
    return
  xmlHttp=new XMLHttpRequest()
  xmlHttp.open("GET", event.data, false)
  try
    xmlHttp.send(null)
    window.frames[1].postMessage(xmlHttp.responseText, "*")
  catch err
    window.frames[1].postMessage("#ERROR#"+err.message, "*")

checkPageReady = (cb)->
  tid=setInterval (->
    if window.frames?[0]?
      clearInterval(tid)
      cb()
  ), 250

await checkPageReady defer()

inject 'renren-markdown.chrome.js'

window.frames[0].addEventListener("message", receiveMessage, false)
