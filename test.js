var N = 200;
var doc = document.querySelector('#preview').contentDocument;
var b = doc.body;

var styEl = doc.createElement('style');
styEl.textContent = PACKED_CSS['markdown.min.css'];
doc.head.appendChild(styEl);

d0 = new Date();
for(var i = 0;i<N;++i) {
  var el = markdown.convert(area.value);
  var x = b.firstElementChild;
  if(x) b.replaceChild(el, x);
  else b.appendChild(el);
}
d1 = new Date();
console.log(d1 - d0);
console.log((d1 - d0)/N);
