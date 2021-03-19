# menuz

```sh
# call specific menu
$ menuz <name>

# select menu from list
$ menuz

# edit menu file
$ menuz -e <name>

# select and edit
$ menuz -e
```

```sh
# menu file
NAME=" Example"
ITEMS=(
  [" Terminal"]="$terminal"
  [" Editor"]="$terminal $editor"
  [" Browser"]="$BROWSER"
  [" Email"]="$terminal neomutt"
  [" Chat"]="$terminal irssi"
)
```
