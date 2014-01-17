###
	Copyright 2012-2014 David Pearson.
	All rights reserved.
###

child_process = require "child_process"
fs = require "fs"

runCmd = (cmd, args) ->
	opts =
		stdio  : "inherit"
		stderr : "inherit"

	child_process.spawn cmd, args, opts

genCpyFunc = (filename, dest) ->
	(curr, prev) ->
		if curr.mtime.getTime() isnt prev.mtime.getTime()
			console.log "cp #{filename} #{dest}"
			child_process.exec "cp #{filename} #{dest}"

task "build", "Compile all Coffee Script and move files", (options) ->
	fs.mkdir "lib", (e) ->
		runCmd "coffee", ["-o", "lib", "-c", "src"]

task "watch", "Watch all source file for changes and build newly changed files", (options) ->
	runCmd "coffee", ["-w", "-o", "lib", "-c", "src"]

	#fs.watchFile "lib/oven.js", genCpyFunc "lib/oven.js", "lib/oven"

task "test", "Runs tests using vows", (options) ->
	exec "vows --spec tests/*", (e, out, err) ->
		console.log out

task "lint", "Run CoffeeLint to lint source files", (options) ->
	args = []

	srcFiles = fs.readdirSync "src"
	for f in srcFiles
		if f.search(".coffee") > 0
			args.push "src/" + f.toString()

	runCmd "coffeelint", args

task "loc", "Counts the number of lines of code", (options) ->
	countLines = (dir) ->
		count = 0
		srcFiles = fs.readdirSync dir
		for f in srcFiles
			if f.search(".coffee") > 0
				lines = fs.readFileSync(dir + "/" + f).toString().split "\n"
				for l in lines
					lineNoWhite = l.replace("/ /g", "").replace "/\t/g", ""
					if lineNoWhite isnt "" and lineNoWhite.substring(0, 1) isnt "#"
						count++

		count

	console.log countLines("src")