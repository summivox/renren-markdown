###!
util
!###

util = {}

# array-like => array, else []
util.arrayize = (a) -> if a?.length then [].slice.call(a) else []

# single quotes <=> double quotes
util.squote_to_dquote = (s) -> s.replace /'/g, '"'
util.dquote_to_squote = (s) -> s.replace /"/g, "'"

# string <=> base64
util.str_to_b64 = (str) -> window.btoa unescape encodeURIComponent str
util.b64_to_str = (b64) -> decodeURIComponent escape window.atob b64

# add script tag to document
#   script => run
#   fnction => IIFE
util.injectScript = (x) ->
  el = document.createElement 'script'
  el.textContent = switch typeof x
    when 'string' then x
    when 'function' then "(#{x.toString()})();"
  document.head.appendChild el
