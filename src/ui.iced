###!
ui
!###

ui = {}

ui.inited = false
ui.init = (cb) ->
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
    @previewWin = @preview.contentWindow
    await $(@previewDoc).ready defer()
    @previewDoc.write PACKED_HTML['ui-preview.html']
    @previewCssClear = @previewDoc.getElementById 'css-clear'
    @previewCssClear.textContent = ui.cssClear
    @previewCss = @previewDoc.getElementById 'css'

    @area = @mainDoc.getElementById 'area'
    @previewBody = @previewDoc.body
    @commit = @mainDoc.getElementById 'commit'

    @open = $(PACKED_HTML['ui-button.html']).prependTo('#title_bg')[0]
    @open.style.opacity = 0.2 # mark as inactive
  )(defer()) # await ui.el

  # fullscreen helper
  util.injectFunction document, '$rrmd$util$launchFullScreen', util.launchFullScreen
  util.injectFunction ui.el.mainDoc, '$rrmd$util$cancelFullScreen', util.cancelFullScreen
  util.injectScript document, ->
    ###!
    rrmd.ui (injected)
    !###
    window.$rrmd$ui$fullscreen = ->
      $rrmd$util$launchFullScreen document.getElementById 'rrmd-ui-loader'

  ui.inited = true
  ui.active = false
  cb?() # ui.init

ui.listen = ->
  ui.el.open.style.opacity = 1 # active
  ui.el.open.addEventListener 'click', (e) -> process.open()
  ui.el.area.addEventListener 'input', (e) -> cron.trig()
  ui.el.commit.addEventListener 'click', (e) -> process.commit()

ui.show = (cb) ->
  await $(ui.el.loader).fadeIn 250, defer()
  $('#container').hide()
  ui.active = true
  cb?()

ui.hide = (cb) ->
  ui.active = false
  $('#container').show()
  await $(ui.el.loader).fadeOut 250, defer()
  cb?()

ui.getSource = -> ui.el.area.value
ui.setSource = (s) -> ui.el.area.value = s

ui.getPreview = -> ui.el.previewBody.firstElementChild
ui.setPreview = (el) -> do (body = ui.el.previewBody) ->
  orig = body.firstElementChild
  if orig? then body.replaceChild el, orig
  else body.appendChild el

ui.getSourceScroll = -> util.scrollRatio(ui.el.area)
ui.setPreviewScroll = (ratio) -> null # FIXME: copy dillinger.io impl

ui.setPreviewCss = (css) -> ui.el.previewCss.textContent = css
