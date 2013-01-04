`
// ==UserScript==
// @name            renren-markdown
// @include         *blog.renren.com/blog/*/*Blog*
// @version         0.1.5
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
          presEl=document.createElement('span')
          presEl.style.fontFamily="Consolas, 'Courier New', Monospace, Courier"
          presEl.style.lineHeight="100%"
          presEl.innerHTML=content
          codeEl.innerHTML=presEl.outerHTML
          preEl.parentElement.replaceChild(codeEl, preEl)

      #header: replace with presentation element
      fontSizeList=['', '2em', '1.5em', '1.17em', '1em', '0.83em', '0.67em']
      for i in [1..6]
        for hEl in [].slice.call(el.getElementsByTagName('h'+i))
          presEl=document.createElement('span')
          presEl.innerHTML=hEl.innerHTML
          presEl.style.fontSize=fontSizeList[i]
          presEl.style.fontWeight='bold'
          presEl.style.display='block'
          presEl.style.marginTop='1em'
          hEl.parentElement.replaceChild(presEl, hEl)

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


    #minimalistic UI
    @uiHtml=
      """
      <div id="rrmd_wrapper" style="margin: 0em 0em 1em 0em">
        <textarea id="rrmd_area" style="font-family: Consolas, 'Courier New';" placeholder="Type markdown _here_!"></textarea>
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

    #2012-12-20 fix: fuck renren's position:absolute blog title input
    titleBgEl=document.getElementById('title_bg')
    titleBgEl?.style.cssText='position: inherit !important; width: 100%'
    titleEl=document.getElementById('title')
    titleEl?.style.cssText='width: 98%'

    #2012-12-30 fix: remove old tinymce padding (used to make room for the offset title)
    document.getElementById('editor_ifr').contentDocument.body.style.paddingTop="0px"

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
