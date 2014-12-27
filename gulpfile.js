var gulp = require('gulp');
var gutil = require('gulp-util');
var rename = require('gulp-rename');
var uglify = require('gulp-uglify');
var browserify = require('gulp-browserify');
var optimizeBrowserify = require('gulp-optimizebrowserify');
var plumber = require('gulp-plumber');
var less = require('gulp-less');
var minifycss = require('gulp-minify-css');
var sequence = require('run-sequence');


var paths = {
	css: {
		src: 'less/index.less',
		target: 'miwo-navside.css',
		distDir: './dist/css/'
	},
	js: {
		src: 'src/index.coffee',
		target: 'miwo-navside.js',
		distDir: './dist/js/'
	},
	assets: {
		src: 'less/*.less',
		distDir: './dist/less/'
	},
	watch: {
		coffee: ['src/**/*.coffee'],
		less: ['less/*.less']
	}
};


var pipes = {
	createPlumber: function() {
		return plumber(function(error) {
			gutil.log(gutil.colors.red(error.message));
			gutil.beep();
			this.emit('end');
		});
	}
};



gulp.task('default', ['build']);

gulp.task("watch", function() {
	gulp.start('build');
	gulp.watch(paths.watch.less, ['compile-css']);
	gulp.watch(paths.watch.coffee, ['compile-js']);
});

gulp.task('compile-js', function() {
	return gulp.src(paths.js.src, { read: false })
		.pipe(pipes.createPlumber())
		.pipe(browserify({transform: ['caching-coffeeify'], extensions: ['.coffee']}))
		.pipe(rename(paths.js.target))
		.pipe(gulp.dest(paths.js.distDir));
});

gulp.task('copy-assets', function() {
	return gulp.src(paths.assets.src)
		.pipe(gulp.dest(paths.assets.distDir));
});

gulp.task('minify-js', function() {
	return gulp.src(paths.js.distDir+paths.js.target)
		.pipe(optimizeBrowserify())
		.pipe(uglify())
		.pipe(rename({suffix:'.min'}))
		.pipe(gulp.dest(paths.js.distDir));
});

gulp.task('compile-css', function() {
	return gulp.src(paths.css.src)
		.pipe(pipes.createPlumber())
		.pipe(less())
		.pipe(rename(paths.css.target))
		.pipe(gulp.dest(paths.css.distDir));
});

gulp.task('minify-css', function() {
	return gulp.src(paths.css.distDir+paths.css.target)
		.pipe(minifycss({keepBreaks:true}))
		.pipe(rename({suffix:'.min'}))
		.pipe(gulp.dest(paths.css.distDir));
});

gulp.task('build', function(cb) {
	sequence(['compile-js', 'compile-css', 'copy-assets'], cb);
});

gulp.task('dist', function(cb) {
	sequence('build', ['minify-js', 'minify-css'], cb);
});