#!/bin/bash
# Deploy selected Watchfaces from /unofficial-watchfaces folder
# to a connected AsteroidOS watch in Developer or ADB mode.
# Use -a for adb or no flag for scp transfer.

PS3='- Deploy watchface by entering its number - 
- Refresh list with the enter key -
- Quit with any other input -'

# These can be changed to 2222 and localhost for qemux86 target
WATCHPORT=22
WATCHADDR=192.168.2.15

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
              if [ "$1" = "-a" ]
                then
                  adb push $opt/usr/share/* /usr/share/
                else
                  echo scp -P${WATCHPORT} -r $opt/usr/share/* root@${WATCHADDR}:/usr/share/
              fi
            fi
         done
         echo " "
         echo "Press 'y' to restart the ceres session on the watch."
         echo "Or get back to watchface selection with any other key press."
         read -rsn1 input
         if [ "$input" = "y" ];
           then
             if [ "$1" = "-a" ]
               then
                 adb shell systemctl restart user@1000
               else
                 ssh -t ${WATCHROOTADDR} "systemctl restart user@1000"
             fi
         fi
      else
        if [ -e $opt/usr/share/asteroid-launcher/watchfaces ]
          then
            if [ "$1" = "-a" ]
              then
                adb push $opt/usr/share/* /usr/share/
                echo " "
                echo "Press 'y' to activate ${opt::-1} and restart the ceres session on the watch."
                echo "Back to watchface selection with any other key press."
                read -rsn1 input
                if [ "$input" = "y" ]; 
                  then
                    printf -v cmd %q "'file:///usr/share/asteroid-launcher/watchfaces/${opt::-1}.qml'"
                    printf -v cmd %q "dconf write /desktop/asteroid/watchface $cmd"
                    adb shell "su ceres -c $cmd"
                    adb shell systemctl restart user@1000
                fi
              else
                scp -P${WATCHPORT} -r $opt/usr/share/* root@${WATCHADDR}:/usr/share/
                echo " "
                echo "Press 'y' to activate ${opt::-1} and restart the ceres session on the watch."
                echo "Back to watchface selection with any other key press."
                read -rsn1 input
                if [ "$input" = "y" ]; then
                  ssh -p ${WATCHPORT} -t ceres@${WATCHADDR} "dconf write /desktop/asteroid/watchface \"'file:///usr/share/asteroid-launcher/watchfaces/${opt::-1}.qml'\""
                  ssh -p ${WATCHPORT} -t root@${WATCHADDR} "systemctl restart user@1000"
                fi
            fi
          else
            break
        fi
    fi
done



