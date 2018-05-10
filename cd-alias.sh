#!/usr/bin/env bash
function cd() {
    local dir="$@"
    local cmd="$1"

    local path="${HOME}/.config/cd-alias"
    local cfg="${path}/alias.cfg"
    local tmp="${path}/.alias.cfg.tmp"

    [ ! -d "${path}" ] && mkdir -p ${path}
    [ ! -f "${cfg}" ] && touch ${cfg}

    if [ "${cmd}" == "--help" ]; then
        echo -e "\e[0;32mUSAGE: (cd-alias)\e[0m"
        echo -e " - cd <path>                 Uses built-in cd command in bash"
        echo -e " - cd --add <name>           Creates a named alias and uses the current directory as the path"
        echo -e " - cd --add <name> <path>    Creates a named alias and using the next argument as path       "
        echo -e " - cd --remove <name>        Removes created alias having the name argument                  "
        echo -e " - cd --list                 Displays the list of current alias names and corresponding path "
        echo -e " - cd --help                 Displays help message (cd-alias usages and built-in cd help)    "
        echo -e "---------------------------------------------------------------------------------------------"
        builtin cd --help
        return 0
    elif [ "${cmd}" == "--add" ]; then
        if [ -z "$2" ]; then
            echo -e "\e[0;31mERROR:\e[0m \e[0;33m<name>\e[0m argument value required"
            return 1
        elif ! [[ "$2" =~ ^([A-Za-z])([A-Za-z0-9-]+)([A-Za-z0-9])$ ]]; then
            echo -e "\e[0;31mERROR:\e[0m \e[0;33m<name>\e[0m argument invalid format \e[0;32m(alnum, n>3)\e[0m"
            return 1
        fi

        local alias=$(grep "^$2=" ${cfg})
        if [ -n "${alias}" ]; then
            local _path=$(echo "${alias}" | cut -d'=' -f2)
            echo -e "\e[0;35mWARN:\e[0m alias name \"\e[0;33m$2\e[0m\" already exists (\e[0;32m${_path}\e[0m)"
            return 0
        fi

        local _path=$(pwd)
        [ -n "$3" ] && _path=$(cd $3 &>/dev/null && pwd || echo "")
        if [ -z "${_path}" ]; then
            echo -e "\e[0;31mERROR:\e[0m path or directory \"\e[0;33m$3\e[0m\" does not exists"
            return 1
        fi

        echo "$2=${_path}" >> ${cfg}
        echo -e "\e[0;32mINFO:\e[0m create alias \"\e[0;33m$2\e[0m\" (\e[0;32m${_path}\e[0m)"
        return 0
    elif [ "${cmd}" == "--remove" ]; then
        local alias=$(grep "^$2\=" ${cfg})
        if [ -z "${alias}" ]; then
            echo -e "\e[0;31mERROR:\e[0m alias name \"\e[0;33m$2\e[0m\" does not exists"
            return 1
        fi

        grep -v "^$2\=" ${cfg} > ${tmp}
        [ -f ${cfg} ] && rm ${cfg}
        mv ${tmp} ${cfg}
        echo -e "\e[0;32mINFO:\e[0m removed alias \"\e[0;33m$2\e[0m\""
        return 0
    elif [ "${cmd}" == "--list" ]; then
        local aliases=$(cat ${cfg})
        if [ -z "${aliases}" ]; then
            echo -e "\e[0;35mWARN:\e[0m no aliases found"
            return 1
        fi

        echo -e "NAME=PATH\n${aliases}" | column  -ts '='
        return 0
    fi

    local alias=$(grep "^$1\=" ${cfg})
    [ -n "${alias}" ] && dir=$(echo "${alias}" | cut -d'=' -f2)
    builtin cd ${dir}
}
