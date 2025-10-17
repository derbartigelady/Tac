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
import Toybox.Math;

class TacView extends WatchUi.WatchFace {

    var _showNorthTriangle = true;
    var _isSleeping = false;

    // cached drawables (declare without explicit types so they may be null until onLayout)
    var _iconBellOn;
    var _iconBellOff;
    var _iconBtOn;
    var _iconBtOff;

    var _lblSec;
    var _lblStep;
    var _lblBattery;
    var _lblHeart;

    var _lblDayOfWeek;
    var _lblDay;
    var _lblMin;
    var _lblHour;
    var _lblMonth;
    var _lblYear;

    var _lblUtcDayOfWeek;
    var _lblUtcDay;
    var _lblUtcHour;
    var _lblUtcMin;
    var _lblUtcMonth;
    var _lblUtcYear;
    var _lblTexZ;
    var _lblTexAB;

    var _mgrsZoneLabel;
    var _mgrsSquareLabel;
    var _mgrsEastingLabel;
    var _mgrsNorthingLabel;

    var _altitudeLabel;
    var _texamslLabel;

    var _hdngLabel;
    var _texangleLabel;

    var _tacLines;

    var _aohourLabel;
    var _aominLabel;
    var _texaoLabel;
    var _texzaoLabel;
    var _aodateLabel;

    // initialize
    function initialize() {
        WatchUi.WatchFace.initialize();
    }

    // helper: safe setVisible / setText
    function setVisibleIfExistsByRef(el, visible as Boolean) as Void {
        if (el != null) {
            el.setVisible(visible);
        }
    }
    function setTextIfExistsByRef(el, txt as String) as Void {
        if (el != null) {
            el.setText(txt);
        }
    }

