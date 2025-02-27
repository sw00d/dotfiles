#!/usr/bin/env zsh

# Load main files.
# echo "Load start\t" $(gdate "+%s-%N")
source "$dotfiles/terminal/startup.sh"
source "$dotfiles/terminal/completion.sh"
source "$dotfiles/terminal/highlight.sh"
# echo "Load end\t" $(gdate "+%s-%N")

# Load local completion files
for file in $dotfiles/etc/completion/* ; do
  #echo "looking at $file"
  if [ -f "$file" ] ; then
    . "$file"
    #echo "loading $file"
  fi
done

autoload -U colors && colors

# Load and execute the prompt theming system.
fpath=("$dotfiles/terminal" $fpath)
autoload -Uz promptinit && promptinit
prompt 'paulmillr'

# Python
python_bin='/Library/Frameworks/Python.framework/Versions/3.8/bin/'
path+=$python_bin

# Python OpenSSL cert
CERT_PATH=$(python3 -m certifi)
SSL_CERT_FILE=${CERT_PATH}
REQUESTS_CA_BUNDLE=${CERT_PATH}

# Heroku
path+=('/usr/local/heroku/bin')

# Ruby (installed from `brew install ruby`)
export PATH=/usr/local/opt/ruby/bin:$PATH;

# Virtualenvwrapper
#export WORKON_HOME=$HOME/.virtualenvs
#export VIRTUALENVWRAPPER_PYTHON=/Library/Frameworks/Python.framework/Versions/3.8/bin/python3
#export VIRTUALENVWRAPPER_VIRTUALENV=$python_bin'/virtualenv'
#source $python_bin'/virtualenvwrapper.sh'
source virtualenvwrapper.sh

# Android/react native dev
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Node Version Manager (nvm)
mkdir -p ~/.nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
# We have the nvm bash completion already from ../terminal/completion/_nvm
#[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# To get the latest node LTS and use it by default:
#   nvm install --lts && nvm use --lts && nvm alias default node

# Postgres 11 install helper, not necessary on latest `brew install postres`
path+=('/usr/local/opt/postgresql@11/bin')

# Set global git ignore up
git config --global core.excludesfile '~/.gitignore'

# After modifications, export path for other people to use
export PATH

# Don't share history between terminal tabs
unsetopt inc_append_history
unsetopt share_history

# ==================================================================
# = Aliases =
# ==================================================================
alias killpycs='find . -name "*.pyc" -delete'
alias ls='ls -AGhl'

# Docker stuff
alias down="docker compose down"
alias up="docker compose up -d"
alias dcr="docker compose restart"
alias dcd="docker compose exec django ./manage.py"
alias dcb="docker compose exec builder"
alias dcs="docker compose stop"
alias dc="docker compose"
alias dcl="docker compose logs -f"
alias f8="docker compose exec django flake8"
alias yeet="rm -rf"
alias pytest="docker compose exec django pytest"
alias fuck="docker compose down; docker system prune -f; docker volume rm $(docker volume ls -qf dangling=true); docker compose up -d"

# Git Shit
alias gch="git checkout"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gm="git merge"
alias gs="git status"
alias gd="git diff"
alias stash="git stash"
alias gb="git branch"
alias graph="git log --graph --abbrev-commit --decorate --format=format:'%C(bold yellow)%h%C(reset) - %C(green)(%ar)%C(reset)%C(bold white) %s%C(reset) %C(dim     white)- %an%C(reset)%C(auto)%d%C(reset)' --all"


# ==================================================================
# = Functions =
# ==================================================================

function gsu(){
 echo "git branch --set-upstream-to=origin/$(git branch --show-current) $(git branch --show-current)"
 git branch --set-upstream-to=origin/$(git branch --show-current) $(git branch --show-current)
}

function gset () {
    echo "git branch --set-upstream-to=origin/ $(git branch --show-current)  $(git branch --show-current)"
    git branch --set-upstream-to=origin/$(git branch --show-current)  $(git branch --show-current)
}
function gpu () {
    echo "git push -u origin $(git branch --show-current)"
    git push -u origin $(git branch --show-current)
}
function pr () {
    URL=$(echo "$(git remote -v)\n$(git branch --show-current)" | p -c "import sys; lines = sys.stdin.readlines(); print(f\"https://github.com/{lines[-2].split('github.com:')[-1].split('.git')[0]}/pull/new/{lines[-1].strip()}\");");
    open $URL
}
function parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
function pycharm() {
  open -na "PyCharm.app" --args "$@"
}
# Better find(1)
function ff() {
  find . -iname "*${1:-}*"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source /Users/samuelwood/.docker/init-zsh.sh || true # Added by Docker Desktop
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/samuelwood/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/samuelwood/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/samuelwood/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/samuelwood/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
