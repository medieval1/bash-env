#!/bin/bash

#### Utility

#
# Prioritise local scripts after running setup_path
# Used to ensure the build slave executes scripts from within the build environment
#
function setup_path() {
    # Try to get the path to the root of the containing repo
    local me="${BASH_SOURCE[0]}"
    while [[ -h "$me" ]] ; do me="$(readlink "$me")"; done
    local repo_root="$( cd -P "$( dirname "$me" )" && cd .. && pwd )"
    export PATH=${repo_root}/bin:${repo_root}/tools:${repo_root}/jenkins/scripts${PATH:+:}$PATH
}

#
# Look to source a file in a hierarchy of locations
#   1. current working directory of process
#   2. local directory of this file
#   3. local directory of process sourcing this file
#
function do_source() {
    local file="${1:?"Need to know what file to source"}"
    local me="${BASH_SOURCE[0]}"
    while [[ -h "$me" ]] ; do me="$(readlink "$me")"; done
    local my_pwd="$( cd -P "$( dirname "$me" )" && pwd )"
    local caller="${0}"
    [[ ! -e $caller ]] && caller="."
    while [[ -h "$caller" ]] ; do caller="$(readlink "$caller")"; done
    local caller_pwd="$( cd -P "$( dirname "$caller" )" && pwd )"

    # Check the local directory
    if [[ -e "${file}" ]]
    then
        source ${file}
    elif [[ -e "${my_pwd}/${file}" ]]
    then
        source ${my_pwd}/${file}
    elif [[ -e "${caller_pwd}/${file}" ]]
    then
        source ${caller_pwd}/${file}
    else
        echo "Could not source ${file}"
        return 1
    fi
}

#### Git

#
# Run all commands needed to ensure that submodules are consistent with committed code
#
function git_sm_update() {
    # Make sure we have the correct remote references in config
    git submodule sync
    # Make sure our on-disk remotes match what is specified in our config
    git submodule init
    # Make sure we have the correct sha1 checked out in each submodule
    git submodule update
}

#
# Update every git repository in the local directory
# Handy when you have all the chef repositories checked out in one location
#
function git_pull_all_subdirs() {
    for i in *
    do
        if [[ -d "${i}" ]]
        then
            pushd ${i}
            git pull -p
            popd
        fi
    done
}

#### Chef

#
# Search (from cwd) for the first cookbook matching the specified name.
# A cookbook is identified as any directory containing a 'metadata.rb'
# file.
# The metadata.rb file is checked to ensure that the cookbook does not
# contain a 'name' override.
#
function cb_name() {
    local alias=${1:?"Specify the cookbook to search for"}
    for i in $(find . -regex ".*/$1/metadata.rb")
    do
        sed_name="$(sed -n "s,^[[:space:]]*name[[:space:]]*\(.*\)$,\1,gp" ${i})"
        if [[ -z "${sed_name}" ]]
        then
            echo "$(basename $(dirname ${i}))"
        fi
    done
}

#
# Retrieve the version of the specified cookbook
# TODO: Need to take into account the name tag in the metadata.rb to find the cookbook
#
function cb_ver() {
    local alias=${1:?"Specify the cookbook to search for"}
    for i in $(find . -regex ".*/$1/metadata.rb")
    do
        echo -n "${i}: "
        grep "^[[:space:]]*version[[:space:]]*" ${i}
    done
}

### The following 'cookbook_.*' functions operate on specific cookbooks, the
### root of which is passed as the first argument.
### There don't seem to be knife commands to do this - perhaps there should?
function cookbook_meta() {
  cb_root=$1
  cbm=$cb_root/metadata.rb
  if ! [[ -e $cbm ]]
  then
    echo "cookbook_meta: Not valid cookbook '$cb_root' - no metadata.rb!">&2
    return 1
  fi
  echo $cbm
}

function cookbook_name() {
  cb_root=$1
  cbm=$(cookbook_meta $cb_root)
  sed_name="$(sed -n "s,^[[:space:]]*name[[:space:]]*\(.*\)$,\1,gp" $cbm)"
  if [[ -n "$sed_name" ]]
  then
    echo $sed_name | tr -d "'\""
  else
    basename $cb_root
  fi
  return 0
}
     
function cookbook_version() {
  cb_root=$1
  cbm=$(cookbook_meta $cb_root)
  # Using a trailing xargs to strip any quotes.
  grep '^[[:space:]]*version[[:space:]]' $cbm | awk '{print $2}' | xargs
}

function readjson() {
  # readjson <json file> <field>
  # Return the requested field from the specified json file
  ruby -e "require 'rubygems'; require 'json'; JSON.create_id=nil; d=JSON.parse(IO.read(ARGV[0])); ARGV[1].split('.').each { |f| d=d[f] }; puts d" $1 $2
}

function databag_item_id() {
  dbi_path=$1
  readjson $dbi_path id
}

###

#
# Unset CHEF_SERVER_ALIAS so that stray knife commands don't talk ot a server
#
function unset_chef() {
    unset CHEF_SERVER_ALIAS
}

#
# Set CHEF_SERVER_ALIAS so that knife commands target the specified chef server/organisation
#
function set_chef() {
    local chef_alias=${1:-""}

    if [[ "$(gem list -i knife-select)" == "true" ]]
    then
        if [[ -z "${chef_alias}" ]]
        then
            knife select list
            return $?
        fi
        eval "$(knife select $chef_alias)"
    else
        echo "Error: knife-select gem not installed"
    fi
}

do_source prompts.bash
#do_source knife-completion.bash