    function onLayout(dc as Dc) as Void {
        // device-independent layout reference
        setLayout(Rez.Layouts.WatchFace(dc));

        // cache drawables (typecast where useful)
        _iconBellOn = View.findDrawableById("icon_note_on") as Bitmap;
        _iconBellOff = View.findDrawableById("icon_note_off") as Bitmap;
        _iconBtOn = View.findDrawableById("bt_on") as Bitmap;
        _iconBtOff = View.findDrawableById("bt_off") as Bitmap;

        _lblSec = View.findDrawableById("secLabel") as Text;
        _lblStep = View.findDrawableById("stepLabel") as Text;
        _lblBattery = View.findDrawableById("batteryLabel") as Text;
        _lblHeart = View.findDrawableById("heartRateLabel") as Text;

        _lblDayOfWeek = View.findDrawableById("dayofweekLabel") as Text;
        _lblDay = View.findDrawableById("dayLabel") as Text;
        _lblMin = View.findDrawableById("minLabel") as Text;
        _lblHour = View.findDrawableById("hourLabel") as Text;
        _lblMonth = View.findDrawableById("monthLabel") as Text;
        _lblYear = View.findDrawableById("yearLabel") as Text;

        _lblUtcDayOfWeek = View.findDrawableById("utcdayofweekLabel") as Text;
        _lblUtcDay = View.findDrawableById("utcdayLabel") as Text;
        _lblUtcHour = View.findDrawableById("utchourLabel") as Text;
        _lblUtcMin = View.findDrawableById("utcminLabel") as Text;
        _lblUtcMonth = View.findDrawableById("utcmonthLabel") as Text;
        _lblUtcYear = View.findDrawableById("utcyearLabel") as Text;
        _lblTexZ = View.findDrawableById("texzLabel") as Text;
        _lblTexAB = View.findDrawableById("texabLabel") as Text;

        _mgrsZoneLabel = View.findDrawableById("mgrsZoneLabel") as Text;
        _mgrsSquareLabel = View.findDrawableById("mgrsSquareLabel") as Text;
        _mgrsEastingLabel = View.findDrawableById("mgrsEastingLabel") as Text;
        _mgrsNorthingLabel = View.findDrawableById("mgrsNorthingLabel") as Text;

        _altitudeLabel = View.findDrawableById("altitudeLabel") as Text;
        _texamslLabel = View.findDrawableById("texamslLabel") as Text;

        _hdngLabel = View.findDrawableById("hdngLabel") as Text;
        _texangleLabel = View.findDrawableById("texangleLabel") as Text;

        _tacLines = View.findDrawableById("tac_lines") as Bitmap;

        _aohourLabel = View.findDrawableById("aohourLabel") as Text;
        _aominLabel = View.findDrawableById("aominLabel") as Text;
        _texaoLabel = View.findDrawableById("texaoLabel") as Text;
        _texzaoLabel = View.findDrawableById("texzaoLabel") as Text;
        _aodateLabel = View.findDrawableById("aodateLabel") as Text;

        // initial visibilities (safe)
        setVisibleIfExistsByRef(_iconBellOn, true);
        setVisibleIfExistsByRef(_iconBellOff, true);
        setVisibleIfExistsByRef(_iconBtOn, true);
        setVisibleIfExistsByRef(_iconBtOff, true);

        setVisibleIfExistsByRef(_lblSec, true);
        setVisibleIfExistsByRef(_lblStep, true);
        setVisibleIfExistsByRef(_lblBattery, true);
        setVisibleIfExistsByRef(_lblHeart, true);

        setVisibleIfExistsByRef(_lblDayOfWeek, true);
        setVisibleIfExistsByRef(_lblDay, true);
        setVisibleIfExistsByRef(_lblHour, true);
        setVisibleIfExistsByRef(_lblMin, true);
        setVisibleIfExistsByRef(_lblMonth, true);
        setVisibleIfExistsByRef(_lblYear, true);

        setVisibleIfExistsByRef(_lblUtcDayOfWeek, true);
        setVisibleIfExistsByRef(_lblUtcDay, true);
        setVisibleIfExistsByRef(_lblUtcHour, true);
        setVisibleIfExistsByRef(_lblUtcMin, true);
        setVisibleIfExistsByRef(_lblTexZ, true);
        setVisibleIfExistsByRef(_lblUtcMonth, true);
        setVisibleIfExistsByRef(_lblUtcYear, true);

        setVisibleIfExistsByRef(_mgrsZoneLabel, true);
        setVisibleIfExistsByRef(_mgrsSquareLabel, true);
        setVisibleIfExistsByRef(_mgrsEastingLabel, true);
        setVisibleIfExistsByRef(_mgrsNorthingLabel, true);

        setVisibleIfExistsByRef(_altitudeLabel, true);
        setVisibleIfExistsByRef(_texamslLabel, true);

        setVisibleIfExistsByRef(_hdngLabel, true);
        setVisibleIfExistsByRef(_texangleLabel, true);
        setVisibleIfExistsByRef(_tacLines, true);

        setVisibleIfExistsByRef(_aohourLabel, false);
        setVisibleIfExistsByRef(_texaoLabel, false);
        setVisibleIfExistsByRef(_texzaoLabel, false);
        setVisibleIfExistsByRef(_aominLabel, false);
        setVisibleIfExistsByRef(_aodateLabel, false);
    }

