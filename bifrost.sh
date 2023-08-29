#!/bin/bash
. ./.core/assembler.sh

# Bifrost Start
start() {
    #sudoreq
    clear
    logo
    #target_domain
    #target_username
    #target_password
    target_data
    menu
    menu_select
}

# Function to print the version
print_version() {
    echo
    echo "Bifrost Bridge Version: $version"
}

tmp_folder="zzz_BifrostEphemeral.tmp"

tmp() {
    rm -r "./projects/$tmp_folder"
    mkdir -p "./projects/$tmp_folder"
    cd "projects/$tmp_folder" #|| exit
    cp "../../.core/create_target.sh" "../../projects/$tmp_folder/TARGET"
}

list_projects() {
    local project_index=1
    for project_dir in projects/*/; do
        if [ -d "$project_dir" ] && [ "$(basename "$project_dir")" != "$tmp_folder" ]; then
            project_name=$(basename "$project_dir")
            echo "  $project_index) Project $green2$project_name$end"
            project_index=$((project_index + 1))
        fi
    done
}

# Function to display the project menu
projects_menu() {
    local project_name="$1"

    while true; do
        echo
        list_projects
        echo 
        echo "  T) Temporary Project"
        echo "  N) New Project"
        echo
        echo -n "     Enter your choice: $white" && read choice
        echo "$end"
        projects_menu_select
        done
        }

projects_menu_select() {
    counter=1

    # Loop through each folder in the current directory
    for project_dir in ./projects/*/; do
        project_name=$(basename "$project_dir")  # Remove trailing slash and path
        #echo "$counter. $project_name"  # Print the option
        counter=$((counter + 1))  # Increment the counter
    done

    if [ "$choice" = "t" ] || [ "$choice" = "T" ]; then
        tmp
        echo "     $yellow2[EPHEMERAL]$end Initializing$white Temporary Project$end."
        sleep 3
        start
    elif [ "$choice" = "n" ] || [ "$choice" = "N" ]; then
        echo -n "     Enter project name: $green" && read project_name
        mkdir -p "projects/$project_name"
        cd "projects/$project_name" || exit
        echo "$end"
        cp "../../.core/create_target.sh" "../../projects/$project_name/TARGET"
        echo "     $green2[PROJECT CREATED]$end Initializing $white$project_name$end."
        sleep 3
        start
    elif [ "$choice" = "0" ]; then
        credits
        exit
    else
        if [ "$choice" -ge 1 ] && [ "$choice" -lt "$counter" ]; then
            counter=1
            for project_dir in ./projects/*/; do
                if [ "$counter" -eq "$choice" ]; then
                    selected_folder=$(basename "$project_dir")
                    break
                fi
                counter=$((counter + 1))
            done
            echo "     $cyan2[PROJECT FOUND]$end Initializing $white$selected_folder$end."
            sleep 3
            cd "projects/$selected_folder"
            start
        else
            echo
            echo -n "\033[2A\033[0K $red    Incorrect selection. Aborting. $end"
            exit
        fi
    fi
}

# Function to handle command-line arguments
handle_arguments() {
    while [ $# -gt 0 ]; do
        case "$1" in
            -v|--version)
                print_version
                exit 0
                ;;
            -p)
                shift  # Consume the -p flag
                if [ $# -eq 0 ]; then
                    #echo "Missing project name after -p option."
                    #exit 1
                    projects_menu
                fi
                project_name="$1"
                
                # Check if the folder already exists
                if [ -d "projects/$project_name" ]; then
                    echo
                    echo "     $cyan2[PROJECT FOUND]$end Initializing $white$project_name$end."
                    sleep 3
                    cd "projects/$project_name"
                    start
                else
                    mkdir -p "projects/$project_name"
                    cd "projects/$project_name" || exit
                    echo "$green"
                    cp "../../.core/create_target.sh" "../../projects/$project_name/TARGET"
                    echo "     $green2[PROJECT CREATED]$end Initializing $white$project_name$end."
                    sleep 2
                    start
                fi
                ;;
            *)
                echo
                echo "Invalid argument. Use the $yellow2-h$end flag to see all the available commands."
                exit 1
                ;;
        esac
        shift
    done
}


handle_arguments "$@" # Pass all command-line arguments to the handle_arguments function
start "$@"
