#!/bin/bash
# Shared setup functions for macOS Host and Dev profiles

# Safer shell defaults even when sourced
set -o errexit -o nounset -o pipefail
IFS=$'\n\t'

# -------------------------------
# Homebrew Package Installation
# -------------------------------
install_homebrew_packages() {
  local brewfile="$PROFILE_DIR/Brewfile"
  local bundle_flags=(--file="$brewfile")

  if [ "${NO_UPGRADE:-false}" = true ]; then
    bundle_flags+=(--no-upgrade)
  fi
  if [ "${BREW_CLEANUP:-false}" = true ]; then
    bundle_flags+=(--cleanup)
  fi

  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would run: brew bundle ${bundle_flags[*]}"
  else
    brew bundle "${bundle_flags[@]}"
  fi
}

# -------------------------------
# TeX Live (LaTeX) Updates
# -------------------------------
update_latex_packages() {
  if [ "${SKIP_TEXLIVE:-false}" = true ]; then
    echo "[INFO] Skipping TeX Live updates (flag set)."
    return 0
  fi

  export PATH="/Library/TeX/texbin:$PATH"
  if ! command -v tlmgr >/dev/null 2>&1; then
    echo "[WARN] tlmgr not found (is MacTeX installed?). Skipping."
    return 0
  fi

  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would run: tlmgr update --self"
    echo "[DRY RUN] Would run: tlmgr update --all"
  else
    tlmgr update --self
    tlmgr update --all
  fi
}

# -------------------------------
# Dotfiles via GNU Stow
# -------------------------------
link_dotfiles() {
  local dfdir="$PROFILE_DIR/dotfiles"
  if [ ! -d "$dfdir" ]; then
    echo "[INFO] No dotfiles directory at $dfdir; skipping."
    return 0
  fi

  # Candidate package dirs (only those that actually exist)
  local candidates=(zsh git config)
  local packages=()
  for p in "${candidates[@]}"; do
    [ -d "$dfdir/$p" ] && packages+=("$p")
  done
  if [ ${#packages[@]} -eq 0 ]; then
    echo "[INFO] No known dotfile packages found in $dfdir; skipping."
    return 0
  fi

  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would delete stray .DS_Store files under $dfdir"
  else
    find "$dfdir" -name '.DS_Store' -delete
  fi

  (
    cd "$dfdir"
    if [ "$DRY_RUN" = true ]; then
      stow -n -v -t "$HOME" "${packages[@]}"
    else
      stow -v -t "$HOME" "${packages[@]}"
    fi
  )
}

# -------------------------------
# macOS defaults scripts
# -------------------------------
apply_macos_defaults() {
  local defdir="$PROFILE_DIR/defaults"
  if [ ! -d "$defdir" ]; then
    echo "[INFO] No defaults directory at $defdir; skipping."
    return 0
  fi

  shopt -s nullglob
  local scripts=("$defdir"/*.sh)
  if [ ${#scripts[@]} -eq 0 ]; then
    echo "[INFO] No defaults scripts found in $defdir; skipping."
    return 0
  fi

  if [ "$DRY_RUN" = true ]; then
    for script in "${scripts[@]}"; do
      echo "[DRY RUN] Would run: bash \"$script\""
    done
  else
    chmod +x "${scripts[@]}"
    for script in "${scripts[@]}"; do
      bash "$script"
    done
  fi
}

# -------------------------------
# VS Code extensions
# -------------------------------
install_vscode_extensions() {
  local list="$PROFILE_DIR/vscode-extensions/extensions.txt"

  if ! command -v code >/dev/null 2>&1; then
    echo "[WARN] VS Code CLI ('code') not found. Skipping VS Code extensions."
    return 0
  fi
  if [ ! -f "$list" ]; then
    echo "[INFO] No VS Code extensions list at $list; skipping."
    return 0
  fi

  # Read line-by-line; skip blanks and comments
  while IFS= read -r line || [ -n "$line" ]; do
    # trim
    local ext="${line#"${line%%[![:space:]]*}"}"
    ext="${ext%"${ext##*[![:space:]]}"}"
    [[ -z "$ext" || "$ext" =~ ^# ]] && continue

    if [ "$DRY_RUN" = true ]; then
      echo "[DRY RUN] Would install VS Code extension: $ext"
    else
      code --install-extension "$ext" || echo "[WARN] Failed to install $ext; continuing."
    fi
  done < "$list"
}

# -------------------------------
# Mac App Store apps
# -------------------------------
install_mas_apps() {
  if ! command -v mas >/dev/null 2>&1; then
    echo "[INFO] 'mas' CLI not installed; skipping MAS apps."
    return 0
  fi
  if ! mas account >/dev/null 2>&1; then
    echo "[WARN] Not signed into Mac App Store. Skipping MAS installs."
    return 0
  fi

  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would run: mas install 1440147259  # AdGuard for Safari"
  else
    mas install 1440147259 || echo "[INFO] AdGuard may already be installed."
  fi
}

# -------------------------------
# Preflight (informational)
# -------------------------------
preflight_checks() {
  echo "[INFO] Preflight:"
  echo "  - PROFILE_DIR: $PROFILE_DIR"
  if command -v brew >/dev/null 2>&1; then
    echo "  - Homebrew: $(brew --prefix)"
  else
    echo "  - Homebrew: missing"
  fi
  echo "  - Stow: $(command -v stow >/dev/null 2>&1 && echo present || echo missing)"
  echo "  - code CLI: $(command -v code >/dev/null 2>&1 && echo present || echo missing)"
  echo "  - mas CLI:  $(command -v mas  >/dev/null 2>&1 && echo present || echo missing)"
  echo "  - Flags: DRY_RUN=$DRY_RUN, NO_UPGRADE=${NO_UPGRADE:-false}, BREW_CLEANUP=${BREW_CLEANUP:-false}, SKIP_TEXLIVE=${SKIP_TEXLIVE:-false}"
}