    function drawNorthTriangle(dc as Dc) as Void {
        if (!_showNorthTriangle) {
            return;
        }

        var actInfo = Activity.getActivityInfo();
        if (actInfo == null || actInfo.currentHeading == null) {
            return;
        }

        var heading = actInfo.currentHeading;
        var cx = dc.getWidth() / 2;
        var cy = dc.getHeight() / 2;

        var deg = Math.toDegrees(heading);
        if (deg < 0) {
            deg += 360;
        }
        var angleDeg = Math.round(deg).toNumber();

        if (_hdngLabel != null) {
            _hdngLabel.setText(((360 - angleDeg) % 360).toString());
        }
        if (_texangleLabel != null) {
            _texangleLabel.setText("° N");
        }

        var angleC = Math.toRadians(-angleDeg.toFloat());
        var degL = ((angleDeg - 4 + 360) % 360);
        var degR = ((angleDeg + 4) % 360);
        var angleL = Math.toRadians(-degL.toFloat());
        var angleR = Math.toRadians(-degR.toFloat());

        var minDim = (dc.getWidth() < dc.getHeight() ? dc.getWidth() : dc.getHeight()).toFloat();
        var rMain = minDim * 0.47;
        var rWing = minDim * 0.44;

        var ptC = polarToXY(angleC, rMain, cx.toFloat(), cy.toFloat());
        var ptL = polarToXY(angleL, rWing, cx.toFloat(), cy.toFloat());
        var ptR = polarToXY(angleR, rWing, cx.toFloat(), cy.toFloat());

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

    function onUpdate(dc as Dc) as Void {
        // update once per frame
        View.onUpdate(dc);

        // compute time objects once
        var nowShort = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var nowMedium = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        // Bluetooth
        var phoneConnected = System.getDeviceSettings().phoneConnected;
        if (!_isSleeping) {
            if (phoneConnected) {
                setVisibleIfExistsByRef(_iconBtOn, true);
                setVisibleIfExistsByRef(_iconBtOff, false);
            } else {
                setVisibleIfExistsByRef(_iconBtOn, false);
                setVisibleIfExistsByRef(_iconBtOff, true);
            }
        } else {
            setVisibleIfExistsByRef(_iconBtOn, false);
            setVisibleIfExistsByRef(_iconBtOff, false);
        }

        // sec
        var secInfo = nowShort;
        var secString = secInfo != null ? secInfo.sec.format("%02d") : "--";
        setTextIfExistsByRef(_lblSec, secString);

        // notifications
        var notifications = System.getDeviceSettings().notificationCount;
        if (!_isSleeping) {
            if (notifications > 0) {
                setVisibleIfExistsByRef(_iconBellOn, true);
                setVisibleIfExistsByRef(_iconBellOff, false);
            } else {
                setVisibleIfExistsByRef(_iconBellOn, false);
                setVisibleIfExistsByRef(_iconBellOff, true);
            }
        } else {
            setVisibleIfExistsByRef(_iconBellOn, false);
            setVisibleIfExistsByRef(_iconBellOff, false);
        }

        // battery
        var battery = System.getSystemStats().battery;
        if (_lblBattery != null) {
            _lblBattery.setText(battery.format("%d"));
        }

        // heart rate
        var heartRateText = "-";
        var actInfo = Activity.getActivityInfo();
        if (actInfo != null && actInfo.currentHeartRate != null && actInfo.currentHeartRate != 0) {
            heartRateText = actInfo.currentHeartRate.format("%d");
        }
        setTextIfExistsByRef(_lblHeart, heartRateText);

        // steps (today)
        var stepCount = ActivityMonitor.getInfo().steps;
        if (_lblStep != null) {
            _lblStep.setText(stepCount == null ? "-" : stepCount.format("%d"));
        }

        // LOCAL: weekday
        var currentTime = Time.now();
        var dayofweekInfo = Gregorian.info(currentTime, Time.FORMAT_SHORT);
        var weekDays = ["Sa", "So", "Mo", "Di", "Mi", "Do", "Fr"];
        var dowIdx = (dayofweekInfo != null && dayofweekInfo.day_of_week != null) ? dayofweekInfo.day_of_week : 0;
        if (dowIdx == 7) {
            dowIdx = 0;
        }
        var dayofweekString = (dowIdx >= 0 && dowIdx < weekDays.size()) ? weekDays[dowIdx] : "??";
        setTextIfExistsByRef(_lblDayOfWeek, dayofweekString);

        // day
        var dayString = nowShort != null ? nowShort.day.format("%02d") : "--";
        setTextIfExistsByRef(_lblDay, dayString);

        // min
        var minString = nowMedium != null ? nowMedium.min.format("%02d") : "--";
        setTextIfExistsByRef(_lblMin, minString);

        // month (DE, 3 letters)
        var germanMonths = ["jan","feb","mär","apr","mai","jun","jul","aug","sep","okt","nov","dez"];
        var mIndex = (nowShort != null && nowShort.month != null) ? (nowShort.month - 1) : 0;
        var monthString = germanMonths[(mIndex >= 0 && mIndex < germanMonths.size()) ? mIndex : 0];
        setTextIfExistsByRef(_lblMonth, monthString);

        // year (YY)
        var yearString = nowShort != null ? nowShort.year.format("%d").substring(2,4) : "--";
        setTextIfExistsByRef(_lblYear, yearString);

        // UTC: weekday
        var utcNow = Time.now();
        var utcDayOfWeekInfo = Gregorian.info(utcNow, Time.FORMAT_SHORT);
        var utcWeekDays = ["sa","su","mo","tu","we","th","fr"];
        var utcDowIdx = (utcDayOfWeekInfo != null && utcDayOfWeekInfo.day_of_week != null) ? utcDayOfWeekInfo.day_of_week : 0;
        if (utcDowIdx == 7) {
            utcDowIdx = 0;
        }
        var utcDayOfWeekString = (utcDowIdx >= 0 && utcDowIdx < utcWeekDays.size()) ? utcWeekDays[utcDowIdx] : "??";
        setTextIfExistsByRef(_lblUtcDayOfWeek, utcDayOfWeekString);

        // dayUTC
        var utcDayInfo = Gregorian.utcInfo(utcNow, Time.FORMAT_SHORT);
        var utcDayString = utcDayInfo != null ? utcDayInfo.day.format("%02d") : "--";
        setTextIfExistsByRef(_lblUtcDay, utcDayString);

        // minUTC
        var utcMinInfo = Gregorian.utcInfo(utcNow, Time.FORMAT_MEDIUM);
        var utcMinString = utcMinInfo != null ? utcMinInfo.min.format("%02d") : "--";
        setTextIfExistsByRef(_lblUtcMin, utcMinString);

        // text Z
        setTextIfExistsByRef(_lblTexZ, "Z");

        // monthUTC (EN, 3 letters)
        var utcMonthInfo = Gregorian.utcInfo(utcNow, Time.FORMAT_SHORT);
        var englishMonths = ["jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"];
        var umIndex = (utcMonthInfo != null && utcMonthInfo.month != null) ? (utcMonthInfo.month - 1) : 0;
        var utcmonthString = englishMonths[(umIndex >= 0 && umIndex < englishMonths.size()) ? umIndex : 0];
        setTextIfExistsByRef(_lblUtcMonth, utcmonthString);

        // yearUTC
        var utcYearString = utcMonthInfo != null ? utcMonthInfo.year.format("%d").substring(2,4) : "--";
        setTextIfExistsByRef(_lblUtcYear, utcYearString);

        // LOCAL/UTC AB calculation
        var hourInfo = nowMedium;
        var hourString = hourInfo != null ? hourInfo.hour.format("%02d") : "--";
        setTextIfExistsByRef(_lblHour, hourString);

        var utcHourInfo = Gregorian.utcInfo(utcNow, Time.FORMAT_MEDIUM);
        var utcHourString = utcHourInfo != null ? utcHourInfo.hour.format("%02d") : "--";
        setTextIfExistsByRef(_lblUtcHour, utcHourString);

        var timeDifference = 0;
        if (hourInfo != null && utcHourInfo != null) {
            timeDifference = hourInfo.hour - utcHourInfo.hour;
            if (timeDifference < 0) {
                timeDifference = -timeDifference;
            }
        }
        var texab = "";
        if (timeDifference == 2) {
            texab = "B";
        } else if (timeDifference == 1) {
            texab = "A";
        }
        setTextIfExistsByRef(_lblTexAB, texab);

        // Position / MGRS - layout-aware parsing and label updates
        try {
            var posInfo = Position.getInfo();
            if (posInfo != null && posInfo.position != null) {
                var myLocation = posInfo.position;
                var mgrsString = myLocation.toGeoString(Position.GEO_MGRS);
                if (mgrsString != null) {
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
                        // Zeige Fehlertext in Zone-Label, leere die anderen Felder
                        setTextIfExistsByRef(_mgrsZoneLabel, "BAD MGRS DATA");
                        setTextIfExistsByRef(_mgrsSquareLabel, "");
                        setTextIfExistsByRef(_mgrsEastingLabel, "");
                        setTextIfExistsByRef(_mgrsNorthingLabel, "");
                    } else {
                        // Einzelne Teile der MGRS-Koordinate extrahieren
                        var mgrsZone = mgrsCleaned.substring(0, 3);
                        var mgrsSquare = mgrsCleaned.substring(3, 5);
                        var mgrsEasting = mgrsCleaned.substring(5, 10);
                        var mgrsNorthing = mgrsCleaned.substring(10, 15);

                        // Label-Elemente aktualisieren (bereits gecacht in onLayout)
                        setTextIfExistsByRef(_mgrsZoneLabel, mgrsZone);
                        setTextIfExistsByRef(_mgrsSquareLabel, mgrsSquare);
                        setTextIfExistsByRef(_mgrsEastingLabel, mgrsEasting);
                        setTextIfExistsByRef(_mgrsNorthingLabel, mgrsNorthing);
                    }
                }
            }
        } catch (e) {
            // ignore position errors
        }

        // altitude
        try {
            var altitude = null;
            var ai = Activity.getActivityInfo();
            if (ai != null && ai.altitude != null) {
                altitude = ai.altitude;
            }
            if (altitude != null) {
                setTextIfExistsByRef(_altitudeLabel, altitude.format("%d"));
            }
        } catch (e) {
            // ignore
        }
        setTextIfExistsByRef(_texamslLabel, "MSL");

        // always-on display small fields
        setTextIfExistsByRef(_aominLabel, minString);
        setTextIfExistsByRef(_texaoLabel, ":");
        setTextIfExistsByRef(_texzaoLabel, "<------{  Don't be evil  }------>");
        setTextIfExistsByRef(_aohourLabel, hourString);

        var aodateString = nowShort != null ? Lang.format("$1$.$2$.$3$", [
            nowShort.day.format("%02d"),
            nowShort.month.format("%02d"),
            nowShort.year.format("%d").substring(2,4)
        ]) : "--.--.--";
        setTextIfExistsByRef(_aodateLabel, aodateString);

        // draw triangle if visible
        drawNorthTriangle(dc);
    }

