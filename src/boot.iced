###!
boot
!###

if !unsafeWindow? then unsafeWindow = window

$ ->
  console.log '### renren-markdown starting'
  # TODO: load settings
  await window.kisume = Kisume unsafeWindow, 'kisume_rrmd', {coffee: true}, defer()
  await window.kisume.set 'util', [], util, defer()
  await
    css.init defer()
    ui.init defer()
    tinymce.init defer()
    postproc.init defer()
  cron.init()
  markdown.init()
  ui.listen()
  console.log '### renren-markdown ready'
