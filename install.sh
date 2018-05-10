#!/usr/bin/env bash

comment="##cd-alias-installer"
file="${HOME}/.bashrc"
[ ! -f "${file}" ] && file="${HOME}/.bash_profile"
[ ! -f "${file}" ] && file="${HOME}/.profile"
[ ! -f "${file}" ] && echo -e "ERROR: run command file(s) (~/.bashrc, ~/.bash_profile, ~/.profile) not found" && exit 1

line=$(grep "${comment}$" ${file})
[ -n "${line}" ] && echo -e "WARN: cd-alias already installed" && exit 1

echo "INFO: installing cd-alias to rc file (${file})"
echo "source $(pwd)/cd-alias.sh ${comment}" >> ${file}
echo "INFO: run \"source ${file}\" to apply installation in current session"