    function onHide() as Void {
        // nothing
    }

    function onExitSleep() as Void {
        _showNorthTriangle = true;
        _isSleeping = false;

        // restore icons immediately based on current state
        var phoneConnected = System.getDeviceSettings().phoneConnected;
        var notifications = System.getDeviceSettings().notificationCount;
        if (phoneConnected) {
            setVisibleIfExistsByRef(_iconBtOn, true);
            setVisibleIfExistsByRef(_iconBtOff, false);
        } else {
            setVisibleIfExistsByRef(_iconBtOn, false);
            setVisibleIfExistsByRef(_iconBtOff, true);
        }
        if (notifications > 0) {
            setVisibleIfExistsByRef(_iconBellOn, true);
            setVisibleIfExistsByRef(_iconBellOff, false);
        } else {
            setVisibleIfExistsByRef(_iconBellOn, false);
            setVisibleIfExistsByRef(_iconBellOff, true);
        }

        // make relevant elements visible again (safe)
        setVisibleIfExistsByRef(_lblSec, true);
        setVisibleIfExistsByRef(_lblStep, true);
        setVisibleIfExistsByRef(_lblBattery, true);
        setVisibleIfExistsByRef(_lblHeart, true);

        setVisibleIfExistsByRef(_lblDayOfWeek, true);
        setVisibleIfExistsByRef(_lblDay, true);
        setVisibleIfExistsByRef(_lblHour, true);
        setVisibleIfExistsByRef(_lblMin, true);
        setVisibleIfExistsByRef(_lblTexAB, true);
        setVisibleIfExistsByRef(_lblMonth, true);
        setVisibleIfExistsByRef(_lblYear, true);

        setVisibleIfExistsByRef(_lblUtcDayOfWeek, true);
        setVisibleIfExistsByRef(_lblUtcDay, true);
        setVisibleIfExistsByRef(_lblUtcHour, true);
        setVisibleIfExistsByRef(_lblUtcMin, true);
        setVisibleIfExistsByRef(_lblTexZ, true);
        setVisibleIfExistsByRef(_lblUtcMonth, true);
        setVisibleIfExistsByRef(_lblUtcYear, true);

        setVisibleIfExistsByRef(_mgrsZoneLabel, true);
        setVisibleIfExistsByRef(_mgrsSquareLabel, true);
        setVisibleIfExistsByRef(_mgrsEastingLabel, true);
        setVisibleIfExistsByRef(_mgrsNorthingLabel, true);

        setVisibleIfExistsByRef(_altitudeLabel, true);
        setVisibleIfExistsByRef(_texamslLabel, true);

        setVisibleIfExistsByRef(_hdngLabel, true);
        setVisibleIfExistsByRef(_texangleLabel, true);
        setVisibleIfExistsByRef(_tacLines, true);

        setVisibleIfExistsByRef(_aohourLabel, false);
        setVisibleIfExistsByRef(_texaoLabel, false);
        setVisibleIfExistsByRef(_texzaoLabel, false);
        setVisibleIfExistsByRef(_aominLabel, false);
        setVisibleIfExistsByRef(_aodateLabel, false);
    }

