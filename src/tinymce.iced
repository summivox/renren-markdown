###!
tinymce
!###

tinymce = {}

tinymce.inited = false
tinymce.init = (autocb) ->
  await tinymce.kisume = Kisume window, defer(kisume)
  await
    kisume.set 'util', util, defer(err1)
    kisume.set 'tinymce', {
      editor: null
      setContent: (s) -> @tinymce.editor.setContent(s) ; true
      getContent:     -> @tinymce.editor.getContent()
    }, defer(err2)
  if err1 || err2
    console.log err1
    console.log err2
    return false
  await kisume.run (->
    editor = null
    @util.pollUntil 500, (-> editor = window.tinymce?.editors?[0]), ->
      window.kisume.env.tinymce.editor = editor
  ), defer(err, ret)
  if err
    console.log err
    return false

  tinymce.inited = true

# example: tinymce.call 'setContent', '...', (err, ret) -> console.log ret
tinymce.call = (arg...) ->
  tinymce.kisume.run 'tinymce', arg...
