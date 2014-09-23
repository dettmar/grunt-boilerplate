# Grunt for WordPress
## How to use
* `npm install` **installs** the requirements
* `grunt start` **downloads latest WordPress** and **creates these folders**:
```
frontend/
	coffee/
	js/
	stylus/
	css/
	img/
```
* `grunt` to run the **development** task
* `grunt prod` for the **production** task

## Features
* Stylus compilation
* CoffeScript compilation
* JavaScript and CSS piping
* Image piping
* Live reload (insert `<script src="//localhost:35729/livereload.js"></script>`)