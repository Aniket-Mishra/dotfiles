
eval "$(/opt/homebrew/bin/brew shellenv)"

export DOTFILES_DIR="$HOME/github/dotfiles"
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"
