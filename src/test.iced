###!
test
!###

$ ->
  area = document.getElementById 'area'
  area.addEventListener 'input', handler = (e) -> cron.trig()
