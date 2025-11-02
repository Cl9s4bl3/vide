module main

import os
import lib

fn main() {
	env := './bin'
	mut last_exit_code := 0

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
				binary := input[0]
				args := input[1..]

				if binary == "cd" {
					builtin_status := lib.cd(args)
					last_exit_code = builtin_status
					continue
				}

				binarypath_str := os.join_path(env, binary)
				binarypath := os.real_path(binarypath_str)

				if !os.exists(binarypath){
					eprintln('"${binary}" does not exist')
					continue
				}

				execute := binarypath + " " + args.join(" ")

				execute_data := os.execute(execute)
				print('${execute_data.output}')
				last_exit_code = execute_data.exit_code
			}
		}
	}
}
