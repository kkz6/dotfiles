# kk's macOS dotfiles

Current setup for Apple's built-in Terminal: Catppuccin Mocha colors, MesloLGS NF 14pt, a single-line Powerlevel10k prompt, command suggestions, syntax highlighting, completion menus, and history search. No additional terminal application is needed. Apple Terminal does not support smooth cursor animation.

## Install or apply changes

```sh
git clone https://github.com/kkz6/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles
./install.sh
exec zsh
```

Requires macOS, Git, curl, and Python 3. `install.sh` downloads missing Oh My Zsh components and four Meslo font styles from their official repositories, then links the managed configuration files. Existing files are backed up under `~/.dotfiles-backup-<timestamp>-<unique suffix>/` before replacement. Existing links to this repository are left intact on subsequent runs.

The installer merges the Mocha profile into Terminal preferences, preserves other profiles, and sets Mocha as the default and startup profile. Quit Terminal before applying profile changes, then reopen it. In an existing window, select **Shell → New Window → Mocha** or choose Mocha under **Terminal → Settings → Profiles**. If icons look incorrect, select **MesloLGS NF Regular**, 14pt, in that profile's font settings. Fonts are installed in `~/Library/Fonts`.

To apply only the shell files using already installed dependencies:

```sh
./install.sh --skip-deps --skip-terminal
```

## Managed files

| Repository file | Installed location |
| --- | --- |
| `.zshrc` | `~/.zshrc` |
| `.zprofile` | `~/.zprofile` |
| `.p10k.zsh` | `~/.p10k.zsh` |
| `config/mise/config.toml` | `~/.config/mise/config.toml` |
| `settings/Mocha.terminal` | Mocha profile in Apple Terminal preferences |

Edit these files in the repository; symlinked shell files use the changes on the next shell startup. Reapply `install.sh` for Terminal profile changes. Place private values and machine-specific overrides in `~/.zshrc.local`, which is ignored by Git. Do not commit credentials, shell history, or complete Terminal preference exports.

Homebrew is detected for either Apple Silicon or Intel. If mise is installed, its shell integration loads automatically. The mise configuration retains Go set to `latest`; install it with `mise install` when needed. Herd PHP and Node integration loads only when Herd is present. Homebrew, mise, and Herd are not installed by this script.

Right arrow accepts suggestions; Tab completes; Up/Down searches history using the text already typed; `z <folder-name>` jumps to previously visited folders.

## Installing kk CLI

CLI source and build changes belong in [kk-cli](https://github.com/kkz6/kk-cli). Its local Makefile installs to `~/.local/bin`, creating the directory and using executable permissions without sudo. This directory is included in the managed shell PATH.

```sh
cd ~/projects/kk-cli
make install
kk version
```

The CLI Makefile change must also be committed in that repository to reproduce it on another machine. The binary is not stored in dotfiles.

## Restore

Choose the backup directory printed by the installer. For each file to restore, remove only its managed symlink and move the matching backed-up file back to its original path. For example:

```sh
# Replace BACKUP with the actual backup directory.
rm ~/.zshrc
mv BACKUP/.zshrc ~/.zshrc
```

With Terminal quit, restore its preferences if a `Terminal.plist` backup exists:

```sh
defaults import com.apple.Terminal BACKUP/Terminal.plist
```

## Legacy files

The earlier Bash prompts, aliases, editor settings, `brew.sh`, `macOS.sh`, `sublime.sh`, and `vscode.sh` remain for reference. The current installer does not execute them. They describe the older setup and may install additional applications or change unrelated settings.

## License

See `LICENSE-MIT.txt` for the inherited MIT license and attribution.
