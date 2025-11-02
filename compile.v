module main

import os

fn main() {
    directory := "bin/"

    copy_files := false
    copy_dir := "./"

    entries := os.ls(directory) or { 
        eprintln('${err}')
        return
    }

    for entry in entries {

        if !entry.ends_with(".v") {
            println('Skipping invalid V file: "${entry}"')
            continue
        }

        println('Compiling "${entry}"')

        full_path := os.join_path(directory, entry)

        command := "v ${full_path}"

        os.system(command)

        if copy_files {

            println('Copying "${entry}" to "${copy_dir}"')

            os.cp(full_path, copy_dir) or { 
                eprintln('Failed to copy "${full_path}" to "${copy_dir}". Error: ${err}')
            }
        }
    }
}