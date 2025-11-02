module lib

import os

pub fn cd(args []string) int {
	if args.len != 1 {
		eprintln('Command "cd" only supports one argument')
		return 2
	}

	path_str := args[0]

	new_path := os.real_path(path_str)

	if !os.exists(new_path) {
		eprintln('"${new_path}" does not exist')
		return 1
	}

	os.chdir(new_path) or { 
		eprintln('Failed to set "${new_path}" as current directory. Error: ${err}')
		return 1
	}

	return 0
}