module.exports = (grunt) ->
  'use strict'


  ############
  # plugins

  [
    'grunt-contrib-clean'
    'grunt-iced-coffee'
    'grunt-contrib-uglify'
    'grunt-contrib-cssmin'
    'grunt-svgmin'
    'grunt-contrib-concat'
    'grunt-contrib-copy'
    #'grunt-grunticon'
  ].map (x) -> grunt.loadNpmTasks(x)

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

  # template
  grunt.registerMultiTask 'template', ->
    for x in @files
      cont = ''
      for src in x.src
        cont += grunt.template.process grunt.file.read(src, encoding: 'utf-8')
      cont = cont.replace(/\r\n/g, '\n')
      grunt.file.write(x.dest, cont, encoding: 'utf-8')


  ############
  # config

  grunt.initConfig new ->
    @pkg = grunt.file.readJSON('package.json')

    # default
    @clean =
      build: ['build/*']
      dist: ['dist/*']
    @coffee =
      options:
        bare: true
    @uglify =
      options:
        preserveComments: 'none' # 'some'
    @cssmin = {}
    @svgmin = {}
    @pack = {}
    @template = {}
    @copy = {}
    @concat = {}
    #@grunticon = {}

    # minify and join libraries
    @uglify.lib =
      options:
        mangle: false
      files: [
        {
          expand: true
          cwd: 'lib/'
          src: ['*.js', '!*.min.js']
          dest: 'build/lib/'
        }
      ]
    @copy.lib =
      files: [
        {
          expand: true
          cwd: 'lib/'
          src: '*.min.js'
          dest: 'build/lib/'
        }
      ]
    @concat.lib =
      src: 'build/lib/*.js'
      dest: 'build/lib.js'
    grunt.registerTask 'lib', [
      'uglify:lib'
      'copy:lib'
      'concat:lib'
    ]

    # minify and pack CSS
    @cssmin.main =
      files: [
        {
          expand: true
          cwd: 'src/css/'
          src: '*.css'
          dest: 'build/css/'
        }
      ]
    @pack.css =
      name: 'PACKED_CSS'
      src: 'build/**/*.css'
      dest: 'build/packed/css.js'
    grunt.registerTask 'pack-css', [
      'cssmin:main'
      'pack:css'
    ]

    # pack HTML
    @pack.html =
      name: 'PACKED_HTML'
      src: 'src/**/*.html'
      dest: 'build/packed/html.js'
    grunt.registerTask 'pack-html', [
      'pack:html'
    ]

    # join all packed files
    @concat.pack =
      src: 'build/packed/*.js'
      dest: 'build/packed.js'
    grunt.registerTask 'pack-all', [
      'pack-css'
      'pack-html'
      'concat:pack'
    ]

    # main code
    @coffee.main =
      options:
        join: true
        # sourceMap: true
        runtime: 'window'
      files: [
        {src: 'src/*.{iced,coffee}', dest: 'build/main.js'}
      ]
    grunt.registerTask 'main', [
      'coffee:main'
    ]

    # postprocessors
    @coffee.postproc =
      options:
        join: false
        runtime: 'none'
      files: [
        {
          expand: true
          cwd: 'src/postproc/'
          src: '**/*.{iced,coffee}'
          dest: 'build/postproc/'
          ext: '.js'
        }
      ]
    @copy.postproc =
      options:
        join: false
      files: [
        {
          expand: true
          cwd: 'src/postproc/'
          src: '**/*.js'
          dest: 'build/postproc/'
        }
      ]
    grunt.registerTask 'postproc', [
      'coffee:postproc'
      'copy:postproc'
    ]

    # make all-in-one script (lib + packed + main code + postproc)
    @concat.aio =
      files: [
        {
          src: [
            'build/lib.js'
            'build/packed.js'
            'build/main.js'
            'build/postproc/**/*.js'
          ]
          dest: 'build/aio.js'
        }
      ]
    grunt.registerTask 'aio', [
      'concat:aio'
    ]

    # make chrome plugin
    @template.chrome =
      files: [
        {src: 'src/chrome/manifest.json', dest: 'dist/chrome/manifest.json'}
      ]
    @copy.chrome =
      files: [
        {src: 'build/aio.js', dest: 'dist/chrome/aio.js'}
        {src: 'images/rrmd.png', dest: 'dist/chrome/images/rrmd.png'}
        #{ # FIXME: build/convert/copy correct images
          #expand: true
          #cwd: 'images/'
          #src: '**/*'
          #dest: 'dist/chrome/images/'
        #}
      ]
    grunt.registerTask 'chrome', [
      'template:chrome'
      'copy:chrome'
    ]

    # make userscript
    @template.gm =
      files: [
        {src: 'src/gm/metadata.js', dest: 'build/metadata.js'}
      ]
    @concat.gm =
      src: [
        'build/metadata.js'
        'build/aio.js'
      ]
      dest: "dist/gm/#{@pkg.name}.user.js"
    grunt.registerTask 'gm', [
      'template:gm'
      'concat:gm'
    ]

    @ # grunt.initConfig

  grunt.registerTask 'default', [
    'pack-all'
    'main'
    'postproc'
    'aio'
    'chrome'
    'gm'
  ]
