###!
process
!###

process = {}

process.sync = ->
  md = ui.getSource()
  el = markdown.convert md
  ui.setPreview el
  ui.setPreviewCss markdown.cssText
