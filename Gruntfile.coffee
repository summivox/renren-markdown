module.exports = (grunt) ->
  'use strict'


  ############
  # plugins

  grunt.loadNpmTasks 'grunt-iced-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'


  ############
  # text files -> JSON

  grunt.registerMultiTask 'pack', 'pack text files into JSONP', ->
    path = require 'path'
    for x in @files
      o = {}
      for f in x.src
        name = path.basename f
        cont = grunt.file.read f, encoding: 'utf-8'
        o[name] = cont
      ret = ";var #{x.name}=#{JSON.stringify(o)};\n"
      grunt.file.write x.dest, ret, encoding: 'utf-8'


  ############
  # template

  grunt.registerMultiTask 'template', ->
    for x in @files
      src = x.src[0] # FIXME: support one src only
      dest = x.dest
      cont = grunt.template.process grunt.file.read(src, encoding: 'utf-8')
      cont = cont.replace(/\r\n/g, '\n')
      grunt.file.write(dest, cont, encoding: 'utf-8')


  ############
  # main config

  config =
    pkg: grunt.file.readJSON('package.json')

    coffee: # actually grunt-iced-coffee
      options:
        bare: true
        runtime: 'inline'
      main:
        options:
          join: true
        files: [
          {src: 'src/*.{iced,coffee}', dest: 'build/main.js'}
        ]
      other:
        files: [
          {
            expand: true
            cwd: 'src/'
            src: '*/**/*.{iced,coffee}'
            dest: 'build/'
            ext: '.js'
          }
        ]

    uglify:
      options:
        preserveComments: 'some'
      lib:
        files: [
          {
            expand: true
            cwd: 'lib/'
            src: '*.js'
            dest: 'build/lib/'
            ext: '.min.js'
          }
        ]

    cssmin:
      markdown:
        files: [
          {
            expand: true
            cwd: 'src/css/'
            src: '*.css'
            dest: 'build/css/'
          }
        ]

    pack:
      css:
        name: 'PACKED_CSS'
        src: 'build/css/*.css'
        dest: 'build/packed/css.js'
      html:
        name: 'PACKED_HTML'
        src: 'src/html/*.html'
        dest: 'build/packed/html.js'

    concat:
      lib: # all minified libraries
        src: 'build/lib/*.js'
        dest: 'build/lib.js'
      pack: # all packed text files
        src: 'build/packed/*.js'
        dest: 'build/packed.js'
      #main: # common code (without compatibility layer)
        #src: [
          #'build/lib.js'
          #'build/packed.js'
          #'src/emoticon.js' # TODO: auto emoticon.js
          #'build/iced/renren-markdown.js'
        #]
        #dest: 'build/renren-markdown.main.js'
      #chrome:
        #src: [
          #'build/iced/chrome/env.js'
          #'build/renren-markdown.main.js'
        #]
        #dest: 'dist/chrome/js/renren-markdown.chrome.js'
      #gm:
        #src: [
          #'build/metadata.js'
          #'build/iced/gm/env.js'
          #'build/renren-markdown.main.js'
        #]
        #dest: 'dist/gm/renren-markdown.user.js'

    copy:
      chrome:
        files: [
          {src: 'build/iced/chrome/inject.js', dest: 'dist/chrome/js/inject.js'}
          {src: 'images/icon.png', dest: 'dist/chrome/img/icon.png'}
        ]

    template: # for metadata
      chrome:
        files: [
          {src: 'src/chrome/manifest.json', dest: 'dist/chrome/manifest.json'}
        ]
      gm:
        files: [
          {src: 'src/gm/metadata.js', dest: 'build/metadata.js'}
        ]

    clean:
      build: ['build/*']
      dist: ['dist/*']

  grunt.initConfig config

  grunt.registerTask 'lib', [
    'uglify:lib'
    'concat:lib'
  ]

  grunt.registerTask 'css', [
    'cssmin:markdown'
    'pack:css'
  ]

  grunt.registerTask 'prepare', [
    'lib'
    'css'
  ]

  grunt.registerTask 'compile', [
    'coffee:main'
    #'concat:main'
  ]

  grunt.registerTask 'chrome', [
    'template:chrome'
    'copy:chrome'
    'concat:chrome'
  ]

  grunt.registerTask 'gm', [
    'template:gm'
    'concat:gm'
  ]

  grunt.registerTask 'default', [
    'compile'
    'pack'
    'concat:pack'
    #'chrome'
    #'gm'
  ]
