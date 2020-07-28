#!/bin/bash
VERS="@VERSION@"
#
# $XDG_CONFIG_HOME should be mapped to $HOME/.config
# $XDG_DATA_HOME should be mapped to $HOME/.local/share
# some users may have modified it to a custom location so honor that
#

# https://github.com/graysky2/profile-cleaner

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

#
# read in config file
#

config="$XDG_CONFIG_HOME/profile-cleaner.conf"

if [[ -f $config ]]; then
  . $config
else
  echo "#" > $config
  echo "# $HOME/.config/profile-cleaner.conf" >> $config
  echo "#" >> $config
  echo >> $config
  echo "# Define the background of your terminal theme here." >> $config
  echo "# A setting of "dark" will produce colors that nicely contrast a dark background." >> $config
  echo "# A setting of "light" will produce colors that nicely contrast a light background." >> $config
  echo "COLORS=dark" >> $config
  echo "#COLORS=light" >> $config
fi

#
# if users screws up syntax, default to dark
#

[[ -z "$COLORS" ]] && COLORS="dark"
[[ "$COLORS" = "dark" ]] && export BLD="\e[01m" \
  RED="\e[01;31m" \
  GRN="\e[01;32m" \
  YLW="\e[01;33m" \
  NRM="\e[00m"
[[ "$COLORS" = "light" ]] && export BLD="\e[01m" \
  RED="\e[00;31m" \
  GRN="\e[00;32m" \
  YLW="\e[00;34m" \
  NRM="\e[00m"

echo -e "${RED}profile-cleaner v$VERS${NRM}"
echo

dep_check()
{
  #
  # Although the package manager should handle these deps
  # this function is a sanity check for users.
  #

  command -v bc >/dev/null 2>&1 || {
  echo "I require bc but it's not installed. Aborting." >&2
  exit 1; }
  command -v find >/dev/null 2>&1 || {
  echo "I require find but it's not installed. Aborting." >&2
  exit 1; }
  #command -v parallel >/dev/null 2>&1 || {
  #echo "I require parallel but it's not installed. Aborting." >&2
  #exit 1; }
  command -v sqlite3 >/dev/null 2>&1 || {
  echo "I require sqlite3 but it's not installed. Aborting." >&2
  exit 1; }
  command -v xargs >/dev/null 2>&1 || {
  echo "I require xargs but it's not installed. Aborting." >&2
  exit 1; }
}

do_clean()
{
  echo -en "${GRN} Cleaning${NRM} ${1##*/}"
  bsize=$(du -b "$1" | cut -f 1)

  sqlite3 "$1" vacuum
  sqlite3 "$1" reindex

  asize=$(du -b "$1" | cut -f 1)
  dsize=$(echo "scale=2; ($bsize-$asize)/1048576" | bc)
  echo -e "$(tput cr)$(tput cuf 46) ${GRN}done${NRM}  -${YLW}${dsize}${NRM} Mbytes"
}

