###!
util
!###

util = {}

# array-like => array, else []
util.arrayize = (a) -> if a?.length then [].slice.call(a) else []

# single quotes <=> double quotes
util.squote_to_dquote = (s) -> s.replace /'/g, '"'
util.dquote_to_squote = (s) -> s.replace /"/g, "'"

# safely unescape javascript string representation
util.jsStr = (s) ->
  if !(s = s?.trim()) then return null
  try JSON.parse util.squote_to_dquote s
  catch e then null

# string <=> base64
util.str_to_b64 = (str) -> window.btoa unescape encodeURIComponent str
util.b64_to_str = (b64) -> decodeURIComponent escape window.atob b64

# add script tag to document
#   script => run
#   fnction => IIFE
util.injectScript = (doc, x) ->
  el = doc.createElement 'script'
  el.textContent = switch typeof x
    when 'string' then x
    when 'function' then "(#{x.toString()})();"
  doc.head.appendChild el

# scrolling
util.canScroll = (el) -> !! el?.scrollHeight?

util.scrollRange = (el) ->
  if util.canScroll(el) then return null
  el.scrollHeight - el.clientHeight

util.scrollRatio = (el) ->
  if util.canScroll(el) then return null
  el.scrollTop / util.scrollRange(el)

util.setScrollRatio = (el, ratio) ->
  if util.canScroll(el) then return null
  if !isFinite(ratio) then return null
  ratio = Math.min(Math.max(ratio, 0), 1)
  el.scrollTop = ratio * util.scrollRange(el)
