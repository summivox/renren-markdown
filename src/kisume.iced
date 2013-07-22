###!
https://github.com/smilekzs/kisume
Cross-sandbox-window utility library for userscript environments (Chrome, GreaseMonkey, ...)
!###

Kisume = do ->
  # inject script to bottom
  $ = (doc, script) ->
    el = doc.createElement 'script'
    el.textContent = script
    doc.head.appendChild el

  # coffee-script shims (~1.6.0)
  # recompile this script with newer version to get full set of shims
  COFFEE_SHIM = """
    var
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
      __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
      __slice = [].slice,
      __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  """
  _dummy = (args...) ->
    x in args
    v for own k, v of obj
    class X extends Y
      bound: => null

  LIB = ->
    ###!
    kisume: bottom library
    !###
    if window.kisume? then return
    window.kisume = kisume =
      DEBUG: true

      # env: "ensure exist"
      env: (name) -> @env[name] ||= {}

      _iife: {}
      _tran: {}

      _err: (e) -> switch
        when e instanceof Error
          # manually serialize
          do ->
            {name, message, stack} = e
            {name, message, stack}
        when e? then e
        else true

      _Q_up: do ->
        n = 0
        (cb, o) ->
          ++n
          if cb
            @_tran[n] = cb
          if o?
            o._kisume_Q_up = n
            window.postMessage o, window.location.origin
          return n
      _A_up: (n, o) ->
        o._kisume_A_up = n
        window.postMessage o, window.location.origin
        n

      _Q_dn: (n, o) ->
        try
          switch o.type
            when 'set'
              x = @env(o.ns)
              for {name, value} in o.v
                x[name] = value
              @_A_up n, {type: 'set'}
            when 'get'
              x = @env(o.ns)
              ret = {}
              for name in o.names
                ret[name] = x[name]
              @_A_up n, {type: 'get', ret}
            when 'run'
              if o.iife?
                f = @_iife[o.iife]
              else
                f = @env(o.ns)[o.name]
              if !f
                @_A_up n, {type: 'run', err: true}
              else if o.async
                f?.call @env, o.args..., (err, rets...) =>
                  @_A_up n, {type: 'run', async: true, err, rets}
              else
                ret = f?.apply @env, o.args
                @_A_up n, {type: 'run', async: false, ret}
        catch e
          @_A_up n, {type: o.type, async: false, err: @_err(e)}

      _A_dn: (n, o) ->
        switch o.type
          when 'pub'
            null #TODO

    window.addEventListener 'message', (e) ->
      if e.origin != window.location.origin ||
         !(o = e.data)? then return
      if kisume.DEBUG then console.log o
      switch
        when (n = o._kisume_Q_dn)? then kisume._Q_dn n, o
        when (n = o._kisume_A_dn)? then kisume._A_dn n, o

    # notify top: bottom init finished
    kisume._Q_up null, {type: 'init'}

  class Kisume
    debug: true
    constructor: (W, cb) ->
      unless this instanceof Kisume then return new Kisume(W, cb)
      @W = W
      @D = W.document
      @_tran = {}
      @_init_cb = cb
      @W.addEventListener 'message', @_listener
      if !(@D.body.dataset['kisume'])?
        $ @D, "#{COFFEE_SHIM};(#{LIB})();"
        @D.body.dataset['kisume'] = true

    set: (ns, o, cb) ->
      # TODO: sanitize
      f = '' # func: metaprogrammed
      v = [] # var : posted
      for own name, x of o
        switch
          when x instanceof Function
            f += "o[#{JSON.stringify name}] = #{x};\n"
          when x instanceof Node
            #TODO
          else
            v.push {name, value: x}
      $ @D, "(function(o){#{f}})(window.kisume.env(#{JSON.stringify ns}));"
      @_Q_dn cb, {type: 'set', ns, v}

    get: (ns, names, cb) ->
      # TODO: sanitize
      @_Q_dn cb, {type: 'get', ns, names}

    # macro: run sync / async
    # NOTE: `_run` returns "->" function for proper binding
    _run = (async) ->
      _func = (f, args..., cb) ->
        n = @_Q_dn()
        $ @D, "window.kisume._iife[#{n}] = (#{f});"
        @_Q_dn cb, {type: 'run', async, iife: n, args}
      _script = (s, cb) ->
        _func.call this, "function(){;#{s};}", cb
      _env = (ns, name, args..., cb) ->
        @_Q_dn cb, {type: 'run', async, ns, name, args}

      (x, xs...) ->
        (switch typeof x
          when 'function' then _func
          when 'string'
            if xs.length == 1 then _script
            else _env
          else ->
        ).apply this, arguments

    run: _run false
    runAsync: _run true

    _Q_dn: do ->
      n = 0
      (cb, o) ->
        ++n
        if cb
          @_tran[n] = cb
        if o?
          o._kisume_Q_dn = n
          @W.postMessage o, @W.location.origin
        return n
    _A_dn: (n, o) ->
      o._kisume_A_dn = n
      @W.postMessage o, @W.location.origin
      n

    _Q_up: (n, o) ->
      switch o.type
        when 'init'
          @_init_cb this
        when 'pub'
          null #TODO

    _A_up: (n, o) ->
      cb = @_tran[n]
      switch o.type
        when 'set', 'get', 'run'
          if o.async
            cb? o.err, o.rets...
          else
            cb? o.err, o.ret
      delete @_tran[n]

    _listener: (e) =>
      if e.origin != window.location.origin ||
         !(o = e.data)? then return
      switch
        when (n = o._kisume_Q_up)? then @_Q_up n, o
        when (n = o._kisume_A_up)? then @_A_up n, o
