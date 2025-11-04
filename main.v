module main

import os
import lib

fn main() {
	env := '/home/cl9s4bl3/Documents/v/vide/bin'
	mut last_exit_code := 0

	aliases := {
		"ls": "list"
	}

	for {
		buffer := os.input('> ').trim_space()

		match buffer {
			"" {
				eprintln("Input cannot be empty")
				continue
			}

			"e?" {
				println("${last_exit_code}")
			} else {

				input := buffer.split(' ')
				mut binary := input[0]
				mut args := input[1..].clone()
				mut use_sudo := false

				if binary == "sudo" {
					binary = input[1]
					args = input[2..].clone()
					use_sudo = true
				}

				if value := aliases[binary] {
					binary = value
				}

				if binary == "cd" {
					builtin_status := lib.cd(args)
					last_exit_code = builtin_status
					continue
				}

				binarypath_str := os.join_path(env, binary)
				binarypath := os.real_path(binarypath_str)

				if !os.exists(binarypath){
					eprintln('"${binary}" binary does not exist')
					continue
				}

				mut execute := binarypath + " " + args.join(" ")
				
				if use_sudo {
					execute = "sudo " + binarypath + " " + args.join(" ")
				}

				execute_data := os.execute(execute)
				print('${execute_data.output}')
				last_exit_code = execute_data.exit_code
			}
		}
	}
}
