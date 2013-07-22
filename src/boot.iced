###!
boot
!###

kisume = null

$ ->
  # TODO: load settings
  await
    kisume = Kisume window, defer()
    css.init defer()
    ui.init defer()
    tinymce.init defer()
    postproc.init defer()
  cron.init()
  markdown.init()
  ui.listen()
