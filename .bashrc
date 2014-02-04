# Run on every instance, place for aliases and functions
# I moved here stuff from ~/.bash_profile

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
