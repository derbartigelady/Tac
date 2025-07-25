Hello, here is a Garmin watchface for Outdoor/Mil use.

![Tac_preview](https://github.com/user-attachments/assets/27d953a2-85c1-4aee-87ba-af0ec6cae8e4)

Newer Versions may differ from screenshot.

Right now, this devices are supported (some devices share the same folder - dont worry): 

- D2 Mach 1 Pro (..\Releases\epix2pro51mm)
- Enduro 2 (..\Releases\fenix7x)
- Enduro 3 (..\Releases\enduro3)
- Epix Pro (Gen 2) 51mm (..\Releases\epix2pro51mm)
- Forerunner 265 (..\Releases\fr265)
- Fenix 7 / Quatix 7 (..\Releases\fenix7)
- Fenix 7 Pro (..\Releases\fenix7pro)
- Fenix 7 Pro - Solar Edition (no Wi-Fi) (..\Releases\fenix7pronowifi)
- Fenix 7S (..\Releases\fenix7s)
- Fenix 7S Pro (..\Releases\fenix7pro)
- Fenix 7X (..\Releases\fenix7x)
- Fenix 7X Pro (..\Releases\fenix7xpro)
- Fenix 7X Pro - Solar Edition (no Wi-Fi) (..\Releases\fenix7xpronowifi)
- Fenix 8 43mm (..\Releases\fenix843mm)
- Fenix 8 47mm / 51mm (..\Releases\fenix847mm)
- Fenix 8 Solar 47mm (..\Releases\fenix8solar47mm)
- Fenix 8 Solar 51mm (..\Releases\fenix851mm)
- Quatix 7X Solar (..\Releases\fenix7x)
- Tactix 7 (..\Releases\fenix7x)
- Tactix 7 – AMOLED Edition (..\Releases\epix2pro51mm)
- Tactix 8 47mm / 51mm (..\Releases\fenix847mm)
- Tactix 8 Solar 51mm (..\Releases\fenix851mm)
- Venu 2 (..\Releases\venu2)
- Venu 2 Plus (..\Releases\venu2plus)
- Venu 2 S (..\Releases\venu2s)
- Venu 3 (..\Releases\venu3)
- Venu 3 S (..\Releases\venu3s)

More Devices can be added - just ask here:
- https://www.reddit.com/r/bundeswehr/comments/1lek5bx/garmin_watchface/
- garmin-app-dev.chevron998@passmail.net

--------------------------------

This is a learning project. It is not up to programmer standards!

There are no options/settings in this watchface.

Layout positions are based on percentages. Graphics are embedded as .svg (vector graphics). 
The main problems when adding new models are different font interpretations per model.

--------------------------------

Instructions for easy installation of the watchface:

- Click on the Folder "Releases", select your watchmodel, click on the file “Tac.prg”.
- Click on the download icon (“Download Raw File”) at the top right next to “Raw”. Save the file on the PC.
- Then connect the watch to the PC via USB cable, wait briefly until it is recognized as a drive and then open the path in Explorer: ...\yourWatchModel\Internal Storage\GARMIN\Apps. Copy the file here.
- Disconnect the watch from the PC. The watch takes a moment to recognize and process the file and applies the file directly as a watchface.

If you have a different model, the path may be named after a different model. I could not test with other models, only simulate, feel free to report which model you are using and if the watchface runs.

--------------------------------

Anleitung zur einfachen Installation der Watchface:

- Klickt oben auf den Ordner "Releases", wählt euer Uhrmodell, klick auf die Datei "Tac.prg".
- Klick rechts oben neben "Raw" auf das Download Icon ("Download Raw File"). Die Datei auf dem PC speichern. 
- Dann Uhr mit dem PC via USB Kabel verbinden, kurz warten bis sie als Laufwerk erkannt wird und dann den Pfad im Explorer öffnen: ...\DeinUhrenModell\Internal Storage\GARMIN\Apps. Datei hierhin kopieren. 
- Uhr vom PC trennen. Die Uhr braucht einen Augenblick bis die Datei erkannt und verarbeitet wurde und wendet die Datei direkt als Watchface an.

Wenn man ein anderes Modell hat, kann der Pfad nach einem anderen Modell benannt sein. Ich konnte nicht mit anderen Modellen testen, nur simulieren, berichtet gerne welches Modell ihr nutzt und ob die Watchface läuft.

--------------------------------

Software used:
- Visual Studio Code (https://code.visualstudio.com/)
- Garmin SDK (https://developer.garmin.com/connect-iq/overview/)
- Adobe Illustrator or Inkscape (https://inkscape.org/) for graphics editing
- Microsoft Copilot (https://copilot.microsoft.com/chats/)

Tutorials:
- https://medium.com/@ericbt/design-your-own-garmin-watch-face-21d004d38f99
- https://krasimirtsonev.com/blog/article/how-to-create-garmin-fenix-8-watch-face


Helpful:
- Garmin Forum
- Youtube

--------------------------------

This "manual" code is not compatible to watchface builders like:
- https://garmin.watchfacebuilder.com/
- https://facemaker.pt/

--------------------------------

Privacy

- this watchface does not connect to the internet or garmin- / google- / apple-servers
- this watchface is able to run offline (messages and bluetooth notification wont be avalible)
- the only external data in use are positioning services like GPS, GLONASS, Galileo,... included in the Watch OS
- best deal for privacy/battery/features: Enduro 3, its a Fenix 8 without microphone or speaker (only vibration) 
- If you dont want to use Garmin apps on your android phone for private reasons, you can use https://gadgetbridge.org/. It can be used without internet connection an still provide connection to the watch and show your daily parameters.
