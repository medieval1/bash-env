source ~/.git-completion.bash
source ~/.bash_gitprompt
source ~/.bashrc
#source ~/.aliases
source ~/novacli/nova-prod

source ~/.bash_functions

#source ~/.hpcloud

export EC2_ACCESS_KEY=86TE7PHLo4lIQbfbg4OOYTl5UArn8aOHA76:26371941905214
export EC2_SECRET_KEY=Em5lYZO8ysVaCswpoqoAIoRA9gVIfP4JM3k5zFm5
export EC2_URL=https://az-2.region-a.geo-1.ec2-compute.hpcloudsvc.com/services/Cloud/

export NODE_PATH=/usr/local/lib/node

export PATH=$PATH:/usr/local/sbin
export EDITOR="mate -w"

##export PS1='\h:[\w$(__git_ps1 "|%s")]\$ '

# Setting PATH for Python 2.7
# The orginal version is saved in .profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"

PATH=/usr/local/bin:$PATH
export PATH

##
# Your previous /Users/jim/.profile file was backed up as /Users/jim/.profile.macports-saved_2013-01-17_at_10:24:33
##

# MacPorts Installer addition on 2013-01-17_at_10:24:33: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

