"use strict"
gulp = require 'gulp'
gutil = require "gulp-util"
bower = require 'main-bower-files'
browserSync = require "browser-sync"
spritesmith = require 'gulp.spritesmith'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
isRelease = gutil.env.release?
$ = require("gulp-load-plugins")()

$public = "./public"
$src = "./src"
$server = "./src/server"
$client = "./src/client"

config =
  path:
    public: $public
    server: $server+"/app.coffee"
    stylus: $client+"/stylesheets/**/*.styl"
    coffee: $client+"/javascripts/**/*.coffee"
    jade: $client+"/views/**/*.jade"
    images: [$client + '/images/**/*.*', '!'+$client+'/**/*.ico' ,'!'+$client+'/images/**/*.svg']
  outpath:
    stylus: $public+'/assets/stylesheets/'
    coffee: $public+'/assets/javascripts/'
    bower: $public+'/assets/libs'


#build
gulp.task 'script', ->
  browserify
    entries: ['./src/client/javascripts/main.coffee']
    extensions: ['.coffee']
  .transform 'coffeeify'
  .bundle()
  .pipe source 'angular-sticky.0.1.js'
  .pipe gulp.dest config.outpath.coffee

# ブラウザーシンク起動
gulp.task "browser-sync",->
  browserSync.init null,{
    proxy: "http://localhost:9000"
    port: 5000
  }
gulp.task "browser-sync-reload",->
  browserSync.reload()


# サーバ起動
gulp.task "nodemon",(callback)->
  return $.nodemon({
    script: config.path.server
    })

# cssの生成
gulp.task 'stylus', ['sprite_stylus'], ->
    gulp.src(config.path.stylus)
    .pipe $.plumber()
    .pipe $.stylus()
    .pipe gulp.dest(config.outpath.stylus)

# coffeeの生成
gulp.task 'coffee', ->
    gulp.src(config.path.coffee)
    .pipe $.plumber()
    .pipe $.coffee()
    .pipe gulp.dest(config.outpath.coffee)

gulp.task 'sprite_stylus', ->
  spriteDataStylus = gulp.src config.path.images
    .pipe spritesmith({
      imgName: 'sprite.png'
      cssName: 'sprite.styl'
      cssFormat: 'stylus'
      imgPath: 'sprite.png'
      destCSS: config.path.stylesheets
      engine: 'gm'
    })
  spriteDataStylus.img.pipe(gulp.dest('public/stylesheets/'));
  spriteDataStylus.css.pipe(gulp.dest('public/stylesheets/'));


gulp.task "watch", ()->
  gulp.watch config.path.stylus,["stylus","browser-sync-reload"]
  gulp.watch config.path.coffee,["script","coffee","browser-sync-reload"]
  gulp.watch config.path.jade,["browser-sync-reload"]


gulp.task "default",[
  "script"
  "nodemon"
  "browser-sync"
  "stylus"
  "coffee"
  "watch"
],->
