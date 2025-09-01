# dotfiles

![Bash](https://img.shields.io/badge/Bash-121011?style=for-the-badge&logo=gnu-bash&logoColor=blue)
![Rust](https://img.shields.io/badge/Rust-000000?style=for-the-badge&logo=rust&logoColor=CE422B)

<!-- LANG_TABLE_START -->
| Language | % |
|----------|---|
| Shell | 80.65% |
| Rust | 19.35% |

<!-- LANG_TABLE_END -->

A portable, battle (shell) tested toolkit for setting up macOS and Linux exactly the way I like it.  
Set up a fresh machine or your current one to a tuned, hyper-productive (YES) environment in one go.

### What's in it, and why?
- Zsh (zinit) + Powerlevel10k.
    - ZComet is faster, but I like to manage my manager, which ICE allows me to do in Zinit.
- Homebrew & packages
    - This can be updated for Linux systems if you don't use Mac. Windows can be left to dry.
- Git setup (with TU/e override - cuz sikouriti)
    - Can be added for work profiles as well.
- Encrypted SSH config - I've lost my keys far too many times
    - I hope it's safe. Else I'll remove it/add it to gitignore.
- Misc configuration - tools like micro, etc
    - One day, I'll have enough courage to move to Vim.
- Contains code for QoL scripts, like Download organisers, etc.
    - Yes, I wrote that in Rust. Why? Idk, I hate myself or sth.


Whether I’m on a new laptop, spinning up a VM, or just experimenting, these dotfiles keep my workflow consistent.

## Features

- **One-command setup** — install packages, link configs, and apply tweaks with `bootstrap.sh`.
- **Zsh + Powerlevel10k** — fast shell with custom theme and plugin management via Zinit.
- **Unified package install list** — managed with Homebrew (swap for your package manager if needed).
- **Defaults that make sense** — smarter commands without changing muscle memory.
- **Rust utilities** — small CLI tools like an automated downloads organizer (cron-ready).
- **Cross-platform** — works on macOS and Linux out of the box.

## What it looks like:
<img width="1352" height="508" alt="image" src="https://github.com/user-attachments/assets/b79ce6c9-4427-4dae-9b15-d089cd208c61" />


## Quick Start

```bash
git clone https://github.com/Aniket-Mishra/dotfiles.git ~/github/dotfiles
cd ~/github/dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

This will:

1. Install packages from brew-packages.txt
2. Back up your existing configs so you don’t cry later.
3. Symlink configs like .zshrc, .p10k.zsh, and .gitconfig
4. Set up aliases and functions
5. Apply other quality-of-life changes and automations


## Customisation guide

### Repository Structure

```bash
.
├── bootstrap.sh          # Initial setup
├── brew-packages.txt     # Homebrew packages list - Swap with apt/pacman/etc
├── .zshrc                # Shell configs - You'll not need to change much here
├── .p10k.zsh             # Powerlevel10k settings - Customised
├── zsh_aliases           # .zsh_aliases - This has my renames, like nano opens micro
├── shell_functions       # .zsh_functions - creating and activating envs, cleaning file types, etc
├── rust-tools/           # System automations, I chose to write it in rust.
│   └── download_organizer/  # Auto-sorts downloads folder. Can update for other folders as well.
├── scripts/              # Scripts to reduce load on bootstrap.sh. Keep misc shell scripts here.
├── .config/              # App configurations, like micro n fastfetch
└── secrets/              # Private files - encrypt with gpg
```

### Cronjob setup
For download organiser, and other things

```
crontab -e
```

It'll open it in vim. Paste this:

```
0 12 * * * {REPO_LOCATION}/rust-tools/download_organizer/target/release/download_organizer
```
Runs daily at noon. Change time to taste.


### Customization
These configs are tailored for my workflow, but you can:
1. Add or remove packages in brew-packages.txt
2. Modify aliases and functions
3. Swap themes or plugins in .zshrc and .p10k.zsh
4. Extend Rust utilities with your own scripts

### Contributing
Open to ideas and improvements. PRs and discussions are welcome.
If you have a faster way, a cleaner config, or a clever automation, I’d love to see it!

License
MIT License.
Use, modify, and share freely. If you break your system, that's on you, I'm just a cat.