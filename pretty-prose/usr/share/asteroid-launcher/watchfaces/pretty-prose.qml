// SPDX-FileCopyrightText: 2026 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: BSD-3-Clause
// pretty-prose — AsteroidOS watchface
// Time as a natural sentence in the system language. Filler words render
// dim; the time phrase renders in full white via inline RichText color
// tags. Four generation patterns cover ten languages without Weblate —
// grammar logic cannot be safely delegated to string substitution.
// Adding a language:
//   1. Identify which pattern number fits the target grammar (see pattern
//      function comments below).
//   2. Write a generateTimeXX(time) function supplying the word arrays
//      and calling the matching pattern helper.
//   3. Add a case in generateTime() keyed on Qt.locale().name.
//   4. Open a PR — native speaker review of word arrays is welcome.
// Pattern 1 — minutes-first sentence, single hour list, configurable
//             nextHour boundary. Covers: en, da, nl, sv, nb.
// Pattern 2 — like Pattern 1 but with a second hour list for o'clock
//             slots, handling morphological forms (German ein/eins).
//             Covers: de.
// Pattern 3 — Romance connectors. Verb and article agree with the hour
//             number via a verbFn callback. Covers: es, pt, it.
// Pattern 4 — hour + "heures" always first, suffix phrase varies.
//             Singular form for hour 1 via heuresFn. Covers: fr.

import Qt5Compat.GraphicalEffects
import QtQuick

