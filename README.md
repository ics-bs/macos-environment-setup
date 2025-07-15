## macOS Environment Setup

### Contents
- Profiles for Host and Dev
- Dotfiles per profile
- Homebrew package lists per profile
- VS Code extensions file per profile
- macOS defaults per profile
- Single setup script with dry-run and logging

### Installation

1. **Install Homebrew manually if missing:**
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

2. **(Host Profile Only) Sign into iCloud and Mac App Store.**

    This is required for installing App Store applications via `mas`.

3. **Pre-authorize and Prepare Setup Script**

    Before running the setup, ensure permissions and sudo session:

    ```bash
    chmod +x setup.sh
    sudo -v
    ```

    - `chmod +x` ensures the setup script is executable.
    - `sudo -v` pre-authorizes system-level changes, avoiding interruptions during setup.

4. **Choose a Profile and Run Setup:**

    For Host configuration:
    ```bash
    ./setup.sh --profile=host
    ```

    For Development configuration:
    ```bash
    ./setup.sh --profile=dev
    ```

5. **(Optional) Dry Run Check:**
    ```bash
    ./setup.sh --profile=host --dry-run
    ```
    This simulates all actions without applying changes.

### Folder Structure
- `profiles/host/` → Host-specific Brewfile, dotfiles, defaults, single VS Code extensions file
- `profiles/dev/` → Development-specific Brewfile, dotfiles, defaults, single VS Code extensions file
- `functions.sh` → Core setup logic shared across profiles
- `setup.sh` → Entry script handling profile selection and execution flow

### Notes
- If no `--profile` argument is provided, `host` is used by default.
