###!
tinymce
!###

tinymce = {}

tinymce.inited = false
tinymce.init = (autocb) ->
  await window.kisume.runAsync ((cb) ->
    editor = null
    @util.pollUntil 200, (-> editor = window.tinymce?.editors?[0]), =>
      ENV('tinymce').editor = editor
      cb()
  ), defer(err, ret)
  if err
    console.error err
    return false
  await
    window.kisume.set 'tinymce', ['util'], {
      setContent: (s) -> @editor.setContent(s) ; true
      getContent:     -> @editor.getContent()
    }, defer(err)
  if err
    console.error err
    return false

  tinymce.inited = true

# example: tinymce.call 'setContent', '...', (err, ret) -> console.log ret
tinymce.call = (arg...) ->
  window.kisume.run 'tinymce', arg...
