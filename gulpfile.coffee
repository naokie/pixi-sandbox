'use strict'

gulp = require 'gulp'
$ = (require 'gulp-load-plugins') lazy: false
del = require 'del'
bs = require 'browser-sync'

# HTML
gulp.task 'html', ->
  gulp.src ['src/**.jade']
    .pipe $.plumber()
    .pipe $.jade()
    .pipe gulp.dest 'dist'

# JS
gulp.task 'js', ->
  gulp.src ['src/scripts/**.coffee']
    .pipe $.plumber()
    .pipe $.coffee()
    .pipe gulp.dest 'dist/scripts'

# CSS
gulp.task 'css', ->
  gulp.src ['src/styles/**.{sass,scss}']
    .pipe $.plumber()
    .pipe $.sass indentedSyntax: true
    .pipe $.autoprefixer 'last 1 version'
    .pipe gulp.dest 'dist/styles'

# Copy
gulp.task 'copy', ['copy:js']

gulp.task 'copy:js', ->
  gulp.src [
    'src/scripts/vendor/*.js'
    'node_modules/jquery/dist/jquery.min.js'
  ]
    .pipe gulp.dest 'dist/scripts/vendor'

# Clean output directory
gulp.task 'clean', del.bind null, ['dist'], dot: true

# Default task
gulp.task 'default', ['html', 'js', 'css', 'copy']

# BrowserSync
gulp.task 'server', ['default'], ->
  bs
    server:
      baseDir: ['dist']

  gulp.watch ['src/**/*.jade'], ['html', bs.reload]
  gulp.watch ['src/scripts/**/*.coffee'], ['js', bs.reload]
  gulp.watch ['src/styles/**/*.{sass,scss}'], ['css', bs.reload]
