#!/bin/bash

set -o pipefail


APP_NAME="COWFORTUNE"


function exists {
  command -v "$1" >/dev/null 2>&1
}

function say_uninstalled {
    app=$1
    echo "Error: ${app} not installed" >&2
}

function say {
    echo $1
}

function install_brew {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    say "Brew successfully installed on your machine."
}

function test_brew_exists {
    if ! exists brew; then
        say "You don't have brew installed on your machine. You need to have it installed to install dependencies of $APP_NAME"
        say "Select an option below, whether to install homebrew or not."

        select yn in "Yes" "No"; do
            case $yn in
                Yes ) install_brew; break;;
                No ) exit;;
            esac
        done
    fi

    say "Homebrew is installed on your computer."
}

function brew_install {
    brew install $1
}

function main {
    unavailable_comands=()
    IS_ANY_COMMAND_UNAVAILABLE=0

    # does cowsay exist, what should we do
    if ! exists cowsay; then
        unavailable_comands+=('cowsay')
        say_uninstalled 'cowsay'
        IS_ANY_COMMAND_UNAVAILABLE=1
    fi

    if ! exists fortune; then
        unavailable_comands+=('fortune')
        say_uninstalled 'fortune'
        IS_ANY_COMMAND_UNAVAILABLE=1
    fi

    if [ $IS_ANY_COMMAND_UNAVAILABLE -eq 1 ]; then
        test_brew_exists
        for t in ${unavailable_comands[@]}; do
            say "about to install $t on your computer. Confirm if I should proceed: "
            select yn in "Yes" "No"; do
                case $yn in
                    Yes ) brew_install $t; break;;
                    No ) exit;;
                esac
            done
        done
        say "Dependencies successfully installed"
    fi

    exit 0
}

main