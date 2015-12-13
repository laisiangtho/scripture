 /*
var gulp = require('gulp');
var uglify = require('gulp-uglify');
var concat = require('gulp-concat');
var sass = require('gulp-sass');

gulp.task('scripts',function(){
    //gulp.src('src/js/*.js')
    gulp.src(['src/js/test.js','src/js/test-second.js'])
    .pipe(concat('all.min.js'))
    .pipe(uglify())
    .pipe(gulp.dest('js'));
});
gulp.task('sass',function(){
    gulp.src(['src/sass/app.scss'])
    .pipe(sass())
    .pipe(concat('all.min.css'))
    .pipe(gulp.dest('css'));
});
*/
