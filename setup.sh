#!/bin/bash
# macOS Host and Dev Setup Script
#
# Usage: ./setup.sh [--profile=host|dev] [--dry-run]
#
# - Installs Homebrew packages, links dotfiles, applies macOS defaults,
#   installs VS Code extensions, and Mac App Store apps based on the selected profile.
# - Profile-specific files are stored under ./profiles/{profile-name}/.
# - If --dry-run is specified, actions are printed but not executed.


SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

PROFILE="host"
for arg in "$@"; do
  case $arg in
    --profile=*)
      PROFILE="${arg#*=}"
      ;;
    --dry-run)
      DRY_RUN=true
      ;;
  esac
done
PROFILE_DIR="$SCRIPT_DIR/profiles/$PROFILE"
if [ ! -d "$PROFILE_DIR" ]; then
  echo "[ERROR] Invalid profile: $PROFILE"
  exit 1
fi
set -e

# Enable logging with timestamp
LOGFILE="$SCRIPT_DIR/setup.log"
exec > >(tee -a "$LOGFILE") 2>&1

# Initialize dry-run flag
: "${DRY_RUN:=false}"
if [ "$DRY_RUN" = true ]; then
  echo "[INFO] Running in dry-run mode."
fi

# Check if user has sudo privileges
if ! sudo -n true 2>/dev/null; then
  echo "[WARN] Sudo privileges required. Please run 'sudo -v' first."
  exit 1
fi

# Import functions from functions.sh
. "$SCRIPT_DIR/functions.sh"

# Run setup steps with clear user feedback
echo "[INFO] Starting Homebrew package installation..."
install_homebrew_packages

echo "[INFO] Linking dotfiles..."
link_dotfiles

if [ "$PROFILE" = "host" ]; then
  echo "[INFO] Updating LaTeX packages..."
  update_latex_packages
fi

echo "[INFO] Applying macOS defaults..."
apply_macos_defaults

echo "[INFO] Installing VS Code extensions..."
install_vscode_extensions

echo "[INFO] Installing Mac App Store apps..."
install_mas_apps

echo "[INFO] Setup complete."