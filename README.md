## Oven Build Tool for CoffeeScript ##

This is a drop-dead simple build tool for CoffeeScript applications. Features include:

 * Compilation and linting of CoffeeScript
 * Copying of non-CoffeeScript files
 * Automatic recompilation when files change
 * Counting lines of code

Oven was built for use in my own projects, although I certainly hope others will find it useful.

### Installing ###

Make sure you have [node.js](http://nodejs.org/) installed, then run:

    sudo npm install -g oven-build

### Using Oven ###

For each project you want to build with Oven, you'll need to create a file named `Ovenfile` in the project's root directory. This file is just JSON, with one key: `directories`. This value is an array of objects, each with two keys: `src`, the relative path to the source directory, and `bin`, the relative path to the output directory. Both paths are searched recursively.

##### Example Ovenfile #####

	{
		"directories":[
			{
				"src":"./src",
				"bin":"./lib"
			}
		]
	}

### Commands ###

Oven supports a handful of built-in commands, and it will eventually support custom commands.

`oven build` - Compiles all CoffeeScript code, and copies all other files from the source directory to the output directory.

`oven watch` - Like `oven build`, but tracks all changes and automatically performs the build action.

`oven lint` - Passes all CoffeeScript code through a [CoffeeLint](http://www.coffeelint.org/).

`oven clean` - Removes all files from the output directory.

### License ###

	Copyright (c) 2012-2014, David Pearson
	All rights reserved.
	
	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.