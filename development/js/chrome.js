var app, isUpgraded = "upgraded";

chrome.runtime.onInstalled.addListener(function(e) {
    var i = chrome.runtime.getManifest();
    if (e.previousVersion) {
        if (e.previousVersion != i.version) {
            chrome.notifications.create(isUpgraded, {
                type: "basic",
                iconUrl: "img/icon.128.png",
                title: i.name + " has been upgraded",
                message: "Version " + i.version + ". Thoughts and opinions are most welcome via Chrome Web Store!",
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
    chrome.app.window.create("chrome.package.html", {
        frame: "none",
        id: "laisiangtho",
        innerBounds: {
            width: 700,
            height: 500,
            left: 600,
            minWidth: 300,
            minHeight: 400
        }
    }, function(e) {
        app = e.contentWindow;
        var i = {
            data: {
                jquery: {
                    type: "script"
                },
                "jquery.ui": {
                    type: "script"
                },
                "chrome.google-analytics-bundle": {
                    type: "script"
                },
                "jquery.laisiangtho": {
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
                var i = e.shift(), n = this.data[i].type, t = this, a = this[n].dir + (this.data[i].dir ? this.data[i].dir : "") + i + this[n].extension;
                var o = app.document.createElement(n);
                for (var s in this[n].attr) {
                    o[s] = this[n].attr[s] ? this[n].attr[s] : a;
                }
                o.onload = function() {
                    if (e.length) {
                        t.load(e);
                    } else {
                        t.done();
                    }
                };
                app.document.head.appendChild(o);
            },
            done: function() {
                app.localStorage = chrome.storage.local;
                app.screenStatus = e;
                app.laisiangtho = {};
            },
            ready: function() {
                app.jQuery(app.document).laisiangtho({
                    E: [ "Load", "Watch", {
                        "Meta link": [ "api" ]
                    } ],
                    Device: "chrome",
                    Platform: "app",
                    App: "laisiangtho",
                    Click: "click",
                    On: "zO"
                }).Agent({
                    win: {
                        minimize: function() {
                            e.minimize();
                        },
                        maximize: function(i) {
                            if (e.isFullscreen() || e.isMaximized()) e.restore(); else e.maximize();
                        },
                        fullscreen: function(i, n) {
                            if (e.isFullscreen()) e.restore(); else e.fullscreen();
                        },
                        close: function(i) {
                            e.close();
                        }
                    },
                    analytics: {
                        config: function(e) {
                            e.setTrackingPermitted(app.config.google.analytics.permission);
                        },
                        service: function() {
                            this.service = app.analytics.getService(app.config.name);
                            this.service.getConfig().addCallback(this.config);
                            this.tracker = this.service.getTracker(app.config.google.analytics.tracker);
                        },
                        sendPage: function(e) {},
                        sendEvent: function(e) {}
                    }
                });
            }
        };
        app.addEventListener("DOMContentLoaded", function(e) {
            i.init();
        });
        app.addEventListener("load", function(e) {
            i.ready();
        }, false);
        e.onBoundsChanged.addListener(function() {});
        e.onClosed.addListener(function() {});
        e.onRestored.addListener(function() {
            if (!e.isFullscreen()) app.laisiangtho.screen.Full.is();
            if (!e.isMaximized()) app.laisiangtho.screen.Max.is();
        });
        e.onFullscreened.addListener(function() {
            app.laisiangtho.screen.Full.is(true);
        });
        e.onMaximized.addListener(function() {
            app.laisiangtho.screen.Max.is(true);
        });
        e.onMinimized.addListener(function() {});
        e.focus();
    });
});