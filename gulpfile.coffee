gulp = require 'gulp'
ts = require 'gulp-typescript'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
uglify = require 'gulp-uglify'
streamify = require 'gulp-streamify'
header = require 'gulp-header'

gulp.task 'typescript', ->
  gulp.src 'src/**/*.ts'
  .pipe ts {
    module: 'commonjs'
  }
  .js.pipe gulp.dest 'src/js'

gulp.task 'build', ['typescript'], ->
  pkg = require('./package.json')
  banner = ['/**',
            ' * <%= pkg.name %> - <%= pkg.description %>',
            ' * @version v<%= pkg.version %>',
            ' * @link <%= pkg.homepage %>',
            ' * @license <%= pkg.license %>',
            ' */',
            ''].join('\n')
  browserify ['./src/js/main.js']
    .bundle()
    .pipe source 'main.js'
    .pipe streamify uglify()
    .pipe header banner, pkg: pkg
    .pipe gulp.dest 'app/js'
  gulp.src ['src/js/*.js', 'bower_components/jquery/dist/jquery.min.js']
    .pipe gulp.dest 'app/js'
  gulp.src ['src/manifest.json']
    .pipe gulp.dest 'app'

gulp.task 'watch', ['typescript'], ->
  gulp.watch 'src/**/*.ts', ['typescript']

gulp.task 'default', ['watch'], ->
