#!/bin/sh
#
# Dev Tools
#
# Common development things that i need

# Check for Pow
if ! [[ -a ~/.pow ]]
then
  echo "  Installing Pow for you."
  curl get.pow.cx | sh
fi

# Check for Heroku
if test ! $(which heroku)
then
  echo "  Installing Heroku Toolbelt for you."
  curl toolbelt.heroku.com/install.sh | sh
fi

exit 0
