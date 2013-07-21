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
  breaks: true # warning: backward incompatible
  smartLists: true
}

markdown.cssClearText = PACKED_CSS['cssreset.css'] + '\n' + PACKED_CSS['cssbase.css']

markdown.setCss = (cssText) ->
  markdown.cssText = cssText
  markdown.cssRules = css.aug css.parse cssText

markdown.inited = false
markdown.init = ->
  markdown.setCss PACKED_CSS['markdown.css']
  markdown.inited = true
