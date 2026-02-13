# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

### Zinit Plugins

# Essential interactive plugins (load early, but wait for prompt)
# zinit ice --as=plugin --wait
zinit light zsh-users/zsh-autosuggestions

# zinit ice --as=plugin --wait
zinit light zdharma-continuum/fast-syntax-highlighting

# Zsh history search
zinit ice wait'1' lucid
zinit light zsh-users/zsh-history-substring-search

# General Zsh completions
zinit ice blockf
zinit light zsh-users/zsh-completions

# fzf setup (must be before compinit as it provides completions)
zinit ice from"gh-r" as"program" wait'1' lucid
zinit load junegunn/fzf

# fzf-tab
# zinit ice wait lucid
zinit ice wait'1' lucid
zinit load Aloxaf/fzf-tab

# Snippet
zinit ice wait'1' lucid
zinit snippet https://gist.githubusercontent.com/hightemp/5071909/raw/


# Deferred/Lazy loaded plugins
zinit ice --as=program --defer lucid
zinit light asdf-vm/asdf


### Setting up from brew
### Theme - Powerlevel10k. It is no longer maintained
### But it's p good rn. If things go bad we search for sth else.
# zinit ice depth=1;
# zinit light romkatv/powerlevel10k

# Zsh completion initialization
autoload -Uz compinit
# compinit -C # supresses sec warnings
compinit -d ~/.zcompdump-$ZSH_VERSION

# UV
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# Direnv
eval "$(direnv hook zsh)"

# Zoxide
eval "$(zoxide init zsh)"

### Run fastfetch on terminal startup
# if [[ $- == *i* ]] && command -v fastfetch &>/dev/null; then
#   fastfetch --config ~/github/dotfiles/fastfetch/config.jsonc
# fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### Aliases
unalias ls 2>/dev/null
unalias -m 'ls*' 2>/dev/null
[[ -r ~/.zsh_aliases   ]] && source ~/.zsh_aliases
[[ -r ~/.zsh_functions ]] && source ~/.zsh_functions

eval "$(zoxide init --cmd cd zsh)"

### Commands
if command -v axel &> /dev/null; then
  alias fastget='axel -n 8'
else
  alias fastget='curl -O'
fi

### Functions

## alias brew-sync='brew list > ~/github/dotfiles/brew-packages.txt && brew list --cask >> ~/github/dotfiles/brew-packages.txt'
[[ -r ~/.zsh_functions ]] && source ~/.zsh_functions
export JAVA_HOME=$(/usr/libexec/java_home -v 21) # 24 is present but misbehaves with spark 4.0

[[ -r ~/.config/secrets/openml.env ]] && source ~/.config/secrets/openml.env
