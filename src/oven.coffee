###
	Copyright 2012-2014 David Pearson.
	All rights reserved.
###

clc = require "cli-color"
fs = require "fs"
{runCmd, runSilent} = require "./cmd"

pkg = __filename.substring 0, __filename.length - 12
coffee = "#{pkg}/node_modules/coffee-script/bin/coffee"
coffeelint = "#{pkg}/node_modules/coffeelint/bin/coffeelint"
coffeelintConfig = "#{pkg}/coffeelint.json"

genCpyFunc = (filename, dest) ->
	(curr, prev) ->
		if curr.mtime.getTime() isnt prev.mtime.getTime()
			console.log "cp #{filename} #{dest}"
			child_process.exec "cp #{filename} #{dest}"

fileIs = (name, type) ->
	name.toString().indexOf(type) is name.toString().length - type.length

build = (src, bin) ->
	runCmd coffee, ["-o", bin, "-c", src], (code) ->
		if code is 0
			srcFiles = fs.readdirSync src
			for f in srcFiles
				if f.toString() is ".DS_Store"
					continue

				srcPath = src + "/" + f
				binPath = bin + "/" + f

				stat = fs.statSync srcPath
				if stat.isDirectory()
					if !fs.existsSync binPath
						fs.mkdirSync binPath

					build srcPath, binPath
				else if fileIs(f, ".js") or fileIs(f, ".json")
					runCmd "cp", [srcPath, binPath], (code) ->
						if code isnt 0
							console.log "Error copying #{srcPath}"
							process.exit -1
		else
			process.exit -1

watch = (src, bin) ->
	runCmd coffee, ["-w", "-o", bin, "-c", src]

	srcFiles = fs.readdirSync src
	for f in srcFiles
		if f.toString() is ".DS_Store"
			continue

		srcPath = src + "/" + f
		binPath = bin + "/" + f

		stat = fs.statSync srcPath
		if stat.isDirectory()
			if !fs.existsSync binPath
				fs.mkdirSync binPath

			build srcPath, binPath
		else if fileIs(f, ".js") or fileIs(f, ".json")
			fs.watchFile srcPath, genCpyFunc srcPath, binPath

clean = (src, bin) ->
	binFiles = fs.readdirSync bin
	for f in binFiles
		binPath = bin + "/" + f
		stat = fs.statSync binPath
		if stat.isDirectory()
			fs.rmdirSync binPath
		else
			fs.unlink binPath

genList = (folder, type) ->
	list = []

	files = fs.readdirSync folder
	for f in files
		if f.toString() is ".DS_Store"
			continue

		path = folder + "/" + f

		stat = fs.statSync path
		if stat.isDirectory()
			contents = genList path, type
			list.push contents...
		else if fileIs f, type
			list.push path

	list

lint = (src, quiet, cb) ->
	args = ["-f", coffeelintConfig]
	fileList = genList src, ".coffee"
	args.push fileList...

	unless quiet
		if cb?
			runCmd coffeelint, args, cb
		else
			runCmd coffeelint, args
	else
		runSilent coffeelint, args, (code) ->
			if code is 0
				console.log clc.green "Lint succeeded."
			else
				console.log clc.red "Lint failed; run 'oven lint' for details."

			if cb?
				cb code

cmd = process.argv[2]

srcdir = null
bindir = null

if cmd in ["build", "watch", "clean", "lint"]
	ovenfilePath = process.cwd() + "/Ovenfile"

	if fs.existsSync ovenfilePath
		ovenfile = JSON.parse fs.readFileSync ovenfilePath

		srcdir = ovenfile.src
		bindir = ovenfile.bin
	else
		console.log "An Ovenfile wasn't found in the current directory!"
		process.exit -1

switch cmd
	when "build"
		lint srcdir, true, (code) ->
			if code isnt -900
				build srcdir, bindir
				console.log clc.green "Build succeeded."
	when "watch" then watch srcdir, bindir
	when "clean" then clean srcdir, bindir
	when "lint"  then lint srcdir, false