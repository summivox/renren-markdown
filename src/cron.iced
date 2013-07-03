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

cron.start = ->
  cron.mainId = setTimeout cron.mainHandler, cron.mainPeriod

cron.stop = ->
  if cron.mainId?
    clearTimeout cron.mainId
    cron.mainId = null

cron.trig = ->
  cron.hasUpdate = true
  cron.heat++

cron.mainHandler = do ->
  n = n0 = 2
  mainHandler = ->
    if cron.mainId then setTimeout cron.mainHandler, cron.mainPeriod
    if cron.hasUpdate
      cron.hasUpdate = false
      n = n0
      process.sync()
    else if --n == 0
      console.log 'cron.mainHandler: TODO: async'

#cron.heatHandler = ->
  #cron.heat -= cron.heat >> 3
  #cron.mainPeriod = 100 + cron.heat*4
  #console.log cron.heat #debug
