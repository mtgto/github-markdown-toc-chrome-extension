gulp = require 'gulp'
ts = require 'gulp-typescript'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
uglify = require 'gulp-uglify'
streamify = require 'gulp-streamify'
header = require 'gulp-header'
concat = require 'gulp-concat'
sourcemaps = require 'gulp-sourcemaps'

gulp.task 'typescript', ->
  result = gulp.src 'src/**/*.ts'
    .pipe sourcemaps.init()
    .pipe ts {
      module: 'commonjs'
    }
  return result.js
    .pipe sourcemaps.write()
    .pipe gulp.dest 'src/js'

gulp.task 'debug-build', ['typescript'], ->
  browserify entries: ['./src/js/main.js'], debug: true
    .bundle()
    .pipe source 'main.js'
    .pipe gulp.dest 'build/debug/js'
  gulp.src ['bower_components/jquery/dist/jquery.min.js']
    .pipe gulp.dest 'build/debug/js'
  gulp.src ['src/manifest.json']
    .pipe gulp.dest 'build/debug'

gulp.task 'release-build', ['typescript'], ->
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
    .pipe gulp.dest 'build/release/js'
  gulp.src ['bower_components/jquery/dist/jquery.min.js']
    .pipe gulp.dest 'build/release/js'
  gulp.src ['src/manifest.json']
    .pipe gulp.dest 'build/release'

gulp.task 'watch', ['typescript'], ->
  gulp.watch 'src/**/*.ts', ['typescript']

gulp.task 'default', ['watch'], ->
