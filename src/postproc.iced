###!
postproc
!###

postproc = new class extends Array
  register: (name, sel, handler) ->
    @push {
      enabled: true
      name
      sel
      handler
    }
    # FIXME: plugin initialization? May need to really use classes.
  run: do ->
    tag = 'rrmd-pp'
    run = (rootEl) ->
      ct = []
      for {sel, handler} in this
        $(sel).each ->
          unless tag in this.classList
            this.classList.add tag
            x = handler(this)
            # FIXME: tag could be lost
            switch
              when x == false
                this.classList.remove tag
              when typeof(x) == 'function'
                # continuity
                ct.push {f: x, el: this}
              else null
          return # each
      return ->
        for {f, el} in ct
          f el
        return
