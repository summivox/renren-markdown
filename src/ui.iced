###!
ui
FIXME: currently only for test.html
!###

ui = {}

ui.inited = false
ui.init = ->
  ui.srcArea = document.getElementById 'area'

  ui.pFrame = document.getElementById 'preview'
  ui.pDoc = ui.pFrame.contentDocument
  $(ui.pDoc).ready ->
    ui.pBody = ui.pDoc.body
    ui.pStyleClear = ui.pDoc.createElement 'style'
    ui.pStyleClear.textContent = PACKED_CSS['cssreset.css'] + '\n' + PACKED_CSS['cssbase.css']
    ui.pDoc.head.appendChild ui.pStyleClear
    ui.pStyle = ui.pDoc.createElement 'style'
    ui.pDoc.head.appendChild ui.pStyle
    ui.inited = true

ui.getSource = -> ui.srcArea.value

ui.setPreview = (el) ->
  orig = ui.pBody.firstElementChild
  if orig? then ui.pBody.replaceChild el, orig
  else ui.pBody.appendChild el

ui.setPreviewStyle = (css) -> ui.pStyle.textContent = css
