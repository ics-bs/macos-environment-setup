# macOS Environment Setup

## What it does
- Installs Homebrew packages per profile
- Symlinks dotfiles **into `$HOME`** via GNU Stow (repo = source of truth)
- Applies macOS defaults (per profile)
- Installs VS Code extensions
- Installs Mac App Store apps (if signed in)
- Single setup script with flags and logging (`setup.log`)

## Installation

1) **Install Homebrew (if missing)**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2) **(Host only) Sign into iCloud + Mac App Store**  
Needed for `mas` installs.

3) **Authorize and run**
```bash
chmod +x setup.sh
sudo -v
./setup.sh --profile=host    # or --profile=dev
```

**Common flags**
- `--dry-run` → print actions only
- `--no-upgrade` → install from Brewfile without upgrading existing formulae/casks
- `--brew-cleanup` → remove formulae/casks not in Brewfile
- `--skip-texlive` → skip TeX Live (`tlmgr`) updates

Examples:
```bash
./setup.sh --profile=dev --dry-run
./setup.sh --profile=host --no-upgrade --skip-texlive
```

## Folder structure
- `profiles/host/` — Brewfile, `dotfiles/`, `defaults/`, `vscode-extensions/`
- `profiles/dev/` — Brewfile, `dotfiles/`, `defaults/`, `vscode-extensions/`
- `functions.sh` — shared logic
- `setup.sh` — entrypoint

## Notes
- Default profile is `host` if none is provided.
- Run `git` once to trigger Xcode command line tools if needed.
- Install Parallels Tools in VMs.
- If Spotlight misbehaves in a guest but other shortcuts work, restart guest and host.
