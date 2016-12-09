#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

# git pull origin master; # I'll be pulling in manually anyway so this is redundant

function doIt() {
	# Install oh-my-zsh if not installed already
	if [ -d "~/.oh-my-zsh" ]; then
	  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	fi
	# Install the powerline fonts
	git submodule init
	git submodule update
	(cd fonts && ./install.sh)
	# Install personal overrides to oh-my-zsh
	rsync -avh --no-perms ./ohmyzsh_custom/ ~/.oh-my-zsh/

	# Install all the other stuff
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude ".macos" \
		--exclude "fonts" \
		--exclude "ohmyzsh_custom" \
		--exclude "brew.sh" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		-avh --no-perms . ~;
	# Read the new configurations
	if [ "$$" == "-zsh" -o "$$" == "zsh" ]; then
		source ~/.zshrc;
	elif [ "$$" == "-bash" -o "$$" == "bash" ]; then
		source ~/.bash_profile;
	fi;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
