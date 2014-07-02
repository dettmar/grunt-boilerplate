module.exports = (grunt) ->
	
	randCss = Math.random().toString(36).substr(2, 10)
	randJs = Math.random().toString(36).substr(2, 10)
	srcDir = "frontend/"
	destDir = "backend/"
	
	@initConfig
	
		watch:
			scripts:
				files: "#{srcDir}coffee/**/*.coffee"
				tasks: ["newer:coffee:development", "injector:development"]
			styles:
				files: "#{srcDir}css/**/*.css",
				tasks: ["clean:dev_css", "newer:cssmin", "injector:development"]
		
		coffee:
			options:
				sourceMap: true
				bare: true
			development:
				expand: true
				flatten: false
				cwd: "#{srcDir}coffee/"
				src: ["**/*.coffee"]
				dest: "#{destDir}js/"
				ext: ".js"
			prod:
				options:
					sourceMap: false
					bare: false
					join: true
				files:
					"#{destDir}js/scripts.js": "#{srcDir}coffee/**/*.coffee"
		
		cssmin:
			minify:
				expand: true,
				cwd: "#{srcDir}css/",
				src: ["*.css"],
				dest: "#{destDir}css/",
				ext: ".min.#{randCss}.css"
				
		
		# Js concat
		concat:
				
			prod_js:
				src: ["#{srcDir}libs/angular.min.js", "#{srcDir}libs/*.js", "#{destDir}js/scripts.min.js"]
				dest: "#{destDir}js/scripts.min.#{randJs}.js" 
		
		
		clean:
			development: ["#{destDir}"]
			dev_css: ["#{destDir}css/"]
			prod: [
					"#{destDir}js/scripts.js"
					"#{destDir}js/scripts.min.js"
					"#{destDir}css/mapcam.css"
				]
		
		
		uglify:
			options:
				report: "gzip"
			prod:
				files:
					"#{destDir}js/scripts.min.js": ["#{destDir}js/scripts.js"] # 
		
		injector:
			options:
				ignorePath: "#{destDir}"
				sort: (a, b) ->
					if a.indexOf("libs") isnt -1
						-1
					else if a.indexOf("app.js") isnt -1
						0
					else
						1
			development:
				files:
					"#{destDir}views/index.ejs": ["#{destDir}js/**/*.js", "#{destDir}css/**/*.css"]
			prod:
				files:
					"#{destDir}views/index.ejs": [
						"#{destDir}js/*.js"
						"#{destDir}css/*.css"
					]
		
		copy:
			img:
				files: [
					expand: true
					cwd: "#{srcDir}img/"
					src: ["**"]
					dest: "#{destDir}img/"
				]
			libs:
				files: [
					expand: true
					cwd: "#{srcDir}libs/"
					src: ["**"]
					dest: "#{destDir}js/libs"
				]			
	
	@loadNpmTasks "grunt-contrib-watch"
	@loadNpmTasks "grunt-contrib-coffee"
	@loadNpmTasks "grunt-contrib-uglify"
	@loadNpmTasks "grunt-contrib-clean"
	@loadNpmTasks "grunt-contrib-cssmin"
	@loadNpmTasks "grunt-contrib-copy"
	@loadNpmTasks "grunt-contrib-concat"
	@loadNpmTasks "grunt-newer"
	@loadNpmTasks "grunt-concurrent"
	@loadNpmTasks "grunt-injector"

	@registerTask "default", [
		"clean:development"
		"copy:img"
		"copy:libs"
		"cssmin"
		"coffee:development"
		"injector:development"
		"watch"
	]
	
	@registerTask "prod", [
		"clean:development"
		"copy:img"
		"coffee:prod"
		"uglify:prod"
		"cssmin"
		"concat:prod_js"
		"clean:prod"
		"injector:prod"
	]