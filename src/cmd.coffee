###
	Copyright 2012-2014 David Pearson.
	All rights reserved.
###

child_process = require "child_process"

runCmd = (cmd, args, cb) ->
	opts =
		stdio  : "inherit"
		stderr : "inherit"

	proc = child_process.spawn cmd, args, opts
	if cb?
		proc.on "close", cb

runSilent = (cmd, args, cb) ->
	opts =
		stdio  : "ignore"
		stderr : "ignore"

	proc = child_process.spawn cmd, args, opts
	if cb?
		proc.on "close", cb

exports.runCmd = runCmd
exports.runSilent = runSilent