# .files

Keeping track of dot files for easy computer configuration

## Steps to bootstrap a new Mac

1. Install Apple's Command Line Tools, which are prerequisites for Git and Homebrew.

```zsh
xcode-select --install
```

1. Clone repo into new hidden directory.

```zsh
# Use SSH (if set up)...
git clone git@github.com:edouardmisset/dotfiles.git ~/.dotfiles

# ...or use HTTPS and switch remotes later.
git clone https://github.com/edouardmisset/dotfiles.git ~/.dotfiles
```

1. Create symlinks, install Homebrew, packages and other software with the
   `install` script.

```zsh
cd ~/.dotfiles && ./install
```

The `install` script is plain `zsh` with no third-party dependencies. It is
**idempotent** — safe to run as many times as you like; it only changes what is
out of date.

## How `install` works

Running `./install`:

1. **Cleans** broken symlinks it manages.
2. **Links** every entry in [`links.conf`](links.conf) into place
   (`source target [force]`, one per line). Parent directories are created as
   needed; an existing real file/directory is left untouched unless the line is
   marked `force`.
3. **Creates** required directories (e.g. `~/Projects`).
4. **Runs** the setup scripts: `setup_homebrew.zsh` (installs Homebrew and runs
   `brew bundle` against the [`Brewfile`](Brewfile)), `setup_zsh.zsh` (makes the
   Homebrew `zsh` the default shell) and `setup_node.zsh`.

To add a new symlink, add a line to [`links.conf`](links.conf) and re-run
`./install`.

### Shell layout

- [`zshenv`](zshenv) — environment variables and `PATH` (sourced by every shell).
- [`zshrc`](zshrc) — interactive setup: zinit plugins (turbo-loaded), completion,
  history, Starship prompt.
- [`zsh/aliases.zsh`](zsh/aliases.zsh) — all aliases, sourced from `zshrc`.
- [`zsh/functions/autoload`](zsh/functions/autoload) — autoloaded shell functions.

## TODO List

- Terminal Preferences
- Dock Preferences
- Mission Control Preferences (don't rearrange spaces)
- Finder Show Path Bar
- Git (config and SSH)
- Turn off Spotlight shortcut to switch to Alfred's

- Learn how to use [`defaults`](https://macos-defaults.com/#%F0%9F%99%8B-what-s-a-defaults-command) to record and restore System Preferences and other macOS configurations.
- Make a checklist of steps to decommission your computer before wiping your hard drive.
- Create a [bootable USB installer for macOS](https://support.apple.com/en-us/HT201372).
- Find inspiration and examples in other Dotfiles repositories at [dotfiles.github.io](https://dotfiles.github.io/).

## Credit

[fireship.io](https://fireship.io/ 'Build and ship 🔥 your app ⚡ faster') & [Patrick McDonald](https://github.com/eieioxyz)

See the [github repo](https://github.com/eieioxyz/Beyond-Dotfiles-in-100-Seconds)

Watch the [video collaboration](https://youtu.be/r_MpUP6aKiQ 'Dotfiles in 100
Seconds on YouTube') between [fireship.io](https://fireship.io/ 'Build and ship
🔥 your app ⚡ faster') and [eieio.xyz](http://dotfiles.eieio.xyz 'Dotfiles from
Start to Finish-ish'). And don't forget to
[subscribe](https://fireship.page.link/youtube 'Fireship YouTube Channel') while
you're there!

Then, go **_way_** beyond 100 seconds by taking the full course on Udemy, [**_Dotfiles from Start to Finish-ish_**](https://www.udemy.com/course/dotfiles-from-start-to-finish-ish/?referralCode=445BE0B541C48FE85276 'Learn Dotfiles from Start to Finish-ish on Udemy') (aka "Dotiles in 15240 Seconds and Growing"). Keep an eye on [Twitter](https://twitter.com/EIEIOxyz '@EIEIOxyz') and [YouTube](https://www.youtube.com/channel/UCcZZOzRKMbql7IEL0midfgQ 'EIEIO YouTube Channel') for updates to the course.
