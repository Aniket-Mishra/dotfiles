# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
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
zinit ice --as=plugin --wait
zinit light zsh-users/zsh-autosuggestions

zinit ice --as=plugin --wait
zinit light zdharma-continuum/fast-syntax-highlighting

# Zsh history search (your choice)
zinit ice --as=plugin --wait
zinit light zsh-users/zsh-history-substring-search

# General Zsh completions (essential for compinit)
zinit ice --as=plugin --wait
zinit light zsh-users/zsh-completions

# fzf setup (must be before compinit as it provides completions)
zinit ice from"gh-r" as"program"
zinit load junegunn/fzf
zinit ice wait lucid
zinit load Aloxaf/fzf-tab

# Snippet (placed here with other Zinit loads)
zinit snippet https://gist.githubusercontent.com/hightemp/5071909/raw/

# Deferred/Lazy loaded plugins (e.g., asdf)
zinit ice --as=program --defer
zinit light asdf-vm/asdf


# # Setting up from brew
# # Theme - Powerlevel10k. It is no longer maintained
# # But it's p good rn. If things go bad we search for sth else.
# zinit ice depth=1;
# zinit light romkatv/powerlevel10k

# Zsh completion initialization (moved after all completion-providing plugins and external completion setups)
autoload -Uz compinit
compinit -C

# UV (Python manager) - Shell completion setup (placed before compinit)
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# Direnv for per-project envs (placed after compinit as it modifies environment)
eval "$(direnv hook zsh)"

# Zoxide for smart directories (placed after compinit as it modifies environment)
eval "$(zoxide init zsh)"

# Setting up from brew
# # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### Aliases
alias ls="eza --long --git --icons --group-directories-first --classify --header"
alias cat="bat"
alias nano="micro"
alias grep="rg"
alias find="fd"
alias fm="ranger"
# alias cd="z"
eval "$(zoxide init --cmd cd zsh)"

### Commands
if command -v axel &> /dev/null; then
  alias fastget='axel -n 8'
else
  alias fastget='curl -O'
fi

# alias brew-sync='brew list > ~/github/dotfiles/brew-packages.txt && brew list --cask >> ~/github/dotfiles/brew-packages.txt'
brew-sync() {
  echo "Syncing Homebrew packages to dotfiles"
  brew list > ~/github/dotfiles/brew-packages.txt
  brew list --cask >> ~/github/dotfiles/brew-packages.txt
  echo "Brew packages saved to ~/github/dotfiles/brew-packages.txt"
}
