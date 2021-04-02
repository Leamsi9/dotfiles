# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# This loads nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Path to your oh-my-zsh installation.
export ZSH="/home/ismael/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="ivtheme"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following linetheme to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(aws autojump colorize command-not-found emoji zsh-syntax-highlighting zsh-autosuggestions ansiweather zsh-z)

source $ZSH/oh-my-zsh.sh
# source /usr/bin/ansiweather

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"~/.oh-my-zsh/custom/

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
eval $(thefuck --alias)

alias sudo='sudo ' # make aliases available in sudo
alias fals='alias | grep'
alias fff='fuck' #corrects command with rule from previous output (e.g doing apt-get on missing command or adding sudo)

#Navigation
alias tool='cd ~/Documents/Tools'
alias ent='cd ~/Documents/Bookinglive/mysite'
alias conn='cd ~/Documents/Bookinglive/connect'
alias scrp='cd ~/Documents/Bookinglive/connect/scripts'
alias wbh='cd ~/Documents/Bookinglive/webhooks'
alias book='cd ~/Documents/Bookinglive'
alias docs='cd ~/Documents/'
alias vela='cd ~/Documents/velascodev'
alias theme="idea ~/.oh-my-zsh/custom/themes/ivtheme.zsh-theme"
alias plug='cd ~/.oh-my-zsh/custom/plugins'


## config ##


alias path="idea sudo /etc/paths"
alias apti="sudo apt install"
alias aptu="sudo apt-get --purge remove"
alias profile="idea ~/.zsh_profile"

## zsh ##
alias zc="idea ~/.zshrc"
alias sz="source ~/.zshrc"
## oh-my-zsh ##
alias omy="idea ~/.oh-my-zsh/oh-my-zsh.sh"
function omyplug() {
    PLUGIN_PATH="$HOME/.oh-my-zsh/plugins/"
    for plugin in $plugins; do
        echo "\n\nPlugin: $plugin"; grep -r "^function \w*" $PLUGIN_PATH$plugin | awk '{print $2}' | sed 's/()//'| tr '\n' ', '; grep -r "^alias" $PLUGIN_PATH$plugin | awk '{print $2}' | sed 's/=.*//' |  tr '\n' ', '
    done
}

## use a long listing format ##

alias ll='ls -lAFh'
alias ls='ls -aFh'
alias lS='ls -1FSsh'

## clear the screen of your clutter ##

alias c="clear"

alias rmf='rm -rf'

## list directory and file sizes
alias size="du -hs ./* | sort -h" #current directory
alias size2="du -hcd 2 | sort -h" #current directory and subdirectory

# make dir and move into it
mkdir () {
    command mkdir -p "$@" && cd "$@"
}
# cd into a dir then pwd and ls. No argument provided, use $HOME
cdl() { if [ $# -eq 0 ]; then cd "$HOME" && pwd && ls; else cd "$1" && pwd && ls; fi; }

alias cp='cp -v'
alias mv='mv -v'
alias fdd='find . -type d -name'
alias fdf='find . -type f -name'

#find string
alias grep='grep --color'
#find string within files
alias grepf='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}'
#command history
alias h='history'
#search for word in command history
alias fdh='fc -El 0 | grep'

#displays currently running processes
alias proc='ps -f'


# GIT (move to git config)

alias gs="git status"

alias ga="git add"

alias gac="git commit -am"

alias gc="git commit -m"

alias gch="git checkout"

alias gchm="git checkout master"

alias gp="git push"

alias gpl="git pull"

alias gunstage="git reset HEAD"

alias gst="git stash"

alias gsp="git stash pop"

alias glog="log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"

# PHP UNIT

alias test="vendor/bin/phpunit"

# COMPOSER

alias cc='composer clear-cache'

alias cu='composer update'

alias ci='composer install'

alias cdmp='composer dump-autoload -o'

alias cr='composer require'

#DOCKER

alias dup="docker-compose up"
alias ddwn="docker-compose down"
alias dps="docker ps"
alias dstp='docker stop $(docker ps -aq)' #stop all running containers
alias dx='docker-compose exec'  #run a bash command inside my container
alias dprn='docker system prune'

# NPM
alias npi='npm install && npm run build'
alias npb='npm run build'
alias npt='npm run test'


#CONNECT SCRIPTS
alias cna='docker exec connect_app php artisan'
alias cns='( dstp && cd  ~/Documents/Bookinglive/connect/scripts && ./build.sh && ./composer.sh dump-autoloadfals && cna route:cache && ./seed.sh && npi )'
alias npc='( cd  ~/Documents/Bookinglive/connect/ && npm run cypress )'
alias cnt='( cd  ~/Documents/Bookinglive/connect/scripts && ./tests.sh && npt && ./seed.sh && npc )'



#HEROKU

## export my .env variables to heroku config vars

alias henv="cat .env | xargs heroku config:set --app"


# LARAVEL

alias art='php artisan'

# Sail
alias sail='bash vendor/bin/sail'
alias s='sail'
alias sart='sail artisan'
alias sarm='sart migrate'
alias sup='sail up -d' #detached mode
alias sdwn='sail down -v'
alias srst='sail restart'
alias scnf='sail config'
alias scr='sail composer require'
alias sci='sail composer install'
alias scu='sail composer update'
alias scdmp='sail composer dump-autoload -o'
alias snpm='sail npm'
alias snpmr='sail npm run'
alias sphp='sail php'
alias stink='sail tinker'
alias sbld='sail build --no-cache'

# LANDO

alias l='lando'
alias lds='l start'
alias ldst='l stop'
alias lrs='l restart'
alias lrb='l rebuild --yes'
alias linit='l init'
alias linfo='l info'
alias llist='l list'
alias ldb='l db-import'
alias ldst='l destroy -y'

alias lart='l artisan'
alias lartm='lart migrate'

alias lcr='l composer require'
alias lcc='l composer clear-cache'
alias lcu='l composer update'
alias lci='l composer install'
alias lcdmp='l composer dump-autoload -o'

##PHPUnit
# test docker container
alias ltest='l phpunit'

# alias ltst='docker exec -it webhooksclient_appserver_1 ./app/vendor/bin/phpunit'

##

## Weather
alias bris='ansiweather -l bristol'
alias newp='ansiweather -l newport'
alias weather='ansiweather -l'



# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true
PATH=$PATH:/snap/bin