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
    echo "$(tput setaf 1)qmlscene could not be found. Install qtcreator from your package manager.$(tput sgr0)"
    exit
else
    echo "$(tput setaf 2)qmlscene found, proceeding...$(tput sgr0)
         "
fi

select opt in "${options[@]}"

do
    if [ -e $opt/usr/share/ ]
    then
          sed '/Item {/a height: 640; width: 640; Image { source: "background.jpg"; width: 640; height: 640;}' <$opt/usr/share/asteroid-launcher/watchfaces/${opt::-1}.qml >$opt/usr/share/asteroid-launcher/watchfaces/${opt::-1}_scene.qml
          sed -i "/Item {/a Item { property var value: $use12; id: use12H;} Item { property var time: new Date(); id: wallClock; Timer { interval: 1000; running: true; repeat: true; onTriggered: wallClock.time = new Date(); } }" $opt/usr/share/asteroid-launcher/watchfaces/${opt::-1}_scene.qml

          if [[ -f "${opt::-1}/usr/share/asteroid-launcher/watchfaces/background.jpg" ]]
          then
              echo "$(tput setaf 2)${opt::-1}/usr/share/asteroid-launcher/watchfaces/background.jpg found and using as background.$(tput sgr0)"
              download=false
          else
              echo "$(tput setaf 214)Downloading background.jpg from AsteroidOS Github repo. Will be removed after closing qmlscene.$(tput sgr0)"
              wget -O ${opt::-1}/usr/share/asteroid-launcher/watchfaces/background.jpg https://raw.githubusercontent.com/AsteroidOS/asteroid-wallpapers/master/480x480/000-flatmesh.jpg
              download=true
          fi
          qmlscene --scaling --resize-to-root $opt/usr/share/asteroid-launcher/watchfaces/${opt::-1}_scene.qml
          if $download; then
              echo "$(tput setaf 2)Removing temporary background.jpg since it did not exist before execution of this script.$(tput sgr0)"
              rm ${opt::-1}/usr/share/asteroid-launcher/watchfaces/background.jpg
          fi
          rm $opt/usr/share/asteroid-launcher/watchfaces/${opt::-1}_scene.qml
          else
        break   
    fi
done
