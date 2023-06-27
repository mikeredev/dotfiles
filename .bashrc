# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# aliases
alias ai='python ~/data/scripts/openai/gpt-console.py'
alias backup='python ~/data/scripts/system-mgmt/backup-dotfiles.py'
alias grep='grep --color=auto'
alias ls='ls -lA --color=auto --block-size=M'
alias rr='ranger'

# api keys
export OPENAI_API_KEY=$(cat ~/data/auth/openai/openai_api_key.txt)
export PINECONE_API_KEY=$(cat ~/data/auth/pinecone/pinecone_api_key.txt)

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
export GTK_THEME='Arc-Dark'

# variables
export OPENAI_MODEL='gpt-3.5-turbo'
export PATH=$PATH:~/.local/bin
export PYTHONPATH=$PYTHONPATH:~/data/scripts/modules
export VISUAL=vim
