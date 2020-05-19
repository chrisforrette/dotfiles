#!/bin/sh

brew install node nvm

if [ ! -d ~/.nvm ]; then
	mkdir ~/.nvm
fi
