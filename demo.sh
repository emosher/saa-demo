#!/usr/bin/env bash

TEMP_DIR="saa-spring-petclinic"

check_dependencies() {
    local tools=("vendir" "advisor" "git")
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo "$tool not found. Please install $tool first."
            exit 1
        fi
    done
    # This env must be set for the demo to work
    if [[ -z "${GIT_TOKEN_FOR_PRS}" ]]; then
        echo "GIT_TOKEN_FOR_PRS env var must be set to run this demo"
        exit 1
    fi
}

clone_app() {
    displayMessage "Clone the Spring Pet Clinic"
    git clone git@github.com:emosher/saa-spring-petclinic.git 
}

displayMessage() {
    echo "#### $1"
    echo
}

# Main demo workflow
# Set up the demo environment with deps, etc.
check_dependencies
vendir sync 
. vendir/demo-magic/demo-magic.sh
export TYPE_SPEED=50
export DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"
export PROMPT_TIMEOUT=0

# Set up, clone the app and go to our new directory
rm -rf "$TEMP_DIR"
clone_app
cd "$TEMP_DIR" || exit 1

clear
pe "advisor build-config get"
pe "advisor upgrade-plan get"
pe "advisor upgrade-plan apply --push"
