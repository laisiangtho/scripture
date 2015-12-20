/*!
    laisiangtho -- the Holy Bible in languages
    Version 1.1.9
    https://khensolomonlethil.github.io/laisiangtho
    (c) 2013-2015
*/
(function(e, t) {
    var n = "laisiangtho", o = "1.9.86.2015.8.28";
    e.fn[n] = function(o) {
        help = {
            Agent: {
                o: "config",
                f: "Device"
            },
            Listen: {
                o: {},
                f: {}
            },
            Initiate: {
                o: {},
                f: [ "exe" ]
            },
            exe: {
                description: "exe only apply Prototype!",
                load: {
                    o: [ "fO", "config" ],
                    f: [ "new Database(db,fO,config)", "other", "init" ]
                },
                watch: {
                    o: {},
                    f: [ "exe", "is", "get" ]
                },
                Metalink: {
                    o: {},
                    f: [ "is", "get" ]
                }
            }
        };
        db = {}, fO = e.extend({
            E: [ "Action" ],
            App: n,
            Click: "click",
            On: null,
            Hash: "hashchange",
            Device: "desktop",
            Platform: "web",
            Layout: null,
            Browser: "chrome",
            fileSystask: "Chrome",
            Orientation: {
                change: "D1699",
                landscape: "landscape",
                portrait: "portrait"
            },
            note: {},
            lang: {},
            query: {},
            lookup: {
                setting: {},
                book: {}
            },
            previous: {},
            todo: {
                Orientation: true,
                Template: true
            },
            container: {},
            msg: {
                info: e("li#msg")
            }
        }, o);
        window.indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;
        var s, a = this, r = function() {
            this.arg = arguments;
            return this;
        };
        var l = window[fO.App] = function() {
            var e = arguments;
            function t() {
                r.apply(this, e);
            }
            t.prototype = Object.create(r.prototype);
            t.prototype.constructor = r;
            return new t();
        };
        r.prototype.tmp = function() {
            console.log("tmp");
        };
        r.prototype.ClickTest = function(e) {
            console.log("aaa");
        };
        r.prototype.load = function() {
            h = this.HTML();
            e("p").addClass(config.css.active).html(config.version);
            e("h1").attr({
                title: config.build
            }).attr({
                "class": "icon-fire"
            });
            var t = this, n = [], i = {}, o = {
                reading: function(e) {
                    if (config.bible.ready) {
                        if (fO.query.bible && config.bible.ready == 1) {
                            return fO.query.bible;
                        } else if (config.bible.ready == 2) {
                            return e;
                        } else {
                            return true;
                        }
                    } else {
                        return true;
                    }
                },
                start: function() {
                    var t = n.shift();
                    fO[t] = {};
                    if (fO.lang[t].info) {
                        e("p").html(fO.lang[t].info.name).promise().done(function() {
                            if (o.reading(t) == t) {
                                new l({
                                    bible: t,
                                    reading: t,
                                    downloading: t
                                }).xml(function(e) {
                                    o.next();
                                }).has();
                            } else {
                                o.next();
                            }
                        });
                    } else {
                        this.json(t, this.next);
                    }
                },
                json: function(s, a, r) {
                    var f = t.url(config.id, [ s ], config.file.lang);
                    var c = e.ajax({
                        url: (r ? r : "") + f.fileUrl,
                        dataType: f.fileExtension,
                        contentType: f.fileContentType,
                        cache: false
                    });
                    c.done(function(n) {
                        var r = n.info.lang = n.info.lang || config.language.info.lang;
                        fO.msg.info.html(n.info.name);
                        var f = function(n, i) {
                            var f = {};
                            return {
                                is: {
                                    index: function(e) {
                                        f[e] = fO.lang[s].index;
                                    },
                                    name: function(o) {
                                        f[o] = {};
                                        for (var s in n[o]) {
                                            var a = typeof i.b === "undefined" || typeof i.b[s] === "undefined" ? [] : [ i.b[s] ];
                                            var r = typeof i.name === "undefined" || typeof i.name[s] === "undefined" ? [] : i.name[s];
                                            e.merge(a, r);
                                            f[o][s] = e.unique(t.array(n[o][s]).merge(a).data);
                                        }
                                    }
                                },
                                merge: function() {
                                    for (var t in n) {
                                        if (this.is[t]) {
                                            this.is[t](t);
                                        } else {
                                            f[t] = i[t] ? e.extend({}, n[t], i[t]) : n[t];
                                        }
                                    }
                                    return f;
                                },
                                next: function() {
                                    e.extend(fO.lang[s], this.merge());
                                    e("p").html(r).attr({
                                        "class": "icon-database"
                                    }).promise().done(function() {
                                        new l({
                                            bible: s,
                                            reading: o.reading(s),
                                            downloading: o.reading(s)
                                        }).xml(function(e) {
                                            a();
                                        }).has();
                                    });
                                }
                            };
                        };
                        if (i[r]) {
                            f(i[r], n).next();
                        } else {
                            var c = t.url("lang", [ r ], config.file.lang), u = e.ajax({
                                url: c.fileUrl,
                                dataType: c.fileExtension,
                                contentType: c.fileContentType,
                                cache: false
                            });
                            u.done(function(e) {
                                i[r] = f(config.language, e).merge();
                                f(i[r], n).next();
                            });
                            u.fail(function(e, t) {
                                f(config.language, n).next();
                            });
                        }
                    });
                    c.fail(function(e, t) {
                        if (api.name) {
                            if (r) {
                                db.RemoveLang(s, function() {
                                    n.splice(n.indexOf(s), 1);
                                    a();
                                });
                            } else {
                                o.json(s, a, api.name);
                            }
                        } else {
                            db.RemoveLang(s, function() {
                                n.splice(n.indexOf(s), 1);
                                a();
                            });
                        }
                    });
                },
                next: function() {
                    if (n.length) {
                        o.start();
                    } else {
                        e(window).bind(fO.Hash, function() {
                            l().init();
                        });
                        function t() {
                            db.get({
                                table: config.store.note
                            }).then(function(e) {
                                if (e) {
                                    fO.note = e;
                                    o.done();
                                } else {
                                    db.add({
                                        table: config.store.note,
                                        data: config.store.noteData
                                    }).then(function(e) {
                                        fO.note = e;
                                        o.done();
                                    });
                                }
                            });
                        }
                        function i() {
                            db.get({
                                table: config.store.lookup
                            }).then(function(e) {
                                if (e) {
                                    fO.lookup = e;
                                    t();
                                } else {
                                    db.add({
                                        table: config.store.lookup,
                                        data: {
                                            setting: fO.lookup.setting,
                                            book: fO.lookup.book
                                        }
                                    }).then(function(e) {
                                        fO.lookup = e;
                                        t();
                                    });
                                }
                            });
                        }
                        db.update.lang().then(i);
                    }
                },
                available: function(n) {
                    if (n) {
                        fO.lang = t.array(config.bible.available, Object.keys(n)).merge().unique().reduce(function(t, i, o) {
                            if (e.isPlainObject(n[i])) {
                                t[i] = {
                                    index: n[i].index || n[i].index == 0 || o
                                };
                            } else {
                                t[i] = {
                                    index: o
                                };
                            }
                            return t;
                        }, {});
                    } else {
                        fO.lang = config.bible.available.reduce(function(e, t, n) {
                            e[t] = {
                                index: n
                            };
                            return e;
                        }, {});
                    }
                },
                done: function() {
                    if (fO.todo.Template) {
                        e(document.body).load(config.file.template.replace(/z/, fO.DeviceTemplate.join(".")), function() {
                            t.init();
                        }).promise().done(function() {
                            this.attr("id", fO.App);
                        });
                    } else {
                        if (fO.todo.RemoveID) {
                            e(document.body).attr("id", fO.App).removeClass().promise().done(function() {
                                this.children()[0].remove();
                                this.children().last().remove();
                                t.init();
                            });
                        }
                    }
                    e(document.body).keydown(function(e) {
                        if (e.which == 27) {
                            fO.todo.pause = true;
                        } else if (e.which == 13) {
                            fO.todo.enter = true;
                        }
                    });
                }
            };
            fO.msg.info.html("getting Database ready").attr({
                "class": "icon-database"
            });
            db = new this.Database(function() {
                fO.msg.info.html("getting Configuration ready").attr({
                    "class": "icon-config"
                });
                db.get({
                    table: config.store.info
                }).then(function(i) {
                    fO.msg.info.html("getting Language ready").attr({
                        "class": "icon-language"
                    });
                    e("p").attr({
                        "class": "ClickTest fO icon-language"
                    }).html("One more moment please");
                    db.get({
                        table: config.store.lang
                    }).then(function(e) {
                        fO.msg.info.attr({
                            "class": "icon-flag"
                        });
                        if (e) {
                            if (i && i.build == config.build) {
                                fO.Ready = 3;
                                fO.lang = e;
                                a();
                            } else {
                                fO.Ready = 2;
                                o.available(e);
                                a();
                            }
                        } else {
                            fO.Ready = 1;
                            o.available();
                            a();
                        }
                    });
                    function a() {
                        db.get({
                            table: config.store.query
                        }).then(function(e) {
                            if (e) {
                                fO.query = e;
                                r();
                            } else {
                                r();
                            }
                        });
                    }
                    function r() {
                        t.index();
                        n = config.bible.available.concat();
                        s = new fileSystask({
                            Base: "Other",
                            RequestQuota: 1073741824,
                            Permission: 0
                        }, {
                            success: function(e) {},
                            fail: function(e) {},
                            done: function(e) {
                                if (fO.Ready == 3) {
                                    o.start();
                                } else {
                                    db.add({
                                        table: config.store.info,
                                        data: {
                                            build: config.build,
                                            version: config.version
                                        }
                                    }).then(o.start());
                                }
                            }
                        });
                    }
                });
            });
        };
        r.prototype.Database = function(e) {
            var t = this;
            this.deleteDatabase = function() {
                return localforage.clear(function(e) {
                    return console.log(e || "Deleted entirely!");
                });
            }, this.add = function(e) {
                return localforage.setItem(e.table, e.data);
            };
            this.get = function(e) {
                return localforage.getItem(e.table);
            };
            this.read = function(e) {
                localforage.keys(e);
            };
            this.delete = function(e) {
                return localforage.removeItem(e.table);
            };
            this.UpdateQuery = function() {
                return this.put({
                    table: config.store.query,
                    data: fO.query
                });
            };
            this.UpdateLang = function() {
                return this.add({
                    table: config.store.lang,
                    data: fO.lang
                });
            };
            this.UpdateNote = function() {
                return this.put({
                    table: config.store.note,
                    data: fO.note
                });
            };
            this.UpdateLookUp = function() {
                return this.put({
                    table: config.store.lookup,
                    data: fO.lookup
                });
            };
            this.update = {
                query: function() {
                    return t.add({
                        table: config.store.query,
                        data: fO.query
                    });
                },
                lang: function() {
                    return t.add({
                        table: config.store.lang,
                        data: fO.lang
                    });
                },
                note: function() {
                    return t.add({
                        table: config.store.note,
                        data: fO.note
                    });
                },
                lookup: function() {
                    return t.add({
                        table: config.store.lookup,
                        data: fO.lookup
                    });
                }
            };
            this.remove = {
                query: function() {},
                lang: function(e, n) {
                    delete fO[e];
                    delete fO.lang[e];
                    config.bible.available.splice(config.bible.available.indexOf(e), 1);
                    t.update.lang().then(function() {
                        if (n) n();
                        return t;
                    });
                },
                note: function() {},
                lookup: function() {}
            };
            this.RemoveLang = function(e, t) {
                delete fO[e];
                delete fO.lang[e];
                config.bible.available.splice(config.bible.available.indexOf(e), 1);
                this.UpdateLang().then(function() {
                    if (t) t();
                });
            };
            localforage.config({
                name: config.store.name,
                storeName: "store",
                version: config.store.version,
                description: config.description,
                size: 3e8
            });
            localforage.setDriver([ localforage.INDEXEDDB, localforage.WEBSQL, localforage.LOCALSTORAGE ]);
            localforage.ready().then(function() {
                return e.apply(t);
            });
            return "!";
        };
        r.prototype.chapter = {
            name: {
                previous: function(e) {
                    e.arg[0].attr("title", this.text("next"));
                },
                current: function(e) {
                    e.arg[0].html(e.num(fO.query.chapter));
                },
                next: function(e) {
                    e.arg[0].attr("title", this.text("previous"));
                },
                has: {
                    next: function() {
                        var e = parseInt(fO.query.book), t = parseInt(fO.query.chapter) + 1;
                        if (bible.info[e].c < t) {
                            e++;
                            e = e > 66 ? 1 : e;
                            t = 1;
                        }
                        return {
                            book: e,
                            chapter: t
                        };
                    },
                    previous: function() {
                        var e = parseInt(fO.query.book), t = parseInt(fO.query.chapter) - 1;
                        if (t < 1) {
                            e--;
                            e = e < 1 ? 66 : e;
                            t = bible.info[e].c;
                        }
                        return {
                            book: e,
                            chapter: t
                        };
                    }
                },
                text: function(e) {
                    var t = this.has[e](), n = fO.lang[fO.query.bible];
                    return n.l.BFVBC.replace(/{b}/, n.b[t.book]).replace(/{c}/, l().num(t.chapter));
                }
            },
            next: function(e) {
                e.hash(2).hashChange(this.name.has.next());
            },
            previous: function(e) {
                e.hash(2).hashChange(this.name.has.previous());
            },
            book: function(e) {},
            list: function(t, n) {
                var i = t.arg[0].parent().children().eq(1);
                if (i.is(":hidden")) {
                    new t.menu(fO.query.book).chapter().appendTo(i.fadeIn(200).children().empty()).promise().done(function() {
                        this.children().on(fO.Click, function() {
                            fO.todo.ActiveChapter = e(this);
                        });
                        l(i).doClick(function(e) {
                            if (t.container.closest(i, e, t.arg[0])) {
                                t.container.fade(i, t.arg[0]);
                                return true;
                            }
                        });
                    });
                } else {
                    t.container.fade(i, t.arg[0]);
                }
            }
        };
        r.prototype.lookup = {
            setting: function(e) {
                var t = e.arg[0].parent().children().eq(1);
                if (t.is(":hidden")) {
                    e.arg[0].addClass(config.css.active);
                    new e.menu().lookup(t.fadeIn(200).children().empty()).promise().done(function() {
                        l(t).doClick(function(n) {
                            if (e.container.closest(t, n, e.arg[0])) {
                                e.container.fade(t, e.arg[0]);
                                return true;
                            }
                        });
                    });
                } else {
                    e.container.fade(t, e.arg[0]);
                }
            },
            msg: function(e) {
                fO.msg.lookup = e.arg[0];
                if (fO.query.result > 0) {
                    e.arg[0].text(e.num(fO.query.result)).attr("title", fO.query.q);
                } else {
                    e.arg[0].empty();
                }
            }
        };
        r.prototype.menu = function(t) {
            this.bible = function() {
                var n = e(h.ol, {
                    id: "dragable",
                    "class": "row row-bible"
                });
                config.bible.available.forEach(function(e) {
                    var i = {
                        bID: e,
                        lang: fO.lang[e].info,
                        local: fO.lang[e].local,
                        classOffline: "icon-ok offline",
                        classOnline: "icon-logout offline"
                    };
                    i.classAvailable = i.local ? config.css.available : config.css.notAvailable;
                    i.isAvailable = i.local ? i.classOffline : i.classOnline;
                    i.classActive = (fO.query.bible == e ? config.css.active : "") + " " + i.classAvailable;
                    t(i).appendTo(n);
                });
                return n;
            };
            this.chapter = function() {
                var n = e(h.ol, {
                    "class": "list-chapter"
                });
                e.each(bible.info[t].v, function(t, i) {
                    t++;
                    e(h.li, {
                        id: t,
                        "class": fO.query.chapter == t ? config.css.active : ""
                    }).append(e(h.a, {
                        href: l().hash(2) + e.param({
                            chapter: t
                        })
                    }).html(l().num(t)).append(e(h.sup).html(l().num(i)))).appendTo(n);
                });
                return n;
            };
            this.lookup = function(t) {
                var n = {
                    Query: function(t) {
                        t.each(function() {
                            var t = e(this);
                            t.children().each(function(t, i) {
                                var i = e(i), o = l(i).get("id").element[0];
                                i.toggleClass(config.css.active);
                                n.ID(o);
                            }).promise().done(function() {
                                n.Class(t);
                            });
                        });
                    },
                    Click: function(t, n) {
                        var i = e(t.target);
                        if (i.get(0).tagName.toLowerCase() === "p") {
                            this.Query(n);
                        } else {
                            var o = i.parents("li"), s = o.attr("id");
                            n.fadeToggle(100);
                            i.toggleClass(config.css.active).promise().done(function() {
                                if (this.hasClass(config.css.active)) {
                                    fO.lookup.setting[s] = true;
                                } else {
                                    delete fO.lookup.setting[s];
                                }
                            });
                        }
                        db.update.lookup();
                    },
                    Class: function(e) {
                        var t = e.children().length, n = e.children(l(config.css.active).is("class").name).length, i = e.parent().children().eq(0);
                        if (t === n) {
                            i.removeClass().addClass("yes");
                        } else if (n > 0) {
                            i.removeClass().addClass("some");
                        } else {
                            i.removeClass().addClass("no");
                        }
                    },
                    ID: function(e) {
                        if (fO.lookup.book[e]) {
                            delete fO.lookup.book[e];
                        } else {
                            fO.lookup.book[e] = {};
                        }
                    }
                }, t = e(h.ol, {
                    "class": "list-lookup"
                }).appendTo(t), i = fO.lang[fO.query.bible];
                e.each(bible.catalog, function(o, s) {
                    var a = Object.keys(config.language)[0] + o, r = fO.lookup.setting[a] ? config.css.active : "testament";
                    e(h.li, {
                        id: a,
                        "class": r
                    }).html(e(h.p, {
                        text: i.t[o]
                    }).on(fO.Click, function(t) {
                        n.Click(t, e(this).parent().children("ol").find("ol"));
                    }).append(e(h.span).text("+").addClass(r))).appendTo(t).promise().done(function() {
                        e(h.ol, {
                            "class": "section"
                        }).appendTo(this).promise().done(function() {
                            var t = this;
                            e.each(s, function(o, s) {
                                var a = Object.keys(config.language)[1] + o, r = fO.lookup.setting[a] ? config.css.active : "";
                                e(h.li, {
                                    id: a,
                                    "class": r
                                }).append(e(h.p, {
                                    text: i.s[o]
                                }).on(fO.Click, function(t) {
                                    n.Click(t, e(this).parent().children("ol"));
                                }).append(e(h.span, {
                                    text: "+"
                                }).addClass(r))).appendTo(t).promise().done(function() {
                                    var t = e(h.ol, {
                                        "class": "book"
                                    }).appendTo(this);
                                    s.forEach(function(o) {
                                        e(h.li, {
                                            id: o,
                                            "class": fO.lookup.book[o] ? config.css.active : ""
                                        }).text(i.b[o]).on(fO.Click, function() {
                                            e(this).toggleClass(config.css.active);
                                            n.ID(o);
                                            db.update.lookup();
                                        }).appendTo(t);
                                    });
                                    t.promise().done(function() {
                                        n.Class(t);
                                    });
                                });
                            });
                        });
                    });
                });
                return t;
            };
            this.tmp = function(e) {
                console.log("OK...");
            };
        };
        r.prototype.container = {
            msg: {
                info: function(e) {
                    fO.msg.info = e.arg[0];
                    return true;
                }
            },
            closest: function(t, n, i) {
                if (t.is(":visible") && !e(n.target).closest("#dialog, .misc").length && !e(n.target).closest(t).length && !e(n.target).closest(i).length) return true;
            },
            fade: function(e, t, n) {
                e.fadeOut(300).promise().done(function() {
                    t.removeClass(config.css.active);
                    if (n) n.removeAttr("style");
                });
            }
        };
        r.prototype.info = {
            about: {
                version: function() {
                    e(h.div, {
                        id: "dialog",
                        "class": "version"
                    }).append(e(h.div, {
                        id: "window"
                    }).append(e(h.h1, {
                        title: config.build
                    }).text(config.name), e(h.h2).text(config.version), e(h.p).html(config.aboutcontent), e(h.p, {
                        id: "by"
                    }).append(e(h.a, {
                        target: "_blank",
                        href: config.developerlink
                    }).text(config.developer)), e(h.div, {
                        id: "clickme"
                    }).html("Ok").on(fO.Click, function(t) {
                        t.stopImmediatePropagation();
                        e(this).parents("div").remove();
                    }))).appendTo("body").on(fO.Click, function(t) {
                        if (!e(t.target).closest("#window").length) {
                            e("#clickme").effect("highlight", {
                                color: "#F30C10"
                            }, 100);
                        }
                    });
                }
            }
        };
        r.prototype.doClick = function(t) {
            var n = this.arg[0];
            e(document).on(fO.Click, function(i) {
                if (n) {
                    if (n.is(":visible")) {
                        if (e.isFunction(t) && t(i)) {} else {}
                    }
                } else {
                    t(i);
                }
            });
        };
        r.prototype.url = function(e, t, n) {
            var i = this.string([ e, 47, t.join("/"), 46, n ]), o = i.substring(i.lastIndexOf("/") + 1), s = this.string([ "application", 47, n ]);
            return {
                fileName: o,
                fileExtension: n,
                fileUrl: i,
                fileCharset: s + ";charset=utf-8",
                fileContentType: s
            };
        };
        r.prototype.hash = function(e) {
            return this.string([ 35, config.page[e], 63 ]);
        };
        r.prototype.dot = function(e) {};
        r.prototype.num = function(e, t) {
            if (!t) t = fO.query.bible;
            if (fO.lang[t].hasOwnProperty("n")) {
                return Object.getOwnPropertyNames(fO.lang[t].n).length === 0 ? e : e.toString().replace(/[0123456789]/g, function(e) {
                    return fO.lang[t].n[e];
                });
            } else {
                return e;
            }
        };
        r.prototype.hashURI = function(e) {
            var t = location.hash, n = {
                page: t.split("?")[0].replace("#", "")
            }, i, o = /([^\?#&=]+)=([^&]*)/g, s = function(e) {
                return decodeURIComponent(e.replace(/\+/g, " "));
            };
            while (i = o.exec(t)) n[s(i[1])] = s(i[2]);
            e(n);
        };
        r.prototype.string = function(t) {
            return e.map(t, function(t) {
                return e.isNumeric(t) ? String.fromCharCode(t) : t;
            }).join("").toString();
        };
        r.prototype.index = function() {
            config.bible.available = [];
            e.map(fO.lang, function(e, t) {
                return {
                    id: t,
                    index: e.index
                };
            }).sort(function(e, t) {
                return e.index - t.index;
            }).forEach(function(e) {
                config.bible.available.push(e.id);
            });
        };
        r.prototype.array = function(t, n) {
            return {
                merge: function(i) {
                    if (e.type(i) === "array") n = i;
                    this.data = t = t.concat(n).sort(function(e, t) {
                        return e - t;
                    });
                    return this;
                },
                unique: function() {
                    return t.filter(function(e, n) {
                        return t.indexOf(e) === n;
                    });
                },
                removeIfduplicate: function(n) {
                    return e.map(t, function(e, n) {
                        t[n] === t[n + 1] && (t[n] = t[n + 1] = null);
                        return t[n];
                    });
                },
                to: function(e) {
                    return {
                        sentence: function(n) {
                            return t.length > 1 ? [ t.slice(0, -1).join(e || ", "), t.slice(-1)[0] ].join(n || " & ") : t[0];
                        }
                    };
                }
            };
        };
        r.prototype.working = function(t) {
            if (fO.msg.info.is(":hidden")) {
                e("body").addClass(config.css.working).promise().done(fO.msg.info.slideDown(200));
            }
            if (t.wait === true) {
                e("body").addClass(config.css.wait);
            }
            if (t.wait === false) {
                e("body").removeClass(config.css.wait);
            }
            if (t.disable === true) {
                e("body").addClass(config.css.disable);
            }
            return t.msg ? fO.msg.info.html(t.msg) : fO.msg.info;
        };
        r.prototype.done = function(t) {
            fO.msg.info.slideUp(200).empty().promise().done(function() {
                e("body").removeClass(config.css.working).removeClass(config.css.wait).removeClass(config.css.disable).promise().done(function() {
                    if (t) t();
                });
            });
        };
        r.prototype.template = function(t, n) {
            var o = e(), s = this.obj;
            var a = this;
            e.each(this.arg[0], function(t, n) {
                (function s(t, n, a, r) {
                    var f = n.attr, c = n.text, u = false, p = e(l(t).is("tag").name, f);
                    if (f && f.fn) {
                        u = n.attr.fn.split(" ");
                        delete f.fn;
                    }
                    if (e.type(c) === "string") {
                        p.html(c);
                    } else if (n.value) {
                        p.val(n.value);
                    } else if (!c) {} else {
                        for (i in c) {
                            if (e.isNumeric(i)) {
                                var t = Object.keys(c[i]);
                                s(t, c[i][t], p);
                            } else {
                                s(i, c[i], p);
                            }
                        }
                    }
                    if (r) {
                        o = a.add(p);
                    } else {
                        a.append(p);
                    }
                })(t, n, o, true);
            });
            if (t) {
                (e.type(t) !== "object" ? e(t) : t)[n || "append"](o);
            }
            return o;
        };
        r.prototype.activeClass = function(t) {
            return t.find(l(config.css.active).is("class").name).removeClass(config.css.active).promise().done(e(config.css.currentPage).addClass(config.css.active));
        };
        r.prototype.HTML = function() {
            return {
                ol: l("ol").is("tag").name,
                ul: l("ul").is("tag").name,
                li: l("li").is("tag").name,
                a: l("a").is("tag").name,
                div: l("div").is("tag").name,
                p: l("p").is("tag").name,
                h1: l("h1").is("tag").name,
                h2: l("h2").is("tag").name,
                h3: l("h3").is("tag").name,
                h4: l("h4").is("tag").name,
                span: l("span").is("tag").name,
                em: l("em").is("tag").name,
                sup: l("sup").is("tag").name
            };
        };
        r.prototype.init = function() {
            var t = this, n = {
                page: config.page[0],
                bible: config.bible.available[0],
                book: 1,
                testament: 1,
                catalog: 1,
                chapter: 1,
                verses: "",
                verse: "",
                q: "",
                result: ""
            };
            this.hashURI(function(t) {
                var i = {
                    page: function(t, n, i) {
                        fO.query[t] = e.inArray(n.toLowerCase(), config.page) >= 0 ? n : i;
                        config.css.currentPage = l(fO.query[t]).is("class").name;
                    },
                    bible: function(t, n, i) {
                        fO.query[t] = e.inArray(n.toLowerCase(), config.bible.available) >= 0 ? n : i;
                    },
                    book: function(n, i, o) {
                        if (e.isNumeric(i)) {
                            fO.query[n] = bible.book[i] ? i : o;
                        } else {
                            fO.query[n] = o;
                            var i = i.replace(new RegExp("-", "g"), " ").toLowerCase(), s = fO.lang[fO.query.bible].b;
                            for (var a in s) {
                                if (s[a].toLowerCase() == t || lang.b[a].toLowerCase() == i) {
                                    fO.query[n] = a;
                                    break;
                                }
                            }
                        }
                    },
                    testament: function(e, t, n) {
                        fO.query[e] = bible.info[fO.query.book].t;
                    },
                    catalog: function(e, t, n) {
                        fO.query[e] = bible.info[fO.query.book].s;
                    },
                    chapter: function(e, t, n) {
                        fO.query[e] = bible.info[fO.query.book].c >= t && t > 0 ? t : n;
                    },
                    verse: function(e, t, n) {
                        fO.query[e] = bible.info[fO.query.book].v[fO.query.chapter - 1] >= t ? t : n;
                    },
                    verses: function(e, t, n) {},
                    q: function(e, n, i) {
                        if (t.q) {
                            fO.query.q = t.q;
                        }
                    },
                    bookmark: function() {}
                };
                if (e.isEmptyObject(fO.query)) {
                    fO.query = e.extend({}, n, t);
                } else {
                    t.page = t.page ? t.page : fO.query.page;
                    e.extend(fO.query, t);
                }
                fO.query.loop(function(t, o) {
                    if (e.isFunction(i[t])) i[t](t, o, n[t]);
                });
            });
            e(config.css.header).find("*").removeClass(config.css.active).siblings(config.css.currentPage).addClass(config.css.active);
            var i = l("lookup").is("form").element;
            if (i.length) {
                i.off().on("submit", function() {
                    var t = e(this);
                    t.serializeObject(fO.query);
                    if (fO.query.page == t.attr("name")) {
                        t.find(l("q").is("input").name).attr("autocomplete", "off").focus().select().promise().done(function() {
                            if (fO.todo.lookup) {
                                console.log("already enter");
                            } else {
                                l().pagelookup();
                            }
                        });
                    } else {
                        t.attr("action").hashChange({
                            q: fO.query.q
                        });
                    }
                    return false;
                });
                l("search").is("input").element.off().on(fO.Click, function() {
                    e(this.form).submit();
                }).promise().done(function() {
                    l("q").is("input").element.attr("autocomplete", "off").focus().select();
                });
            }
            fO.container.main = e(config.css.content).children(config.css.currentPage);
            var o = "page" + fO.query.page, s = "page" + e(config.page).get(-1);
            fO.container.main.addClass(config.css.active).siblings().removeClass(config.css.active).promise().done(function() {
                t[e.isFunction(t[o]) ? o : s](t);
            });
            l("fn").is("attr").element.each(function(n, i) {
                var o = e(i), s = l(o).get("fn"), a = s.get("class").element, r = s.get("fn").split();
                if (t[a[0]]) {
                    r.unshift(a[0]);
                    l(o).exe(r);
                }
            }).promise().done(function() {
                db.update.query();
            });
            if (fO.todo.Orientation) {
                a.Orientation();
                delete fO.todo.Orientation;
            }
        };
        r.prototype.pagenote = function() {
            console.log("no note?");
        };
        r.prototype.pagetodo = function() {
            console.log("nothing todo?");
        };
        r.prototype.xml = function(t) {
            var n = this, i = this.arg[0];
            var o = fO.lang[i.bible], a = o.l, r = o.b;
            var l = this.url(config.id, [ i.bible ], config.file.bible);
            var f = [];
            this.has = function() {
                if (e.isEmptyObject(fO[i.bible].bible)) {
                    if (s.support) {
                        s.get({
                            fileOption: {},
                            fileUrlLocal: l.fileUrl,
                            fileReadAs: true,
                            before: function() {
                                f.push(i.bible.toUpperCase());
                            },
                            success: function(e) {
                                f.push("Found");
                                n.file.read(e.fileContent);
                            },
                            fail: function(e) {
                                f.push("NotFound");
                                if (i.bible == i.downloading) {
                                    f.push("SendTo");
                                    n.file.download(true);
                                } else {
                                    f.push("Sendback");
                                    n.ResponseGood(false);
                                }
                            }
                        });
                    } else if (window.indexedDB) {
                        f.push("Store");
                        db.get({
                            table: i.bible
                        }).then(function(t) {
                            if (t) {
                                if (e.isEmptyObject(t)) {
                                    f.push("Empty");
                                    if (i.bible == i.downloading) {
                                        f.push("SendTo");
                                        n.file.download(false);
                                    } else {
                                        f.push("Sendback");
                                        n.ResponseGood(false);
                                    }
                                } else {
                                    f.push("Reading");
                                    if (i.bible == i.reading) {
                                        fO[i.bible].bible = t;
                                        f.push("Success");
                                        n.ResponseGood(true);
                                    } else {
                                        f.push("Disabled");
                                        n.ResponseGood(true);
                                    }
                                }
                            } else {
                                f.push("NotFound");
                                if (i.bible == i.downloading) {
                                    f.push("SendTo");
                                    n.file.download(false);
                                } else {
                                    f.push("Sendback");
                                    n.ResponseGood(false);
                                }
                            }
                        });
                    } else {
                        f.push("fileSystemNotOk", "indexedDBNotOK");
                        if (i.bible == i.downloading) {
                            f.push("CanNotSetDownloadingTRUE");
                        }
                        f.push("Sendback");
                        n.ResponseGood(false);
                    }
                } else {
                    f.push("AlreadyInObject");
                    n.ResponseGood(true);
                }
                return this;
            };
            this.get = function() {
                if (e.isEmptyObject(fO[i.bible].bible)) {
                    if (s.support) {
                        s.get({
                            fileOption: {},
                            fileUrlLocal: l.fileUrl,
                            fileReadAs: true,
                            before: function() {
                                f.push(i.bible.toUpperCase());
                                n.working({
                                    msg: a.PleaseWait,
                                    wait: true
                                });
                            },
                            success: function(e) {
                                f.push("Found");
                                n.file.read(e.fileContent);
                            },
                            fail: function(e) {
                                f.push("NotFound", "SendTo");
                                n.file.download(true);
                            }
                        });
                    } else if (window.indexedDB) {
                        f.push("Store");
                        db.get({
                            table: i.bible
                        }).then(function(t) {
                            if (t) {
                                if (e.isEmptyObject(t)) {
                                    f.push("Empty", "SendTo");
                                    n.file.download(false);
                                } else {
                                    f.push("Reading");
                                    if (i.bible == i.reading) {
                                        fO[i.bible].bible = t;
                                        f.push("Success");
                                        n.ResponseGood(true);
                                    } else {
                                        f.push("Disabled");
                                        n.ResponseGood(true);
                                    }
                                }
                            } else {
                                f.push("NotFound", "SendTo");
                                n.ResponseGood(false);
                            }
                        });
                    } else {
                        f.push("fileSystemNotOk", "indexedDBNotOK");
                        f.push("GettingReadyForWeb");
                        n.file.download(false);
                    }
                } else {
                    f.push("AlreadyInObject");
                    n.ResponseCallbacks(true);
                }
                return this;
            };
            this.remove = function() {
                f.push(i.bible.toUpperCase());
                if (s.support) {
                    s.remove({
                        fileOption: {},
                        fileUrlLocal: l.fileUrl,
                        fileNotFound: true,
                        success: function(e) {
                            f.push("Removed");
                            n.ResponseBad(true);
                        },
                        fail: function(e) {
                            f.push("Fail");
                            n.ResponseBad(false);
                        }
                    });
                } else if (window.indexedDB) {
                    f.push("Store");
                    db.delete({
                        table: i.bible
                    }).then(function() {
                        f.push("Removed");
                        n.ResponseBad(true);
                    });
                } else {
                    f.push("fileSystemNotOk", "indexedDBNotOK");
                    f.push("NothingToRemove", "Sendback");
                    n.ResponseBad(false);
                }
            };
            this.file = {
                download: function(e) {
                    s.download({
                        fileOption: {
                            create: e
                        },
                        fileUrl: l.fileUrl,
                        fileUrlLocal: true,
                        before: function(e) {
                            f.push("Downloading");
                            n.working({
                                msg: a.Downloading,
                                wait: true
                            });
                        },
                        progress: function(e) {
                            n.working({
                                msg: a.PercentLoaded.replace(/{Percent}/, n.num(e, i.bible))
                            });
                        },
                        fail: function(e) {
                            f.push("Fail");
                            n.ResponseGood(false);
                        },
                        success: function(e) {
                            f.push("Success");
                            if (e.fileCreation === true) {
                                f.push("AndSaved");
                            } else {
                                f.push("NotSaved");
                            }
                            n.file.read(e.fileContent);
                        }
                    });
                },
                read: function(e) {
                    f.push("Reading");
                    if (!i.downloading || i.bible == i.reading) {
                        this.content(e);
                    } else {
                        f.push("Disabled");
                        n.ResponseGood(true);
                    }
                },
                content: function(e) {
                    f.push(l.fileExtension.toUpperCase());
                    n.JobType(new DOMParser().parseFromString(e, l.fileContentType));
                }
            };
            this.JobType = function(t) {
                var n = e(t).children().get(0).tagName;
                f.push(n);
                if (e.isFunction(this.Job[n])) {
                    fO[i.bible].bible = {
                        info: {},
                        book: {}
                    };
                    this.Job[n](t);
                } else {
                    f.push("NotFound");
                    this.ResponseGood(false);
                }
            };
            this.Job = {
                bible: function(t) {
                    var o = [], a = [], l = 0;
                    e(t).children().each(function(t, o) {
                        var a = e(o), l = a.children(), c = a.attr("id");
                        if (l.length) {
                            l.each(function(t, o) {
                                var a = e(o), c = a.children(), o = a.attr("id"), u = a.get(0).tagName.toLowerCase(), p = 0;
                                if (e.type(fO[i.bible].bible[u]) === "undefined") fO[i.bible].bible[u] = {};
                                if (c.length) {
                                    fO[i.bible].bible[u][o] = {};
                                    setTimeout(function() {
                                        c.each(function(a, r) {
                                            var d = e(r), h = d.children(), r = d.attr("id"), g = d.get(0).tagName.toLowerCase();
                                            if (e.type(fO[i.bible].bible[u][o][g]) === "undefined") fO[i.bible].bible[u][o][g] = {};
                                            if (h.length) {
                                                fO[i.bible].bible[u][o][g][r] = {};
                                                fO[i.bible].bible[u][o][g][r].verse = {};
                                                setTimeout(function() {
                                                    h.each(function(p, d) {
                                                        var b = e(d), m = b.children(), d = b.attr("id"), v = b.get(0).tagName.toLowerCase();
                                                        d = "v" + d;
                                                        fO[i.bible].bible[u][o][g][r].verse[d] = {};
                                                        fO[i.bible].bible[u][o][g][r].verse[d].text = b.text();
                                                        if (b.attr("ref")) fO[i.bible].bible[u][o][g][r].verse[d].ref = b.attr("ref").split(",");
                                                        if (b.attr("title")) fO[i.bible].bible[u][o][g][r].verse[d].title = b.attr("title").split(",");
                                                        if (l.length == t + 1) {
                                                            if (c.length == a + 1) {
                                                                if (h.length == p + 1) {
                                                                    if (s.support) {
                                                                        f.push("Success");
                                                                        n.ResponseGood(true);
                                                                    } else if (window.indexedDB) {
                                                                        f.push("Stored");
                                                                        db.add({
                                                                            table: i.bible,
                                                                            data: fO[i.bible].bible
                                                                        }).then(n.ResponseGood(true));
                                                                    } else {
                                                                        f.push("NotStored");
                                                                        n.ResponseGood(true);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    });
                                                }, 30 / t * a);
                                            } else if (r) {
                                                fO[i.bible].bible[u][o][g][r] = d.text();
                                            } else {
                                                p++;
                                                fO[i.bible].bible[u][o][g][p] = {
                                                    title: d.text()
                                                };
                                                if (d.attr("ref")) fO[i.bible].bible[u][o][g][p].ref = d.attr("ref").split(",");
                                            }
                                        }).promise().done(function() {
                                            fO.msg.info.html(r[o]);
                                        });
                                    }, 90 * t);
                                } else {
                                    fO[i.bible].bible[u][o] = a.text();
                                }
                            });
                        } else {
                            var u = a.attr("id"), p = a.text();
                        }
                    });
                }
            };
            this.ResponseGood = function(e) {
                o.local = e;
                var t = o.local.toString().toUpperCase();
                f.push("LangVariableUpdatedAs", t);
                f.push("LangDB");
                if (i.reading) {
                    f.push("NotUpdatedDueToReadingIsTrue");
                    n.ResponseCallbacks(e);
                } else {
                    db.update.lang().then(function() {
                        f.push("UpdatedAs", t);
                        n.done();
                        n.ResponseCallbacks(e);
                    });
                }
                return this;
            };
            this.ResponseBad = function(e) {
                delete fO[i.bible].bible;
                f.push("Lang");
                if (e) o.local = false;
                var t = o.local.toString().toUpperCase();
                if (e) {
                    f.push("Removed");
                    db.update.lang().then(function() {
                        f.push("AndVariableUpdatedAs", t);
                        n.done();
                        n.ResponseCallbacks(true);
                    });
                } else {
                    f.push("ButVariableUpdatedAs", t);
                    n.ResponseCallbacks(true);
                }
                return this;
            };
            this.ResponseCallbacks = function(e) {
                this.msg = f.join(" ");
                t({
                    msg: this.msg,
                    status: e
                });
            };
            return this;
        };
        r.prototype.pagebible = function(t) {
            var n = this.hash(1);
            fO.container.main.html(e(h.div, {
                "class": "wrp wrp-bible"
            })).children().html(new this.menu(function(i) {
                return e(h.li, {
                    id: i.bID,
                    "class": i.classActive
                }).html(e(h.p).append(e(h.span, {
                    "class": i.isAvailable
                }).on(fO.Click, function(n) {
                    n.preventDefault();
                    var o = e(this), s = o.parents("li");
                    if (fO.msg.info.is(":hidden")) fO.todo.bibleOption = false;
                    if (fO.todo.bibleOption === i.bID) {
                        t.done(function() {
                            delete fO.todo.bibleOption;
                        });
                    } else if (s.hasClass(config.css.notAvailable)) {
                        t.working({
                            msg: e(h.ul, {
                                "class": "data-dialog"
                            }).append(e(h.li).append(e(h.p).html(fO.lang[i.bID].l.WouldYouLikeToAdd.replace(/{is}/, o.parent().children("a").text()))), e(h.li).append(e(h.span, {
                                "class": "yes icon-thumbs-up-alt"
                            }).on(fO.Click, function(e) {
                                e.preventDefault();
                                new l({
                                    bible: i.bID
                                }).xml(function(e) {
                                    if (e.status) {
                                        s.removeClass(config.css.notAvailable).addClass(config.css.available);
                                        o.removeClass(i.classOnline).addClass(i.classOffline);
                                    }
                                }).get();
                            }), e(h.span, {
                                "class": "no icon-thumbs-down-alt"
                            }).on(fO.Click, function(e) {
                                e.preventDefault();
                                t.done(function() {
                                    delete fO.todo.bibleOption;
                                });
                            }))),
                            wait: true
                        });
                    } else {
                        fO.todo.bibleOption = i.bID;
                        t.working({
                            msg: e(h.ul, {
                                "class": "data-dialog"
                            }).append(e(h.li).append(e(h.p).html(fO.lang[i.bID].l.WouldYouLikeToRemove.replace(/{is}/, o.parent().children("a").text()))), e(h.li).append(e(h.span, {
                                "class": "yes icon-thumbs-up-alt"
                            }).on(fO.Click, function(e) {
                                e.preventDefault();
                                s.removeClass(config.css.available).addClass(config.css.notAvailable);
                                o.removeClass(i.classOffline).addClass(i.classOnline);
                                t.working({
                                    msg: fO.lang[i.bID].l.PleaseWait,
                                    wait: true
                                }).promise().done(function() {
                                    s.removeClass(config.css.available).addClass(config.css.notAvailable);
                                    o.removeClass(i.classOffline).addClass(i.classOnline);
                                    new l({
                                        bible: i.bID
                                    }).xml(function(e) {
                                        t.done(function() {
                                            delete fO.todo.bibleOption;
                                        });
                                    }).remove();
                                });
                            }), e(h.span, {
                                "class": "no icon-thumbs-down-alt"
                            }).on(fO.Click, function(e) {
                                e.preventDefault();
                                t.done(function() {
                                    delete fO.todo.bibleOption;
                                });
                            }))),
                            wait: true
                        });
                    }
                }), e(h.a, {
                    href: n + e.param({
                        bible: i.bID
                    })
                }).html(i.lang.name), e(h.span, {
                    "class": "icon-menu drag"
                })));
            }).bible()).promise().done(function(n) {
                this.children().sortable({
                    handle: ".drag",
                    containment: "parent",
                    helper: ".dsdfd",
                    placeholder: "ghost",
                    forcePlaceholderSize: true,
                    opacity: .7,
                    update: function(n, i) {
                        e(this).children().each(function(t, n) {
                            fO.lang[e(n).get(0).id].index = e(n).index();
                        }).promise().done(function() {
                            db.update.lang().then(t.index);
                        });
                    }
                });
            });
        };
        r.prototype.pagebook = function(t) {
            var n = this.hash(2), i = fO.lang[fO.query.bible];
            fO.container.main.html(e(h.div, {
                "class": "wrp wrp-book"
            }));
            e.each(bible.catalog, function(t, o) {
                var s = i.t[t];
                e(h.ol, {
                    "class": "testament",
                    id: t
                }).append(e(h.li, {
                    id: "t-" + t
                }).html(e(h.h1, {
                    text: s
                }))).appendTo(fO.container.main.children()).promise().done(function() {
                    e(h.ol, {
                        "class": "catalog"
                    }).appendTo(this.children()).promise().done(function(t) {
                        e.each(o, function(o, s) {
                            var a = i.s[o];
                            e(h.li, {
                                id: "c-" + o
                            }).append(e(h.h2, {
                                text: a
                            })).appendTo(t).promise().done(function(t) {
                                e(h.ol, {
                                    "class": "book"
                                }).appendTo(this);
                                s.forEach(function(o) {
                                    var s = i.b[o];
                                    e(h.li, {
                                        id: "b-" + o,
                                        "class": fO.query.book == o ? config.css.active : ""
                                    }).append(e(h.p).append(e(h.a, {
                                        href: n + e.param({
                                            book: o
                                        })
                                    }).html(s))).appendTo(t.children()[1]);
                                });
                            });
                        });
                    });
                });
            });
        };
        r.prototype.pagereader = function() {
            new this.content(fO.query).chapter(fO.container.main.children());
        };
        r.prototype.pagelookup = function() {
            new this.content(fO.query).lookup(fO.container.main.children());
        };
        r.prototype.content = function(t, n) {
            var i = this, o = fO.lang[t.bible], s = o.l, a = o.b;
            this.Num = function(e) {
                return l().num(e, t.bible);
            };
            function r(n) {
                var o = this;
                this.Result = {
                    Book: 0,
                    Chapter: 0,
                    Verse: 0,
                    Str: "",
                    Booklist: {}
                };
                this.get = function(e) {
                    return e(this);
                };
                this.xml = function(e) {
                    new l({
                        bible: t.bible
                    }).xml(function(t) {
                        e(t);
                    }).get();
                };
                this.verseMerge = function(t, n) {
                    return e(t).map(function(e, t) {
                        var i = n, o = i.split("-");
                        if (i == t) {
                            return t;
                        } else if (o.length > 1 && o[0] <= t && o[1] >= t) {
                            return t;
                        }
                    }).get();
                };
                this.verseRegex = function(t, n) {
                    if (e.type(n) === "string") {
                        if (t.search(new RegExp(n, "gi")) > -1) {
                            return true;
                        } else {
                            return false;
                        }
                    } else {
                        return true;
                    }
                };
                this.verseReplace = function(t, n) {
                    if (e.type(n) === "string") {
                        return t.replace(new RegExp(n, "i"), "<b>$&</b>");
                    } else {
                        return t;
                    }
                };
                this.verseSearch = function(e) {
                    if ((this.LIST.length ? this.verseMerge(this.LIST, this.VID) : [ this.VID ]).length && this.verseRegex(this.VERSE.text, e)) {
                        return true;
                    }
                };
                this.query = {
                    chapter: function() {
                        o.Result.Booklist[t.book] = {};
                        o.Result.Booklist[t.book][t.chapter] = [];
                        this.is = function() {
                            return fO.previous.bible !== t.bible || fO.previous.chapter !== t.chapter;
                        };
                        return o.Result.Booklist;
                    },
                    list: function() {
                        return o.Result.BooklistName = Object.keys(o.Result.Booklist).join();
                    },
                    book: function() {
                        o.Result.Booklist = {};
                        if (Object.getOwnPropertyNames(fO.lookup.book).length > 0) {
                            e.each(fO.lookup.book, function(t, n) {
                                o.Result.Booklist[t] = {};
                                if (e.isEmptyObject(n)) {
                                    e.each(bible.info[t].v, function(e, n) {
                                        e++;
                                        o.Result.Booklist[t][e] = [];
                                    });
                                } else {
                                    o.Result.Booklist[t] = n;
                                }
                            });
                            return o.Result.Booklist;
                        }
                    },
                    regex: function() {
                        return o.Result.Booklist = new f(t).is(t.q);
                    },
                    prev: function() {
                        if (t.booklist) {
                            o.Result.Booklist = t.booklist;
                            return o.Result.Booklist;
                        }
                    },
                    lookup: function(e) {
                        this.callbackBibleBefore = e;
                        this.is = function() {
                            var e = fO.previous.booklist != this.list() || fO.previous.q != t.q;
                            this.callbackBibleBeforeHas = new f(t).is(t.q) ? "" : t.q;
                            if (e) {}
                            return e;
                        };
                        return this.prev() || this.regex() || this.book();
                    }
                };
                this.book = function(s) {
                    var r = new e.Deferred(), l = {
                        task: {
                            bible: Object.keys(s),
                            chapter: [],
                            verse: []
                        },
                        BookID: function() {
                            o.BID = l.task.bible.shift();
                            o.BNA = a[o.BID];
                            l.task.chapter = Object.keys(s[o.BID]);
                        },
                        ChapterID: function() {
                            o.CID = l.task.chapter.shift();
                            o.CNA = i.Num(o.CID);
                            o.LIST = s[o.BID][o.CID];
                            l.task.verse = Object.keys(o.LIST);
                        },
                        VerseID: function() {
                            o.VID = l.task.verse.shift();
                        },
                        isNew: function() {
                            o.Result.Verse++;
                            if (o.Result.b !== o.BID) {
                                o.Result.b = o.BID;
                                o.Result.Book++;
                                o.Result.NewBook = true;
                            } else {
                                o.Result.NewBook = false;
                            }
                            if (o.Result.b !== o.BID || o.Result.c !== o.CID) {
                                o.Result.c = o.CID;
                                o.Result.Chapter++;
                                o.Result.NewChapter = true;
                            } else {
                                o.Result.NewChapter = false;
                            }
                        },
                        start: function() {
                            fO.todo.lookup = true;
                            delete fO.todo.pause;
                            l.BookID();
                            l.next();
                        },
                        next: function() {
                            l.ChapterID();
                            l.done().progress(function() {
                                r.notify();
                            }).fail(function() {
                                r.reject();
                                delete fO.todo.lookup;
                            }).done(function() {
                                if (l.task.chapter.length) {
                                    l.next();
                                } else if (l.task.bible.length) {
                                    l.start();
                                } else {
                                    r.resolve();
                                    delete fO.todo.lookup;
                                }
                            });
                        },
                        done: function() {
                            var s = fO[t.bible].bible.book[o.BID], a = s.chapter[o.CID], r = a.verse;
                            var f = new e.Deferred();
                            (function c(e) {
                                setTimeout(function() {
                                    if (e.length) {
                                        var t = e.shift();
                                        o.VID = t.slice(1);
                                        o.VNA = i.Num(o.VID);
                                        o.VERSE = r[t];
                                        if (fO.todo.pause) {
                                            f.reject();
                                            delete fO.todo.pause;
                                        } else {
                                            if (o.query.callbackBibleBefore) {
                                                if (o[o.query.callbackBibleBefore](o.query.callbackBibleBeforeHas)) {
                                                    l.isNew();
                                                    n(o).progress(function() {
                                                        f.notify();
                                                    }).fail(function() {
                                                        f.reject();
                                                    }).done(function() {
                                                        c(e);
                                                    });
                                                } else {
                                                    f.notify();
                                                    c(e);
                                                }
                                            } else {
                                                l.isNew();
                                                n(o).progress(function() {
                                                    f.notify();
                                                }).fail(function() {
                                                    f.reject();
                                                }).done(function() {
                                                    c(e);
                                                });
                                            }
                                        }
                                    } else {
                                        f.resolve();
                                    }
                                });
                            })(Object.keys(r));
                            return f.promise();
                        }
                    };
                    return r.promise(l.start());
                };
            }
            this.Example = function(n) {
                var i, o, a, f;
                new r(function(t) {
                    var n = new e.Deferred();
                    var i = s.BFVBC.replace(/{b}/, t.BNA).replace(/{c}/, t.CNA);
                    if (t.Result.NewBook) {
                        console.log("yes new book", t.BNA);
                    } else {
                        console.log("no old book", t.BNA);
                    }
                    n.notify();
                    n.resolve();
                    return n.promise();
                }).get(function(i) {
                    i.xml(function(o) {
                        if (o.status) {
                            if (i.query.lookup("verseSearch")) {
                                if (i.query.is()) {
                                    f = e(h.ol, {
                                        "class": t.bible
                                    }).appendTo(n);
                                    i.book(i.Result.Booklist).progress(function(e) {
                                        var t = s.BFVBC.replace(/{b}/, i.BNA).replace(/{c}/, i.CNA);
                                        l().working({
                                            msg: t
                                        });
                                    }).done(function() {
                                        console.log("Example.done");
                                    }).fail(function() {}).always(function() {
                                        l().done();
                                    });
                                } else {
                                    console.log("Ob.query.is empty");
                                }
                            } else {
                                console.log("Ob.query.lookup empty");
                            }
                        } else {
                            console.log("download fail");
                        }
                    });
                });
            };
            this.chapter = function(n) {
                var i, o, s, a;
                new r(function(n) {
                    var s = new e.Deferred();
                    if (n.Result.NewBook) {
                        i = e(h.ol).appendTo(e(h.li, {
                            id: n.BID,
                            "class": "bID"
                        }).append(e(h.div).append(e(h.h2).text(n.BNA))).appendTo(a));
                    }
                    if (n.Result.NewChapter) {
                        o = e(h.ol, {
                            "class": "verse"
                        }).appendTo(e(h.li, {
                            id: n.CID,
                            "class": "cID"
                        }).append(e(h.div).append(e(h.h3, {
                            "class": "no"
                        }).text(n.CNA).on(fO.Click, function() {
                            e(this).parents("li").children("ol").children().each(function() {
                                if (e(this).attr("id")) e(this).toggleClass(config.css.active);
                            });
                        }))).appendTo(i));
                    }
                    if (n.VERSE.title) {
                        e(h.li, {
                            "class": "title"
                        }).html(n.VERSE.title.join(", ")).appendTo(o);
                    }
                    e(h.li, {
                        id: n.VID,
                        "data-verse": n.VNA
                    }).html(n.verseReplace(n.VERSE.text, t.q)).appendTo(o).on(fO.Click, function() {
                        e(this).toggleClass(config.css.active);
                    }).promise().always(function() {
                        s.resolve();
                    });
                    return s.promise();
                }).get(function(i) {
                    i.xml(function(o) {
                        if (o.status) {
                            if (i.query.chapter()) {
                                if (i.query.is()) {
                                    if (fO.todo.containerEmpty) {
                                        delete fO.todo.containerEmpty;
                                    } else {
                                        n.empty();
                                    }
                                    a = e(h.ol, {
                                        "class": t.bible
                                    }).appendTo(n);
                                    i.book(i.Result.Booklist).progress(function() {}).done(function() {}).always(function() {
                                        fO.previous.bible = t.bible;
                                        fO.previous.book = t.book;
                                        fO.previous.chapter = t.chapter;
                                    });
                                } else {
                                    console.log("same chapter");
                                }
                            } else {
                                console.log("selected chapter could not find");
                            }
                        } else {
                            console.log("DownloadNotSuccess");
                        }
                    });
                });
            };
            this.lookup = function(n) {
                var o, a, f, c;
                new r(function(n) {
                    var i = new e.Deferred();
                    i.notify();
                    if (n.Result.NewBook) {
                        o = e(h.ol).appendTo(e(h.li, {
                            id: n.BID,
                            "class": "bID"
                        }).append(e(h.div).append(e(h.h2).text(n.BNA))).appendTo(c));
                    }
                    if (n.Result.NewChapter) {
                        a = e(h.ol, {
                            "class": "verse"
                        }).appendTo(e(h.li, {
                            id: n.CID,
                            "class": "cID"
                        }).append(e(h.div).append(e(h.h3, {
                            "class": "no"
                        }).text(n.CNA).on(fO.Click, function() {
                            e(this).parents("li").children("ol").children().each(function() {
                                if (e(this).attr("id")) e(this).toggleClass(config.css.active);
                            });
                        }))).appendTo(o));
                    }
                    if (n.VERSE.title) {
                        e(h.li, {
                            "class": "title"
                        }).html(n.VERSE.title.join(", ")).appendTo(a);
                    }
                    e(h.li, {
                        id: n.VID,
                        "data-verse": n.VNA
                    }).html(n.verseReplace(n.VERSE.text, t.q)).appendTo(a).on(fO.Click, function() {
                        e(this).toggleClass(config.css.active);
                    }).promise().always(function() {
                        i.resolve();
                    });
                    return i.promise();
                }).get(function(o) {
                    o.xml(function(a) {
                        if (a.status) {
                            if (o.query.lookup("verseSearch")) {
                                if (o.query.is()) {
                                    if (fO.todo.containerEmpty) {
                                        delete fO.todo.containerEmpty;
                                    } else {
                                        n.empty();
                                    }
                                    c = e(h.ol, {
                                        "class": t.bible
                                    }).appendTo(n);
                                    o.book(o.Result.Booklist).progress(function(e) {
                                        var t = s.BFVBC.replace(/{b}/, o.BNA).replace(/{c}/, o.CNA);
                                        fO.msg.lookup.html(i.Num(o.Result.Verse));
                                        l().working({
                                            msg: t
                                        });
                                    }).done(function() {}).fail(function() {}).always(function() {
                                        fO.previous.booklist = o.Result.BooklistName;
                                        fO.previous.q = t.q;
                                        t.result = o.Result.Verse;
                                        fO.msg.lookup.attr("title", t.q);
                                        l().done();
                                    });
                                } else {
                                    console.log("Ob.query.is same");
                                }
                            } else {
                                console.log("Ob.query.lookup empty");
                            }
                        } else {
                            console.log("download fail");
                        }
                    });
                });
            };
        };
        function f(e) {
            var t = fO.lang[e.bible].name, n = bible.info, o, s, a, r, l = {
                book: ";",
                chapter: ",",
                verse: "-"
            };
            this.result = {};
            this.search = function(e) {
                var n;
                for (var i in t) {
                    var o = t[i].map(function(e) {
                        return e.toLowerCase();
                    }).indexOf(e.trim().toLowerCase());
                    if (o >= 0) {
                        n = i;
                        break;
                    }
                }
                return parseInt(n);
            };
            this.options = function() {
                if (!this.result[o]) this.result[o] = {};
                if (s <= n[o].c) {
                    var e = n[o].v[s - 1];
                    if (!this.result[o][s]) this.result[o][s] = [];
                    if (a && r) {
                        var t = a <= e ? a : e, l = r <= e ? r : e;
                        for (i = t; i < l + 1; i++) {
                            this.push(this.result[o][s], i);
                        }
                    } else if (a) {
                        this.push(this.result[o][s], a <= e ? a : e);
                    }
                } else if (Object.getOwnPropertyNames(this.result[o]).length === 0) {
                    delete this.result[o];
                }
            };
            this.push = function(e, t) {
                if (e.indexOf(t) <= 0) {
                    e.push(t);
                    e.sort(function(e, t) {
                        return e > t ? 1 : e < t ? -1 : 0;
                    });
                }
            };
            this.nameVerse = function(e) {
                var t;
                function n(e, t) {
                    var n = e.toString().slice(-1) != l.verse ? l.verse : "";
                    return e + n + t;
                }
                e.filter(function(e, i, o) {
                    var s = parseInt(e), a = parseInt(o[i - 1]), r = parseInt(o[i + 1]);
                    if (i == 0) {
                        t = s;
                    } else if (s >= a + 1) {
                        if (s > a + 1) {
                            t = t + l.chapter + s;
                        } else if (s + 1 < r) {
                            t = n(t, s);
                        } else {
                            if (i == o.length - 1) {
                                if (s > a) {
                                    t = n(t, s);
                                }
                            } else {
                                t = n(t, "");
                            }
                        }
                    }
                });
                return t;
            };
            this.obj = function(e) {
                for (var t in e) {
                    o = t;
                    for (var n in e[t]) {
                        s = n;
                        for (var i in e[t][n]) {
                            var f = e[t][n][i].split(l.verse);
                            a = parseInt(f[0]), r = f.length > 1 ? parseInt(f[1]) : false;
                            this.options();
                        }
                    }
                }
                return this;
            };
            this.ref = function(e) {
                if (!Array.isArray(e)) e = e.split(l.book);
                for (var t in e) {
                    var n = /(((\w+)\.(\d+)\.(\d+))([\-–]?)?((\w+)\.(\d+)\.(\d+))?)/.exec(e[t]);
                    if (Array.isArray(n)) {
                        o = this.search(n[3]);
                        if (o) {
                            s = parseInt(n[4]), a = parseInt(n[5]), r = parseInt(n[10]);
                            this.options();
                        }
                    }
                }
                return this;
            };
            this.str = function(e) {
                if (!Array.isArray(e)) e = e.split(l.book);
                for (var t in e) {
                    if (e[t]) {
                        var n = e[t].trim().split(l.chapter);
                        for (var i in n) {
                            if (i == 0) {
                                var f = /(\d?(\w+?)?(\s?)\w+(\s+?)?(\s?)\w+(\s+?))?((\d+)((\s+)?\:?(\s+)?)?)((\d+)([\-–])?(\d+)?)?/.exec(n[i]);
                                if (f && f[1]) {
                                    o = this.search(f[1]);
                                    if (o) {
                                        s = parseInt(f[8]), a = parseInt(f[13]), r = parseInt(f[15]);
                                        this.options();
                                    } else {
                                        break;
                                    }
                                } else {
                                    break;
                                }
                            } else if (o) {
                                var f = /(\s?(\d+?)(\s+)?\:(\s+)?)?(\s?\d+)?(\s?(\d+?)?([\-–])?(\s?\d+)?)/.exec(n[i]);
                                if (f) {
                                    s = parseInt(f[2]) || s, a = parseInt(f[5]), r = parseInt(f[9]);
                                    this.options();
                                } else {
                                    break;
                                }
                            }
                        }
                    }
                }
                return this;
            };
            this.is = function(e) {
                if (Object.getOwnPropertyNames(this.str(e).result).length > 0) {
                    return this.result;
                } else if (Object.getOwnPropertyNames(this.ref(e).result).length > 0) {
                    return this.result;
                }
            };
        }
        r.prototype.watch = function() {
            a.on(fO.Click, l(fO.On).is("class").name, function() {
                l(e(this)).exe(l(e(this)).get("class").element);
            });
        };
        r.prototype.metalink = function() {
            this.arg[0].loop(function(e, t) {
                window[t] = l(t).is("link").get("href");
            });
        };
        r.prototype.metacontent = function() {
            this.arg[0].loop(function(e, t) {
                window[t] = l(t).is("meta").get("content");
            });
        };
        r.prototype.exe = function(t) {
            var n = this.arg[0], i = this[t[0]];
            if (i) {
                if (e.isFunction(i)) {
                    return l(n)[t[0]](t);
                } else {
                    i = i[t[1]];
                    if (i) {
                        if (e.isFunction(i)) {
                            return l(n)[t[0]][t[1]](this, t);
                        } else {
                            i = i[t[2]];
                            if (i) {
                                if (e.isFunction(i)) {
                                    return l()[t[0]][t[1]][t[2]](this, t);
                                }
                            }
                        }
                    }
                }
            }
            return false;
        };
        r.prototype.is = function(t) {
            var n = this.arg[0], i = "*";
            this.class = function() {
                return this.name = ".*".replace(i, n);
            };
            this.id = function() {
                return this.name = "#*".replace(i, n);
            };
            this.tag = function() {
                this.name = "<*>".replace(i, n);
                return n;
            };
            this.link = function() {
                return this.name = 'link[rel="*"]'.replace(i, n);
            };
            this.form = function() {
                return this.name = 'form[name="*"]'.replace(i, n);
            };
            this.input = function() {
                return this.name = 'input[name="*"]'.replace(i, n);
            };
            this.meta = function() {
                return this.name = 'meta[name="*"]'.replace(i, n);
            };
            this.attr = function() {
                return this.name = "[*]".replace(i, n);
            };
            this.fn = function(t) {
                this.element = e(t);
                this.arg[0] = this.element;
                return this;
            };
            if (e.isFunction(this[t])) {
                return this.fn(this[t]());
            } else if (this[t]) {
                return this[t];
            } else {
                return this;
            }
        };
        r.prototype.get = function(t) {
            var n = this.arg[0], i = {
                id: "-",
                "class": " "
            };
            this.class = function() {
                return this.name = n.attr("class");
            };
            this.id = function() {
                return this.name = n.attr("id");
            };
            this.content = function() {
                return this.name = n.attr("content");
            };
            this.href = function() {
                return this.name = n.attr("href");
            };
            this.tag = function() {
                return this.name = n.get(0).tagName;
            };
            this.attr = function() {
                return this.name = n.attr(t);
            };
            this.check = function() {
                return this.name || "";
            };
            this.split = function(e) {
                e = e || " ";
                return this.check().split(e);
            };
            this.fe = function(e) {
                if (i[t]) {
                    this.element = this.split(i[t]);
                }
                return this;
            };
            if (e.isFunction(this[t])) {
                return this.fe(this[t]());
            } else if (this[t]) {
                return this[t];
            } else if (t) {
                return this.fe(this.attr());
            } else {
                return this;
            }
        };
        this.Agent = function(t) {
            fO.Orientation.evt = Object.prototype.hasOwnProperty.call(window, "onorientationchange") ? "orientationchange" : "resize";
            var n = {
                meta: [ {
                    type: "script",
                    name: "localforage.min"
                }, {
                    type: "script",
                    name: "data.bible"
                }, {
                    type: "script",
                    name: "data.config"
                } ],
                type: {
                    script: {
                        attr: {
                            src: null
                        },
                        extension: ".js",
                        dir: "js/"
                    },
                    link: {
                        attr: {
                            rel: "stylesheet",
                            href: null
                        },
                        extension: ".css",
                        dir: "css/"
                    }
                },
                m: this,
                go: function(e) {
                    var t = e.shift(), i = t.type, o = (t.dir || n.type[i].dir) + t.name + n.type[i].extension, s = document.createElement(i);
                    n.type[i].attr.loop(function(e, t) {
                        s[e] = t || o;
                    });
                    s.onload = function() {
                        fO.msg.info.html(t.name);
                        if (e.length) {
                            n.go(e);
                        } else {
                            n.m.Listen();
                        }
                    };
                    document.head.appendChild(s);
                }
            };
            n.go(e.merge(n.meta, this.Device.f1()));
            this.createProperty("Orientation", function() {
                e(config.css.content).css({
                    top: e(config.css.header).outerHeight(),
                    bottom: e(config.css.footer).outerHeight()
                });
            });
        };
        this.Listen = function() {
            if (fO.isCordova) {
                fO.msg.info.html("getting Device ready").attr({
                    "class": "icon-database"
                });
                document.addEventListener("deviceready", this.Initiate, false);
            } else {
                fO.msg.info.attr({
                    "class": "icon-database"
                });
                this.Initiate();
            }
        };
        this.Initiate = function() {
            fO.E.loop(function(t, n) {
                t = e.type(n) === "object" ? Object.keys(n)[0] : n;
                l(n[t]).exe(t.split(" "));
            });
        };
        this.Device = {
            name: {
                is: function(e) {
                    return t.toLowerCase().indexOf(e) !== -1;
                },
                ios: function() {
                    return this.iphone() || this.ipod() || this.ipad();
                },
                iphone: function() {
                    return !this.windows() && this.is("iphone");
                },
                ipod: function() {
                    return this.is("ipod");
                },
                ipad: function() {
                    return this.is("ipad");
                },
                android: function() {
                    return !this.windows() && this.is("android");
                },
                androidPhone: function() {
                    return this.android() && this.is("mobile");
                },
                androidTablet: function() {
                    return this.android() && !this.is("mobile");
                },
                blackberry: function() {
                    return this.is("blackberry") || this.is("bb10") || this.is("rim");
                },
                blackberryPhone: function() {
                    return this.blackberry() && !this.is("tablet");
                },
                blackberryTablet: function() {
                    return this.blackberry() && this.is("tablet");
                },
                windows: function() {
                    return this.is("windows");
                },
                windowsPhone: function() {
                    return this.windows() && this.is("phone");
                },
                windowsTablet: function() {
                    return this.windows() && (this.is("touch") && !this.windowsPhone());
                },
                fxos: function() {
                    return (this.is("(mobile;") || this.is("(tablet;")) && this.is("; rv:");
                },
                fxosPhone: function() {
                    return this.fxos() && this.is("mobile");
                },
                fxosTablet: function() {
                    return this.fxos() && this.is("tablet");
                },
                meego: function() {
                    return this.is("meego");
                },
                cordova: function() {
                    return window.cordova && location.protocol === "file:";
                },
                chrome: function() {
                    return fO.Platform === "chrome";
                },
                nodeWebkit: function() {
                    return typeof window.process === "object";
                },
                mobile: function() {
                    return this.androidPhone() || this.iphone() || this.ipod() || this.windowsPhone() || this.blackberryPhone() || this.fxosPhone() || this.meego();
                },
                tablet: function() {
                    return this.ipad() || this.androidTablet() || this.blackberryTablet() || this.windowsTablet() || this.fxosTablet();
                }
            },
            f3: function() {
                if (window.addEventListener) {
                    window.addEventListener(fO.Orientation.evt, this.f2, false);
                } else if (window.attachEvent) {
                    window.attachEvent(fO.Orientation.evt, this.f2);
                } else {
                    window[fO.Orientation.evt] = this.f2;
                }
                this.f2();
            },
            f2: function() {
                e(window.document.documentElement).attr({
                    "class": window.innerHeight / window.innerWidth < 1 ? fO.Orientation.landscape : fO.Orientation.portrait
                });
                if (Object.prototype.hasOwnProperty.call(this, "Orientation")) this.Orientation();
            },
            f1: function() {
                this.f3();
                var t = [], n = [], i = "mobile", o = "tablet", s = "ios", a = "android";
                fO.isCordova = this.name.cordova();
                fO.isChrome = this.name.chrome();
                if (!fO.Platform) fO.Platform = "web";
                if (!fO.Deploy) fO.Deploy = "desktop";
                if (this.name.mobile()) {
                    fO.Deploy = "mobile";
                } else if (this.name.tablet()) {
                    fO.Deploy = "tablet";
                } else {
                    if (e.isFunction(this.name[fO.Device])) {}
                }
                t.push(fO.Deploy, fO.Platform);
                if (this.name.ios()) {
                    fO.Device = "ios";
                } else if (this.name.android()) {
                    fO.Device = "android";
                } else if (e.isFunction(this.name[fO.Device])) {} else {
                    if (fO.Deploy != "desktop") {
                        fO.Deploy = "desktop";
                    }
                    fO.Device = "default";
                }
                t.push(fO.Device);
                fO.DeviceTemplate = [ fO.Device, fO.Platform, fO.Deploy ];
                var r = [], l = [];
                for (var f in t) {
                    l.push(t[f]);
                    var c = l.join(".");
                    r.push({
                        type: "link",
                        name: c
                    }, {
                        type: "script",
                        name: c
                    });
                }
                return r;
            }
        };
        return this;
    };
})(jQuery, navigator.userAgent);

(function() {
    "use strict";
    Object.defineProperties(Object.prototype, {
        loop: {
            value: function(e) {
                var t = {
                    object: function(t) {
                        for (var n in t) {
                            e(n, t[n], t);
                        }
                    },
                    array: function(t) {
                        for (var n = 0, i = t.length; n < i; n++) {
                            e(t, n, t[n]);
                        }
                    }
                };
                return t[typeof this](this);
            }
        },
        XMLHttp: {
            value: function(e, t) {
                var n = new XMLHttpRequest();
                n.open("GET", this, false);
                n.send();
                return n.responseText;
            }
        },
        hashChange: {
            value: function(e) {
                window.location.hash = this.toString() + jQuery.param(e);
            }
        },
        tagID: {
            value: function() {
                return document.getElementById(this);
            }
        },
        tagClass: {
            value: function() {
                return document.getElementsByClassName(this);
            }
        },
        tagName: {
            value: function() {
                return document.getElementsByTagName(this);
            }
        },
        attrNameAll: {
            value: function() {
                return document.querySelectorAll(this);
            }
        },
        attrName: {
            value: function() {
                return document.querySelector(this);
            }
        },
        createElement: {
            value: function() {
                return document.createElement(this);
            }
        },
        serializeObject: {
            value: function(e) {
                this.serializeArray().forEach(function(t) {
                    e[t.name] = t.value;
                });
                return e;
            }
        },
        makeProperty: {
            value: function(e, t) {
                Object.defineProperty(this, e, t);
            }
        },
        createProperties: {
            value: function(e) {
                Object.defineProperties(this, e);
            }
        },
        createProperty: {
            value: function(e, t) {
                this.makeProperty(e, {
                    value: t
                });
            }
        },
        hasProperty: {
            value: function(e) {
                return Object.prototype.hasOwnProperty.call(this, e);
            }
        }
    });
})();

/*!
    fileSystask -- Javascript file System task
    Version 1.0.2
    https://khensolomonlethil.github.io/laisiangtho/fileSystask
    (c) 2013-2015
*/
(function(e) {
    "use strict";
    window.requestfileSystask;
    window.resolvefileSystask;
    window[e] = function(e, t) {
        var n = this, i = {};
        var o = {
            base: {
                Chrome: {
                    RequestQuota: 1073741824
                },
                Cordova: {
                    RequestQuota: 0
                },
                Other: {
                    RequestQuota: 0
                }
            },
            message: {
                RequestFileSystem: "requestFileSystem API/Method supported!",
                NoRequestFileSystem: "No requestFileSystem API/Method!",
                PleaseSeeStatus: "Please see {status}!"
            },
            Callback: {
                before: function() {},
                progress: function() {},
                done: function() {},
                fail: function() {},
                success: function() {}
            },
            Arguments: function(e, t) {
                for (var n in t) {
                    if (t.hasOwnProperty(n) && n == 0) {
                        e = Object.assign({}, this.Callback, t[n]);
                    } else if (t.hasOwnProperty(n)) {
                        e = Object.assign({}, this.Callback, e, t[n]);
                    }
                }
                return e;
            },
            ReadAs: [ "readAsText", "readAsArrayBuffer", "readAsBinaryString", "readAsDataURL" ],
            extension: {
                mp3: {
                    ContentType: "audio/mp3"
                },
                mp4: {
                    ContentType: "audio/mp4"
                },
                txt: {
                    ContentType: "text/plain"
                },
                css: {
                    ContentType: "text/css"
                },
                avi: {
                    ContentType: "video/x-msvideo"
                },
                html: {
                    ContentType: "text/html"
                },
                mxml: {
                    ContentType: "application/xv+xml"
                },
                rss: {
                    ContentType: "application/rss+xml"
                },
                xml: {
                    ContentType: "application/xml"
                },
                js: {
                    ContentType: "application/javascript"
                },
                json: {
                    ContentType: "application/json"
                },
                xhtml: {
                    ContentType: "application/xhtml+xml"
                },
                pdf: {
                    ContentType: "application/pdf"
                },
                jpg: {
                    ContentType: "image/jpeg"
                },
                jpeg: {
                    ContentType: "image/jpeg"
                },
                png: {
                    ContentType: "image/png"
                },
                other: {
                    ContentType: "text/plain",
                    Charset: "UTF-8",
                    fileName: "Uknown",
                    fileExtension: ""
                }
            },
            Assigns: function(e) {
                var s = Object.keys(this.base).pop();
                if (e) {
                    if (typeof e === "object") {
                        if (e.Base && this.base.hasOwnProperty(e.Base)) {
                            Object.assign(i, this.base[e.Base], e);
                        } else {
                            Object.assign(i, this.base[s], e, {
                                Base: s
                            });
                        }
                    } else if (typeof e === "string" && this.base[e]) {
                        Object.assign(i, this.base[e], {
                            Base: e
                        });
                    } else {
                        Object.assign(i, this.base[s], {
                            Base: s
                        });
                    }
                } else {
                    Object.assign(i, this.base[s], {
                        Base: s
                    });
                }
                new Promise(function(e, t) {
                    o.Initiate[i.Base](function(t) {
                        i.Ok = true;
                        i.message = o.message.RequestFileSystem;
                        e(t);
                    }, function(e) {
                        i.Ok = false;
                        if (typeof e === "string") {
                            i.message = e;
                        } else if (e.message) {
                            i.message = e.message;
                            if (e.name) i.name = e.name;
                            if (e.code) i.code = e.code;
                        } else {
                            i.status = e;
                            i.message = o.message.PleaseSeeStatus;
                        }
                        t(i);
                    });
                }).then(function(e) {
                    p(t.success, e);
                }, function(e) {
                    p(t.fail, e);
                }).then(function() {
                    n.support = i.Ok;
                    p(t.done, i);
                });
            },
            Initiate: {
                Chrome: function(e, t) {
                    try {
                        navigator.webkitPersistentStorage.requestQuota(i.RequestQuota, function(n) {
                            i.ResponseQuota = n;
                            window.requestfileSystask = window.webkitRequestFileSystem;
                            window.resolvefileSystask = window.webkitResolveLocalFileSystemURL;
                            window.requestfileSystask(i.Permission > 0 ? window.PERSISTENT : window.TEMPORARY, n, function(t) {
                                i.Root = t.root.toURL();
                                e(t);
                            }, function(e) {
                                t(e);
                            });
                        }, function(e) {
                            t(e);
                        });
                    } catch (n) {
                        t(n);
                    } finally {}
                },
                Cordova: function(e, t) {
                    try {
                        window.requestfileSystask = window.requestFileSystem || window.webkitRequestFileSystem;
                        window.resolvefileSystask = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        if (window.requestfileSystask) {
                            if (window.LocalFileSystem) {
                                window.PERSISTENT = window.LocalFileSystem.PERSISTENT;
                                window.TEMPORARY = window.LocalFileSystem.TEMPORARY;
                            } else if (window.cordova && location.protocol === "file:") {}
                            window.requestfileSystask(i.Permission > 0 ? window.PERSISTENT : window.TEMPORARY, i.RequestQuota, function(t) {
                                i.Root = t.root.toURL();
                                e(t);
                            }, function(e) {
                                t(e);
                            });
                        } else {
                            t(o.message.NoRequestFileSystem);
                        }
                    } catch (n) {
                        t(n);
                    } finally {}
                },
                Other: function(e, t) {
                    try {
                        window.requestfileSystask = window.requestFileSystem || window.webkitRequestFileSystem;
                        window.resolvefileSystask = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        window.requestfileSystask(i.Permission > 0 ? window.PERSISTENT : window.TEMPORARY, i.RequestQuota, function(t) {
                            i.Root = t.root.toURL();
                            e(t);
                        }, function(e) {
                            t(e);
                        });
                    } catch (n) {
                        if (navigator.webkitPersistentStorage) {
                            this.Chrome(e, t);
                        } else {
                            t(n);
                        }
                    } finally {}
                }
            },
            Request: {
                Chrome: function(e, t) {
                    try {
                        navigator.webkitPersistentStorage.requestQuota(i.RequestQuota, function(n) {
                            i.ResponseQuota = n;
                            window.requestfileSystask(i.Permission > 0 ? window.PERSISTENT : window.TEMPORARY, n, function(t) {
                                i.Root = t.root.toURL();
                                e(t);
                            }, function(e) {
                                t(e);
                            });
                        }, function(e) {
                            t(e);
                        });
                    } catch (n) {
                        t(n);
                    } finally {
                        return window.requestfileSystask;
                    }
                },
                Cordova: function(e, t) {
                    try {
                        if (window.requestfileSystask) {
                            window.requestfileSystask(i.Permission > 0 ? window.PERSISTENT : window.TEMPORARY, i.RequestQuota, function(t) {
                                e(t);
                            }, function(e) {
                                t(e);
                            });
                        } else {
                            t(o.message.NoRequestFileSystem);
                        }
                    } catch (n) {
                        t(n);
                    } finally {
                        return window.requestfileSystask;
                    }
                },
                Other: function(e, t) {
                    try {
                        if (window.requestfileSystask) {
                            window.requestfileSystask(i.Permission > 0 ? window.PERSISTENT : window.TEMPORARY, i.RequestQuota, function(t) {
                                e(t);
                            }, function(e) {
                                t(e);
                            });
                        } else {
                            t(o.message.NoRequestFileSystem);
                        }
                    } catch (n) {
                        t(n);
                    } finally {
                        return window.requestfileSystask;
                    }
                }
            },
            Resolve: {
                Chrome: function(e, t, n) {
                    try {
                        navigator.webkitPersistentStorage.requestQuota(i.RequestQuota, function(o) {
                            i.ResponseQuota = o;
                            window.resolvefileSystask(e, t, n);
                        }, function(e) {
                            n(e);
                        });
                    } catch (o) {
                        n(o);
                    } finally {
                        return window.resolvefileSystask;
                    }
                },
                Cordova: function(e, t, n) {
                    try {
                        window.resolvefileSystask(e, t, n);
                    } catch (i) {
                        n(i);
                    } finally {
                        return window.resolvefileSystask;
                    }
                },
                Other: function(e, t, n) {
                    try {
                        window.resolvefileSystask(e, t, n);
                    } catch (i) {
                        n(i);
                    } finally {
                        return window.resolvefileSystask;
                    }
                }
            }
        };
        o.Assigns(e);
        function s(e, t) {
            e.fileUrlLocal = e.fileUrlLocal.replace(/[\#\?].*$/, "");
            n.request(function(n, i) {
                n.root.getFile(e.fileUrlLocal, e.fileOption, function(e) {
                    t(1, e);
                }, function(e) {
                    t(2, n.root);
                });
            }, function(e) {
                t(3, e);
            });
        }
        function a(e, t, n) {
            e.getFile(t.fileUrlLocal, t.fileOption, function(e) {
                if (t.fileContent && t.fileContentType) {
                    f(e, t, function(e, t) {
                        n(e, t);
                    });
                } else {
                    r(e, t, function(e, t) {
                        n(e, t);
                    });
                }
            }, function(e) {
                n(false, e);
            });
        }
        function r(e, t, n) {
            e.file(function(i) {
                if (t.fileReadAs) {
                    var s = new FileReader();
                    s.onloadstart = function(e) {
                        t.before(e);
                    };
                    s.onprogress = function(e) {
                        t.progress(e);
                    };
                    s.onabort = function(e) {
                        n(false, e);
                    };
                    s.onerror = function(e) {
                        n(false, e);
                    };
                    s.onload = function(e) {
                        n(true, this.result);
                    };
                    if (o.ReadAs === true) {
                        t.fileReadAs = o.ReadAs[0];
                    } else if (o.ReadAs.indexOf(t.fileReadAs) < 0) {
                        t.fileReadAs = o.ReadAs[0];
                    }
                    s[t.fileReadAs](i);
                } else {
                    n(true, e);
                }
            }, function(e) {
                n(false, e);
            });
        }
        function l(e, t, n) {
            e.remove(function(e) {
                n(true, e);
            }, function(e) {
                n(false, e);
            });
        }
        function f(e, t, n) {
            e.createWriter(function(e) {
                e.onwriteend = function(e) {
                    this.onwriteend = null;
                    this.truncate(this.position);
                    n(true, t.fileContent);
                };
                e.onerror = function() {
                    n(false, this);
                };
                if (!t.fileContentType) {
                    if (!t.fileExtension) {
                        t.fileExtension = t.fileUrlLocal.split(".").pop();
                    }
                    if (o.extension[t.fileExtension]) {
                        t.fileContentType = o.extension[t.fileExtension].ContentType;
                    } else {
                        t.fileContentType = o.extension.other.ContentType;
                    }
                }
                e.write(new Blob([ t.fileContent ], {
                    type: t.fileContentType
                }));
            }, function(e) {
                n(false, e);
            });
        }
        function c(e, t, n) {
            if (t[0] == "." || t[0] == "") {
                t = t.slice(1);
            }
            e.getDirectory(t[0], {
                create: true
            }, function(e) {
                if (t.length) {
                    c(e, t.slice(1), n);
                } else {
                    n(true);
                }
            }, function(e) {
                n(false, e);
            });
        }
        function u(e) {
            var t = e.split("/").slice(0, -1);
            if (t.length >= 1) {
                return t;
            } else {
                return false;
            }
        }
        function p(e, t) {
            if (typeof e === "function") {
                return e(t);
            } else {
                return t;
            }
        }
        this.setting = function(e) {
            return o.Assigns(e);
        };
        this.permission = function() {};
        this.request = function(e, t) {
            if (i.Ok === false) {
                return p(t, i);
            }
            return o.Request[i.Base](function(t) {
                return p(e, t);
            }, function(e) {
                if (typeof e !== "string") {
                    if (e.message) {
                        e = e.message;
                    }
                }
                return p(t, e);
            });
        };
        this.resolve = function(e, t, n) {
            if (i.Ok === false) {
                return p(n, i);
            }
            return o.Resolve[i.Base](e, function(e) {
                return p(t, e);
            }, function(e) {
                if (typeof e !== "string") {
                    if (e.message) {
                        e = e.message;
                    }
                }
                return p(n, e);
            });
        };
        this.get = function(e) {
            e = o.Arguments(e, arguments);
            return new Promise(function(t, n) {
                s(e, function(i, o) {
                    if (i == 1) {
                        if (e.fileOption.create === true && e.fileContent && e.fileContentType) {
                            f(o, e, function(i, o) {
                                if (i) {
                                    t(e);
                                } else {
                                    n(o);
                                }
                            });
                        } else {
                            r(o, e, function(i, o) {
                                e.fileContent = o;
                                if (i) {
                                    t(e);
                                } else {
                                    n(fileWriterMsg);
                                }
                            });
                        }
                    } else if (i == 2) {
                        var s = u(e.fileUrlLocal);
                        if (s && e.fileOption.create === true && e.fileContent && e.fileContentType) {
                            c(o, s, function(i, s) {
                                if (i) {
                                    a(o, e, function(i, o) {
                                        if (i) {
                                            t(e);
                                        } else {
                                            n(o);
                                        }
                                    });
                                } else {
                                    n(s);
                                }
                            });
                        } else {
                            n(o);
                        }
                    } else {
                        n(o);
                    }
                });
            }).then(function(t) {
                e.success(t);
                return t;
            }, function(t) {
                e.fail(t);
                return t;
            }).then(function(t) {
                e.done(t);
                return t;
            });
        };
        this.remove = function(e) {
            e = o.Arguments(e, arguments);
            return new Promise(function(t, n) {
                s(e, function(i, o) {
                    if (i == 1) {
                        l(o, e, function(e, i) {
                            if (e) {
                                t(o);
                            } else {
                                n(i);
                            }
                        });
                    } else if (i == 2) {
                        if (e.fileNotFound) {
                            t(o);
                        } else {
                            n(o);
                        }
                    } else {
                        n(o);
                    }
                });
            }).then(function(t) {
                e.success(t);
                return t;
            }, function(t) {
                e.fail(t);
                return t;
            }).then(function(t) {
                e.done(t);
                return t;
            });
        };
        this.download = function(e) {
            e = o.Arguments(e, arguments);
            return new Promise(function(t, n) {
                var r = window.XMLHttpRequest ? new XMLHttpRequest() : new ActiveXObject("Microsoft.XMLHTTP");
                var l = 0;
                r.addEventListener("progress", function(t) {
                    l++;
                    if (t.lengthComputable) {
                        l = Math.floor(t.loaded / t.total * 100);
                        e.progress(l);
                    } else if (r.readyState == XMLHttpRequest.DONE) {
                        e.progress(100);
                    } else if (r.status != 200) {
                        e.progress(Math.floor(l / 7 * 100));
                        l++;
                    }
                }, false);
                r.addEventListener("load", function(l) {
                    e.fileUrlResponse = l.target.responseURL;
                    e.fileName = e.fileUrl.replace(/[\#\?].*$/, "").substring(e.fileUrl.lastIndexOf("/") + 1);
                    e.fileExtension = e.fileName.split(".").pop();
                    if (e.fileUrlLocal) {
                        if (e.fileUrlLocal === true) {
                            var p = e.fileUrl.match(/\/\/[^\/]+\/([^\.]+)/);
                            if (p) {
                                e.fileUrlLocal = p[1].replace(/[\#\?].*$/, "");
                            } else {
                                e.fileUrlLocal = e.fileUrl.replace(/[\#\?].*$/, "");
                            }
                        } else {
                            e.fileUrlLocal = e.fileUrlLocal.replace(/[\#\?].*$/, "");
                        }
                    } else {
                        e.fileUrlLocal = e.fileName;
                    }
                    if (l.target.responseXML) {
                        e.fileCharset = l.target.responseXML.charset;
                        e.fileContentType = l.target.responseXML.contentType;
                    } else {
                        e.fileCharset = "UTF-8";
                        if (o.extension[e.fileExtension]) {
                            e.fileContentType = o.extension[e.fileExtension].ContentType;
                        }
                    }
                    e.responseXML = l.target.responseXML;
                    e.responseURL = l.target.responseURL;
                    if (r.status == 200) {
                        e.fileSize = l.total;
                        e.fileContent = l.target.responseText;
                        if (typeof e.fileOption == "object" && e.fileOption.create === true && e.fileUrlLocal && i.Ok === true) {
                            s(e, function(i, o) {
                                if (i == 1) {
                                    f(o, e, function(i, o) {
                                        if (i) {
                                            e.fileCreation = true;
                                            t(e);
                                        } else {
                                            e.fileCreation = o;
                                            n(e);
                                        }
                                    });
                                } else if (i == 2) {
                                    var s = u(e.fileUrlLocal);
                                    if (s) {
                                        c(o, s, function(i, s) {
                                            if (i) {
                                                a(o, e, function(i, o) {
                                                    if (i) {
                                                        e.fileCreation = true;
                                                        t(e);
                                                    } else {
                                                        e.fileCreation = o;
                                                        n(e);
                                                    }
                                                });
                                            } else {
                                                e.fileCreation = s;
                                                n(e);
                                            }
                                        });
                                    } else {
                                        e.fileCreation = o;
                                        n(e);
                                    }
                                } else {
                                    e.fileCreation = o;
                                    n(e);
                                }
                            });
                        } else {
                            e.fileCreation = false;
                            t(e);
                        }
                    } else if (r.statusText) {
                        n({
                            message: r.statusText + ": " + e.fileUrl,
                            code: r.status
                        });
                    } else if (r.status) {
                        n({
                            message: "Error",
                            code: r.status
                        });
                    } else {
                        n({
                            message: "Unknown Error",
                            code: 0
                        });
                    }
                }, false);
                r.addEventListener("error", function(e) {
                    n(e);
                }, false);
                r.addEventListener("abort", function(e) {
                    n(e);
                }, false);
                if (e.fileCache) {
                    e.fileUrlRequest = e.fileUrl + (e.fileUrl.indexOf("?") > 0 ? "&" : "?") + "_=" + new Date().getTime();
                } else {
                    e.fileUrlRequest = e.fileUrl;
                }
                if (e.fileUrl) {
                    r.open(e.requestMethod ? e.requestMethod : "GET", e.fileUrlRequest, true);
                    e.before(r);
                    r.send();
                } else {
                    n({
                        message: "fileUrl not provided",
                        code: 0
                    });
                }
            }).then(function(t) {
                e.success(t);
                return t;
            }, function(t) {
                e.fail(t);
                return t;
            }).then(function(t) {
                e.done(t);
                return t;
            });
        };
        this.save = function(e) {
            e = o.Arguments(e, arguments);
            return new Promise(function(t, n) {
                s(e, function(i, o) {
                    if (i == 1) {
                        f(o, e, function(i, o) {
                            if (i) {
                                t(e);
                            } else {
                                n(o);
                            }
                        });
                    } else if (i == 2) {
                        var s = u(e.fileUrlLocal);
                        if (s) {
                            c(o, s, function(i, s) {
                                if (i) {
                                    a(o, e, function(i, o) {
                                        if (i) {
                                            t(e);
                                        } else {
                                            n(o);
                                        }
                                    });
                                } else {
                                    n(o);
                                }
                            });
                        } else {
                            n(o);
                        }
                    } else {
                        n(o);
                    }
                });
            }).then(function(t) {
                e.success(t);
                return t;
            }, function(t) {
                e.fail(t);
                return t;
            }).then(function(t) {
                e.done(t);
                return t;
            });
        };
    };
})("fileSystask");