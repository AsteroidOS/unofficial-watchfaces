#!/bin/bash

previewResolutions=( 182 160 144 128 112 )
webResolution=320
PS3='
Test a watchface in qmlscene.
Enter watchface number.
Quit with any other input -> '

unset options i
while IFS= read -r -d $'\0' f; do
  options[i++]="$f"
done < <(find */ -maxdepth 0 -type d -print0 )

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

if ! command -v mogrify &> /dev/null
then
    echo "
$(tput setaf 1)mogrify could not be found. Install mogrify (Image Magick) from your package manager.$(tput sgr0)"
    exit
else
    echo "
$(tput setaf 2)mogrify found, proceeding...$(tput sgr0)
         "
fi

select opt in "${options[@]}"

do
    if [ -e ${opt::-1}/usr/share/ ]
    then
        if [[ -f "background.jpg" ]]
        then
            echo "$(tput setaf 2)Custom background.jpg found and is used as background.$(tput sgr0)"
        else
            echo "$(tput setaf 214)Downloading background.jpg from AsteroidOS Github repo. Place a background.jpg to this folder to avoid download.$(tput sgr0)"
            wget -O  background.jpg https://raw.githubusercontent.com/AsteroidOS/asteroid-wallpapers/master/full/000-flatmesh.jpg
            cp background.jpg background-round.jpg
        fi
        qmlscene ${opt::-1} loader.qml
        if [[ -f "${opt::-1}-round.png" ]]
        then
            mogrify -resize $webResolutionx$webResolution -adaptive-sharpen 0x.4 -quality 85 -path .thumbnails -format webp ${opt::-1}-round.png
            rm ${opt::-1}-round.png
            echo "$(tput setaf 2)Round preview found and converted to webp in .thumbnails folder.$(tput sgr0)"
        fi
        if [[ -f "${opt::-1}.png" ]]
        then
            mogrify -resize $webResolutionx$webResolution -adaptive-sharpen 0x.4 -quality 85 -path .thumbnails -format webp ${opt::-1}.png
            rm ${opt::-1}.png
            echo "$(tput setaf 2)Square preview found and converted to webp in .thumbnails folder.$(tput sgr0)"
        fi
        if [[ -f "${opt::-1}-trans.png" ]]
        then
            echo "$(tput setaf 2)Transparent preview found.$(tput sgr0)"
            mv ${opt::-1}-trans.png ${opt::-1}.png
            for res in "${previewResolutions[@]}" ; do
                mogrify -resize $resx$res -adaptive-sharpen 0x.8 -quality 70 -format png -path ${opt::-1}/usr/share/asteroid-launcher/watchfaces-preview/$res ${opt::-1}.png
                echo "$res px resize done."
            done
            rm ${opt::-1}.png
            echo "$(tput setaf 2)Transparent previews generated successfully into the watchfaces-preview folder.$(tput sgr0)"
        fi
    else
      break
    fi
done
