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
