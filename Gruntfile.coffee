module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    opt:
      tsMain: 'src/main/typescript'
      tsMainLib: '<%= opt.tsMain %>/lib'
      tsTest: 'src/test/typescript'
      tsTestLib: '<%= opt.tsTest %>/lib'
      sass: 'src/main/sass'
      sassLib: '<%= opt.sass %>/lib'

      outBase: 'src/main/webapp'
      jsMainOut: 'src/main/webapp/scripts'
      jsMainLibOut: '<%= opt.jsMainOut %>/lib' # save modules from bower
      jsTestOut: 'src/test/typescript'
      cssOut: 'src/main/webapp/css'
      imageOut: 'src/main/webapp/images'

    ts:
      options:
        compile: true         # perform compilation. [true (default) | false]
        comments: false       # same as !removeComments. [true | false (default)]
        target: 'es5'         # target javascript language. [es3 (default) | es5]
        module: 'commonjs'    # target javascript module style. [amd (default) | commonjs]
        noImplicitAny: false
        sourceMap: false      # generate a source map for every output js file. [true (default) | false]
        sourceRoot: ''        # where to locate TypeScript files. [(default) '' == source ts location]
        mapRoot: ''           # where to locate .map.js files. [(default) '' == generated js location.]
        declaration: false    # generate a declaration .d.ts file for every output js file. [true | false (default)]
      main:
        src: ['<%= opt.tsMain %>/Ignite.ts']
        out: '<%= opt.jsMainOut %>/app.js'
      test:
        src: ['<%= opt.tsTest %>/IgniteSpec.ts']
        out: '<%= opt.jsTestOut %>/app_spec.js'

    compass:
      dev:
        options:
          sassDir: '<%= opt.sass %>'
          cssDir: '<%= opt.cssOut %>'
          imagesDir: '<%= opt.imageOut %>'
          javascriptsDir: '<%= opt.jsMainOut %>'
          importPath: '<%= opt.sassLib %>'
          config: 'config.rb'
          noLineComments: false
          debugInfo: true
          relativeAssets: true

    clean:
      css:
        src: '<%= opt.cssOut %>/*.css'
      clientScript:
        src: [
          '<%= opt.jsMainOut %>/*.js'
          '<%= opt.jsTestOut %>/*.js'
        ]
      clientTestScript:
        src: [
          '<%= opt.jsTestOut %>/*.js'
        ]
      bower:
        src: [
          '<%= opt.jsMainLibOut %>'
          '<%= opt.outBase %>/less/lib'
          '<%= opt.cssOut %>/lib'
          '<%= opt.sassLib %>'
          'components'
          'bower-task'
        ]

    concat:
      options:
        separator: ';'
      dev:
        src: [
          '<%= opt.jsMainLibOut %>/*.js'
          '<%= opt.jsMainOut %>/*.js'
        ]
        dest: '<%= opt.jsMainOut %>/app.js'

    copy:
      bower:
        files: [
          expand: true
          flatten: false
          cwd: 'bower-task'
          src: 'main-sass/gumby/**'
          dest: '<%= opt.sassLib %>'
        ]

    bower:
      install:
        options:
          targetDir: 'bower-task'
          layout: 'byType' # exportsOverride の左辺に従って分類
          install: true
          verbose: true # ログの詳細を出すかどうか
          cleanTargetDir: true
          cleanBowerDir: false

    karma:
      unit:
        options:
          configFile: 'karma.conf.js'
          autoWatch: false
          browsers: ['PhantomJS']
          reporters: ['progress']
          singleRun: true
          keepalive: true

    tslint:
      options:
        configuration: grunt.file.readJSON(".tslintrc")
      main:
        files:
          src: ['src/main/typescript/*.ts']
      test:
        files:
          src: ['src/test/typescript/*.ts']

  grunt.registerTask 'setup', ['copy:bower']
  grunt.registerTask 'compile', ['clean:css', 'clean:clientScript', 'ts:main', 'compass:dev']
  grunt.registerTask 'default', ['tslint:main', 'compile']

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)