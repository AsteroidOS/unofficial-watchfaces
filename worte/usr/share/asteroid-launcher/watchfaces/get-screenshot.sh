#!/bin/zsh
scp * root@192.168.2.15:/usr/share/asteroid-launcher/watchfaces/
ssh -t root@192.168.2.15 "date +%T -s "07:14:22" && systemctl restart user@1000"
ssh -t root@192.168.2.15 "screenshottool /home/ceres/screenshot.jpg 10"
scp root@192.168.2.15:/home/ceres/screenshot.jpg screenshot.jpg
feh --geometry 1120x1120 --zoom 300 screenshot.jpg