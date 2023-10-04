# .files

Keeping track of dot files for easy computer configuration

## Steps to bootstrap a new Linux

1. Clone repo into new hidden directory.

```zsh
# Use SSH (if set up)...
git clone git@github.com:edouardmisset/dotfiles.git ~/.dotfiles

# ...or use HTTPS and switch remotes later.
git clone https://github.com/edouardmisset/dotfiles.git ~/.dotfiles
```

2. Create symlinks in the Home directory to the real files in the repo.

```zsh
# There are better and less manual ways to do this;
# investigate install scripts and bootstrapping tools.

ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.p10k.zsh ~/.p10k.zsh
```

## TODO List

- Automatically install all the packages install via `apt-get`
- Organize these growing steps into multiple script files.
- Automate symlinking and run script files with a bootstrapping tool like [Dotbot](https://github.com/anishathalye/dotbot).
- Make a checklist of steps to decommission your computer before wiping your hard drive.
- Create a bootable USB installer for Linux.
- Integrate other cloud services into your Dotfiles process (Dropbox, Google Drive, etc.).
- Find inspiration and examples in other Dotfiles repositories at [dotfiles.github.io](https://dotfiles.github.io/).
- And last, but hopefully not least, [**take my course, _Dotfiles from Start to Finish-ish_**](https://www.udemy.com/course/dotfiles-from-start-to-finish-ish/?referralCode=445BE0B541C48FE85276 'Learn Dotfiles from Start to Finish-ish on Udemy')!

## Credit

[fireship.io](https://fireship.io/ 'Build and ship 🔥 your app ⚡ faster') & [Patrick McDonald](https://github.com/eieioxyz)

See the [github repo](https://github.com/eieioxyz/Beyond-Dotfiles-in-100-Seconds)

Watch the [video collaboration](https://youtu.be/r_MpUP6aKiQ 'Dotfiles in 100
Seconds on YouTube') between [fireship.io](https://fireship.io/ 'Build and ship
🔥 your app ⚡ faster') and [eieio.xyz](http://dotfiles.eieio.xyz 'Dotfiles from
Start to Finish-ish').

Then, go **_way_** beyond 100 seconds by taking the full course on Udemy, [**_Dotfiles from Start to Finish-ish_**](https://www.udemy.com/course/dotfiles-from-start-to-finish-ish/?referralCode=445BE0B541C48FE85276 'Learn Dotfiles from Start to Finish-ish on Udemy') (aka "Dotiles in 15240 Seconds and Growing").
