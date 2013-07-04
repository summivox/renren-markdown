###!
cron
!###

cron = {}

cron.inited = false
cron.init = ->
  cron.hasUpdate = false
  cron.mainPeriod = 50
  cron.mainid = null

  #cron.heat = 0
  #cron.heatPeriod = 125
  #cron.heatId = setInterval cron.heatHandler, cron.heatPeriod

  cron.inited = true

cron.trig = ->
  cron.hasUpdate = true
  cron.heat++
  if !cron.mainId then cron.mainId = setTimeout cron.mainHandler, cron.mainPeriod

cron.mainHandler = do ->
  n = n0 = 10 # TODO: use heat to determine async timing instead
  mainHandler = ->
    if --n == 0
      cron.mainId = null
      console.log 'cron.mainHandler: TODO: async' # TODO
    else
      cron.mainId = setTimeout cron.mainHandler, cron.mainPeriod
      if cron.hasUpdate
        cron.hasUpdate = false
        n = n0
        process.sync()
    return

#cron.heatHandler = ->
  #cron.heat -= cron.heat >> 3
  #cron.mainPeriod = 100 + cron.heat*4
  #console.log cron.heat #debug
