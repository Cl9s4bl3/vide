module main

import os
import term

fn print_items(dir string){

	entries := os.ls(dir) or { 
		eprintln('Failed to read directory "$dir". Error: $err')
		exit(1)
	}

	if entries.len == 0 {
		eprintln('Directory does not contain any items')
		return
	}

	for entry in entries {
		path := os.join_path(dir, entry)
		if os.is_dir(path) {
			print(term.green('$entry    '))
		} else if os.is_file(path) {
			print(term.white('$entry    '))
		} else {
			print(term.blue('$entry     '))
		}
	}
	term.reset('')
	println('')
}

fn main() {
	mut args := os.args[1..].clone()
	current_directory := os.getwd()

	if args.len == 0 {
		print_items(current_directory)
	} else if args.len == 1 {
		list_path_arg := args[0]
		list_path := os.real_path(list_path_arg)

		if !os.exists(list_path) || !os.is_dir(list_path){
			eprintln('"$list_path_arg" does not exist or is not a directory')
			exit(1)
		}

		print_items(list_path)
	} else {
		eprintln("Invalid amount of arguments given")
		exit(1)
	}

	exit(0)
}