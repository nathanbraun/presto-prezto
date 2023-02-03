#!/usr/bin/env bash

# A script for the quick setup of Zsh shell with Prezto, several useful plugins and an awesome theme.
# 
# Based on https://github.com/gustavohellwig/gh-zsh


#--------------------------------------------------
# Parse CLI options (logic based on https://github.com/ryanoasis/nerd-fonts/blob/master/install.sh)
#--------------------------------------------------
optspec=":f-:"
while getopts "$optspec" optchar; do
  case "${optchar}" in

    # Short options
    f) WITH_FONT=true;;

    -)
      case "${OPTARG}" in
        # Long options
        font) WITH_FONT=true;;
      esac;;

    *)
      echo "Unknown option -${OPTARG}" >&2
      exit 1
      ;;

  esac
done
shift $((OPTIND-1))


#--------------------------------------------------
# Shell Configurations
#--------------------------------------------------
OS="$(uname)"
if [[ "$OS" == "Linux" ]] || [[ "$OS" == "Darwin" ]] ; then
    echo
    if [[ "$OS" == "Linux" ]]; then
        echo "--> Please, type your password (to 'sudo apt install' the requirements):"
        sudo apt install zsh bat git snap -y
        echo -e "\nInstalling zsh, bat, git and snap"
    fi
    echo -e "\nShell Configurations"
    if [[ "$OS" == "Linux" ]]; then
        sudo usermod -s /usr/bin/zsh $(whoami) &> /dev/null
        sudo usermod -s /usr/bin/zsh root &> /dev/null
    fi
    # if mv -n ~/.zshrc ~/.zshrc_backup_$(date +"%Y-%m-%d_%H:%M:%S") &> /dev/null; then
    #     echo -e "\n--> Backing up the current .zshrc config to .zshrc_backup-date"
    # fi

    #--------------------------------------------------
    # Prezto and plugins
    #--------------------------------------------------
    echo -e "\nInstalling Prezto"
    # Install Prezto (by downloading the repo int .zprezto folder in our home directory): https://github.com/sorin-ionescu/prezto
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

    echo -e "\nPrezto configuration complete (plugins will be installed on the first shell run)"

    # Inspired by https://github.com/romkatv/zsh4humans/blob/v5/sc/exec-zsh-i
    try_exec_zsh() {
        >'/dev/null' 2>&1 command -v "$1" || 'return' '0'
        <'/dev/null' >'/dev/null' 2>&1 'command' "$1" '-fc' '
        [[ $ZSH_VERSION == (5.<8->*|<6->.*) ]] || return
        exe=${${(M)0:#/*}:-$commands[$0]}
        zmodload -s zsh/terminfo zsh/zselect || [[ $ZSH_PATCHLEVEL == zsh-5.8-0-g77d203f && $exe == */bin/zsh && -e ${exe:h:h}/share/zsh/5.8/scripts/relocate ]]' || 'return' '0'
        'exec' "$@" || 'return'
    }
    exec_zsh() {
        'try_exec_zsh' 'zsh' "$@" || 'return'
        'try_exec_zsh' '/usr/local/bin/zsh' "$@" || 'return'
        'try_exec_zsh' '/bin/zsh' "$@" || 'return'
    }
    'exec_zsh' '-i'
    # Inspired from: https://github.com/romkatv/zsh4humans/blob/v5/sc/exec-zsh-i

else
    echo "This script is only supported on macOS and Linux."
    exit 0
fi
