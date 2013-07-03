###!
process
!###

process = {}

process.sync = ->
  md = ui.getSource()
  el = markdown.convert md
  ui.setPreview el
  ui.setPreviewStyle PACKED_CSS['markdown.min.css']
