module.exports = (grunt) ->
	
	randCss = Math.random().toString(36).substr(2, 10)
	randJs = Math.random().toString(36).substr(2, 10)
	
	@initConfig
	
		watch:
			scripts:
				files: 'frontend/coffee/**/*.coffee'
				tasks: ['newer:coffee:development', 'injector:development']
			styles:
				files: 'frontend/css/**/*.css',
				tasks: ['clean:dev_css', 'newer:cssmin', 'injector:development']
		
		coffee:
			options:
				sourceMap: true
				bare: true
			development:
				expand: true
				flatten: false
				cwd: 'frontend/coffee/'
				src: ['**/*.coffee']
				dest: 'backend/public/js/'
				ext: '.js'
			prod:
				options:
					sourceMap: false
					bare: false
					join: true
				files:
					'backend/public/js/scripts.js': 'frontend/coffee/**/*.coffee'
		
		cssmin:
			minify:
				expand: true,
				cwd: 'frontend/css/',
				src: ['*.css'],
				dest: 'backend/public/css/',
				ext: ".min.#{randCss}.css"
				
		
		# Js concat
		concat:
				
			prod_js:
				src: ['frontend/libs/angular.min.js', 'frontend/libs/*.js', 'backend/public/js/scripts.min.js']
				dest: "backend/public/js/scripts.min.#{randJs}.js" 
		
		
		clean:
			development: ['backend/public/']
			dev_css: ['backend/public/css/']
			prod: [
					'backend/public/js/scripts.js'
					'backend/public/js/scripts.min.js'
					'backend/public/css/mapcam.css'
				]
		
		
		uglify:
			options:
				report: 'gzip'
			prod:
				files:
					'backend/public/js/scripts.min.js': ['backend/public/js/scripts.js'] # 
		
		injector:
			options:
				ignorePath: 'backend/public/'
				sort: (a, b) ->
					if a.indexOf("libs") isnt -1
						-1
					else if a.indexOf("app.js") isnt -1
						0
					else
						1
			development:
				files:
					'backend/views/index.ejs': ['backend/public/js/**/*.js', 'backend/public/css/**/*.css']
			prod:
				files:
					'backend/views/index.ejs': [
						'backend/public/js/*.js'
						'backend/public/css/*.css'
					]
		
		copy:
			img:
				files: [
					expand: true
					cwd: 'frontend/img/'
					src: ['**']
					dest: 'backend/public/img/'
				]
			libs:
				files: [
					expand: true
					cwd: 'frontend/libs/'
					src: ['**']
					dest: 'backend/public/js/libs'
				]
			sounds:
				files: [
					expand: true
					cwd: 'frontend/sounds/'
					src: ['**']
					dest: 'backend/public/sounds/'
				]
	
	@loadNpmTasks 'grunt-contrib-watch'
	@loadNpmTasks 'grunt-contrib-coffee'
	@loadNpmTasks 'grunt-contrib-uglify'
	@loadNpmTasks 'grunt-contrib-clean'
	@loadNpmTasks 'grunt-contrib-cssmin'
	@loadNpmTasks 'grunt-contrib-copy'
	@loadNpmTasks 'grunt-contrib-concat'
	@loadNpmTasks 'grunt-newer'
	@loadNpmTasks 'grunt-concurrent'
	@loadNpmTasks 'grunt-injector'

	@registerTask 'default', [
		'clean:development'
		'copy:img'
		'copy:libs'
		'copy:sounds'
		'cssmin'
		'coffee:development'
		'injector:development'
		'watch'
	]
	
	# TODO: Concat libs/*.js into production js
	@registerTask 'prod', [
		'clean:development'
		'copy:img'
		'copy:sounds'
		'coffee:prod'
		'uglify:prod'
		'cssmin'
		'concat:prod_js'
		'clean:prod'
		'injector:prod'
	]