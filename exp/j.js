// Generated by CoffeeScript 1.6.2
(function() {
  var s;

  s = "This is a paragraph with inline math $$ a=\\frac{-b\\pm\\sqrt{b^2-4ac}}{2a} $$. How wonderful!\n\nAnd here comes display math:\n$$$ G(s)=\\frac{s-1}{s(s+1)} $$$\nwith lots of love.\n$$$\n\\begin{aligned}\n\\nabla \\times \\vec{\\mathbf{B}} -\\, \\frac1c\\, \\frac{\\partial\\vec{\\mathbf{E}}}{\\partial t} & = \\frac{4\\pi}{c}\\vec{\\mathbf{j}} \\\\   \\nabla \\cdot \\vec{\\mathbf{E}} & = 4 \\pi \\rho \\\\\n\\nabla \\times \\vec{\\mathbf{E}}\\, +\\, \\frac1c\\, \\frac{\\partial\\vec{\\mathbf{B}}}{\\partial t} & = \\vec{\\mathbf{0}} \\\\\n\\nabla \\cdot \\vec{\\mathbf{B}} & = 0 \\end{aligned}\n$$$";

  $(function() {
    var boot;

    (function() {
      var iid;

      return iid = setInterval((function() {
        if (typeof MathJax !== "undefined" && MathJax !== null ? MathJax.isReady : void 0) {
          clearInterval(iid);
          return boot();
        }
      }), 1000);
    })();
    return boot = function() {
      var d, el, _i, _len, _ref, _results;

      d = $('#d');
      _ref = d.find("script[type^='math/tex']").toArray();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        el = _ref[_i];
        _results.push((function(el) {
          return MathJax.Hub.Queue([
            'Process', MathJax.Hub, el, function() {
              var base, j, rendered;

              console.log('done');
              j = MathJax.Hub.getJaxFor(el);
              base = document.querySelector("\#" + j.inputID + "-Frame").firstElementChild;
              rendered = base.firstElementChild;
              return html2canvas([rendered], {
                onrendered: function(x) {
                  console.log('--image--');
                  s = x.toDataURL('image/png');
                  console.log('png: ' + s.length);
                  return console.log(s);
                }
              });
            }
          ]);
        })(el));
      }
      return _results;
    };
  });

}).call(this);
