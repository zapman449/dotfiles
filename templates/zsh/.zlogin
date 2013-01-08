# .zlogin.  This is the file that only gets run for actuall login shells
# (the difference between this and non-login, interactive shells, is rather
# esoteric, but the short version is usually ony your first login to a
# certain box).  Things that produce output go here.

#stty cr0 -tabs
ttyctl -f  # freeze the terminal modes... can't change without a ttyctl -u
mesg y

#uptime
#echo

#log		# See who's logged in
#echo

#whence fortune 1>/dev/null 2>&1

#if [[ $? == 0 ]]; then
#   fortune
#   echo
#fi
