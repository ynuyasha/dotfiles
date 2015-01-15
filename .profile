# Executed by the command interpreter for login shells, i.e. shells started
# by the login program or a remote login server such as SSH.

# Place for environment variables (no need to export them in Debian).

# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists. See /usr/share/doc/bash/examples/startup-files for examples. The
# files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Environment variables
export EDITOR=vi

PERL5LIB=$HOME/perl5/MyUtils/lib:$PERL5LIB; export PERL5LIB;
PERL_MB_OPT="--install_base \"/home/jreisinger/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/jreisinger/perl5"; export PERL_MM_OPT;
