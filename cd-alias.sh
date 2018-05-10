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
        echo "USAGE: (cd-alias)"
        echo " - cd <path>                 Uses built-in cd command in bash"
        echo " - cd --add <name>           Creates a named alias and uses the current directory as the path"
        echo " - cd --add <name> <path>    Creates a named alias and using the next argument as path       "
        echo " - cd --remove <name>        Removes created alias having the name argument                  "
        echo " - cd --list                 Displays the list of current alias names and corresponding path "
        echo " - cd --help                 Displays help message (cd-alias usages and built-in cd help)    "
        echo "---------------------------------------------------------------------------------------------"
        builtin cd --help
        return 0
    elif [ "${cmd}" == "--add" ]; then
        if [ -z "$2" ]; then
            echo "ERROR: <name> argument value required"
            return 1
        elif ! [[ "$2" =~ ^([A-Za-z])([A-Za-z0-9-]+)([A-Za-z0-9])$ ]]; then
            echo "ERROR: <name> argument invalid format (alnum, dash, and 3min length)"
            return 1
        fi

        local alias=$(grep "^$2=" ${cfg})
        if [ -n "${alias}" ]; then
            local _path=$(echo "${alias}" | cut -d'=' -f2)
            echo "WARN: cd alias name \"$2\" already exists (${_path})"
            return 0
        fi

        local _path=$(pwd)
        [ -n "$3" ] && _path=$(cd $3 &>/dev/null && pwd || echo "")
        if [ -z "${_path}" ]; then
            echo "ERROR: path or directory \"$3\" does not exists"
            return 1
        fi

        echo "$2=${_path}" >> ${cfg}
        echo "INFO: created cd alias \"$2\" (${_path})"
        return 0
    elif [ "${cmd}" == "--remove" ]; then
        local alias=$(grep "^$2\=" ${cfg})
        if [ -z "${alias}" ]; then
            echo "ERROR: cd alias name \"$2\" does not exists"
            return 1
        fi

        grep -v "^$2\=" ${cfg} > ${tmp}
        [ -f ${cfg} ] && rm ${cfg}
        mv ${tmp} ${cfg}
        echo "INFO: removed cd alias \"$2\""
        return 0
    elif [ "${cmd}" == "--list" ]; then
        local aliases=$(cat ${cfg})
        if [ -z "${aliases}" ]; then
            echo "WARN: no cd aliases found"
            return 1
        fi

        echo -e "NAME=PATH\n${aliases}" | column  -ts '='
        return 0
    fi

    local alias=$(grep "^$1\=" ${cfg})
    [ -n "${alias}" ] && dir=$(echo "${alias}" | cut -d'=' -f2)
    builtin cd ${dir}
}
