//DEFAULT
var path=require('path'),Argv=require('minimist')(process.argv);
//COMMON PACKAGE
var fs=require('fs-extra'),clc=require('cli-color'),extend=require('node.extend');
//REQUIRE PACKAGE
var gulp=require('gulp'),sass=require('gulp-sass'),minifyCss=require('gulp-minify-css'),uglify=require('gulp-uglify'),concat=require('gulp-concat'),include=require('gulp-include');
// REQUIRE DATA
var Package=JSON.parse(fs.readFileSync('package.json'));
// GULP
var rootDevelopment=Package.config.common.development.root;
var rootAssets=path.join(rootDevelopment,Package.config.common.development.assets);
//SASS
gulp.task('sass', function () {
  return gulp
    .src(path.join(rootAssets,'sass','*([^A-Z0-9-]).scss'))//!([^A-Z0-9-])
    .pipe(sass(
        {
            debugInfo: true,
            lineNumbers: true,
            errLogToConsole: true,
            //sourceComments: 'map',//normal, map
            outputStyle: 'expanded'//compressed, expanded
        }
    ).on('error', sass.logError))
    .pipe(gulp.dest(path.join(rootDevelopment,'css')));
});
gulp.task('scripts',function(){
    gulp.src(path.join(rootAssets,'js','*([^A-Z0-9-]).js'))
    //.pipe(concat('all.min.js'))
    .pipe(include().on('error', console.log))
    .pipe(uglify({
        //mangle:false,
        output:{
            beautify: true,
            comments:'license'
        },
        compress:false,
        //outSourceMap: true,
        preserveComments:'license'
    }).on('error', console.log))
    .pipe(gulp.dest(path.join(rootDevelopment,'js')));
});
gulp.task('jstest',function(){
    gulp.src(path.join(rootAssets,'jstest','*([^A-Z0-9-]).js'))
    .pipe(include())
    .pipe(uglify({
        mangle:false,
        output:{
            beautify: true,
            comments:'license'
        },
        compress:false,
        preserveComments:'license'
    }))
    //.pipe(concat('all.min.js'))
    .pipe(gulp.dest(path.join(rootAssets,'output')));
});
//WATCH
gulp.task('watch', function() {
    gulp.watch(path.join(rootAssets,'sass','*.scss'), ['sass']);
    gulp.watch(path.join(rootAssets,'js','*.js'), ['scripts']);
});
//TASK
gulp.task('default', ['watch']);

/*
gulp.task('scripts',function(){
    //gulp.src('src/js/*.js')
    gulp.src(['src/js/test.js','src/js/test-second.js'])
    .pipe(concat('all.min.js'))
    .pipe(uglify())
    .pipe(gulp.dest('js'));
});
// Include gulp
var gulp = require('gulp');

// Include Our Plugins
var jshint = require('gulp-jshint');
var sass = require('gulp-sass');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var rename = require('gulp-rename');

// Lint Task
gulp.task('lint', function() {
    return gulp.src('js/*.js')
        .pipe(jshint())
        .pipe(jshint.reporter('default'));
});

// Compile Our Sass
gulp.task('sass', function() {
    return gulp.src('scss/*.scss')
        .pipe(sass())
        .pipe(gulp.dest('css'));
});

// Concatenate & Minify JS
gulp.task('scripts', function() {
    return gulp.src('js/*.js')
        .pipe(concat('all.js'))
        .pipe(gulp.dest('dist'))
        .pipe(rename('all.min.js'))
        .pipe(uglify())
        .pipe(gulp.dest('dist'));
});

// Watch Files For Changes
gulp.task('watch', function() {
    gulp.watch('js/*.js', ['lint', 'scripts']);
    gulp.watch('scss/*.scss', ['sass']);
});

// Default Task
gulp.task('default', ['lint', 'sass', 'scripts', 'watch']);
*/
