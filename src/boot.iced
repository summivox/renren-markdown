###!
boot
!###

$ ->
  # TODO: load settings
  await
    css.init defer()
    ui.init defer()
    tinymce.init defer()
    postproc.init defer()
  cron.init()
  markdown.init()
  ui.listen()