do_clean_parallel()
{
  [[ ${#toclean[@]} -eq 0 ]] && cleanedsize=0 && return 1
  bsize=$(du -b -c "${toclean[@]}" | tail -n 1 | cut -f 1)

  do_clean "${toclean[@]}"

  asize=$(du -b -c "${toclean[@]}" | tail -n 1 | cut -f 1)
  cleanedsize=$(echo "scale=2; ($bsize-$asize)/1048576" | bc)
}

find_dbs()
{
  #
  # fill to clean array by looking for SQLite files in each input directory
  #

  toclean=()
  while read i; do
    toclean+=("${i}")
  done < <( find -L "$@" -maxdepth 2 -type f -not -name '*.sqlite-wal' -print0 2>/dev/null | xargs -0 file -e ascii | sed -n -e "s/:.*SQLite.*//p" )
}

do_chromebased()
{
  [[ -h "$prepath" ]] && profilepath=$(readlink $prepath) ||
    profilepath="$prepath"
  [[ ! -d "$profilepath" ]] &&
    echo -e ${RED}"Error: no profile directory for $name found.${NRM}" &&
    exit 1
  echo -e " ${YLW}Cleaning profile for $name${NRM}"
  find_dbs "$profilepath"
  do_clean_parallel
  echo
  echo -e " ${BLD}Profile(s) for $name reduced by ${YLW}${cleanedsize}${NRM} ${BLD}Mbytes.${NRM}"
}

do_xulbased()
{
  if [[ -h "$prepath" ]]; then
    profilepath=$(readlink $prepath)
  else
    profilepath="$prepath"
  fi

  if [[ ! -d "$profilepath" ]]; then
    echo -e ${RED}"Error: cannot locate $profilepath${NRM}"
    echo -e ${BLD}"This is the default path for $name and where $0 expects to find it.${NRM}"
    exit 1
  fi

  [[ ! -f $profilepath/profiles.ini ]] &&
    echo -e ${RED}"Error: cannot locate $profilepath/profiles.ini to determine names of profiles for $name.${NRM}" &&
    exit 1

  #
  # build an array correcting for rel and abs paths therein
  # while read will read line-by-line and will tolerate spaces
  # whereas a for loop will not
  #

  index=0
  while read line; do
    if [[ ! -d "$profilepath/$line" ]]; then
      finalArr[index]="$line"
    else
      finalArr[index]="$profilepath/$line"
    fi
    index=$index+1
  done < <(grep '[P,p]'ath "$profilepath/profiles.ini" | sed -e 's/[P,p]ath=//' -e 's/\r//' )

  echo -e " ${YLW}Cleaning profile for $name${NRM}"
  find_dbs "${finalArr[@]}"
  do_clean_parallel
  echo
  echo -e " ${BLD}Profile(s) for $name reduced by ${YLW}${cleanedsize}${NRM} ${BLD}Mbytes.${NRM}"
}

do_dbbased()
{
  [[ -h "$prepath" ]] &&
    profilepath=$(readlink $prepath) || profilepath="$prepath"
  [[ ! -d "$profilepath" ]] &&
    echo -e ${RED}"Error: no profile directory for $name found.${NRM}" &&
    exit 1
  echo -e " ${YLW}Cleaning profile for $name${NRM}"
  find_dbs "${profilepath}"
  do_clean_parallel
  echo
  echo -e " ${BLD}Profile(s) for $name reduced by ${YLW}${cleanedsize}${NRM} ${BLD}Mbytes.${NRM}"
}

do_paths()
{
  profilepaths=()
  for profilepath in "$@"; do
    [[ -d "$profilepath" ]] && profilepaths+=("$profilepath")
  done
  find_dbs "${profilepaths[@]}"
  do_clean_parallel
  echo
  echo -e " ${BLD}Profile(s) for $name reduced by ${YLW}${cleanedsize}${NRM} ${BLD}Mbytes.${NRM}"
}

export -f do_clean
dep_check
GREP_OPTIONS=

case "$1" in
  C|c)
    name="chromium" ; export name
    prepath="$XDG_CONFIG_HOME"/$name
    do_chromebased
    exit 0
    ;;
  CB|cb)
    name="chromium-beta" ; export name
    prepath="$XDG_CONFIG_HOME"/$name
    do_chromebased
    exit 0
    ;;
  CD|cd)
    name="chromium-dev" ; export name
    prepath="$XDG_CONFIG_HOME"/$name
    do_chromebased
    exit 0
    ;;
  GC|gc)
    name="google-chrome" ; export name
    prepath="$XDG_CONFIG_HOME"/$name
    do_chromebased
    exit 0
    ;;
  GCB|gcb)
    name="google-chrome-beta" ; export name
    prepath="$XDG_CONFIG_HOME"/$name
    do_chromebased
    exit 0
    ;;
  GCD|gcd|GCU|gcu)
    name="google-chrome-unstable" ; export name
    prepath="$XDG_CONFIG_HOME"/$name
    do_chromebased
    exit 0
    ;;
  PM|pm)
    name="palemoon"; export name
    prepath=$HOME/.moonchild\ productions/pale\ moon
    do_xulbased
    exit 0
    ;;
  F|f)
    name="firefox"; export name
    prepath=$HOME/.mozilla/$name
    do_xulbased
    exit 0
    ;;
  CK|ck)
    name="conkeror"; export name
    prepath=$HOME/.conkeror.mozdev.org/$name
    do_xulbased
    exit 0
    ;;
  H|h)
    name="aurora"; export name
    prepath=$HOME/.mozilla/aurora
    do_xulbased
    exit 0
    ;;
  S|s)
    name="seamonkey"; export name
    prepath=$HOME/.mozilla/$name
    do_xulbased
    exit 0
    ;;
  T|t)
    name="thunderbird"; export name
    prepath=$HOME/.$name
    do_xulbased
    exit 0
    ;;
  I|i)
    name="icecat"; export name
    prepath=$HOME/.mozilla/$name
    do_xulbased
    exit 0
    ;;
  ID|id)
    name="icedove"; export name
    prepath=$HOME/.$name
    do_xulbased
    exit 0
    ;;
  TO|to)
    name="torbrowser"; export name
    prepath=$HOME/.$name/profile

    #
    # AUR packages for tor-browser customize this for some reason so check for
    # all in a silly for loop this is a shitty solution if users have more than
    # 1 language of tor-browser installed
    #

    for lang in de en es fr it ru; do
      [[ ! -d "$prepath" ]] &&
      prepath="$HOME/.tor-browser-$lang/INSTALL/Data/profile"
    done
    do_dbbased
    exit 0
    ;;
  M|m)
    name="midori"; export name
    prepath="$XDG_CONFIG_HOME"/$name
    do_dbbased
    exit 0
    ;;
  N|n)
    name="newsbeuter"; export name
    prepath="$XDG_DATA_HOME/$name"

    #
    # gentoo uses a path for the db that differs from Arch so try both
    #

    [[ ! -d "$prepath" ]] && prepath="$HOME/.$name"
    do_dbbased
    exit 0
    ;;
  Q|q)
    name="qupzilla"; export name
    prepath=$HOME/.$name/profiles
    do_dbbased
    exit 0
    ;;
  P|p)
    name="paths"; export name
    shift
    do_paths "$@"
    exit 0
    ;;
  *)
    echo -e " ${BLD}$0 ${NRM}${GRN}{browser abbreviation}${NRM}"
    echo
    echo -e "   ${BLD}c) ${GRN}c${NRM}${BLD}hromium${NRM}"
    echo -e "  ${BLD}cb) ${GRN}c${NRM}${BLD}hromium${NRM}-${GRN}b${NRM}${BLD}eta${RNM}"
    echo -e "  ${BLD}cd) ${GRN}c${NRM}${BLD}hromium${NRM}-${GRN}d${NRM}${BLD}ev${RNM}"
    echo -e "  ${BLD}ck) ${GRN}c${NRM}${BLD}on${GRN}k${NRM}${BLD}eror${NRM}"
    echo -e "   ${BLD}f) ${GRN}f${NRM}${BLD}irefox${NRM}"
    echo -e "  ${BLD}gc) ${GRN}g${NRM}${BLD}oogle-${GRN}c${NRM}${BLD}hrome${NRM}"
    echo -e " ${BLD}gcb) ${GRN}g${NRM}${BLD}oogle-${GRN}c${NRM}${BLD}hrome-${GRN}b${NRM}${BLD}eta${NRM}"
    echo -e " ${BLD}gcu) ${GRN}g${NRM}${BLD}oogle-${GRN}c${NRM}${BLD}hrome-${GRN}u${NRM}${BLD}nstable${NRM}"
    echo -e "   ${BLD}h) ${GRN}h${NRM}${BLD}eftig's aurora${NRM}"
    echo -e "   ${BLD}i) ${GRN}i${NRM}${BLD}cecat${NRM}"
    echo -e "  ${BLD}id) ${GRN}i${NRM}${BLD}ce${GRN}d${NRM}${BLD}ove${NRM}"
    echo -e "   ${BLD}m) ${GRN}m${NRM}${BLD}idori${NRM}"
    echo -e "   ${BLD}n) ${GRN}n${NRM}${BLD}ewsbeuter${NRM}"
    echo -e "   ${BLD}t) ${GRN}t${NRM}${BLD}hunderbird${NRM}"
    echo -e "  ${BLD}to) ${GRN}to${NRM}${BLD}rbrowser${NRM}"
    echo -e "   ${BLD}q) ${GRN}q${NRM}${BLD}upZilla${NRM}"
    echo -e "   ${BLD}s) ${GRN}s${NRM}${BLD}eamonkey${NRM}"
    echo -e "  ${BLD}pm) ${GRN}p${NRM}${BLD}ale${GRN}m${NRM}${BLD}oon${NRM}"
    echo -e "   ${BLD}p) ${GRN}p${NRM}${BLD}aths${NRM}"
    exit 0
    ;;
esac