Item {
    id: root

    readonly property string displayFont: "EB Garamond"
    readonly property string dateFont: "JetBrains Mono"
    readonly property color fg: Qt.rgba(1, 1, 1, displayAmbient ? 0.8 : 1)
    readonly property color dimColor: Qt.rgba(1, 1, 1, displayAmbient ? 0.25 : 0.35)

    // Wraps the time phrase in an inline color tag. Called from within
    // generateTime() — root.fg is therefore tracked as a binding dependency,
    // so ambient transitions re-evaluate the text automatically.
    function bright(s) {
        return "<font color=\"" + root.fg + "\">" + s + "</font>";
    }

    // ── Pattern 1 ────────────────────────────────────────────────────────────
    // d: { hours[], phrases[], minutesFirst[], nextHour[], prefix, suffix }
    function pattern1(slot, h12, d) {
        var h = (h12 + (d.nextHour[slot] ? 1 : 0)) % 12;
        var phrase = d.phrases[slot];
        var hour = d.hours[h];
        var time = d.minutesFirst[slot] ? (phrase ? phrase + " " + hour : hour) : (phrase ? hour + " " + phrase : hour);
        return d.prefix + bright(time) + d.suffix;
    }

    // ── Pattern 2 ────────────────────────────────────────────────────────────
    // d: adds hoursOclock[] alongside hours[] for o'clock-slot morphology.
    function pattern2(slot, h12, d) {
        var h = (h12 + (d.nextHour[slot] ? 1 : 0)) % 12;
        var phrase = d.phrases[slot];
        var isOclock = (slot === 0 || slot === 12);
        var hour = isOclock ? d.hoursOclock[h] : d.hours[h];
        var time = d.minutesFirst[slot] ? (phrase ? phrase + " " + hour : hour) : (phrase ? hour + " " + phrase : hour);
        return d.prefix + bright(time) + d.suffix;
    }

    // ── Pattern 3 ────────────────────────────────────────────────────────────
    // d: { hours[], hoursTo[], verbFn(h, slot)→string, phrases[], nextHour[], suffix }
    // verbFn returns the dim sentence prefix including any article that agrees
    // with the hour number. hours[] and hoursTo[] may include articles where
    // the language requires them inside the bright span (Italian le/l').
    function pattern3(slot, h12, d) {
        var h = (h12 + (d.nextHour[slot] ? 1 : 0)) % 12;
        var phrase = d.phrases[slot];
        var hourStr = d.nextHour[slot] ? d.hoursTo[h] : d.hours[h];
        var time = phrase ? hourStr + " " + phrase : hourStr;
        return d.verbFn(h, slot) + bright(time) + d.suffix;
    }

    // ── Pattern 4 ────────────────────────────────────────────────────────────
    // d: { hours[], phrases[], nextHour[], prefix, heuresFn(h)→string, suffix }
    // heuresFn returns "heure" or "heures" (or equivalent) based on the hour.
    function pattern4(slot, h12, d) {
        var h = (h12 + (d.nextHour[slot] ? 1 : 0)) % 12;
        var phrase = d.phrases[slot];
        var time = d.hours[h] + " " + d.heuresFn(h) + (phrase ? " " + phrase : "");
        return d.prefix + bright(time) + d.suffix;
    }

    // ── English (Pattern 1) ──────────────────────────────────────────────────
    function generateTimeEn(time) {
        var slot = Math.round(time.getMinutes() / 5);
        var h12 = time.getHours() % 12;
        return pattern1(slot, h12, {
            "hours": ["twelve", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven"],
            "phrases": ["o'clock", "five past", "ten past", "a quarter past", "twenty past", "twenty-five past", "half past", "twenty-five to", "twenty to", "a quarter to", "ten to", "five to", "o'clock"],
            "minutesFirst": [false, true, true, true, true, true, true, true, true, true, true, true, false],
            "nextHour": [false, false, false, false, false, false, false, true, true, true, true, true, true],
            "prefix": "It is ",
            "suffix": "."
        });
    }

    // ── Danish (Pattern 1) ───────────────────────────────────────────────────
    // nextHour shifts at slot 6 — "halv [next]" references the coming hour.
    function generateTimeDa(time) {
        var slot = Math.round(time.getMinutes() / 5);
        var h12 = time.getHours() % 12;
        return pattern1(slot, h12, {
            "hours": ["tolv", "et", "to", "tre", "fire", "fem", "seks", "syv", "otte", "ni", "ti", "elleve"],
            "phrases": ["", "fem over", "ti over", "kvart over", "tyve over", "femogtyve over", "halv", "femogtyve i", "tyve i", "kvart i", "ti i", "fem i", ""],
            "minutesFirst": [false, true, true, true, true, true, true, true, true, true, true, true, false],
            "nextHour": [false, false, false, false, false, false, true, true, true, true, true, true, true],
            "prefix": "Klokken er ",
            "suffix": "."
        });
    }

    // ── Dutch (Pattern 1) ────────────────────────────────────────────────────
    // nextHour shifts at slot 4 — "tien voor half [next]" already references
    // the coming hour, earlier than the English boundary at slot 7.
    function generateTimeNl(time) {
        var slot = Math.round(time.getMinutes() / 5);
        var h12 = time.getHours() % 12;
        return pattern1(slot, h12, {
            "hours": ["twaalf", "één", "twee", "drie", "vier", "vijf", "zes", "zeven", "acht", "negen", "tien", "elf"],
            "phrases": ["uur", "vijf over", "tien over", "kwart over", "tien voor half", "vijf voor half", "half", "vijf over half", "tien over half", "kwart voor", "tien voor", "vijf voor", "uur"],
            "minutesFirst": [false, true, true, true, true, true, true, true, true, true, true, true, false],
            "nextHour": [false, false, false, false, true, true, true, true, true, true, true, true, true],
            "prefix": "Het is ",
            "suffix": "."
        });
    }

    // ── Swedish (Pattern 1) ──────────────────────────────────────────────────
    // nextHour shifts at slot 6 — "halv [next]" references the coming hour.
    // Empty phrase string at slots 0 and 12 renders just the hour word.
    function generateTimeSv(time) {
        var slot = Math.round(time.getMinutes() / 5);
        var h12 = time.getHours() % 12;
        return pattern1(slot, h12, {
            "hours": ["tolv", "ett", "två", "tre", "fyra", "fem", "sex", "sju", "åtta", "nio", "tio", "elva"],
            "phrases": ["", "fem över", "tio över", "kvart över", "tjugo över", "tjugofem över", "halv", "tjugofem i", "tjugo i", "kvart i", "tio i", "fem i", ""],
            "minutesFirst": [false, true, true, true, true, true, true, true, true, true, true, true, false],
            "nextHour": [false, false, false, false, false, false, true, true, true, true, true, true, true],
            "prefix": "Klockan är ",
            "suffix": "."
        });
    }

    // ── Norwegian Bokmål (Pattern 1) ─────────────────────────────────────────
    function generateTimeNb(time) {
        var slot = Math.round(time.getMinutes() / 5);
        var h12 = time.getHours() % 12;
        return pattern1(slot, h12, {
            "hours": ["tolv", "ett", "to", "tre", "fire", "fem", "seks", "sju", "åtte", "ni", "ti", "elleve"],
            "phrases": ["", "fem over", "ti over", "kvart over", "tjue over", "tjuefem over", "halv", "tjuefem i", "tjue i", "kvart i", "ti i", "fem i", ""],
            "minutesFirst": [false, true, true, true, true, true, true, true, true, true, true, true, false],
            "nextHour": [false, false, false, false, false, false, true, true, true, true, true, true, true],
            "prefix": "Klokken er ",
            "suffix": "."
        });
    }

    // ── German (Pattern 2) ───────────────────────────────────────────────────
    // hoursOclock uses "ein" at o'clock slots; hours uses "eins" everywhere else.
    // nextHour shifts at slot 5 — "fünf vor halb [next]" already references
    // the coming hour, two slots earlier than the English boundary.
    function generateTimeDe(time) {
        var slot = Math.round(time.getMinutes() / 5);
        var h12 = time.getHours() % 12;
        return pattern2(slot, h12, {
            "hours": ["zwölf", "eins", "zwei", "drei", "vier", "fünf", "sechs", "sieben", "acht", "neun", "zehn", "elf"],
            "hoursOclock": ["zwölf", "ein", "zwei", "drei", "vier", "fünf", "sechs", "sieben", "acht", "neun", "zehn", "elf"],
            "phrases": ["Uhr", "fünf nach", "zehn nach", "viertel nach", "zwanzig nach", "fünf vor halb", "halb", "fünf nach halb", "zwanzig vor", "viertel vor", "zehn vor", "fünf vor", "Uhr"],
            "minutesFirst": [false, true, true, true, true, true, true, true, true, true, true, true, false],
            "nextHour": [false, false, false, false, false, true, true, true, true, true, true, true, true],
            "prefix": "Es ist ",
            "suffix": "."
        });
    }

    // ── Spanish (Pattern 3) ──────────────────────────────────────────────────
    // verbFn returns "Es la " for hour 1, "Son las " for all others.
    // "y" and "menos" connectors are baked into the phrase strings.
    function generateTimeEs(time) {
        var slot = Math.round(time.getMinutes() / 5);
        var h12 = time.getHours() % 12;
        return pattern3(slot, h12, {
            "hours": ["doce", "una", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve", "diez", "once"],
            "hoursTo": ["doce", "una", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve", "diez", "once"],
            "phrases": ["en punto", "y cinco", "y diez", "y cuarto", "y veinte", "y veinticinco", "y media", "menos veinticinco", "menos veinte", "menos cuarto", "menos diez", "menos cinco", "en punto"],
            "nextHour": [false, false, false, false, false, false, false, true, true, true, true, true, true],
            "verbFn": function(h) {
                return h === 1 ? "Es la " : "Son las ";
            },
            "suffix": "."
        });
    }

    // ── Portuguese (Pattern 3) ───────────────────────────────────────────────
    // verbFn returns "É " for hour 1, "São " for all others.
    function generateTimePt(time) {
        var slot = Math.round(time.getMinutes() / 5);
        var h12 = time.getHours() % 12;
        return pattern3(slot, h12, {
            "hours": ["doze", "uma", "duas", "três", "quatro", "cinco", "seis", "sete", "oito", "nove", "dez", "onze"],
            "hoursTo": ["doze", "uma", "duas", "três", "quatro", "cinco", "seis", "sete", "oito", "nove", "dez", "onze"],
            "phrases": ["em ponto", "e cinco", "e dez", "e um quarto", "e vinte", "e vinte e cinco", "e meia", "menos vinte e cinco", "menos vinte", "menos um quarto", "menos dez", "menos cinco", "em ponto"],
            "nextHour": [false, false, false, false, false, false, false, true, true, true, true, true, true],
            "verbFn": function(h) {
                return h === 1 ? "É " : "São ";
            },
            "suffix": "."
        });
    }

    // ── Italian (Pattern 3) ──────────────────────────────────────────────────
    // Article is baked into the hours arrays ("le dodici", "l'una") so it falls
    // inside the bright span. verbFn returns only the verb: "È " for 1, "Sono " for others.
    function generateTimeIt(time) {
        var slot = Math.round(time.getMinutes() / 5);
        var h12 = time.getHours() % 12;
        return pattern3(slot, h12, {
            "hours": ["le dodici", "l'una", "le due", "le tre", "le quattro", "le cinque", "le sei", "le sette", "le otto", "le nove", "le dieci", "le undici"],
            "hoursTo": ["le dodici", "l'una", "le due", "le tre", "le quattro", "le cinque", "le sei", "le sette", "le otto", "le nove", "le dieci", "le undici"],
            "phrases": ["in punto", "e cinque", "e dieci", "e un quarto", "e venti", "e venticinque", "e mezza", "meno venticinque", "meno venti", "meno un quarto", "meno dieci", "meno cinque", "in punto"],
            "nextHour": [false, false, false, false, false, false, false, true, true, true, true, true, true],
            "verbFn": function(h) {
                return h === 1 ? "È " : "Sono ";
            },
            "suffix": "."
        });
    }

    // ── French (Pattern 4) ───────────────────────────────────────────────────
    // heuresFn returns the singular "heure" for hour 1, plural for all others.
    function generateTimeFr(time) {
        var slot = Math.round(time.getMinutes() / 5);
        var h12 = time.getHours() % 12;
        return pattern4(slot, h12, {
            "hours": ["douze", "une", "deux", "trois", "quatre", "cinq", "six", "sept", "huit", "neuf", "dix", "onze"],
            "phrases": ["pile", "cinq", "dix", "et quart", "vingt", "vingt-cinq", "et demie", "moins vingt-cinq", "moins vingt", "moins le quart", "moins dix", "moins cinq", "pile"],
            "nextHour": [false, false, false, false, false, false, false, true, true, true, true, true, true],
            "prefix": "Il est ",
            "heuresFn": function(h) {
                return h === 1 ? "heure" : "heures";
            },
            "suffix": "."
        });
    }

    // ── Dispatcher ───────────────────────────────────────────────────────────
    function generateTime(time) {
        var lang = Qt.locale().name.substring(0, 2);
        switch (lang) {
        case "da":
            return generateTimeDa(time);
        case "de":
            return generateTimeDe(time);
        case "es":
            return generateTimeEs(time);
        case "fr":
            return generateTimeFr(time);
        case "it":
            return generateTimeIt(time);
        case "nb":
        case "no":
            return generateTimeNb(time);
        case "nl":
            return generateTimeNl(time);
        case "pt":
            return generateTimePt(time);
        case "sv":
            return generateTimeSv(time);
        default:
            return generateTimeEn(time);
        }
    }

    anchors.fill: parent
    layer.enabled: true

    Text {
        id: prose

        // Declarative binding tracks both wallClock.time and root.fg (accessed
        // inside bright() during evaluation) as dependencies. The text therefore
        // updates on every time tick and on ambient mode transitions automatically.
        text: generateTime(wallClock.time)
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        lineHeight: 1
        color: root.dimColor
        x: root.width * 0.144
        y: root.height * 0.17
        width: Qt.locale().name.substring(0, 2) === "fr" ? root.width * 0.82 : root.width * 0.72

        font {
            family: root.displayFont
            weight: Font.Medium
            pixelSize: root.height * 0.155
            letterSpacing: -0.5
        }

    }

    Text {
        id: dateLabel

        // Qt.formatDate respects Qt.locale() — day and month names render
        // in the system language automatically.
        text: Qt.formatDate(wallClock.time, "ddd").toUpperCase() + " · " + Qt.formatDate(wallClock.time, "d MMM").toUpperCase()
        color: Qt.rgba(1, 1, 1, displayAmbient ? 0.45 : 0.55)

        font {
            family: root.dateFont
            weight: Font.Medium
            pixelSize: root.height * 0.04
            letterSpacing: root.height * 0.01
        }

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: parent.height * 0.1
        }

    }

    Connections {
        // Reinstalls a live binding after a locale change so the dispatcher
        // picks up the new Qt.locale() on subsequent wallClock ticks.
        function onChangesObserverChanged() {
            prose.text = Qt.binding(function() {
                return generateTime(wallClock.time);
            });
        }

        target: localeManager
    }

    layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: 0
        radius: 4
        samples: 9
        color: "#80000000"
    }

}
