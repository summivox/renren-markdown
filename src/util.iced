###!
util
###

util = {}

# array-like => array, else []
util.arrayize = (a) -> if a?.length then [].slice.call(a) else []

# convert single quotes <=> double quotes
util.sq2dq = (s) -> s.replace /'/g, '"'
util.dq2sq = (s) -> s.replace /"/g, "'"
