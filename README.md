# Dotfiles - I'm planning on making a lot of machines

This repo includes configuration for:

- Zsh (zinit) + Powerlevel10k
- Homebrew & packages
- Git setup (with TU/e override - cuz sikouriti)
- Encrypted SSH config - I've lost my keys far too many times
- Misc configuration - tools like micro etc

---

## Quick Start

```bash
git clone https://github.com/aniket/dotfiles.git ~/github/dotfiles
cd ~/github/dotfiles
bash bootstrap.sh
```

## Rust tools
### Download organiser
After building the fn, add a crontab.
```
crontab - e
```
It'll open vim.
Type this:
```
12 * * * /Users/aniket/github/dotfiles/rust-tools/download_organizer/target/release/download_organizer
````
Or whatever time you want it to run for.