###!
cron
!###

cron = {}

cron.inited = false
cron.init = ->
  cron.hasUpdate = false
  cron.mainPeriod = 100
  cron.mainid = null

  cron.heat = 0
  cron.heatPeriod = 125
  cron.heatId = setInterval cron.heatHandler, cron.heatPeriod

  cron.inited = true

cron.trig = ->
  cron.hasUpdate = true
  cron.heat++
  if !cron.mainId then cron.mainId = setTimeout cron.mainHandler, cron.mainPeriod

cron.mainHandler = do ->
  n = n0 = 8
  mainHandler = ->
    if --n == 0
      cron.mainId = null
      console.log 'cron.mainHandler: async'
      process.async()
    else
      cron.mainId = setTimeout cron.mainHandler, cron.mainPeriod
      if cron.hasUpdate
        cron.hasUpdate = false
        n = n0
        process.sync()
    return

cron.heatHandler = ->
  dh = Math.ceil(cron.heat / 8)
  cron.heat -= dh
  cron.mainPeriod = 100 + Math.floor(cron.heat * dh)
  # console.log 'period: ' + cron.mainPeriod
