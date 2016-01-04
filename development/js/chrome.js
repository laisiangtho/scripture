var app, isUpgraded = "upgraded";

chrome.runtime.onInstalled.addListener(function(e) {
    var t = chrome.runtime.getManifest();
    if (e.previousVersion) {
        if (e.previousVersion != t.version) {
            chrome.notifications.create(isUpgraded, {
                type: "basic",
                iconUrl: "img/icon.128.png",
                title: t.name + " has been upgraded",
                message: "Version " + t.version + ". Thoughts and opinions are most welcome via Chrome Web Store!",
                isClickable: true
            });
        } else {}
    } else {}
});

chrome.notifications.onClicked.addListener(function(e) {
    if (e == "upgraded") {
        window.open("https://chrome.google.com/webstore/detail/lai-siangtho/ahbpjkapcngbdcenpkflgmbpeigjlbpc", "target=_blank");
    }
});

chrome.runtime.onSuspend.addListener(function() {});

chrome.runtime.onUpdateAvailable.addListener(function() {});

chrome.app.runtime.onLaunched.addListener(function() {
    chrome.app.window.create("index.html", {
        frame: "none",
        id: "laisiangtho",
        innerBounds: {
            width: 700,
            height: 500,
            left: 600,
            minWidth: 330,
            minHeight: 400
        }
    }, function(e) {
        app = e.contentWindow;
        var t = {
            data: {
                jquery: {
                    type: "script"
                },
                "jquery.ui": {
                    type: "script"
                },
                "jquery.ui.touchpunch.min": {
                    type: "script"
                },
                "chrome.google-analytics-bundle": {
                    type: "script"
                },
                laisiangtho: {
                    type: "script"
                }
            },
            script: {
                attr: {
                    src: ""
                },
                extension: ".js",
                dir: "js/"
            },
            link: {
                attr: {
                    rel: "stylesheet",
                    type: "text/css",
                    href: ""
                },
                extension: ".css",
                dir: "css/"
            },
            init: function() {
                this.load(Object.keys(this.data));
            },
            load: function(e) {
                var t = e.shift(), i = this.data[t].type, n = this, a = this[i].dir + (this.data[t].dir ? this.data[t].dir : "") + t + this[i].extension;
                var o = app.document.createElement(i);
                for (var r in this[i].attr) {
                    o[r] = this[i].attr[r] ? this[i].attr[r] : a;
                }
                o.onload = function() {
                    if (e.length) {
                        n.load(e);
                    } else {
                        n.done();
                    }
                };
                app.document.head.appendChild(o);
            },
            done: function() {
                app.localStorage = chrome.storage.local;
                app.screenStatus = e;
            },
            ready: function() {
                app.jQuery(app.document.body).laisiangtho({
                    E: [ {
                        metalink: [ "api" ]
                    }, "load", "watch" ],
                    Device: "chrome",
                    Platform: "app",
                    App: "laisiangtho",
                    Click: "click",
                    On: "fO"
                }).Agent();
            }
        };
        app.addEventListener("DOMContentLoaded", function(e) {
            t.init(e);
        });
        app.addEventListener("load", function(e) {
            t.ready(e);
        }, false);
    });
});