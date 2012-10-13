`
// ==UserScript==
// @name            renren-markdown
// @include         *blog.renren.com/blog/*/editBlog
// @include         *blog.renren.com/NewEntry.do
// ==/UserScript==
`

injectScript=(src)->
  scriptEl=document.createElement('script')
  scriptEl.innerHTML="(#{src.toString()})();"
  document.head.appendChild(scriptEl)

injectScript ->
  str_to_b64=(str)->window.btoa unescape encodeURIComponent str
  b64_to_str=(b64)->decodeURIComponent escape window.atob b64

  do->
    tid=setInterval (->
      if window.tinymce?.get('editor')?
        clearInterval(tid)
        boot()
    ), 1000

  boot=->window.rrmd=rrmd=new->
    @editor=window.tinymce.get('editor')
    @conv=(md)->marked(md)

    #circumvent tinymce filters
    @transform=(h)->
      el=document.createElement('div')
      el.innerHTML=h

      #code: replace `pre > code` to `code > span` and add some custom formatting
      for preEl in [].slice.call(el.getElementsByTagName('pre'))
        if (codeEl=preEl?.firstElementChild)?.tagName=='CODE'
          content=codeEl.innerHTML
          content=content.replace(/\ /g, '&nbsp;').replace(/[\r\n]/g, '<br />')
          spanEl=document.createElement('span')
          spanEl.style.fontFamily="Consolas, 'Courier New', Monospace, Courier"
          spanEl.style.lineHeight="100%"
          spanEl.innerHTML=content
          codeEl.innerHTML=spanEl.outerHTML
          preEl.parentElement.replaceChild(codeEl, preEl)

      #header: font-size restoration
      fontSizeList=['', '2em', '1.5em', '1.17em', '1em', '0.83em', '0.67em']
      for i in [1..6]
        for hEl in el.getElementsByTagName('h'+i)
          hEl.style.fontSize=fontSizeList[i];

      el.innerHTML



    #embed markdown code in generated html for editing
    @embed=(h, md)->
      h+"""<span style="visibility: hidden; display: block; height: 0; background-image: url('http://dummy/$rrmd$')">#{str_to_b64(md)}</span>"""
    
    @unembed=(h)->
      el=document.createElement('div')
      el.innerHTML=h
      list=(spanEl for spanEl in el.getElementsByTagName('span') when /\$rrmd\$/.test(spanEl.style.backgroundImage))
      b64=if list.length>=1 then list[0].innerHTML else ''
      try return b64_to_str(b64) catch e then return ''


    @uiHtml=
      """
      <div id="rrmd_wrapper" style="margin: 0em 0em 1em 0em">
        <textarea id="rrmd_area" style="font-family: Consolas, 'Courier New';"></textarea>
      </div>
      """
    @uiSpanEl=document.createElement('span')
    @uiSpanEl.innerHTML=@uiHtml
    @uiBefore=document.getElementById('editor_tbl')
    @uiBefore.parentElement.insertBefore(@uiSpanEl, @uiBefore)
    @uiAreaEl=document.getElementById('rrmd_area')
    @uiAreaEl.innerHTML=@unembed(@editor.getContent())
    @uiAreaEl.oninput= =>
      if @tid? then clearTimeout(@tid); @tid=null;
      @tid=setTimeout (@fill()), Math.min(@uiAreaEl.value.length/50, 500)


    #markdown from textarea => tinymce
    @fill=->
      try
        md=@uiAreaEl.value
        htmlInit=@conv(md)
        htmlTrans=@transform(htmlInit)
        htmlEmbed=@embed(htmlTrans, md)
        @editor.setContent(htmlEmbed)
      catch e
        console.log('这不科学$RRMD:')
        console.error(e)

    this;
