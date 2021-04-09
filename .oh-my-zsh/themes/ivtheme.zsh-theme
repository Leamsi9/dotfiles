# #Regular text color
# BLACK='\[\e[0;30m\]'
# #Bold text color
# BBLACK='\[\e[1;30m\]'
# #background color
# BGBLACK='\[\e[40m\]'
# RED='\[\e[0;31m\]'
# BRED='\[\e[1;31m\]'
# BGRED='\e[38;5;196m\]'
# GREEN='\e[38;5;71m\]'
# BGREEN='\[\e[1;32m\]'
# BGGREEN='\[\e[1;32m\]'
# LIGHTGREEN='\e[38;5;10m\]'
# YELLOW='\[\e[0;33m\]'
# BYELLOW='\[\e[1;33m\]'
# BGYELLOW='\[\e[1;33m\]'
# BLUE='\[\e[0;34m\]'
# BBLUE='\[\e[1;34m\]'
# BGBLUE='\[\e[1;34m\]'
# MAGENTA='\[\e[0;35m\]'
# BMAGENTA='\[\e[1;35m\]'
# BGMAGENTA='\[\e[1;35m\]'
# CYAN='\[\e[0;36m\]'
# BCYAN='\[\e[1;36m\]'
# BGCYAN='\[\e[1;36m\]'
# WHITE='\[\e[0;37m\]'
# BWHITE='\[\e[1;37m\]'
# BGWHITE='\[\e[1;37m\]'
# ORANGE='\e[38;5;214m\]'
# VIOLET='\e[38;5;128m\]'
#
# ##
# # Colour coded PS1:  user (red for root) -> host -> path info -> git branch (green for up to date, yellow for need to pull, red for need to commit/push)
# # -> green smiley cursor for good code, red frown for error.
#
# function parse_git_branch
# {
#     git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (ᚵ \1 )/'
# }
#
# function git_color ()
# {
#     # Get the status of the repo and chose a color accordingly
#     local STATUS=`git status 2>&1`
#     if [[ "$STATUS" == *'Not a git repository'* ]]
#     then
#         echo ""
#     else
#         if [[ "$STATUS" == *'working tree clean'* ]]
#         then
#             # Green if up to date
#             echo -e ${GREEN}
#         else
#             if [[ "$STATUS" == *'Your branch is behind'* ]]
#             then
#                 # yellow if need to pull
#                 echo -e  ${ORANGE}
#
#             else
#                 # else red if need to commit or push
#                 echo -e  ${RED}
#         fi
#         fi
#     fi
# }
#
#
# function smile_prompt
# {
#     if [ "$?" -eq "0" ]
# then
# #smiley
# SC="🤘"
# else
# #frowney
# SC="👎"
# fi
# if [ $UID -eq 0 ]
# then
# #root user color
# UC="${RED}"
# else
# #normal user color
# UC="${VIOLET}"
# fi
# #hostname color
# HC="${VIOLET}"
# #regular color
# RC="${CYAN}"
# #default color
# DF='\[\e[0m\]'
# BR=$(parse_git_branch)
# PS1="${UC}\u@${HC}\h ${RC}[\w]\[$(git_color)\]${BR} ${SC}${DF} "
# }
#
#
# ##
# # Colour coded PS1:  user (red for root) -> host -> path info -> git branch (green for up to date, yellow for need to pull, red for need to commit/push)
# # -> green smiley cursor for good code, red frown for error.
#
# function parse_git_branch
# {
#     git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (ᚵ \1 )/'
# }
#
# function git_color ()
# {
#     # Get the status of the repo and chose a color accordingly
#     local STATUS=`git status 2>&1`
#     if [[ "$STATUS" == *'Not a git repository'* ]]
#     then
#         echo ""
#     else
#         if [[ "$STATUS" == *'working tree clean'* ]]
#         then
#             # Green if up to date
#             echo -e ${GREEN}
#         else
#             if [[ "$STATUS" == *'Your branch is behind'* ]]
#             then
#                 # yellow if need to pull
#                 echo -e  ${ORANGE}
#
#             else
#                 # else red if need to commit or push
#                 echo -e  ${RED}
#         fi
#         fi
#     fi
# }
# PROMPT_COMMAND=smile_prompt
#
# function smile_prompt
# {
#     if [ "$?" -eq "0" ]
# then
# #smiley
# SC="🤘"
# else
# #frowney
# SC="👎🤘"
# fi
# if [ $UID -eq 0 ]
# then
# #root user color
# UC="${RED}"
# else
# #normal user color
# UC="${VIOLET}"
# fi
# #hostname color
# HC="${VIOLET}"
# #regular color
# RC="${CYAN}"
# #default color
# DF='\[\e[0m\]'
# BR=$(parse_git_branch)
# PS1="${UC}\u@${HC}\h ${RC}[\w]\[$(git_color)\]${BR} ${SC}${DF} "
# }
#
# precmd() { eval "$PROMPT_COMMAND" }
#
# PROMPT= $<$(git_prompt_info)>

# on two lines for easier vgrepping
# entry in a nice long thread on the Arch Linux forums: https://bbs.archlinux.org/viewtopic.php?pid=521888#p521888
PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;32m%}%n%{\e[1;30m%}@%{\e[0m%}%{\e[0;36m%}%m%{\e[0;34m%}%B]%b%{\e[0m%} - %{\e[0;34m%}%B[%b%{\e[0;33m%}'%D{"%a %b %d, %H:%M"}%b$'%{\e[0;34m%}%B]%b%{\e[0m%} - %{\e[0;35m%}%Bbattery($(acpi | grep -o "[0-9]*%")%)%b - %b%{\e[0;34m%}%B[%b%{\e[1;37m%}%~%{\e[0;34m%}%B]%b%{\e[0m%}
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}$%{\e[0;34m%}%B] <$(git_prompt_info)>%{\e[0m%}%b'
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '






