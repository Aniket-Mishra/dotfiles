# Dotfiles - I'm planning on making a lot of machines

This repo includes configuration for:

- Zsh (zinit) + Powerlevel10k.
    - ZComet is faster, but I like to manage my manager, which ICE allows me to do in Zinit.
- Homebrew & packages
    - This can be updated for linux systems if you don't use Mac. Windows can be left to dry.
- Git setup (with TU/e override - cuz sikouriti)
    - Can be added for work profiles as well.
- Encrypted SSH config - I've lost my keys far too many times
    - I hope it's safe. Else I'll remove it/add it to gitignore.
- Misc configuration - tools like micro etc
    - One day, I'll have enough time to permanently move to vim.
- Contains code for QoL scripts, like Download organisers etc.
    - Yes, I wrote that in Rust. Why? Idk, I hate myself or sth.

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
