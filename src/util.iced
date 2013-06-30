###!
util
!###

util = {}

# array-like => array, else []
util.arrayize = (a) -> if a?.length then [].slice.call(a) else []

# convert single quotes <=> double quotes
util.sq2dq = (s) -> s.replace /'/g, '"'
util.dq2sq = (s) -> s.replace /"/g, "'"

# add script tag to document
#   script => run
#   fnction => IIFE
util.injectScript = (x) ->
  el = document.createElement 'script'
  el.textContent = switch typeof x
    when 'string' then x
    when 'function' then "(#{x.toString()})();"
  document.head.appendChild el
