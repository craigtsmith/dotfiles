#!/bin/sh
echo "\n"
#
# Dev Tools
#
# Common development things that i need

# Check for Pow
if ! [[ -a ~/.pow ]]
then
  echo "  Installing Pow for you."
  curl get.pow.cx | sh
  echo "  ------\n"
fi

# Check for Heroku
if test ! $(which heroku)
then
  echo "  Installing Heroku Toolbelt for you."
  curl https://toolbelt.heroku.com/install.sh | sh
  echo "  ------\n"
fi

echo "------------\n"
exit 0
