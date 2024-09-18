## To export cinnamon settings:

`dconf dump /org/cinnamon/ > cinnamon_dconf`

## To load cinnamon settings:

`dconf load /org/cinnamon/ < cinnamon_dconf`

## To export your keyboard shortcut keys:

`dconf dump /org/cinnamon/desktop/keybindings/ > keybindings-backup.dconf`


## To later import it on another device:

`dconf load /org/cinnamon/desktop/keybindings/ < cinnamon-keybindings.dconf`

## Set default gnome-screenshot destination folder:
`gsettings set org.gnome.gnome-screenshot auto-save-directory file:///home/imran/Pictures/Screenshots`