    function onEnterSleep() as Void {
        _showNorthTriangle = false;
        _isSleeping = true;

        // hide icons immediately so they don't flash during transition
        setVisibleIfExistsByRef(_iconBellOn, false);
        setVisibleIfExistsByRef(_iconBellOff, false);
        setVisibleIfExistsByRef(_iconBtOn, false);
        setVisibleIfExistsByRef(_iconBtOff, false);

        setVisibleIfExistsByRef(_lblSec, false);
        setVisibleIfExistsByRef(_lblStep, false);
        setVisibleIfExistsByRef(_lblBattery, false);
        setVisibleIfExistsByRef(_lblHeart, false);

        setVisibleIfExistsByRef(_lblDayOfWeek, false);
        setVisibleIfExistsByRef(_lblDay, false);
        setVisibleIfExistsByRef(_lblHour, false);
        setVisibleIfExistsByRef(_lblMin, false);
        setVisibleIfExistsByRef(_lblTexAB, false);
        setVisibleIfExistsByRef(_lblMonth, false);
        setVisibleIfExistsByRef(_lblYear, false);

        setVisibleIfExistsByRef(_lblUtcDayOfWeek, false);
        setVisibleIfExistsByRef(_lblUtcDay, false);
        setVisibleIfExistsByRef(_lblUtcHour, false);
        setVisibleIfExistsByRef(_lblUtcMin, false);
        setVisibleIfExistsByRef(_lblTexZ, false);
        setVisibleIfExistsByRef(_lblUtcMonth, false);
        setVisibleIfExistsByRef(_lblUtcYear, false);

        setVisibleIfExistsByRef(_mgrsZoneLabel, false);
        setVisibleIfExistsByRef(_mgrsSquareLabel, false);
        setVisibleIfExistsByRef(_mgrsEastingLabel, false);
        setVisibleIfExistsByRef(_mgrsNorthingLabel, false);

        setVisibleIfExistsByRef(_altitudeLabel, false);
        setVisibleIfExistsByRef(_texamslLabel, false);

        setVisibleIfExistsByRef(_hdngLabel, false);
        setVisibleIfExistsByRef(_texangleLabel, false);
        setVisibleIfExistsByRef(_tacLines, false);

        setVisibleIfExistsByRef(_aohourLabel, true);
        setVisibleIfExistsByRef(_texaoLabel, true);
        setVisibleIfExistsByRef(_texzaoLabel, true);
        setVisibleIfExistsByRef(_aominLabel, true);
        setVisibleIfExistsByRef(_aodateLabel, true);
    }
}