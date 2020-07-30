#!/bin/sh

brew install pyenv;
pyenv install 3.8.5;
pyenv global 3.8.5;

# Pip packages

pip3 install awscli awslogs;