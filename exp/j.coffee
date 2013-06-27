# marked = require './marked.js'

s = """
This is a paragraph with inline math $$ a=\\frac{-b\\pm\\sqrt{b^2-4ac}}{2a} $$. How wonderful!

And here comes display math:
$$$ G(s)=\\frac{s-1}{s(s+1)} $$$
with lots of love.
$$$
\\begin{aligned}
\\nabla \\times \\vec{\\mathbf{B}} -\\, \\frac1c\\, \\frac{\\partial\\vec{\\mathbf{E}}}{\\partial t} & = \\frac{4\\pi}{c}\\vec{\\mathbf{j}} \\\\   \\nabla \\cdot \\vec{\\mathbf{E}} & = 4 \\pi \\rho \\\\
\\nabla \\times \\vec{\\mathbf{E}}\\, +\\, \\frac1c\\, \\frac{\\partial\\vec{\\mathbf{B}}}{\\partial t} & = \\vec{\\mathbf{0}} \\\\
\\nabla \\cdot \\vec{\\mathbf{B}} & = 0 \\end{aligned}
$$$
"""

$ ->
  do ->
    script = document.createElement("script")
    script.type = "text/javascript"
    script.src  = "http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
    $("head")[0].appendChild(script)

  marked.setOptions
    mathjax: true

  console.log s
  console.log (m = marked s)

  do ->
    iid = setInterval (->
      if MathJax?.isReady
        clearInterval iid
        boot()
    ), 1000

  boot = ->
    d = $ '#d'
    d.html m
    MathJax.Hub.Typeset d[0], ->
      console.log 'done'
      # $('span.math').parent().css('position', 'fixed').css('left', '-1000px')
      $('span.math').each ->
        # @parentElement.style.position = 'fixed'
        html2canvas [@], onrendered: (x) ->
          console.log '--image--'
          #s = x.toDataURL('image/jpeg', 0.3)
          #console.log 'jpeg: ' + s.length
          #console.log s
          s = x.toDataURL('image/png')
          console.log 'png: ' + s.length
          console.log s
