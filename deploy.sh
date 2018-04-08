#!/bin/bash
# Deploy selected Watchfaces from /unofficial-watchfaces folder
# to a connected AsteroidOS watch in developer mode

PS3='Deploy watchface #) or quit with any other key) '

unset options i
options[i++]="DEPLOY-ALL"
while IFS= read -r -d $'\0' f
  do
    options[i++]="$f"
  done < <(find */ -maxdepth 0 -type d -print0 )

select opt in "${options[@]}"
  do
    if [ "$opt" == "DEPLOY-ALL" ]
      then
        for opt in "${options[@]}"
          do
            if [ -e $opt/usr/share/asteroid-launcher/watchfaces/ ]
              then
                scp $opt/usr/share/asteroid-launcher/watchfaces/* root@192.168.2.15:/usr/share/asteroid-launcher/watchfaces/
              fi
            if [ -e $opt/usr/share/asteroid-launcher/wallpapers/ ]
              then
                scp $opt/usr/share/asteroid-launcher/wallpapers/* root@192.168.2.15:/usr/share/asteroid-launcher/wallpapers/
              fi
            if [ -e $opt/usr/share/fonts/ ]
              then
                scp $opt/usr/share/fonts/* root@192.168.2.15:/usr/share/fonts/
            fi
       done
      fi
    if [ -e $opt/usr/share/asteroid-launcher/watchfaces/ ]
      then
        scp $opt/usr/share/asteroid-launcher/watchfaces/* root@192.168.2.15:/usr/share/asteroid-launcher/watchfaces/
      else
        break
      fi
    if [ -e $opt/usr/share/asteroid-launcher/wallpapers/ ]
      then
        scp $opt/usr/share/asteroid-launcher/wallpapers/* root@192.168.2.15:/usr/share/asteroid-launcher/wallpapers/
      fi
    if [ -e $opt/usr/share/fonts/ ]
      then
        scp $opt/usr/share/fonts/* root@192.168.2.15:/usr/share/fonts/
      fi
done
