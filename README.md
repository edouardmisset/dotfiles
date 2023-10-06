# .files

Keeping track of dot files for easy computer configuration

## Steps to bootstrap a new Mac

1. Install Apple's Command Line Tools, which are prerequisites for Git and Homebrew.

```zsh
xcode-select --install
```

2. Clone repo into new hidden directory.

```zsh
# Use SSH (if set up)...
git clone git@github.com:edouardmisset/dotfiles.git ~/.dotfiles

# ...or use HTTPS and switch remotes later.
git clone https://github.com/edouardmisset/dotfiles.git ~/.dotfiles
```

3. Create symlinks, install brew and other packages & software using the
   `install` script.

```zsh
~/.dotfiles/install
cd ~/.dotfiles && ./install
```

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
