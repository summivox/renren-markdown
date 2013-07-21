###!
css
!###

css = {}

css.inited = false
css.init = (autocb) ->
  await util.makeIframe 'rrmd-css', defer(doc)
  css.doc = doc
  css.inited = true

# get css rules from css source
css.parse = (cssText) ->
  s = css.doc.createElement 'style'
  s.textContent = cssText
  css.doc.body.appendChild s
  s.sheet.cssRules

# augment css rules:
#   comma-separated selectors with same body => multiple rules
#   rules sorted by specificity (high -> low) then index (last -> first)
#   (later rules don't override earlier rules unless `!important`)
css.aug = (cssRules) ->
  ret = []
  idx = 0
  for r in cssRules
    for {selector, specificity} in getSpecificity r.selectorText
      idx = ret.push {
        selectorText: selector
        style: r.style
        specificity
        idx
      }
  ret.sort (a, b) ->
    for i in [0..2]
      if (c = b.specificity[i] - a.specificity[i])
        return c
    return b.idx - i.idx # stable sort
