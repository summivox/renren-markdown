###!
ui
!###

ui = {}

ui.inited = false
ui.init = ->
  ui.cssClear = markdown.cssClearText

  # construct UI HTML & CSS
  await ui.el = new ((autocb) ->
    @loader = $(PACKED_HTML['ui-loader.html']).appendTo('body')[0]
    @mainDoc = @loader.contentDocument
    await $(@mainDoc).ready defer()
    @mainDoc.write PACKED_HTML['ui-main.html']
    @mainCssClear = @mainDoc.getElementById 'css-clear'
    @mainCssClear.textContent = ui.cssClear
    @mainCss = @mainDoc.getElementById 'css'
    @mainCss.textContent = PACKED_CSS['ui.css']


    @preview = @mainDoc.getElementById 'preview'
    @previewDoc = @preview.contentDocument
    await $(@previewDoc).ready defer()
    @previewDoc.write PACKED_HTML['ui-preview.html']
    @previewCssClear = @previewDoc.getElementById 'css-clear'
    @previewCssClear.textContent = ui.cssClear
    @previewCss = @previewDoc.getElementById 'css'

    @area = @mainDoc.getElementById 'area'
    @previewBody = @previewDoc.body
    @commit = @mainDoc.getElementById 'commit'

    # FIXME: better editor open button
    @open = $('<input type="button" id="rrmd-ui-open" value="renren-markdown" />').insertBefore('#editor')[0]
    
  )(defer())

  # hook up events
  ui.el.open.addEventListener 'click', (e)-> ui.show()
  ui.el.area.addEventListener 'input', (e)-> cron.trig()
  ui.el.commit.addEventListener 'click', (e)-> process.commit()

  ui.inited = true
  ui.active = false

ui.show = (cb) ->
  await $(ui.el.loader).fadeIn 500, defer()
  $('#container').hide()
  ui.active = true
  cb?()

ui.hide = (cb) ->
  $('#container').show()
  await $(ui.el.loader).fadeOut 500, defer()
  ui.active = false
  cb?()

ui.getSource = -> ui.el.area.value

ui.getPreview = -> ui.el.previewBody.firstElementChild
ui.setPreview = (el) -> do (body = ui.el.previewBody) ->
  orig = body.firstElementChild
  if orig? then body.replaceChild el, orig
  else body.appendChild el

ui.getSourceScroll = -> util.scrollRatio(ui.el.area)
ui.setPreviewScroll = (ratio) -> null # FIXME: copy dillinger.io impl

ui.setPreviewCss = (css) -> ui.el.previewCss.textContent = css
