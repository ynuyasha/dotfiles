# Non-login, i.e. run on every instance. Place for aliases and functions.

# Creating a symlink between ~/.bashrc and ~/.bash_profile will ensure that the
# same startup scripts run for both login and non-login sessions. Debian's
# ~/.profile sources ~/.bashrc, which has a similar effect.

eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)

export HISTSIZE=5000
export HISTFILESIZE=5000
export HISTTIMEFORMAT="%d.%m.%y %T "

alias ls="ls --color"

# Usage: bkup <file-to-backup>
function bkup () {
    newname=$1.`date +%Y%m%d.%H%M.bak`;
    mv $1 $newname;
    echo "Backed up $1 to $newname.";
    cp -p $newname $1;
}
