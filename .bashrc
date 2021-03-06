# Non-login, i.e. run on every instance. Place for aliases and functions.

# Creating a symlink between ~/.bashrc and ~/.bash_profile will ensure that the
# same startup scripts run for both login and non-login sessions. Debian's
# ~/.profile sources ~/.bashrc, which has a similar effect.

###########
# History #
###########

export HISTSIZE=9999
export HISTFILESIZE=9999
export HISTTIMEFORMAT="%d.%m.%y %T "
# don't put duplicate lines or lines starting with space in the history
export HISTCONTROL=ignoreboth

#####################
# Colorful terminal #
#####################

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ] || [ -x /bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto -h'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Terminal colors
txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m' # Black - Background
bakred='\e[41m' # Red
badgrn='\e[42m' # Green
bakylw='\e[43m' # Yellow
bakblu='\e[44m' # Blue
bakpur='\e[45m' # Purple
bakcyn='\e[46m' # Cyan
bakwht='\e[47m' # White
txtrst='\e[0m' # Text Reset

# Git stuff in prompt
function git_info {
    git status > /dev/null 2>&1 || return
    msg=$(git branch | perl -ne 'print "$_" if s/^\*\s+// && chomp')
    status_lines=$(git status --porcelain | wc -l)
    [[ $status_lines -ne 0 ]] && msg="$msg !"
    git status | grep -q push && msg="$msg ^"
    git status | grep -q pull && mgs="$msg v"
    echo $msg
}
CURRENT_USER="$(id -un)"
if [ $CURRENT_USER = "root" ]; then
    PS1="\u@\h \W \[${bldred}\]% \[${txtrst}\]"
else
    # \[\] around colors are needed for mintty/cygwin
    PS1="\u@\[${txtcyn}\]\h\[${txtrst}\] \W [\$(git_info)] \[${bldgrn}\]\$ \[${txtrst}\]"
fi

# Git
if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
fi

#########
# SSHFS #
#########

# You might need to uncomment user_allow_other in /etc/fuse.conf and add
# yourself to fuse group.

MYSSHFS_DIR="$HOME/mysshfs";
[ -d $MYSSHFS_DIR ] || mkdir $MYSSHFS_DIR

# Mount remote directory over SSH
function mysshfs_mount () {
    user=$1
    host=$2
    dir=$3

    if [ $# -ne 3 ]; then
        echo "Usage: sshfs_mount USER HOST RDIR"
        return 1
    fi

    ldir="$MYSSHFS_DIR/$host/$dir"

    [ -d $ldir ] || mkdir -p $ldir
    sshfs -o allow_other $user@$host:$dir $ldir -o IdentityFile=~/.ssh/id_rsa
}

# List mounted remote directories
function mysshfs_list_mounted {
    mount | grep sshfs
}

# Unmount remote directory
function mysshfs_umount () {
    ldir=$1

    if [ $# -ne 1 ]; then
        echo "Usage: mysshfs_umount LDIR"
        return 1
    fi

    # unmount and remove empty dirs (for all mount points)
    current_dir=`pwd`
    fusermount -u $ldir && cd $MYSSHFS_DIR && find -type d | grep -v '^\.$' | tac | xargs rmdir
    cd $current_dir
}

########
# Perl #
########

if [ -d "$HOME/perl5/lib/perl5" ]; then
    [ $SHLVL -eq 1 ] && eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"
fi

# perlbrew
if [ -f "$HOME/perl5/perlbrew/etc/bashrc" ]; then
    source "$HOME/perl5/perlbrew/etc/bashrc"
fi

#####################
# Various functions #
#####################

# Open up the todo list
function todo () {
    vi ~/todo.md
}

# Extract compressed files of various type
function extract () {
  if [ -f $1 ] ; then
  case $1 in
    *.tar.bz2) tar xvjf $1     ;;
    *.tar.gz)  tar xvzf $1     ;;
    *.bz2)     bunzip2 $1      ;;
    *.rar)     unrar x $1      ;;
    *.gz)      gunzip $1       ;;
    *.tar)     tar xvf $1      ;;
    *.tbz2)    tar xvjf $1     ;;
    *.tgz)     tar xvzf $1     ;;
    *.zip)     unzip $1        ;;
    *.Z)       uncompress $1   ;;
    *.7z)      7z x $1         ;;
    *)         echo "'$1' cannot be extracted via >extract<" ;;
  esac
  else
    echo "'$1' is not a valid file"
  fi
}

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# prevents accidentally clobbering files
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# other aliases
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
if [ -e /usr/bin/vim ]; then
    alias vi='vim'
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# add compiled perl6 to PATH
if [ -d "/opt/rakudo-star-2017.10/bin" ]; then
    PATH="/opt/rakudo-star-2017.10/bin:$PATH"
fi
if [ -d "/opt/rakudo-star-2017.10/share/perl6/site/bin" ]; then
    PATH="/opt/rakudo-star-2017.10/share/perl6/site/bin:$PATH"
fi

export VAGRANT_DETECTED_OS="$(uname)"

# In case we use Ansible from checkout (development version)
if [ -f ~/ansible/hacking/env-setup ]; then
    source ~/ansible/hacking/env-setup
fi

# Upgrade my dotfiles but not always
runonce ~/.../... supi
runonce -i 10080 install_vim_stuff

# Print quote but not always
runonce myquote -s

# SSH hostnames completion (based on ~/.ssh/config)
if [ -e ~/.ssh_bash_completion ]; then
    source ~/.ssh_bash_completion
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
