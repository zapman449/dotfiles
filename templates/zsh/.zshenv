# .zshenv file.  Rule of thumb: stick environment variables in here.  This
# is read by ALL invocations of zsh, shell scripts, logins, etc.  So don't
# put things that will produce output in here.

if [[ "$TERM" == "screen" ]] export TERM=xterm

# basic tmanpath setup
tmanpath=( /usr/man /usr/local/man /usr/lang/man $HOME/man )
tmanpath=( $tmanpath /usr/openwin/man /usr/dt/man )
tmanpath=( $tmanpath /usr/X11R6/man )
tmanpath=( $tmanpath /usr/local/admin/man )
tmanpath=( $tmanpath /usr/share/man /usr/local/share/man )
tmanpath=( $tmanpath /opt/SUNWspro/man /opt/hpnp/man )
tmanpath=( $tmanpath /usr/opt/SUNWmd/man )
tmanpath=( $tmanpath /usr/openv/man /usr/openv/man/share/man )
tmanpath=( $tmanpath /usr/openv/netbackup/bin/goodies/man )
tmanpath=( $tmanpath /usr/local/home/build/jprice/xemacs/man )

tpath=( ~/bin ~ )
tpath=( $tpath /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin )
tpath=( $tpath /etc /usr/etc /opt/etc /usr/local/etc )
tpath=( $tpath /usr/local/home/build/jprice/xemacs/bin )
tpath=( $tpath /usr/ccs/bin /usr/openwin/bin /usr/dt/bin /usr/X11R6/bin )
tpath=( $tpath /usr/opt/SUNWmd/sbin )
tpath=( $tpath /usr/ucb )
tpath=( $tpath /usr/games )
tpath=( $tpath /opt/gnome/bin /opt/gnome/sbin )
tpath=( $tpath /usr/sbin/nsr /usr/bin/nsr )
tpath=( $tpath /opt/SUNWspci/bin )
tpath=( $tpath /opt/SUNWspro/bin )
tpath=( $tpath /opt/SUNWcluster/bin /opt/SUNWcluster/sbin )
tpath=( $tpath /opt/CPfw1-41/bin /opt/CPgui-41/clients/bin )
tpath=( $tpath /usr/local/admin/bin /usr/local/admin/sbin )
tpath=( $tpath /usr/openv/volmgr/bin /usr/openv/bin /usr/openv/java/jre/bin )
tpath=( $tpath /usr/openv/netbackup/bin /usr/openv/netbackup/bin/goodies )
tpath=( $tpath /usr/openv/netbackup/bin/admincmd )
tpath=( $tpath /usr/openv/netbackup/vault/bin )
tpath=( $tpath /usr/openv/netbackup/vault/production )

typeset -U path
path=()
for dir in $tpath ; do
   [[ -d $dir ]] && path=($path $dir)
done
unset $tpath

typeset -U manpath
manpath=()
for dir in $tmanpath ; do
   [[ -d $dir ]] && manpath=($manpath $dir)
done
unset $tmanpath

export path manpath PATH MANPATH

# Note: we need a basic path built before we can run uname... :(
arch=`uname`

if [[ -x /usr/bin/vi ]]; then
   export EDITOR=/usr/bin/vi
elif [[ -x /bin/vi ]]; then
   export EDITOR=/bin/vi
elif [[ -x /usr/local/bin/vi ]]; then
   export EDITOR=/usr/local/bin/vi
elif [[ -x /usr/local/bin/vim ]]; then
   export EDITOR=/usr/local/bin/vim
else  # er...
   export EDITOR=`whence vi`
fi

if [[ $arch == SunOS ]] export LD_LIBRARY_PATH=/opt/gnome/lib:/usr/local/lib

if [[ "$HOSTNAME" == "" ]]; then
   HOSTNAME=`hostname`
   HOST=${HOSTNAME%%.*}
fi
