# Non-login, i.e. run on every instance. Place for aliases and functions.

# Creating a symlink between ~/.bashrc and ~/.bash_profile will ensure that the
# same startup scripts run for both login and non-login sessions. Debian's
# ~/.profile sources ~/.bashrc, which has a similar effect.

if [ -d "$HOME/perl5/lib/perl5" ]; then
    [ $SHLVL -eq 1 ] && eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"
fi

export HISTSIZE=5000
export HISTFILESIZE=5000
export HISTTIMEFORMAT="%d.%m.%y %T "
# don't put duplicate lines or lines starting with space in the history
export HISTCONTROL=ignoreboth

alias ls="ls --color"

# Usage: bkup <file-to-backup>
function bkup () {
    # alpha sortable
    newname=$1.`date +%Y%m%d.%H%M%S.bak`;
    # handle open references to original file
    mv $1 $newname;
    echo "Backed up '$1' to '$newname'.";
    cp -p $newname $1;
}

# Open up the todo list
function todo () {
    vi ~/todo
}

#########
# SSHFS #
#########

# You might need to uncomment user_allow_other in /etc/fuse.conf and add
# yourself to fuse group.

MYSSHFS_DIR="$HOME/mysshfs";
[ -d $MYSSHFS_DIR ] || mkdir $MYSSHFS_DIR

# Mount remote directory over SSH
function mysshfs_mount () {
    host=$1
    dir=$2

    if [ $# -ne 2 ]; then
        echo "Usage: sshfs_mount HOST RDIR"
        return 1
    fi

    ldir="$MYSSHFS_DIR/$host/$dir"

    [ -d $ldir ] || mkdir -p $ldir
    sshfs -o allow_other root@$host:$dir $ldir -o IdentityFile=~/.ssh/id_rsa
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

    # unmount and remove empty dirs
    current_dir=`pwd`
    fusermount -u $ldir && cd $MYSSHFS_DIR && find -type d | grep -v '^\.$' | tac | xargs rmdir
    cd $current_dir
}
