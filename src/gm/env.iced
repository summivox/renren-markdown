# Copyright (c) 2013, smilekzs, xiaoyao9933 (MIT Licensed)
# compatibility layer: greasemonkey

# "unsafe window": builtin 
window.W = unsafeWindow

# XHR: should be builtin
window.GM_xmlhttpRequest ||= -> console.log "rrmd: xhr: WTF?"
