import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.Position;
import Toybox.Sensor;
import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Math;



class TacView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
   }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onShow() as Void {
   }

function drawNorthTriangle(dc as Dc) as Void {

    var heading = Activity.getActivityInfo().currentHeading;
    if (heading == null) {
        return;
    }

    var cx = dc.getWidth() / 2;
    var cy = dc.getHeight() / 2;

    var deg = Math.toDegrees(heading);
    if (deg < 0) {
        deg += 360;
    }
    var angleDeg = Math.round(deg).toNumber(); // Jetzt garantiert Number!

    // Gradzahl im Label ausgeben
    var hdngLabel = View.findDrawableById("hdngLabel") as Text;
    hdngLabel.setText((360 - angleDeg) % 360 + "");

    // "text angle"
    var texangleLabel = View.findDrawableById("texangleLabel") as Text;
    texangleLabel.setText("° N");

    // Bogenmaß-Winkel berechnen
    var angleC = Math.toRadians(-angleDeg.toFloat());
    var degL = ((angleDeg - 4 + 360) % 360);
    var degR = ((angleDeg + 4) % 360);
    var angleL = Math.toRadians(-degL.toFloat());
    var angleR = Math.toRadians(-degR.toFloat());

    // Dreieck-Radien als Prozent vom kleineren Displaymaß
    var minDim = (dc.getWidth() < dc.getHeight() ? dc.getWidth() : dc.getHeight()).toFloat();
    var rMain = minDim * 0.45; // z.B. 45% vom kleineren Maß
    var rWing = minDim * 0.42; // z.B. 42% vom kleineren Maß

    var ptC = polarToXY(angleC, rMain, cx.toFloat(), cy.toFloat());
    var ptL = polarToXY(angleL, rWing, cx.toFloat(), cy.toFloat());
    var ptR = polarToXY(angleR, rWing, cx.toFloat(), cy.toFloat());

    // Zeichnen
    dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
    dc.fillPolygon([
        [ptC[0].toNumber(), ptC[1].toNumber()],
        [ptR[0].toNumber(), ptR[1].toNumber()],
        [ptL[0].toNumber(), ptL[1].toNumber()]
    ]);
}

function polarToXY(angle as Float, length as Float, cx as Float, cy as Float) as [Float, Float] {
    return [cx + length * Math.sin(angle), cy - length * Math.cos(angle)];
}


