#!/bin/bash
# Shared setup functions for macOS Host and Dev profiles

# ------------------------------------
# Homebrew Package Installation
# ------------------------------------

# install_homebrew_packages
# Installs all Homebrew packages defined in the current profile's Brewfile.
# Respects dry-run mode.
install_homebrew_packages() {
  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would run: brew bundle --file=$SCRIPT_DIR/Brewfile"
  else
    brew bundle --file="$PROFILE_DIR/Brewfile"
  fi
}

# update_latex_packages
# Updates LaTeX packages using tlmgr. Ensures correct PATH for tlmgr.
# Respects dry-run mode.
update_latex_packages() {
  export PATH="/Library/TeX/texbin:$PATH"
  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would run: sudo tlmgr update --self"
    echo "[DRY RUN] Would run: sudo tlmgr update --all"
  else
    # Ensure tlmgr is in PATH
    export PATH="/Library/TeX/texbin:$PATH"

    # Update LaTeX packages
    sudo tlmgr update --self
    sudo tlmgr update --all
  fi
}

# link_dotfiles
# Links dotfiles using stow for the current profile.
link_dotfiles() {
  find "$PROFILE_DIR/dotfiles" -name '.DS_Store' -delete
  cd "$PROFILE_DIR/dotfiles"
  stow zsh git config
  cd "$PROFILE_DIR"
}

# apply_macos_defaults
# Applies macOS defaults from profile-specific scripts.
# Ensures scripts are executable before running.
apply_macos_defaults() {
  chmod +x "$PROFILE_DIR/defaults"/*.sh
  for script in "$PROFILE_DIR/defaults"/*.sh; do
    if [ "$DRY_RUN" = true ]; then
      echo "[DRY RUN] Would run: bash $script"
    else
      bash "$script"
    fi
  done
}

# install_vscode_extensions
# Installs VS Code extensions listed in profile-specific files.
# Respects dry-run mode.
install_vscode_extensions() {
  if command -v code &> /dev/null; then
    while read -r extension; do
      if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would install VS Code extension: $extension"
      else
        code --install-extension "$extension"
      fi
    done < "$PROFILE_DIR/vscode-extensions/extensions.txt"
  else
    echo "VS Code CLI not found. Please install manually."
  fi
}

# install_mas_apps
# Installs Mac App Store apps using mas CLI for the current profile.
# Respects dry-run mode.
install_mas_apps() {
  if mas account &> /dev/null; then
    if [ "$DRY_RUN" = true ]; then
      echo "[DRY RUN] Would run: mas install 1440147259 (AdGuard for Safari)"
    else
      mas install 1440147259 # AdGuard for Safari
    fi
  else
    echo "[WARN] Mac App Store not signed in. Skipping mas installs."
  fi
}