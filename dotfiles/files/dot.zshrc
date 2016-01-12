#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# complement
# source /usr/local/share/zsh/site-functions

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# extra path
export PATH=$HOME/opt/bin:$PATH

# brew
# export HOMEBREW_GITHUB_API_TOKEN=HOMEBREW_GITHUB_API_TOKEN
export HOMEBREW_CASK_OPTS=--appdir=/Applications

# python
export PYTHONSTARTUP=$HOME/.pythonstartup

# go
if [ -x "`which go`" ]; then
        export GOROOT=`go env GOROOT`
        export GOPATH=~/opt/gopath
        export PATH=$PATH:$GOROOT/bin
#       source /usr/local/share/zsh/site-functions/_go
fi

# peco
# https://github.com/peco/peco
function peco-select-history() {
        local tac
        if which tac > /dev/null; then
                tac="tac"
        else
                tac="tail -r"
        fi
        BUFFER=$(history -n 1 | eval $tac | peco --query "$LBUFFER")
        CURSOR=$#BUFFER
        zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# direnv
# https://github.com/direnv/direnv
eval "$(direnv hook zsh)"

# git-flow
# https://github.com/nvie/gitflow
source /usr/local/share/zsh/site-functions/git-flow-completion.zsh

# hub
# https://github.com/github/hub
# eval "$(hub alias -s)"
# source /usr/local/share/zsh/site-functions/_hub

# gibo
# https://github.com/simonwhitaker/gibo
source /usr/local/share/zsh/site-functions/_gibo

# Google Cloud SDK
FPATH="${HOME}/opt/gcloud-zsh-completion/src:${FPATH}"
autoload -U compinit compdef
compinit

# AWS Command Line Tool
source /usr/local/share/zsh/site-functions/_aws
# export AWS_ACCESS_KEY_ID=AWS_ACCESS_KEY_ID
# export AWS_SECRET_ACCESS_KEY=AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=ap-northeast-1
export AWS_DEFAULT_OUTPUT=json

# docker
#source /usr/local/share/zsh/site-functions/_docker
#export DOCKER_HOST=tcp://192.168.59.103:2376
#export DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm
#export DOCKER_TLS_VERIFY=1
#source /usr/local/share/zsh/site-functions/_docker