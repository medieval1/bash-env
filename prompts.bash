#!/bin/bash

function set_xterm_title() {
    # If this is an xterm set the title to user@host:dir chef:server
    case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w chef:$CHEF_SERVER_ALIAS\a\]$PS1"
        ;;
    screen) #Sets the hostname of the box for the tmux window title (possibly for screen also)
        PS1="\[\ek\h\e\]$PS1"
        ;;
    *)
        ;;
    esac
}

function git_chef_prompt() {
    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

    user_host='\[\e[01;30m\]\u@\h'
    dir='\[\e[00m\]:\[\e[00;34m\]\w\[\e[00;00m\]'
    git_changed='$([[ $(git status 2> /dev/null | tail -n1) != \
                        "nothing to commit (working directory clean)" ]] &&\
                            echo "\[\e[00;31m\]" || echo "\[\e[00;32m\]")'
    git_status="\[\e[00;35m\]${git_changed}\$(__git_ps1 \" (%s)\")\[\e[00;35m\]"
    chef_server='${CHEF_SERVER_ALIAS:+ }$CHEF_SERVER_ALIAS'
    prompt='\[\e[01;30m\]\$\[\033[00m\]'

    PS1="${debian_chroot:+($debian_chroot)}${user_host}$dir$git_status$chef_server $prompt "
    set_xterm_title
}

# Same as above but without git information
function chef_prompt() {
    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

    user_host='\[\e[01;30m\]\u@\h'
    dir='\[\e[00m\]:\[\e[00;34m\]\w\[\e[00;00m\]'
    chef_server='${CHEF_SERVER_ALIAS:+ }$CHEF_SERVER_ALIAS'
    prompt='\[\e[01;30m\]\$\[\033[00m\]'

    PS1="${debian_chroot:+($debian_chroot)}${user_host}$dir$chef_server $prompt "
    set_xterm_title
}

function git_chef_prompt2() {
    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

    user_host='\[\e[01;31m\]\u@\h'
    dir='\[\e[00m\]:\[\e[00;34m\]\w\[\e[00;00m\]'
    git_changed='$([[ $(git status 2> /dev/null | tail -n1) != \
                        "nothing to commit (working directory clean)" ]] &&\
                            echo "\[\e[00;31m\]" || echo "\[\e[00;32m\]")'
    git_status="\[\e[00;36m\]${git_changed}\$(__git_ps1 \" (%s)\")\[\e[01;37m\]"
    chef_server='${CHEF_SERVER_ALIAS:+ }$CHEF_SERVER_ALIAS'
    prompt='\[\e[01;31m\]\$\[\033[00m\]'

    PS1="${debian_chroot:+($debian_chroot)}${user_host}$dir$git_status$chef_server $prompt "
    set_xterm_title
}
function git_chef_prompt3() {
    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

    user_host='\[\e[01;37m\]\u@\h'
    dir='\[\e[00m\]:\[\e[00;34m\]\w\[\e[00;00m\]'
    git_changed='$([[ $(git status 2> /dev/null | tail -n1) != \
                        "nothing to commit (working directory clean)" ]] &&\
                            echo "\[\e[00;31m\]" || echo "\[\e[00;32m\]")'
    git_status="\[\e[00;36m\]${git_changed}\$(__git_ps1 \" (%s)\")\[\e[01;33m\]"
    chef_server='${CHEF_SERVER_ALIAS:+ }$CHEF_SERVER_ALIAS'
    prompt='\[\e[01;31m\]\$\[\033[00m\]'

    PS1="${debian_chroot:+($debian_chroot)}${user_host}$dir$git_status$chef_server $prompt "
    set_xterm_title
}

