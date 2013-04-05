# Copyright (c) 2013, smilekzs, xiaoyao9933 (MIT Licensed)
# compatibility layer: greasemonkey

window.rrmdEnv =
  # "unsafe window": builtin 
  window: unsafeWindow

  # XHR: should be builtin
  xhr: GM_xmlhttpRequest || (-> console.log "rrmd: xhr: WTF?")
