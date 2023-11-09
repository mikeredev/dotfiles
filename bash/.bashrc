# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# aliases
alias backup='python ~/data/scripts/system-tools/backup-dotfiles.py'
alias grep='grep --color=auto'
alias gs='git status'
alias gac='git add . && git commit -m'
alias gp='git push -u origin'
alias ls='ls -lA --color=auto --block-size=M'
alias q='python ~/data/scripts/openai/gpt-chatbot-console.py'
alias rr='ranger'

# api keys
export OPENAI_API_KEY=$(cat ~/data/auth/openai/openai_api_key.txt)
export PINECONE_API_KEY=$(cat ~/data/auth/pinecone/pinecone_api_key.txt)

# backup
export BACKUP_CONFIG=~/.config/system-mgmt/backup-dotfiles.json
export BACKUP_LOCATION=~/data/backup/dotfiles

# environment variables
export OPENAI_MODEL='gpt-3.5-turbo'
export PATH=$PATH:~/.local/bin
export PYTHONPATH=$PYTHONPATH:~/.config/pymodules
export EDITOR=vim
export VISUAL=vim

# history
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=100
HISTFILESIZE=200
shopt -s histappend

# prompt
PS1='[\W]\$ > '

# powerline
function _update_ps1() {
    PS1=$(powerline-shell $?)
}
if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

# terminal
shopt -s checkwinsize

# theme
export QT_QPA_PLATFORMTHEME="qt5ct"
export GTK_APPLICATION_PREFER_DARK_THEME=1
export GTK_THEME='Arc-Dark'
export GTK_ICON_THEME="Wings-Dark-Icons"
