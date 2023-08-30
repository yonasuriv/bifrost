#!/bin/sh

origin=~/.local/share/Bifrost # Bifrost Path
. $origin/.core/ASSEMBLER # Assemble 

handle_arguments "$@" # Pass all command-line arguments to the handle_arguments function
start "$@" # Bifrost Link Start
