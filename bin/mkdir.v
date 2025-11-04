module main

import os

fn main(){
	mut args := os.args[1..].clone()

	mut overwrite := false
	mut verbose := false

	if args.len < 1 {
		eprintln("Not enough arguments provided")
		exit(2)
	}

	mut non_flag_args := []string{}
	for arg in args {
		if arg.starts_with("--") {
			match arg {
				"--overwrite" { overwrite = true }
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

	for arg in args{

		if verbose {
			println('DEBUG: Processing "${arg}"')
		}

		if os.exists(arg) && !overwrite{
			eprintln('"${arg}" already exists. Skipping...')
			continue
		}

		if overwrite {

			if verbose {
				println('DEBUG: "${arg}" is being overwritten')
			}

			if !os.is_dir(arg){
				eprintln('"${arg}" isn\'t a directory. Skipping...')
				continue
			}

			if verbose {
				println('DEBUG: "${arg}" is being deleted (to be overwritten)')
			}

			os.rmdir_all(arg) or { 
				eprintln('Failed to remove "${arg}". Error: ${err}')
				continue
			}
		}

		if verbose {
			println('DEBUG: Making directory: "${arg}"')
		}
		
		os.mkdir(arg) or { 
			eprintln('Failed to create "${arg}". Error: ${err}')
			continue
		}
	}

	exit(0)
}