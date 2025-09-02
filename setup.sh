#!/bin/bash
# macOS Host and Dev Setup Script
#
# Usage:
#   ./setup.sh [--profile=host|dev] [--dry-run] [--no-upgrade] [--brew-cleanup] [--skip-texlive]
#
# Notes:
# - Logs to setup.log (appends).
# - Requires prior 'sudo -v' so steps won't prompt mid-run.
# - Upgrades are allowed by default (matches your current tolerance).
#   Use --no-upgrade to avoid Homebrew upgrades on a given run.

set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

PROFILE="host"
DRY_RUN=false
NO_UPGRADE=false
BREW_CLEANUP=false
SKIP_TEXLIVE=false

for arg in "$@"; do
  case "$arg" in
    --profile=*)      PROFILE="${arg#*=}";;
    --dry-run)        DRY_RUN=true;;
    --no-upgrade)     NO_UPGRADE=true;;
    --brew-cleanup)   BREW_CLEANUP=true;;
    --skip-texlive)   SKIP_TEXLIVE=true;;
    *)                echo "[WARN] Ignoring unknown flag: $arg";;
  esac
done

PROFILE_DIR="$SCRIPT_DIR/profiles/$PROFILE"
if [ ! -d "$PROFILE_DIR" ]; then
  echo "[ERROR] Invalid profile: $PROFILE"
  exit 1
fi

# Enable logging
LOGFILE="$SCRIPT_DIR/setup.log"
exec > >(tee -a "$LOGFILE") 2>&1

if [ "$DRY_RUN" = true ]; then
  echo "[INFO] Running in dry-run mode."
fi

# Sudo pre-check
if ! sudo -n true 2>/dev/null; then
  echo "[WARN] Sudo privileges required. Please run 'sudo -v' first."
  exit 1
fi

# Import functions
. "$SCRIPT_DIR/functions.sh"

# Export flags for sourced functions
export DRY_RUN NO_UPGRADE BREW_CLEANUP SKIP_TEXLIVE PROFILE_DIR

# Optional preflight (informational)
preflight_checks || true

echo "[INFO] Starting Homebrew package installation..."
install_homebrew_packages

echo "[INFO] Linking dotfiles..."
link_dotfiles

if [ "$PROFILE" = "host" ]; then
  echo "[INFO] Updating LaTeX packages (host profile)..."
  update_latex_packages
fi

echo "[INFO] Applying macOS defaults..."
apply_macos_defaults

echo "[INFO] Installing VS Code extensions..."
install_vscode_extensions

echo "[INFO] Installing Mac App Store apps..."
install_mas_apps

echo "[INFO] Setup complete."