// "Alle anderen Dinge"--------------------------------------------------------------------------------------------------


    function onUpdate(dc as Dc) as Void {
        // Layout-Elemente aktualisieren
        View.onUpdate(dc);


        // Bluetooth-Verbindung prüfen
        var phoneConnected = Toybox.System.getDeviceSettings().phoneConnected;
        var btOn = View.findDrawableById("bt_on") as Bitmap;
        var btOff = View.findDrawableById("bt_off") as Bitmap;

        if (phoneConnected) {
            btOn.setVisible(true);
            btOff.setVisible(false);
        } else {
            btOn.setVisible(false);
            btOff.setVisible(true);
        }


        // "sec"
        var sec = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var secString = Lang.format(
            "$1$",
            [
                sec.sec.format("%02d"),
            ]
        );
        var seclabel = View.findDrawableById("secLabel") as Text;
        seclabel.setText(secString);


        // "Notifications"
        var notifications = System.getDeviceSettings().notificationCount;
        var bellOn = View.findDrawableById("icon_note_on") as Bitmap;
        var bellOff = View.findDrawableById("icon_note_off") as Bitmap;

        if (notifications > 0) {
            bellOn.setVisible(true);
            bellOff.setVisible(false);
        } else {
            bellOn.setVisible(false);
            bellOff.setVisible(true);
        }


        // "Battery"
        var battery = Toybox.System.getSystemStats().battery;
        var batteryLabel = View.findDrawableById("batteryLabel") as Text;
        batteryLabel.setText(battery.format("%d"));
       

        // "Puls"
        var heartRate = 0;
        var heartRateText = "-";
        var actInfo = Activity.getActivityInfo();
        if (actInfo != null) {
            heartRate = actInfo.currentHeartRate;    
            if (heartRate != 0 && heartRate != null) {
                heartRateText = heartRate.format("%d");
            }
        }
        var heartRateLabel = View.findDrawableById("heartRateLabel") as Text;
        heartRateLabel.setText(heartRateText);


        // "steps"
        var stepCount = Toybox.ActivityMonitor.getInfo().steps;
        var stepLabel = View.findDrawableById("stepLabel") as Text;
        stepLabel.setText(stepCount == null ? "-" : stepCount.format("%d"));


        // "Local"--------------------------------------------------------------------------------------------------


        // "Weekdays"
        var currentTime = Time.now();
        var dayofweekInfo = Gregorian.info(currentTime, Time.FORMAT_SHORT);
        var weekDays = ["Sa", "So", "Mo", "Di", "Mi", "Do", "Fr"];
        var dayofweekString = "??"; // Fallback-Wert sicherstellen
        // Falls Garmin Sonntag als 7 speichert, setzen wir ihn auf 0
        if (dayofweekInfo.day_of_week == 7) {
            dayofweekInfo.day_of_week = 0;
        }
        // Sicherheitsprüfung für den Index
        if (dayofweekInfo.day_of_week >= 0 && dayofweekInfo.day_of_week < weekDays.size()) {
            dayofweekString = weekDays[dayofweekInfo.day_of_week];
        } else {
            System.println("Warnung: Ungültiger Index für day_of_week nach Korrektur: " + dayofweekInfo.day_of_week);
        }
        // Setze den Wert ins UI-Element
        var dayofweeklabel = View.findDrawableById("dayofweekLabel") as Text;
        dayofweeklabel.setText(dayofweekString);

        
        // "day"
        var day = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dayString = Lang.format(
            "$1$",
            [
                day.day.format("%02d"),
            ]
        );
        var daylabel = View.findDrawableById("dayLabel") as Text;
        daylabel.setText(dayString);


        // "min"
        var min = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var minString = Lang.format(
            "$1$",
            [
                min.min.format("%02d"),
            ]
        );
        var minlabel = View.findDrawableById("minLabel") as Text;
        minlabel.setText(minString);


        // "month"
        var month = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var monthString = Lang.format(
            "$1$",
            [
                month.month.toLower(),
            ]
        );
        var monthlabel = View.findDrawableById("monthLabel") as Text;
        monthlabel.setText(monthString);


        // "year"
        var year = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var yearString = Lang.format(
            "$1$",
            [
                year.year.format("%d").substring(2, 4), // Nur die letzten beiden Ziffern
            ]
        );
        var yearlabel = View.findDrawableById("yearLabel") as Text;
        yearlabel.setText(yearString);


        // "UTC"--------------------------------------------------------------------------------------------------


        // "WeekdaysUTC"
        var utccurrentTime = Time.now();
        var utcdayofweekInfo = Gregorian.info(utccurrentTime, Time.FORMAT_SHORT);
        var utcweekDays = ["sa", "su", "mo", "tu", "we", "th", "fr"];
        var utcdayofweekString = "??"; // Fallback-Wert sicherstellen
        // Falls Garmin Sonntag als 7 speichert, setzen wir ihn auf 0
        if (utcdayofweekInfo.day_of_week == 7) {
            utcdayofweekInfo.day_of_week = 0;
        }
        // Sicherheitsprüfung für den Index
        if (utcdayofweekInfo.day_of_week >= 0 && utcdayofweekInfo.day_of_week < utcweekDays.size()) {
            utcdayofweekString = utcweekDays[utcdayofweekInfo.day_of_week];
        } else {
            System.println("Warnung: Ungültiger Index für day_of_week nach Korrektur: " + utcdayofweekInfo.day_of_week);
        }
        // Setze den Wert ins UI-Element
        var utcdayofweeklabel = View.findDrawableById("utcdayofweekLabel") as Text;
        utcdayofweeklabel.setText(utcdayofweekString);

        
        // "dayUTC"
        var dayutc = Time.now();
        var utcday = Gregorian.utcInfo(dayutc, Time.FORMAT_SHORT);
        var utcdayString = Lang.format(
            "$1$",
            [
                utcday.day.format("%02d"),
            ]
        );
        var utcdaylabel = View.findDrawableById("utcdayLabel") as Text;
        utcdaylabel.setText(utcdayString);


        // "minUTC"
        var minutc = Time.now();
        var utcmin = Gregorian.utcInfo(minutc, Time.FORMAT_MEDIUM);
        var utcminString = Lang.format(
            "$1$",
            [
                utcmin.min.format("%02d"),
            ]
        );
        var utcminlabel = View.findDrawableById("utcminLabel") as Text;
        utcminlabel.setText(utcminString);


        // "text Z"
        var texzLabel = View.findDrawableById("texzLabel") as Text;
        texzLabel.setText("Z");


        // "monthUTC"
        var monthutc = Time.now();
        var utcmonth = Gregorian.utcInfo(monthutc, Time.FORMAT_MEDIUM);
        var utcmonthString = Lang.format(
            "$1$",
            [
                utcmonth.month.toLower(),
            ]
        );
        var utcmonthlabel = View.findDrawableById("utcmonthLabel") as Text;
        utcmonthlabel.setText(utcmonthString);


        // "yearUTC"
        var yearutc = Time.now();
        var utcyear = Gregorian.utcInfo(yearutc, Time.FORMAT_SHORT);
        var utcyearString = Lang.format(
            "$1$",
            [
                utcyear.year.format("%d").substring(2, 4), // Nur die letzten beiden Ziffern
            ]
        );
        var utcyearlabel = View.findDrawableById("utcyearLabel") as Text;
        utcyearlabel.setText(utcyearString);


        // "LOCAL / UTC A B Berechnung"--------------------------------------------------------------------------------------------------


        // "hour"
        var hour = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var hourString = Lang.format(
            "$1$",
            [
                hour.hour.format("%02d"),
            ]
        );
        var hourlabel = View.findDrawableById("hourLabel") as Text;
        hourlabel.setText(hourString);

        // "hourUTC"
        var utchour = Time.now();
        var hourutc = Gregorian.utcInfo(utchour, Time.FORMAT_MEDIUM);

        var hourutcString = Lang.format(
            "$1$",
            [
                hourutc.hour.format("%02d"),
            ]
        );
        var hourutclabel = View.findDrawableById("utchourLabel") as Text;
        hourutclabel.setText(hourutcString);

        // Unterschied berechnen
        var timeDifference = hour.hour - hourutc.hour;
        if (timeDifference < 0) {
            timeDifference = -timeDifference; // Sicherstellen, dass es positiv ist
        }

        // "text AB"
        var texab = "";
        if (timeDifference == 2) {
            texab = "B";
        } else if (timeDifference == 1) {
            texab = "A";
        }

        var texabLabel = View.findDrawableById("texabLabel") as Text;
        texabLabel.setText(texab);
    

        // "STUFF"--------------------------------------------------------------------------------------------------


        var myLocation = Position.getInfo().position;
        var mgrsString = myLocation.toGeoString(Position.GEO_MGRS);

        // Entferne Leerzeichen aus der MGRS-Zeichenkette
        var mgrsChars = mgrsString.toCharArray();
        var mgrsCleaned = "";
        for (var i = 0; i < mgrsChars.size(); i++) {
            if (!mgrsChars[i].equals(' ')) {
                mgrsCleaned = mgrsCleaned + mgrsChars[i];
            }
        }
        // Überprüfen, ob die Länge stimmt
        if (mgrsCleaned.length() != 15) {
            mgrsCleaned = "BAD MGRS DATA";
        }

        // Einzelne Teile der MGRS-Koordinate extrahieren
        var mgrsZone = mgrsCleaned.substring(0, 3);
        var mgrsSquare = mgrsCleaned.substring(3, 5);
        var mgrsEasting = mgrsCleaned.substring(5, 10);
        var mgrsNorthing = mgrsCleaned.substring(10, 15);

        // Label-Elemente aktualisieren
        var mgrsZoneLabel = View.findDrawableById("mgrsZoneLabel") as Text;
        mgrsZoneLabel.setText(mgrsZone);

        var mgrsSquareLabel = View.findDrawableById("mgrsSquareLabel") as Text;
        mgrsSquareLabel.setText(mgrsSquare);

        var mgrsEastingLabel = View.findDrawableById("mgrsEastingLabel") as Text;
        mgrsEastingLabel.setText(mgrsEasting);

        var mgrsNorthingLabel = View.findDrawableById("mgrsNorthingLabel") as Text;
        mgrsNorthingLabel.setText(mgrsNorthing);

        // "Altitude"
        var altitude = Activity.getActivityInfo().altitude;
        var altitudeLabel = View.findDrawableById("altitudeLabel") as Text;
        altitudeLabel.setText(altitude.format("%d"));

        // "text AMSL"
        var texamslLabel = View.findDrawableById("texamslLabel") as Text;
        texamslLabel.setText("MSL");


        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        drawNorthTriangle(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}