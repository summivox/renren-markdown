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
  ui.pDoc.write PACKED_HTML['preview-iframe.html']
  $(ui.pDoc).ready ->
    ui.pBody = ui.pDoc.body
    ui.pCssClear = ui.pDoc.querySelector '#css-clear'
    ui.pCssMain = ui.pDoc.querySelector '#css-main'
    ui.pCssClear.textContent = PACKED_CSS['cssreset.css'] + '\n' + PACKED_CSS['cssbase.css']
    ui.inited = true

ui.getSource = -> ui.srcArea.value

ui.setPreview = (el) ->
  orig = ui.pBody.firstElementChild
  if orig? then ui.pBody.replaceChild el, orig
  else ui.pBody.appendChild el

ui.setPreviewCss = (css) -> ui.pCssMain.textContent = css
