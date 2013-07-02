###!
markdown
!###

# convert markdown source to DOM element with inline CSS
markdown = (md) ->
  markdown.render markdown.convert md

markdown.convert = (md) ->
  el = document.createElement 'span'
  el.className = 'rrmd'
  el.innerHTML = marked md, @settings
  el

markdown.render = (el) ->
  if !markdown.inited then return null
  return core.inlineCss el, markdown.cssRules


# set default settings -- should be modifiable by persistence & UI
markdown.settings = {
  gfm: true
  tables: true
  breaks: true # really?
  smartLists: true
}

markdown.inited = false
markdown.init = ->
  await
    core.getAugCssRules PACKED_CSS['markdown.min.css'], defer(markdown.cssRules)
  markdown.inited = true
