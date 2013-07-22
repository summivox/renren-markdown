###!
boot
!###

$ ->
  # TODO: load settings
  await window.kisume = Kisume window, defer()
  await window.kisume.set 'util', [], util, defer(err1)
  # await kisume_test defer() # DEBUG
  await
    css.init defer()
    ui.init defer()
    tinymce.init defer()
    postproc.init defer()
  cron.init()
  markdown.init()
  ui.listen()

# DEBUG
kisume_test = (autocb) ->
  console.log '===begin kisume test==='
 
  await kisume.set 'namespace', [], {
    var1: {x: 1, y: 2}
    var2: {x: -3, y: 4}
    func1: (a, b) -> {x: a.x + b.x, y: a.y + b.y}
    func2: (o) -> window.o = @func1(@var1, o)
    func3: (o, cb) -> setTimeout (=> cb null, o, @func2(o)), 1000
  }, defer(err)
  console.assert !err?

  await kisume.run 'namespace', 'func1', {x: 100, y: 200}, {x: 300, y: -400}, defer(err, ret)
  console.assert !err?
  console.assert ret.x == 400 && ret.y == -200

  await kisume.runAsync 'namespace', 'func3', {x: 100, y: 100}, defer(err, ret1, ret2)
  console.assert !err?
  console.assert ret1.x == 100 && ret1.y == 100
  console.assert ret2.x == 101 && ret2.y == 102

  await kisume.run (-> @namespace.var2.x = -100), defer(err)
  console.assert !err?

  await kisume.get 'namespace', ['var2'], defer(err, {var2})
  console.assert !err?
  console.assert var2.x == -100 && var2.y == 4

  console.log '===end kisume test==='
