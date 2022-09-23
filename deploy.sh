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
-w or --wall    push the named picture to the watch as wallpaper
-q or --qemu    communicates with QEMU emulated watch (same as -r localhost -p 2222 )

EOF
}

function doWatchCommand {
    local user="$1"
    local cmd=$2
    case ${user} in 
        root)
            if [ "$ADB" == true ] ; then
                adb shell "${cmd}"
            else
                ssh -p "${WATCHPORT}" -t root@"${WATCHADDR}" ${cmd}
            fi
            ;;
        ceres)
            if [ "$ADB" == true ] ; then
                printf -v cmd %q "${cmd}"
                adb shell "su -l -c ${cmd} ceres"
            else
                ssh -p "${WATCHPORT}" -t ceres@"${WATCHADDR}" ${cmd}
            fi
            ;;
        *)
            echo "Error: unknown watch user ${user}"
            ;;
    esac
}

function setDconf {
    local dconfsetting="$1"
    local filename="$2"
    doWatchCommand "ceres" "dconf write ${dconfsetting} '\"file://${filename}\"'"
}

function pushFiles {
    local sourcedir="$1"
    local destdir="$2"
    if [ "$ADB" = true ] ; then
        adb push ${sourcedir} "${destdir}"
    else
        scp -P"${WATCHPORT}" -r ${sourcedir} "root@${WATCHADDR}:${destdir}"
    fi
}

function pushWatchface {
    pushFiles "${opt}"'/usr/share/*' "/usr/share/"
}

function pushWallpaper {
    local wallpaper="$1"
    local wp_path="/usr/share/asteroid-launcher/wallpapers/full"
    pushFiles "${wallpaper}" "${wp_path}/${wallpaper}"
    setDconf "/desktop/asteroid/background-filename" "${wp_path}/${wallpaper}"
}

function restartCeres {
    doWatchCommand "root" "systemctl restart user@1000"
}

function activateWatchface {
    setDconf "/desktop/asteroid/watchface" "/usr/share/asteroid-launcher/watchfaces/${opt::-1}.qml"
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

wallpaper=""

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
        -w|--wall)
            wallpaper="$2"
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
if [ -f "${wallpaper}" ] ; then
    pushWallpaper "${wallpaper}"
fi

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
