This repository tries to keep track of AsteroidOS unofficial watchfaces.
Watchface creation in QtQuick is really easy!
You can learn how to make your own by following the [Watchface Creation](https://asteroidos.org/wiki/watchfaces-creation/) Guide.
The creators of the below listed watchfaces are happy to answer your questions and you are free to use their contributions as base for your own work.
Feel free to pull request your work here and if it suits the graphic guidelines of AsteroidOS, it can eventually be merged into the default set of watchfaces shipped with asteroid-launcher.


### Install selected or all watchfaces

- Open a terminal and clone this unofficial-watchfaces repo to a new subfolder from your current location.\
`git clone https://github.com/AsteroidOS/unofficial-watchfaces`
- Cd into unofficial-watchfaces folder.\
`cd unofficial-watchfaces/`
- Connect your AsteroidOS Watch, configured to either ADB Mode (ADB transfer) or Developer Mode (SCP transfer) in Settings -> USB.
- Start `./watchface` to use SCP commands or `./watchface -a` for ADB commands.
- You can also use `./watchface --help` to get a list of available options.
- Select a single watchface to deploy to the watch with its given number or copy multiple watchfaces at once
- The first selected watchface (if more than one is selected) will be activated

Note that restarting the ceres session might be necessary when new fonts were installed along with the new watchfaces, so the script automatically restarts the ceres session after deploying one or more watchfaces.
Restarting the ceres session might break things like Always On Mode or the battery display for the remaining uptime. Reboot the watch in that case.
You may [reboot the watch](https://asteroidos.org/wiki/useful-commands/#restart) manually, or you may use the `--boot` option of `watchface`.

### `watchface` summary
If invoked without arguments, the `watchface` command will start a text menu (using [`dialog`](https://invisible-island.net/dialog/) if available, otherwise using [`whiptail`](https://en.wikibooks.org/wiki/Bash_Shell_Scripting/Whiptail)).  A GUI based menu (using [`zenity`](https://help.gnome.org/users/zenity/stable/) is also available using the `-g` option.
```
watchface v1.2
watchface [option] [command...]
Utility functions for AsteroidOS watchfaces.  By default, uses "SSH Mode"
over ssh, but can also use "ADB Mode" using ADB.

Available options:
-h or --help            print this help screen and quit
-a or --adb             use ADB command to communicate with watch
-b or --boot            reboot watch after deploying multiple watchfaces
-c or --circlewall WP   set the wallpaper for circular watchface thumbnail to the named file (WP)
-e or --every           select every watchface (deploy only)
-g or --gui             use the GTK+ gui
-p or --port            specify an IP port to use for ssh and scp commands
-q or --qemu            communicate with QEMU emulated watch (same as -r localhost -p 2222 )
-r or --remote          specify the remote (watch)  name or address for ssh and scp commands
-t or --transport       when used win ADB mode, specifies the transport id
-w or --wall WP         set the wallpaper for deploy or test to the named file (WP)
-v or --verbose         print verbose messages (useful for debugging)

Available commands:
update          use git to update your local copy of the unoffical-watchfaces repository
version         display the version of this program and exit
deploy WF       push the named watchface to the watch and activate it
deployall       deploy all watchfaces
clone WF NEWWF  clone the named watchface WF to new watchface NEWWF
test WF         test the named watchface on the computer using qmlscene
raw QMLFILE     test a raw QML file without the standard directory structure
```

### Cloning a watchface
Cloning a watchface can be done either via either of the two gui options mentioned above or by the command line argument listed above. 

The script will search for the source watchface in the current working directory first, and then in the script's directory. The cloned watchface will always be created in the current working directory.

Example:
```
./watchface clone decimal-time mister-snerd
```
This will clone the `decimal-time` watchface into a new watchface named `mister-snerd` and make the appropriate substitutions within paths and qml files.  You can now make changes to your new `mister-snerd` and make it your own.

See the [Watchface Creation](https://asteroidos.org/wiki/watchfaces-creation/) Guide for more details.

### Testing a watchface
Testing a watchface can be done either via either of the two gui options mentioned above or by the command line argument listed above.

The script will automatically search for watchfaces in the current working directory first, and then in the script's directory. This allows you to work on watchfaces in any location.

Example:
```
./watchface test decimal-time
```
This will start up a qmlscene tester for the named watch (`decimal-time` in this case) and allow you to see it operating or observe the effects of changes you make.  There are some limitations to the existing test script.  See the Watchface Creation [section on using the test script](https://asteroidos.org/wiki/watchfaces-creation/#scriptfeatures) for details.

### Testing a raw QML file
You can also test a standalone QML file that doesn't follow the standard watchface directory structure using the `raw` command. This is useful for quick prototyping or testing QML files directly.

Example:
```
./watchface raw my-watchface.qml
```
This will test the QML file directly without requiring the `usr/share/asteroid-launcher/watchfaces/` directory structure. If you have custom fonts, place them in a `fonts/` subdirectory next to your QML file.

### Following great community contributions are available ###

| Round Display | Square Display | Watchface Title | Creator |
|---|---|---|---|
| ![thumbnail](.thumbnails/analog-asteroid-logo-round.webp) |![thumbnail](.thumbnails/analog-asteroid-logo.webp) | [analog-asteroid-logo](analog-asteroid-logo/usr/share/asteroid-launcher/watchfaces/analog-asteroid-logo.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-boombox-round.webp) |![thumbnail](.thumbnails/analog-boombox.webp) | [analog-boombox](analog-boombox/usr/share/asteroid-launcher/watchfaces/analog-boombox.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-classy-roman-round.webp) | ![thumbnail](.thumbnails/analog-classy-roman.webp) | [analog-classy-roman](analog-classy-roman/usr/share/asteroid-launcher/watchfaces/analog-classy-roman.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-commander-round.webp) | ![thumbnail](.thumbnails/analog-commander.webp) | [analog-commander](analog-commander/usr/share/asteroid-launcher/watchfaces/analog-commander.qml) | [IvoHulsman](https://github.com/ivohulsman) |
| ![thumbnail](.thumbnails/analog-goldie-round.webp) |![thumbnail](.thumbnails/analog-goldie.webp) | [analog-goldie](analog-goldie/usr/share/asteroid-launcher/watchfaces/analog-goldie.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-duppy-vintage-round.webp) |![thumbnail](.thumbnails/analog-duppy-vintage.webp) | [analog-duppy-vintage](analog-duppy-vintage/usr/share/asteroid-launcher/watchfaces/analog-duppy-vintage.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-halloween-round.webp) | ![thumbnail](.thumbnails/analog-halloween.webp) | [analog-halloween](analog-halloween/usr/share/asteroid-launcher/watchfaces/analog-halloween.qml) | [beroset](https://github.com/beroset) |
| ![thumbnail](.thumbnails/analog-modern-steel-round.webp) | ![thumbnail](.thumbnails/analog-modern-steel.webp) | [analog-modern-steel](analog-modern-steel/usr/share/asteroid-launcher/watchfaces/analog-modern-steel.qml) | [CosmosDev](https://github.com/CosmosDev) |
| ![thumbnail](.thumbnails/analog-moega-sushimaster-round.webp) | ![thumbnail](.thumbnails/analog-moega-sushimaster.webp) | [analog-moega-sushimaster](analog-moega-sushimaster/usr/share/asteroid-launcher/watchfaces/analog-moega-sushimaster.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-neon-diver-round.webp) | ![thumbnail](.thumbnails/analog-neon-diver.webp) | [analog-neon-diver](analog-neon-diver/usr/share/asteroid-launcher/watchfaces/analog-neon-diver.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-nort-round.webp) | ![thumbnail](.thumbnails/analog-nort.webp) | [analog-nort](analog-nort/usr/share/asteroid-launcher/watchfaces/analog-nort.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-nihil-dark-round.webp) | ![thumbnail](.thumbnails/analog-nihil-dark.webp) | [analog-nihil-dark](analog-nihil-dark/usr/share/asteroid-launcher/watchfaces/analog-nihil-dark.qml) | [turretkeeper](https://github.com/turretkeeper) |
| ![thumbnail](.thumbnails/analog-nihil-light-round.webp) | ![thumbnail](.thumbnails/analog-nihil-light.webp) | [analog-nihil-light](analog-nihil-dark/usr/share/asteroid-launcher/watchfaces/analog-nihil-light.qml) | [turretkeeper](https://github.com/turretkeeper) |
| ![thumbnail](.thumbnails/analog-precision-round.webp) |![thumbnail](.thumbnails/analog-precision.webp) | [analog-precision](analog-precision/usr/share/asteroid-launcher/watchfaces/analog-precision.qml) | [Mario Kicherer](mailto:dev@kicherer.org) |
| ![thumbnail](.thumbnails/analog-railway-round.webp) |![thumbnail](.thumbnails/analog-railway.webp) | [analog-railway](analog-railway/usr/share/asteroid-launcher/watchfaces/analog-railway.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-red-handed-round.webp) | ![thumbnail](.thumbnails/analog-red-handed.webp) | [analog-red-handed](analog-red-handed/usr/share/asteroid-launcher/watchfaces/analog-red-handed.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-rings-round.webp) |![thumbnail](.thumbnails/analog-rings.webp) | [analog-rings](analog-rings/usr/share/asteroid-launcher/watchfaces/analog-rings.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-scientific-round.webp) |![thumbnail](.thumbnails/analog-scientific.webp) | [analog-scientific](analog-scientific/usr/share/asteroid-launcher/watchfaces/analog-scientific.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-silly-walks-round.webp) | ![thumbnail](.thumbnails/analog-silly-walks.webp) | [analog-silly-walks](analog-silly-walks/usr/share/asteroid-launcher/watchfaces/analog-silly-walks.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-silver-swerver-round.webp) | ![thumbnail](.thumbnails/analog-silver-swerver.webp) | [analog-silver-swerver](analog-silver-swerver/usr/share/asteroid-launcher/watchfaces/analog-silver-swerver.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-square-round.webp) | ![thumbnail](.thumbnails/analog-square.webp) | [analog-square](analog-square/usr/share/asteroid-launcher/watchfaces/analog-square.qml) | [beroset](https://github.com/beroset) |
| ![thumbnail](.thumbnails/analog-tactical-round.webp) |![thumbnail](.thumbnails/analog-tactical.webp) | [analog-tactical](analog-tactical/usr/share/asteroid-launcher/watchfaces/analog-tactical.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-weather-glow-round.webp) | ![thumbnail](.thumbnails/analog-weather-glow.webp) | [analog-weather-glow](analog-weather-glow/usr/share/asteroid-launcher/watchfaces/analog-weather-glow.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/analog-words-80s-round.webp) | ![thumbnail](.thumbnails/analog-words-80s.webp) | [analog-words-80s](analog-words-80s/usr/share/asteroid-launcher/watchfaces/analog-words-80s.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/arc-round.webp) |![thumbnail](.thumbnails/arc.webp) | [arc (multiple)](arc/usr/share/asteroid-launcher/watchfaces/) | [jgibbon](https://github.com/jgibbon) |
| ![thumbnail](.thumbnails/binary-digital-round.webp) |![thumbnail](.thumbnails/binary-digital.webp) | [binary-digital](binary-digital/usr/share/asteroid-launcher/watchfaces/binary-digital.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/binary-lcd-round.webp) |![thumbnail](.thumbnails/binary-lcd.webp) | [binary-lcd](binary-lcd/usr/share/asteroid-launcher/watchfaces/binary-lcd.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/bold-hour-bebas-v2-round.webp) |![thumbnail](.thumbnails/bold-hour-bebas-v2.webp) | [bold-hour-bebas-v2](bold-hour-bebas-v2/usr/share/asteroid-launcher/watchfaces/bold-hour-bebas-v2.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/clean-bars-round.webp) |![thumbnail](.thumbnails/clean-bars.webp) | [clean-bars](clean-bars/usr/share/asteroid-launcher/watchfaces/clean-bars.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/day-clock-24h-round.webp) |![thumbnail](.thumbnails/day-clock-24h.webp) | [day-clock-24h](day-clock-24h/usr/share/asteroid-launcher/watchfaces/day-clock-24h.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/decimal-time-round.webp) | ![thumbnail](.thumbnails/decimal-time.webp) | [decimal-time](decimal-time/usr/share/asteroid-launcher/watchfaces/decimal-time.qml) | [beroset](https://github.com/beroset) |
| ![thumbnail](.thumbnails/digital-alternative-default-mosen-round.webp) |![thumbnail](.thumbnails/digital-alternative-default-mosen.webp) | [digital-alternative-default-mosen](digital-alternative-default-mosen/usr/share/asteroid-launcher/watchfaces/digital-alternative-default-mosen.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/digital-alternative-mosen-round.webp) |![thumbnail](.thumbnails/digital-alternative-mosen.webp) | [digital-alternative-mosen](digital-alternative-mosen/usr/share/asteroid-launcher/watchfaces/digital-alternative-mosen.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/digital-charge-state-round.webp) | ![thumbnail](.thumbnails/digital-charge-state.webp) | [digital-charge-state](digital-charge-state/usr/share/asteroid-launcher/watchfaces/digital-charge-state.qml) | [beroset](https://github.com/beroset) |
| ![thumbnail](.thumbnails/digital-fat-bwoy-slim-round.webp) |![thumbnail](.thumbnails/digital-fat-bwoy-slim.webp) | [digital-fat-bwoy-slim](digital-fat-bwoy-slim/usr/share/asteroid-launcher/watchfaces/digital-fat-bwoy-slim.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/digital-koiyu-round.webp) |![thumbnail](.thumbnails/digital-koiyu.webp) | [digital-koiyu](digital-koiyu/usr/share/asteroid-launcher/watchfaces/digital-koiyu.qml) | [dodoradio](https://dodorad.io) |
| ![thumbnail](.thumbnails/digital-led-round.webp) |![thumbnail](.thumbnails/digital-led.webp) | [digital-led](digital-led/usr/share/asteroid-launcher/watchfaces/digital-led.qml) | [ncaat](https://github.com/ncaat) |
| ![thumbnail](.thumbnails/digital-namazu-no-henka-round.webp) |![thumbnail](.thumbnails/digital-namazu-no-henka.webp) | [digital-namazu-no-henka](digital-namazu-no-henka/usr/share/asteroid-launcher/watchfaces/digital-namazu-no-henka.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/digital-night-stand-outfit-round.webp) |![thumbnail](.thumbnails/digital-night-stand-outfit.webp) | [digital-night-stand-outfit](digital-night-stand-outfit/usr/share/asteroid-launcher/watchfaces/digital-night-stand-outfit.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/digital-noto-seconds-round.webp) |![thumbnail](.thumbnails/digital-noto-seconds.webp) | [digital-noto-seconds](digital-noto-seconds/usr/share/asteroid-launcher/watchfaces/digital-noto-seconds.qml) | [Commenter25](https://github.com/Commenter25) |
| ![thumbnail](.thumbnails/digital-numeral-unity-round.webp) |![thumbnail](.thumbnails/digital-numeral-unity.webp) | [digital-numeral-unity](digital-numeral-unity/usr/share/asteroid-launcher/watchfaces/digital-numeral-unity.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/digital-pop-space-round.webp) |![thumbnail](.thumbnails/digital-pop-space.webp) | [digital-pop-space](digital-pop-space/usr/share/asteroid-launcher/watchfaces/digital-pop-space.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/digital-random-color-pop-round.webp) |![thumbnail](.thumbnails/digital-random-color-pop.webp) | [digital-random-color-pop](digital-random-color-pop/usr/share/asteroid-launcher/watchfaces/digital-random-color-pop.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/digital-shifted-round.webp) |![thumbnail](.thumbnails/digital-shifted.webp) | [digital-shifted](digital-shifted/usr/share/asteroid-launcher/watchfaces/digital-shifted.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/digital-thoreau-simplify-round.webp) |![thumbnail](.thumbnails/digital-thoreau-simplify.webp) | [digital-thoreau-simplify](digital-thoreau-simplify/usr/share/asteroid-launcher/watchfaces/digital-thoreau-simplify.qml) | [beroset](https://github.com/beroset) |
| ![thumbnail](.thumbnails/digital-weather-hrm-steps-round.webp) |![thumbnail](.thumbnails/digital-weather-hrm-steps.webp) | [digital-weather-hrm-steps](digital-weather-hrm-steps/usr/share/asteroid-launcher/watchfaces/digital-weather-hrm-steps.qml) | [jmlich](https://github.com/jmlich) |
| ![thumbnail](.thumbnails/greenium-round.webp) |![thumbnail](.thumbnails/greenium.webp) | [greenium](greenium/usr/share/asteroid-launcher/watchfaces/greenium.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/humongous-round.webp) |![thumbnail](.thumbnails/humongous.webp) | [humongous](humongous/usr/share/asteroid-launcher/watchfaces/humongous.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/karlos-matrix-round.webp) |![thumbnail](.thumbnails/karlos-matrix.webp) | [karlos-matrix](karlos-matrix/usr/share/asteroid-launcher/watchfaces/karlos-matrix.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/kitt-round.webp) |![thumbnail](.thumbnails/kitt.webp) | [kitt](kitt/usr/share/asteroid-launcher/watchfaces/kitt.qml) | [jgibbon](https://github.com/jgibbon) |
| ![thumbnail](.thumbnails/logo-45degree-round.webp) |![thumbnail](.thumbnails/logo-45degree.webp) | [logo-45degree](logo-45degree/usr/share/asteroid-launcher/watchfaces/logo-45degree.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/motivational-quotes-round.webp) |![thumbnail](.thumbnails/motivational-quotes.webp) | [motivational-quotes](motivational-quotes/usr/share/asteroid-launcher/watchfaces/motivational-quotes.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/nixie-delight-round.webp) | ![thumbnail](.thumbnails/nixie-delight.webp) | [nixie-delight](nixie-delight/usr/share/asteroid-launcher/watchfaces/nixie-delight.qml) | [beroset](https://github.com/beroset) |
| ![thumbnail](.thumbnails/numerals-duo-neon-green-round.webp) |![thumbnail](.thumbnails/numerals-duo-neon-green.webp) | [numerals-duo-neon-green](numerals-duo-neon-green/usr/share/asteroid-launcher/watchfaces/numerals-duo-neon-green.qml) | [MagneFire](https://github.com/MagneFire) |
| ![thumbnail](.thumbnails/orbiting-asteroids-round.webp) |![thumbnail](.thumbnails/orbiting-asteroids.webp) | [orbiting-asteroids](orbiting-asteroids/usr/share/asteroid-launcher/watchfaces/orbiting-asteroids.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/prominent-seconds-round.webp) |![thumbnail](.thumbnails/prominent-seconds.webp) | [prominent-seconds](prominent-seconds/usr/share/asteroid-launcher/watchfaces/prominent-seconds.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/pulsedot-round.webp) | ![thumbnail](.thumbnails/pulsedot.webp) | [pulsedot](pulsedot/usr/share/asteroid-launcher/watchfaces/pulsedot.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/rainbow-uprising-round.webp) |![thumbnail](.thumbnails/rainbow-uprising.webp) | [rainbow-uprising](rainbow-uprising/usr/share/asteroid-launcher/watchfaces/rainbow-uprising.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/resistance-is-futile-round.webp) |![thumbnail](.thumbnails/resistance-is-futile.webp) | [resistance-is-futile](resistance-is-futile/usr/share/asteroid-launcher/watchfaces/resistance-is-futile.qml) | [beroset](https://github.com/beroset) |
| ![thumbnail](.thumbnails/retro-lcd-round.webp) |![thumbnail](.thumbnails/retro-lcd.webp) | [retro-lcd](retro-lcd/usr/share/asteroid-launcher/watchfaces/retro-lcd.qml) | [Huntereb](mailto:Huntereb@lewd.pics), [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/sporty-round-round.webp) |![thumbnail](.thumbnails/sporty-round.webp) | [sporty-round](sporty-round/usr/share/asteroid-launcher/watchfaces/sporty-round.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/sporty-round-v2-round.webp) |![thumbnail](.thumbnails/sporty-round-v2.webp) | [sporty-round-v2](sporty-round-v2/usr/share/asteroid-launcher/watchfaces/sporty-round-v2.qml) | [eLtMosen](https://github.com/eLtMosen) |
| ![thumbnail](.thumbnails/words-worte-palabras-mots-opensans-round.webp) |![thumbnail](.thumbnails/words-worte-palabras-mots-opensans.webp) | [words-worte-palabras-mots-opensans](words-worte-palabras-mots-opensans/usr/share/asteroid-launcher/watchfaces/words-worte-palabras-mots-opensans.qml) | Aleksi Suomalainen, Florent Revest, Sylvia van Os, Timo Könnecke, Oliver Geneser |

### Licenses ###

| Watchface - File | License |
| --- | --- |
| analog-boombox - [Dangrek](analog-boombox/usr/share/fonts/Dangrek-Regular.ttf) | The font "Dangrek" is licensed under SIL Open Font License and was created by [The Dangrek Project Authors](https://github.com/danhhong/Dangrek). [license](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL) |
| digital-pop-space - [Baloo Tammudu 2](digital-pop-space/usr/share/fonts/Baloo_Tammudu_2_Regular.ttf) | The font "Baloo Tammudu 2" is licensed under SIL Open Font License and was created by [Ek type](https://fonts.google.com/?query=Ek%20Type). [license](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL) |
| digital-pop-space - [Outrun future](digital-pop-space/usr/share/fonts/Outrun-future.otf) | The font "Outrun future" is licensed under a custom license that allows "Anyone may use these fonts for non-profit projects". It was created by [Press Gang Studios](https://comicfontsby.tehandeh.com/). [license](https://www.1001fonts.com/future-font.html#license) |
| analog-duppy-vintage - [Kumar One](analog-duppy-vintage/usr/share/fonts/KumarOne-Regular.otf) [Kumar One Outline](analog-duppy-vintage/usr/share/fonts/KumarOneOutline-Regular.otf) | The font "Kumar One" is licensed under SIL Open Font License and was created by [Indian Type Foundry](https://fonts.google.com/?query=Indian+Type+Foundry). [license](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)|
| analog-duppy-vintage - [Varieté - Regular](analog-duppy-vintage/usr/share/fonts/Varieté_Regular.ttf) | The font "Varieté" is licensed under SIL Open Font License and was created by [Peter Wiegel](https://de.fonts2u.com/variete.schriftart). [license](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)|
| digital-fat-bwoy-slim - [NASDAQER](digital-fat-bwoy-slim/usr/share/fonts/NASDAQER_Fett.ttf) | The font "NASDAQER" is licensed under CC BY 3.0 License and was created by Gustavo Paz L. [license](https://creativecommons.org/licenses/by/3.0/) |
| analog-neon-diver - [Bebas Neue](analog-neon-diver/usr/share/fonts/BebasNeueBold.ttf) | The font "Bebas Neue" is licensed under SIL Open Font License and was created by [Dharma Type](http://www.dharmatype.com/). [license](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL) |
| analog-classy-roman - [Roboto Condensed - Bold](analog-classy-roman/usr/share/fonts/RobotoCondensed-Bold.ttf) | The font "Roboto Condensed" is licensed under Apache License, Version 2.0 and was created by [Christian Robertson](https://fonts.google.com/?query=Christian+Robertson). [license](https://www.apache.org/licenses/LICENSE-2.0.html)|
| analog-commander - [Michroma - Regular](analog-commander/usr/share/fonts/Michroma-Regular.ttf) | The font "Michroma - Regular" is licensed under SIL Open Font License and was created by [Vernon Adams](https://fonts.google.com/?query=Vernon+Adams). [license](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)|
| analog-commander - [Teko](analog-commander/usr/share/fonts/) | The font "Teko" is licensed under SIL Open Font License and was created by [Indian Type Foundry](https://fonts.google.com/?query=Indian%20Type%20Foundry). [license](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)|
| analog-modern-steel - [Michroma - Regular](analog-modern-steel/usr/share/fonts/Michroma.ttf) | The font "Michroma" is licensed under SIL Open Font License and was created by [Vernon Adams](https://github.com/vernnobile). [license](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)|
| analog-silly-walks - [Varieté - Regular](analog-silly-walks/usr/share/fonts/Varieté_Regular.ttf) | The font "Varieté" is licensed under SIL Open Font License and was created by [Peter Wiegel](https://de.fonts2u.com/variete.schriftart). [license](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)|
| analog-red-handed - [PTSans - Bold](analog-red-handed/usr/share/fonts/PTSans-Bold.ttf) | The font "PTSans" is licensed under SIL Open Font License and was created by [Alexandra Korolkova, Olga Umpeleva and Vladimir Yefimov and released by ParaType](https://fonts.google.com/specimen/PT+Sans). [license](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)|
| analog-red-handed - [Russo One - Regular](analog-red-handed/usr/share/fonts/RussoOne-Regular.ttf) | The font "Russo One" is licensed under SIL Open Font License and was created by [Jovanny Lemonad](https://fonts.google.com/specimen/Russo+One). [license](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)|
| pulsedot - [Source Sans Pro - Semibold](pulsedot/usr/share/fonts/SourceSansPro-Semibold.ttf) [Source Sans Pro - Regular](pulsedot/usr/share/fonts/SourceSansPro-Regular.ttf)| The font "Source Sans Pro" is licensed under SIL Open Font License and was created by [Paul D Hunt](https://fonts.google.com/specimen/Source+Sans+Pro). [license](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)|
| retro-lcd - [Digital-7 (Mono)](retro-lcd/usr/share/fonts/digital-7%20(mono).ttf) | The font "Digital-7" is freeware for home use and was created by [Sizenko Alexander](http://www.styleseven.com). |
| binary-lcd - [Digital-7 (Mono)](binary-lcd/usr/share/fonts/digital-7%20(mono).ttf) | The font "Digital-7" is freeware for home use and was created by [Sizenko Alexander](http://www.styleseven.com). |
| analog-rings [SlimSans](analog-rings/usr/share/fonts/SlimSans.ttf) | The font "SlimSans" was created by [Manfred Klein](https://web.archive.org/web/20170823125251/http://manfred-klein.ina-mar.com). Manfred’s fonts are free for private and charity use. They are even free for commercial use – but if there’s any profit, pls make a donation to organizations like [Doctors Without Borders](http://www.doctorswithoutborders.org/)|
| day-clock-24h - [Vollkorn-Regular](day-clock-24h/usr/share/fonts/Vollkorn-Regular.ttf) | The font "Vollkorn" is licensed under SIL Open Font License and was created by [Friedrich Althausen](http://www.vollkorn-typeface.com). [license](day-clock-24h/usr/share/fonts/OFL.txt)|
| digital-charge-state - [Titillium-Bold](digital-charge-state/usr/share/fonts/Titillium-Bold.otf), [Titillium-Light](digital-charge-state/usr/share/fonts/Titillium-Light.otf) | The font "Titillium" is licensed under SIL Open Font License and was created at the [Accademia di Belle Arti di Urbino](http://www.campivisivi.net/titillium/). [license](digital-charge-state/usr/share/fonts/OFL.txt)|
| sporty-round, sporty-round-v2 [SlimSans](sporty-round/usr/share/fonts/SlimSans.ttf) | The font "SlimSans" was created by [Manfred Klein](https://web.archive.org/web/20170823125251/http://manfred-klein.ina-mar.com). Manfred’s fonts are free for private and charity use. They are even free for commercial use – but if there’s any profit, pls make a donation to organizations like [Doctors Without Borders](http://www.doctorswithoutborders.org/)|
| numerals-duo-neon-green - [Assets](numerals-duo-neon-green/usr/share/asteroid-launcher/watchfaces-img/) | Assets are originally adapted from [mo_sandhu](https://amazfitwatchfaces.com/gts/view/4290) |
| orbiting-asteroids - [Blue Marble](orbiting-asteroids/usr/share/asteroid-launcher/wallpapers/nasa-blue-marble.jpg) | The image "Blue Marble", Eastern Hemisphere March 2014, Photo from NASA Goddard Space Flight Center is available under creative commons license |
| binary-digital - [Simpleness](binary-digital/usr/share/fonts/Simpleness.otf) | The font "Simpleness" is licensed under SIL Open Font License and was created by [Valentin Francois](http://valentinfrancois.fr/). [license](binary-digital/usr/share/fonts/License.pdf)|
| humongous - [Item-Black](humongous/usr/share/fonts/ITEMBL__.TTF) | The font "Item" is Public Domain and was created by [Bojmic Interpro](https://www.fontzillion.com/fonts/bojmic-interpro/item).|
| logo-45degree - [Sinner](logo-45degree/usr/share/fonts/SINNER__.TTF) | The font "Sinner" is freeware for personal, non-commercial use only and was created by [Helge Barske](http://www.barske.com/). [license-info](https://www.fontzillion.com/fonts/helge-barske/sinner)|
| motivational-quotes - [Lobster](motivational-quotes/usr/share/fonts/Lobster.otf) | The font "Lobster" is licensed under SIL Open Font License and was created by [Impallari Type](http://www.impallari.com/lobster). [license](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)|
| nixie-delight - [Feronia](nixie-delight/usr/share/fonts/Feronia.ttf) | The font "Feronia" is licensed under GPL with font exception and SIL Open Font License and was created by [Peter Wiegel](http://www.peter-wiegel.de/Feronia.html). [license](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)|
| clean-bars, decimal-time - [CPMono_v07](clean-bars/usr/share/fonts/) | The font "CPMono_v07" is licensed under CC-BY-3.0 and was created by [Tino Meinert, Liquitype](http://liquitype.fr/index.html). [license](clean-bars/usr/share/fonts/CC_License.txt)|
| analog-scientific - [Reglo](analog-scientific/usr/share/fonts/) | The font "Reglo" is licensed under SIL Open Font License and was created by [sebsan, Sebastien Sanfilippo](https://github.com/sebsan/Reglo). [license](https://github.com/sebsan/Reglo/blob/master/OFL.txt)|
| karlos-matrix - [Elektra SH](karlos-matrix/usr/share/fonts/) | According to fonts4free.net, the font "Elektra SH" is free for both personel and commercial usages and was created by [Samy Halim](https://www.fontshop.com/designers/samy-halim). [license](http://www.fonts4free.net/elektra-sh-font.html)|
| alternative-digital-mosen - [GeneraleMono](alternative-digital-mosen/usr/share/fonts/) | The font "GeneraleMono" is licensed under SIL Open Font License and was created by [ARIEL MARTÍN PÉREZ](http://www.arielgraphisme.com). [license](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)|
| digital-weather-hrm-steps - [Cantarell](digital-weather-hrm-steps/usr/share/fonts/) | The font "Cantarell" is license under SIL Open Font License and was created by Dave Crossland. [license](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)|
