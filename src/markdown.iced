###!
markdown
!###

# convert markdown source to DOM element with inline CSS
markdown = (md) ->
  if !markdown.inited then return null
  el = document.createElement 'span'
  el.className = 'rrmd'
  el.innerHTML = marked md, @settings
  core.inlineCss el, markdown.cssRules
  el

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
