module.exports = (grunt) ->
	
	###
	#
	# INTRODUCTION
	#
	# Search and replace "MyWpTheme" with the actual
	# theme name of your project.
	#
	###
	
	randCss = Math.random().toString(36).substr(2, 10)
	randJs = Math.random().toString(36).substr(2, 10)
	srcDir = "frontend/"
	
	cssObj = {}
	cssObj["wordpress/wp-content/themes/MyWpTheme/style.#{randCss}.css"] = ["wordpress/wp-content/themes/MyWpTheme/*.css"]
	
	@initConfig
	
		watch:
			scripts:
				files: "#{srcDir}coffee/**/*.coffee"
				tasks: ["newer:coffee:development", "injector:development"]
				options:
					livereload: true
			styles:
				files: "#{srcDir}stylus/**/*.styl"
				tasks: ["newer:stylus:dev", "injector:development"]
				options:
					livereload: true
			images:
				files: "#{srcDir}img/**/*"
				tasks: ["newer:copy:img"]
			css:
				files: "#{srcDir}css/**/*.css"
				tasks: ["newer:copy:css", "injector:development"]
				options:
					livereload: true
			docs:
				files: "#{srcDir}/**/*.php"
				tasks: ["newer:copy:php", "injector:development"]
				options:
					livereload: true
		
		coffee:
			options:
				sourceMap: true
				bare: true
			development:
				expand: true
				flatten: false
				cwd: "#{srcDir}coffee/"
				src: ["**/*.coffee"]
				dest: "wordpress/wp-content/themes/MyWpTheme/js/"
				ext: ".js"
			prod:
				options:
					sourceMap: false
					bare: false
					join: true
				files:
					"wordpress/wp-content/themes/MyWpTheme/js/scripts.js": ["#{srcDir}coffee/*.coffee", "#{srcDir}coffee/**/*.coffee"]
		
		stylus:
			dev:
				paths: ["#{srcDir}stylus/"]
				files:
					'wordpress/wp-content/themes/MyWpTheme/style.css': ['**/*.styl']
			prod:
				paths: ["#{srcDir}stylus/"]
				files:
					"wordpress/wp-content/themes/MyWpTheme/style.css": ['**/*.styl']

		
		cssmin:
			combine:
				files: cssObj
				
		
		# Js concat
		concat:
				
			prod_js:
				src: ["#{srcDir}js/*.js", "wordpress/wp-content/themes/MyWpTheme/js/scripts.min.js"]
				dest: "wordpress/wp-content/themes/MyWpTheme/js/scripts.min.#{randJs}.js" 
		
		
		clean:
			development: ["wordpress/wp-content/themes/MyWpTheme/"]
			dev_css: ["wordpress/wp-content/themes/MyWpTheme/stylus/"]
			prod: [
					"wordpress/wp-content/themes/MyWpTheme/js/scripts.js"
					"wordpress/wp-content/themes/MyWpTheme/js/scripts.min.js"
					"wordpress/wp-content/themes/MyWpTheme/*.css"
					"!wordpress/wp-content/themes/MyWpTheme/style.#{randCss}.css"
				]
			start: ["latest.zip"]
		
		
		uglify:
			options:
				report: "gzip"
			prod:
				files:
					"wordpress/wp-content/themes/MyWpTheme/js/scripts.min.js": ["wordpress/wp-content/themes/MyWpTheme/js/scripts.js"]
		
		injector:
			options:
				ignorePath: "wordpress/"
			development:
				files:
					"wordpress/wp-content/themes/MyWpTheme/header.php": [
						"wordpress/wp-content/themes/MyWpTheme/**/*.css"
					]
					"wordpress/wp-content/themes/MyWpTheme/footer.php": [
						"wordpress/wp-content/themes/MyWpTheme/js/libs/**/*.js"
						"wordpress/wp-content/themes/MyWpTheme/js/MyWpTheme.js"
						"wordpress/wp-content/themes/MyWpTheme/js/**/*.js"
					]
			prod:
				files:
					"wordpress/wp-content/themes/MyWpTheme/header.php": [
						"wordpress/wp-content/themes/MyWpTheme/*.css"
					]
					"wordpress/wp-content/themes/MyWpTheme/footer.php": [
						"wordpress/wp-content/themes/MyWpTheme/js/libs/**/*.js"
						"wordpress/wp-content/themes/MyWpTheme/js/MyWpTheme.js"
						"wordpress/wp-content/themes/MyWpTheme/js/**/*.js"
					]
		
		copy:
			php:
				files: [
					expand: true
					cwd: "#{srcDir}"
					src: ["**/*.php"]
					dest: "wordpress/wp-content/themes/MyWpTheme/"
				]
			img:
				files: [
					expand: true
					cwd: "#{srcDir}img/"
					src: ["**"]
					dest: "wordpress/wp-content/themes/MyWpTheme/img/"
				]
			js_libs:
				files: [
					expand: true
					cwd: "#{srcDir}js/"
					src: ["**"]
					dest: "wordpress/wp-content/themes/MyWpTheme/js/libs/"
				]
			css:
				files: [
					expand: true
					cwd: "#{srcDir}css/"
					src: ["**/*.css"]
					dest: "wordpress/wp-content/themes/MyWpTheme/"
				]
			fonts:
				files: [
					expand: true
					cwd: "#{srcDir}fonts/"
					src: ["**/*"]
					dest: "wordpress/wp-content/themes/MyWpTheme/fonts/"
				]
		
		
		mkdir:
			init:
				options:
					create: [
						srcDir
						"#{srcDir}coffee/"
						"#{srcDir}js/"
						"#{srcDir}stylus/"
						"#{srcDir}css/"
						"#{srcDir}img/"
						"wordpress/"
					]
		
		
		curl:
			"latest.zip": "https://wordpress.org/latest.zip"
		
		unzip:
			"./": "latest.zip"
			
	
	@loadNpmTasks "grunt-contrib-watch"
	@loadNpmTasks "grunt-contrib-coffee"
	@loadNpmTasks "grunt-contrib-uglify"
	@loadNpmTasks "grunt-contrib-clean"
	@loadNpmTasks "grunt-contrib-cssmin"
	@loadNpmTasks "grunt-contrib-copy"
	@loadNpmTasks "grunt-contrib-concat"
	@loadNpmTasks 'grunt-contrib-stylus'
	@loadNpmTasks "grunt-newer"
	@loadNpmTasks "grunt-concurrent"
	@loadNpmTasks "grunt-injector"
	@loadNpmTasks "grunt-mkdir"
	@loadNpmTasks "grunt-curl"
	@loadNpmTasks "grunt-zip"
	
	@registerTask "start", [
		'mkdir:init'
		'curl'
		'unzip'
		'clean:start'
	]
	
	@registerTask "default", [
		"clean:development"
		"copy:php"
		"copy:img"
		"copy:css"
		"copy:fonts"
		"copy:js_libs"
		"stylus:dev"
		"coffee:development"
		"injector:development"
		"watch"
	]
	
	@registerTask "prod", [
		"clean:development"
		"copy:php"
		"copy:img"
		"copy:css"
		"copy:fonts"
		"stylus:prod"
		"cssmin"
		"coffee:prod"
		"uglify:prod"
		"concat:prod_js"
		"clean:prod"
		"injector:prod"
	]