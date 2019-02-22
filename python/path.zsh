# Python 2

PATH="$(brew --prefix python@2)/bin:$PATH"

# Python 3

PATH="~/Library/Python/3.7/bin:$PATH"

# Python & Virtualenv

export PYTHONPATH=${PYTHONPATH}:/usr/bin
#export PIP_REQUIRE_VIRTUALENV=true
export WORKON_HOME=~/.envs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python

export PATH

source /usr/local/bin/virtualenvwrapper.sh
