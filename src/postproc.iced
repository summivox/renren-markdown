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
  run: do ->
    tag = 'rrmd-pp'
    run = (rootEl) ->
      for {sel, handler} in this
        $(sel).each ->
          unless tag in this.classList
            this.classList.add tag
            if handler(this) == false
              this.classList.remove tag
          return # each
      return # run
