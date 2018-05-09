#!/usr/bin/env bash

comment="##cd-alias-installer"
file="${HOME}/.bash_profile"
files="\e[0;33m~/.bashrc\e[0m, \e[0;33m~/.bash_profile\e[0m, \e[0;33m~/.profile\e[0m"

[ ! -f "${file}" ] && file="${HOME}/.bashrc"
[ ! -f "${file}" ] && file="${HOME}/.profile"
[ ! -f "${file}" ] && echo -e "\e[0;31mERROR:\e[0m run command file(s) (${files}) not found" && exit 1

line=$(grep "${comment}$" ${file})
[ -n "${line}" ] && echo -e "\e[0;35mWARN:\e[0m cd-alias already installed" && exit 1

echo -e "\e[0;32mINFO:\e[0m installing cd-alias to rc file (\e[0;34m${file}\e[0m)"
echo -e "\nsource $(pwd)/cd-alias.sh ${comment}\n" >> ${file}
echo -e "\e[0;32mINFO:\e[0m run \"\e[0;34msource ${file}\e[0m\" to apply installation in current session"
