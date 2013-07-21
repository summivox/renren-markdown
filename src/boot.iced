###!
boot
!###

$ ->
  # TODO: load settings
  await
    css.init defer()
    ui.init defer()
    postproc.init defer()
  tinymce.init()
  cron.init()
  markdown.init()
  ui.listen()
