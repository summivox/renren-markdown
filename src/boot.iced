###!
boot
!###

$ ->
  # TODO: load settings
  tinymce.init()
  cron.init()
  await
    markdown.init defer()
    ui.init defer()
    postproc.init defer()
  ui.listen()
