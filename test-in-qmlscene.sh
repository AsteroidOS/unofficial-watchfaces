#!/bin/bash

PS3='
Test a watchface in qmlscene.
Enter watchface number.
Quit with any other input -> '

unset options i
while IFS= read -r -d $'\0' f; do
  options[i++]="$f"
done < <(find */ -maxdepth 0 -type d -print0 )

if [ "$1" = "-use12h" ]
then
    use12=true
else
    use12=false
fi

if ! command -v qmlscene &> /dev/null
then
    echo "
$(tput setaf 1)qmlscene could not be found. Install qtcreator from your package manager.$(tput sgr0)"
    exit
else
    echo "
$(tput setaf 2)qmlscene found, proceeding...$(tput sgr0)
         "
fi

select opt in "${options[@]}"

do
    if [ -e ${opt::-1}/usr/share/ ]
    then
        sed "s#@@@12h@@@#$use12#g" <watchfaceloader.qmltemplate >/tmp/loader.qmltemplate
        sed -i "s#@@@watchface@@@#share/asteroid-launcher/watchfaces/${opt::-1}.qml#g" /tmp/loader.qmltemplate
        if [[ -f "background.jpg" ]]
        then
            echo "$(tput setaf 2)Custom background.jpg found and is used as background.$(tput sgr0)"
            cp background.jpg /tmp/background.jpg
        else
            echo "$(tput setaf 214)Downloading background.jpg from AsteroidOS Github repo. Place a background.jpg to this folder to avoid download.$(tput sgr0)"
            wget -O /tmp/background.jpg https://raw.githubusercontent.com/AsteroidOS/asteroid-wallpapers/master/480x480/000-flatmesh.jpg
        fi
        cp -R ${opt::-1}/usr/share/ /tmp/
        qmlscene --scaling --resize-to-root /tmp/loader.qmltemplate
        echo "$(tput setaf 2)Removing temporary files.$(tput sgr0)"
        rm /tmp/loader.qmltemplate
        rm /tmp/background.jpg
        rm -R /tmp/share/
    else
      break
    fi
done
