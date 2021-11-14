#!/bin/bash
# Deploy selected Watchfaces from /unofficial-watchfaces folder
# to a connected AsteroidOS watch in Developer or ADB mode.

function showHelp {
    cat << EOF
./deploy.sh [option]
Deploy one or more watchfaces to AsteroidOS device.  By default, uses "Developer Mode"
over ssh, but can also use "ADB Mode" using ADB.

Available options:
-h or --help    prints this help screen and quits
-a or --adb     uses ADB command to communicate with watch
-p or --port    specifies a port to use for ssh and scp commands
-r or --remote  specifies the remote (watch)  name or address for ssh and scp commands
-q or --qemu    communicates with QEMU emulated watch (same as -r localhost -p 2222 )

EOF
}

function pushWatchface {
    if [ "$ADB" = true ] ; then
        adb push "$opt"/usr/share/* /usr/share/
    else
        scp -P"${WATCHPORT}" -r "$opt"/usr/share/* root@"${WATCHADDR}":/usr/share/
    fi
}

function restartCeres {
    if [ "$ADB" = true ] ; then
        adb shell systemctl restart user@1000
    else
        ssh -p "${WATCHPORT}" root@"${WATCHADDR}" -t "systemctl restart user@1000"
    fi
}

function activateWatchface {
    printf -v cmd %q "file:///usr/share/asteroid-launcher/watchfaces/${opt::-1}.qml"
    if [ "$ADB" = true ] ; then
        printf -v cmd %q "dconf write /desktop/asteroid/watchface \'${cmd}\'"
        adb shell "su ceres -c ${cmd}"
    else
        ssh -p "${WATCHPORT}" -t ceres@"${WATCHADDR}" "dconf write /desktop/asteroid/watchface \"'$cmd'\""
    fi
}

function showCommsOptions {
    if [ "$ADB" = true ] ; then
        echo "Communicating via ADB"
    else
        echo "Communicating via ssh to ${WATCHADDR}:${WATCHPORT}"
    fi
}

PS3='- Deploy watchface by entering its number - 
- Refresh list with the enter key -
- Quit with any other input -'

# These are the defaults for SSH access
WATCHPORT=22
WATCHADDR=192.168.2.15
# These are the defaults for local QEMU target
QEMUPORT=2222
QEMUADDR=localhost
# Assume no ADB unless told otherwise
ADB=false

options=("DEPLOY-ALL" */)

while [[ $# -gt 0 ]] ; do
    case $1 in 
        -a|--adb)
            ADB=true
            shift
            ;;
        -q|--qemu)
            WATCHPORT=${QEMUPORT}
            WATCHADDR=${QEMUADDR}
            shift
            ;;
        -p|--port)
            WATCHPORT="$2"
            shift
            shift
            ;;
        -r|--remote)
            WATCHADDR="$2"
            shift
            shift
            ;;
        -h|--help)
            showHelp
            exit 1
            ;;
        *)
            echo "Ignoring unknown option $1"
            shift
            ;;
    esac
done 

showCommsOptions

select opt in "${options[@]}" ; do
    if [ "${opt}" == "DEPLOY-ALL" ] ; then
        for opt in "${options[@]}" ; do
            if [ -e "$opt"/usr/share/ ] ; then
                pushWatchface
            fi
        done
        echo " "
        echo "Press 'y' to restart the ceres session on the watch."
        echo "Or get back to watchface selection with any other key press."
        read -rsn1 input
        if [ "$input" = "y" ] ; then
            restartCeres
        fi
    else
        if [ -e "$opt"/usr/share/asteroid-launcher/watchfaces ] ; then
            pushWatchface
            echo " "
            echo "Press 'y' to activate ${opt::-1} and restart the ceres session on the watch."
            echo "Back to watchface selection with any other key press."
            read -rsn1 input
            if [ "$input" = "y" ] ; then
                activateWatchface
                restartCeres
            fi
        else 
            break
        fi
    fi
done
