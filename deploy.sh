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
          if [ -e $opt/usr/share/ ]
              then
                scp -r $opt/usr/share/* root@192.168.2.15:/usr/share/
              fi
       done
      fi
    if [ -e $opt/usr/share/asteroid-launcher/watchfaces ]
      then
        scp -r $opt/usr/share/* root@192.168.2.15:/usr/share/
      else
        break
      fi
done
