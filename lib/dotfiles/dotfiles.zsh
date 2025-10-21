# all of our zsh files
typeset -U config_files
config_files=($DOTFILES/lib/**/*.zsh)

# load the path files
for file in ${(M)config_files:#*/path.zsh}
do
  source $file
done

# load everything else, excluding path.zsh, omz.zsh, and dotfiles.zsh
for file in ${config_files}
do
  # Skip path files (already loaded above)
  [[ $file == */path.zsh ]] && continue
  # Skip omz files (handled separately)
  [[ $file == */omz.zsh ]] && continue
  # Skip this file to prevent circular dependency
  [[ $file == */dotfiles.zsh ]] && continue
  
  source $file
done

unset config_files