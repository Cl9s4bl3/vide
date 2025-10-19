module main

import os

fn main(){
	mut args := os.args[1..].clone()

	mut overwrite := false
	mut verbose := false

	if args.len < 1 {
		eprintln("Not enough arguments provided")
		exit(1)
	}

	mut non_flag_args := []string{}
	for arg in args {
		if arg.starts_with("--") {
			match arg {
				"--overwrite" { overwrite = true }
				"--verbose" { verbose = true }
				else {
					eprintln('Discarding invalid flag "$arg"')
				}
			}
		} else {
			non_flag_args << arg
		}
	}
	args = non_flag_args.clone()

	for arg in args {

		if verbose {
			println('DEBUG: Processing "$arg"')
		}

		if os.exists(arg) && !overwrite {
			eprintln('"$arg" already exists. Skipping...')
			continue
		}

		if verbose {
			println('DEBUG: Creating "$arg"')
		}

		os.create(arg) or { 
			eprintln('Failed to create "$arg". Error: $err')
			continue
		}
	}

	exit(0)
}