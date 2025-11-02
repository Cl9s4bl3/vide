module main

import os

fn is_directory_empty(path string) bool {
	directory_items := os.ls(path) or { 
		eprintln('Failed to read "${path}": Error: ${err}')
		return false
	}

	if directory_items.len == 0 {
		return true
	} else {
		return false
	}
}

fn main() {
	mut args := os.args[1..].clone()

	mut force := false;
	mut directory := false;
	mut verbose := false;

	if args.len < 1 {
		eprintln("Not enough arguments provided");
		exit(2)
	}

	mut non_flag_args := []string{}
	for arg in args {
		if arg.starts_with("--"){
			match arg {
				"--force" { force = true }
				"--directory" { directory = true }
				"--verbose" { verbose = true }
				else {
					eprintln('Discarding invalid flag "${arg}"')
				}
			}
		} else {
			non_flag_args << arg
		}
	}
	args = non_flag_args.clone()

	for arg in args {
		if verbose {
			println('DEBUG: Processing "${arg}"')
		}

		if !os.exists(arg){
			eprintln('"${arg}" does not exist. Skipping...')
			continue
		}

		if os.is_dir(arg) {

			if verbose {
				println('DEBUG: "${arg}" is a directory')
			}

			if directory {

				if verbose {
					println('DEBUG: --directory flag is active')
				}

				if force {

					if verbose {
						println('DEBUG: --force flag is active')
					}

					os.rmdir_all(arg) or { 
						eprintln('Failed to remove all directories inside "${arg}" (and itself). Error: ${err}')
					}
				} else {

					if verbose {
						println('DEBUG: --force flag is NOT active')
					}

					if is_directory_empty(arg) {
						if verbose {
							println('DEBUG: "${arg}" is empty, continuing with directory deletion')
						}
						os.rmdir(arg) or {
							eprintln('Failed to remove directory "${arg}". Error: ${err}')
						}
					} else {
						eprintln('"${arg}" is not empty. Use the --force flag to remove this directory.')
					}
				}
			} else {
				eprintln('"${arg}" is a directory but the --directory flag was not specified')
			}
			continue
		}
		
		if os.is_file(arg){

			if verbose {
				println('DEBUG: "${arg}" is a file')
			}

			if directory {
				eprintln('"${arg}" is a file but the --directory flag was specified')
			} else {

				if verbose {
					println('DEBUG: --directory is not active, continuing with file deletion')
				}

				os.rm(arg) or { 
					eprintln('Failed to remove "${arg}". Error: ${err}')
				}
			}
			continue
		}
	}

	exit(0)
}