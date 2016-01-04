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
        window.indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;
        var s = e.extend({
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
        }, o), a, l, r = {}, c = this, f = function() {
            this.arg = arguments;
            return this;
        }, u = function() {
            var e = arguments;
            function t() {
                f.apply(this, e);
            }
            t.prototype = Object.create(f.prototype);
            t.prototype.constructor = f;
            return new t();
        };
        window[s.App] = f;
        f.prototype.tmp = function() {
            console.log("tmp");
        };
        f.prototype.ClickTest = function(e) {
            console.log("aaa");
        };
        f.prototype.load = function() {
            h = this.HTML();
            l = this;
            e("p").addClass(config.css.active).html(config.version);
            e("h1").attr({
                title: config.build
            }).attr({
                "class": "icon-fire"
            });
            var t = [], n = {}, i = {
                reading: function(e) {
                    if (config.bible.ready) {
                        if (s.query.bible && config.bible.ready == 1) {
                            return s.query.bible;
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
                    var n = t.shift();
                    s[n] = {};
                    if (s.lang[n].info) {
                        e("p").html(s.lang[n].info.name).promise().done(function() {
                            if (i.reading(n) == n) {
                                new u({
                                    bible: n,
                                    reading: n,
                                    downloading: n
                                }).xml(function(e) {
                                    i.next();
                                }).has();
                            } else {
                                i.next();
                            }
                        });
                    } else {
                        this.json(n, this.next);
                    }
                },
                json: function(o, a, c) {
                    var f = l.url(config.id, [ o ], config.file.lang);
                    var p = e.ajax({
                        url: (c ? c : "") + f.fileUrl,
                        dataType: f.fileExtension,
                        contentType: f.fileContentType,
                        cache: false
                    });
                    p.done(function(t) {
                        var r = t.info.lang = t.info.lang || config.language.info.lang;
                        s.msg.info.html(t.info.name);
                        var c = function(t, n) {
                            var c = {};
                            return {
                                is: {
                                    index: function(e) {
                                        c[e] = s.lang[o].index;
                                    },
                                    name: function(i) {
                                        c[i] = {};
                                        for (var o in t[i]) {
                                            var s = typeof n.b === "undefined" || typeof n.b[o] === "undefined" ? [] : [ n.b[o] ];
                                            var a = typeof n.name === "undefined" || typeof n.name[o] === "undefined" ? [] : n.name[o];
                                            e.merge(s, a);
                                            c[i][o] = e.unique(l.array(t[i][o]).merge(s).data);
                                        }
                                    }
                                },
                                merge: function() {
                                    for (var i in t) {
                                        if (this.is[i]) {
                                            this.is[i](i);
                                        } else {
                                            c[i] = n[i] ? e.extend({}, t[i], n[i]) : t[i];
                                        }
                                    }
                                    return c;
                                },
                                next: function() {
                                    e.extend(s.lang[o], this.merge());
                                    e("p").html(r).attr({
                                        "class": "icon-database"
                                    }).promise().done(function() {
                                        new u({
                                            bible: o,
                                            reading: i.reading(o),
                                            downloading: i.reading(o)
                                        }).xml(function(e) {
                                            a();
                                        }).has();
                                    });
                                }
                            };
                        };
                        if (n[r]) {
                            c(n[r], t).next();
                        } else {
                            var f = l.url("lang", [ r ], config.file.lang), p = e.ajax({
                                url: f.fileUrl,
                                dataType: f.fileExtension,
                                contentType: f.fileContentType,
                                cache: false
                            });
                            p.done(function(e) {
                                n[r] = c(config.language, e).merge();
                                c(n[r], t).next();
                            });
                            p.fail(function(e, n) {
                                c(config.language, t).next();
                            });
                        }
                    });
                    p.fail(function(e, n) {
                        if (api.name) {
                            if (c) {
                                r.RemoveLang(o, function() {
                                    t.splice(t.indexOf(o), 1);
                                    a();
                                });
                            } else {
                                i.json(o, a, api.name);
                            }
                        } else {
                            r.RemoveLang(o, function() {
                                t.splice(t.indexOf(o), 1);
                                a();
                            });
                        }
                    });
                },
                next: function() {
                    if (t.length) {
                        i.start();
                    } else {
                        e(window).bind(s.Hash, function() {
                            u().init();
                        });
                        function n() {
                            r.get({
                                table: config.store.note
                            }).then(function(e) {
                                if (e) {
                                    s.note = e;
                                    i.done();
                                } else {
                                    r.add({
                                        table: config.store.note,
                                        data: config.store.noteData
                                    }).then(function(e) {
                                        s.note = e;
                                        i.done();
                                    });
                                }
                            });
                        }
                        function o() {
                            r.get({
                                table: config.store.lookup
                            }).then(function(e) {
                                if (e) {
                                    s.lookup = e;
                                    n();
                                } else {
                                    r.add({
                                        table: config.store.lookup,
                                        data: {
                                            setting: s.lookup.setting,
                                            book: s.lookup.book
                                        }
                                    }).then(function(e) {
                                        s.lookup = e;
                                        n();
                                    });
                                }
                            });
                        }
                        r.update.lang().then(o);
                    }
                },
                available: function(t) {
                    if (t) {
                        s.lang = l.array(config.bible.available, Object.keys(t)).merge().unique().reduce(function(n, i, o) {
                            if (e.isPlainObject(t[i])) {
                                n[i] = {
                                    index: t[i].index || t[i].index == 0 || o
                                };
                            } else {
                                n[i] = {
                                    index: o
                                };
                            }
                            return n;
                        }, {});
                    } else {
                        s.lang = config.bible.available.reduce(function(e, t, n) {
                            e[t] = {
                                index: n
                            };
                            return e;
                        }, {});
                    }
                },
                done: function() {
                    if (s.todo.Template) {
                        e(document.body).load(config.file.template.replace(/z/, s.DeviceTemplate.join(".")), function() {
                            e(this).attr("id", s.App);
                            l.init();
                        });
                    } else {
                        if (s.todo.RemoveID) {
                            e(document.body).attr("id", s.App).removeClass().promise().done(function() {
                                this.children()[0].remove();
                                this.children().last().remove();
                                l.init();
                            });
                        }
                    }
                    e(document.body).keydown(function(e) {
                        if (e.which == 27) {
                            s.todo.pause = true;
                        } else if (e.which == 13) {
                            s.todo.enter = true;
                        }
                    });
                }
            };
            s.msg.info.html("getting Database ready").attr({
                "class": "icon-database"
            });
            r = new this.Database(function() {
                s.msg.info.html("getting Configuration ready").attr({
                    "class": "icon-config"
                });
                r.get({
                    table: config.store.info
                }).then(function(n) {
                    s.msg.info.html("getting Language ready").attr({
                        "class": "icon-language"
                    });
                    e("p").attr({
                        "class": "ClickTest fO icon-language"
                    }).html("One more moment please");
                    r.get({
                        table: config.store.lang
                    }).then(function(e) {
                        s.msg.info.attr({
                            "class": "icon-flag"
                        });
                        if (e) {
                            if (n && n.build == config.build) {
                                s.Ready = 3;
                                s.lang = e;
                                o();
                            } else {
                                s.Ready = 2;
                                i.available(e);
                                o();
                            }
                        } else {
                            s.Ready = 1;
                            i.available();
                            o();
                        }
                    });
                    function o() {
                        r.get({
                            table: config.store.query
                        }).then(function(e) {
                            if (e) {
                                s.query = e;
                                c();
                            } else {
                                c();
                            }
                        });
                    }
                    function c() {
                        l.index();
                        t = config.bible.available.concat();
                        a = new fileSystask({
                            Base: "Chrome",
                            RequestQuota: 1073741824,
                            Permission: 1
                        }, {
                            success: function(e) {},
                            fail: function(e) {},
                            done: function(e) {
                                if (s.Ready == 3) {
                                    i.start();
                                } else {
                                    r.add({
                                        table: config.store.info,
                                        data: {
                                            build: config.build,
                                            version: config.version
                                        }
                                    }).then(i.start());
                                }
                            }
                        });
                    }
                });
            });
        };
        f.prototype.Database = function(e) {
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
                    data: s.query
                });
            };
            this.UpdateLang = function() {
                return this.add({
                    table: config.store.lang,
                    data: s.lang
                });
            };
            this.UpdateNote = function() {
                return this.put({
                    table: config.store.note,
                    data: s.note
                });
            };
            this.UpdateLookUp = function() {
                return this.put({
                    table: config.store.lookup,
                    data: s.lookup
                });
            };
            this.update = {
                query: function() {
                    return t.add({
                        table: config.store.query,
                        data: s.query
                    });
                },
                lang: function() {
                    return t.add({
                        table: config.store.lang,
                        data: s.lang
                    });
                },
                note: function() {
                    return t.add({
                        table: config.store.note,
                        data: s.note
                    });
                },
                lookup: function() {
                    return t.add({
                        table: config.store.lookup,
                        data: s.lookup
                    });
                }
            };
            this.remove = {
                query: function() {},
                lang: function(e, n) {
                    delete s[e];
                    delete s.lang[e];
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
                delete s[e];
                delete s.lang[e];
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
        f.prototype.chapter = {
            note: {
                active: function(e) {
                    new d({
                        bID: s.query.book,
                        cID: s.query.chapter
                    }).search(function(t) {
                        if (t) {
                            e.arg[0].addClass(config.css.active);
                            s.todo.ChapterNoteActive = true;
                        } else {
                            s.todo.ChapterNoteActive = false;
                        }
                    });
                }
            },
            name: {
                previous: function(e) {
                    e.arg[0].attr("title", this.text("next"));
                },
                current: function(e) {
                    e.arg[0].html(e.num(s.query.chapter));
                    if (s.todo.ActiveChapter) {
                        s.todo.ActiveChapter.addClass(config.css.active).promise().done(function() {
                            delete s.todo.ActiveChapter;
                        });
                    }
                },
                next: function(e) {
                    e.arg[0].attr("title", this.text("previous"));
                },
                has: {
                    next: function() {
                        var e = parseInt(s.query.book), t = parseInt(s.query.chapter) + 1;
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
                        var e = parseInt(s.query.book), t = parseInt(s.query.chapter) - 1;
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
                    var t = this.has[e](), n = s.lang[s.query.bible];
                    return n.l.BFVBC.replace(/{b}/, n.b[t.book]).replace(/{c}/, u().num(t.chapter));
                }
            },
            next: function(e) {
                e.hash(2).hashChange(this.name.has.next());
            },
            previous: function(e) {
                e.hash(2).hashChange(this.name.has.previous());
            },
            book: function(e) {},
            list: function(t) {
                var n = t.arg[0].next();
                if (n.is(":hidden")) {
                    new t.menu(s.query.book).chapter(e(h.ol, {
                        "class": "list-chapter"
                    })).appendTo(n.fadeToggle(100).children().empty()).promise().always(function() {
                        this.children().on(s.Click, function() {
                            s.todo.ActiveChapter = e(this);
                        });
                        u(n).doClick(function(e) {
                            if (t.container.closest(n, e, t.arg[0])) {
                                t.container.fade(n, t.arg[0]);
                                return true;
                            }
                        });
                    });
                } else {
                    t.container.fade(n, t.arg[0]);
                }
            }
        };
        f.prototype.lookup = {
            setting: function(e) {
                var t = e.arg[0].next();
                if (t.is(":hidden")) {
                    new e.menu(s.query.book).lookup(t.fadeToggle(100).children().empty()).promise().always(function() {
                        u(t).doClick(function(n) {
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
            query: function(e) {
                e.arg[0].val(s.query.q);
            },
            msg: function(e) {
                s.msg.lookup = e.arg[0];
                if (s.query.result > 0) {
                    e.arg[0].text(e.num(s.query.result)).attr("title", s.query.q);
                } else {
                    e.arg[0].empty();
                }
            }
        };
        f.prototype.menu = function(t) {
            this.bible = function(e) {
                config.bible.available.forEach(function(n) {
                    var i = {
                        bID: n,
                        lang: s.lang[n].info,
                        local: s.lang[n].local,
                        classOffline: "icon-ok offline",
                        classOnline: "icon-logout offline"
                    };
                    i.classAvailable = i.local ? config.css.available : config.css.notAvailable;
                    i.isAvailable = i.local ? i.classOffline : i.classOnline;
                    i.classActive = (s.query.bible == n ? config.css.active : "") + " " + i.classAvailable;
                    t(i).appendTo(e);
                });
                return e;
            };
            this.chapter = function(n) {
                e.each(bible.info[t].v, function(t, i) {
                    t++;
                    e(h.li, {
                        id: t,
                        "class": s.query.chapter == t ? config.css.active : ""
                    }).append(e(h.a, {
                        href: u().hash(2) + e.param({
                            chapter: t
                        })
                    }).html(u().num(t)).append(e(h.sup).html(u().num(i)))).appendTo(n);
                });
                return n;
            };
            this.lookup = function(t) {
                var n = {
                    Query: function(t) {
                        t.each(function() {
                            var t = e(this);
                            t.children().each(function(t, i) {
                                var i = e(i), o = u(i).get("id").element[0];
                                i.toggleClass(config.css.active);
                                n.ID(o);
                            }).promise().always(function() {
                                n.Class(t);
                            });
                        });
                    },
                    Click: function(t, n) {
                        var i = e(t.target);
                        if (i.get(0).tagName.toLowerCase() === "p") {
                            this.Query(n);
                        } else {
                            var o = i.parent().parent().toggleClass(config.css.active), a = o.attr("id");
                            i.toggleClass(config.css.active).promise().done(function() {
                                if (this.hasClass(config.css.active)) {
                                    s.lookup.setting[a] = true;
                                } else {
                                    delete s.lookup.setting[a];
                                }
                            });
                        }
                        r.update.lookup();
                    },
                    Class: function(e) {
                        var t = e.children().length, n = e.children(u(config.css.active).is("class").name).length, i = e.parent().children().eq(0);
                        if (t === n) {
                            i.removeClass().addClass("yes");
                        } else if (n > 0) {
                            i.removeClass().addClass("some");
                        } else {
                            i.removeClass().addClass("no");
                        }
                    },
                    ID: function(e) {
                        if (s.lookup.book[e]) {
                            delete s.lookup.book[e];
                        } else {
                            s.lookup.book[e] = {};
                        }
                    }
                }, t = e(h.ol, {
                    "class": "list-lookup"
                }).appendTo(t), i = s.lang[s.query.bible];
                e.each(bible.catalog, function(o, a) {
                    var l = Object.keys(config.language)[0] + o, c = s.lookup.setting[l] ? config.css.active : "testament";
                    e(h.li, {
                        id: l,
                        "class": c
                    }).html(e(h.p, {
                        text: i.t[o]
                    }).on(s.Click, function(t) {
                        n.Click(t, e(this).parent().children("ol").find("ol"));
                    }).append(e(h.span).text("+").addClass(c))).appendTo(t).promise().always(function() {
                        e(h.ol, {
                            "class": "section"
                        }).appendTo(this).promise().always(function() {
                            var t = this;
                            e.each(a, function(o, a) {
                                var l = Object.keys(config.language)[1] + o, c = s.lookup.setting[l] ? config.css.active : "";
                                e(h.li, {
                                    id: l,
                                    "class": c
                                }).append(e(h.p, {
                                    text: i.s[o]
                                }).on(s.Click, function(t) {
                                    n.Click(t, e(this).parent().children("ol"));
                                }).append(e(h.span, {
                                    text: "+"
                                }).addClass(c))).appendTo(t).promise().always(function() {
                                    var t = e(h.ol, {
                                        "class": "book"
                                    }).appendTo(this);
                                    a.forEach(function(o) {
                                        e(h.li, {
                                            id: o,
                                            "class": s.lookup.book[o] ? config.css.active : ""
                                        }).text(i.b[o]).on(s.Click, function() {
                                            e(this).toggleClass(config.css.active);
                                            n.ID(o);
                                            r.update.lookup();
                                        }).appendTo(t);
                                    });
                                    t.promise().always(function() {
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
        f.prototype.container = {
            msg: {
                info: function(e) {
                    s.msg.info = e.arg[0];
                    return true;
                }
            },
            closest: function(t, n, i) {
                if (t.is(":visible") && !e(n.target).closest("#dialog, .misc").length && !e(n.target).closest(t).length && !e(n.target).closest(i).length) return true;
            },
            fade: function(e, t, n) {
                e.fadeOut(100).promise().always(function() {
                    t.removeClass(config.css.active);
                    if (n) n.removeAttr("style");
                });
            }
        };
        f.prototype.info = {
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
                    }).html("Ok").on(s.Click, function(t) {
                        t.stopImmediatePropagation();
                        e(this).parents("div").remove();
                    }))).appendTo("body").on(s.Click, function(t) {
                        if (!e(t.target).closest("#window").length) {
                            e("#clickme").effect("highlight", {
                                color: "#F30C10"
                            }, 100);
                        }
                    });
                }
            }
        };
        f.prototype.doClick = function(t) {
            var n = this.arg[0];
            e(document.body).on(s.Click, function(i) {
                if (n) {
                    if (n.is(":visible")) {
                        if (e.isFunction(t) && t(i)) {} else {}
                    }
                } else {
                    t(i);
                }
            });
        };
        f.prototype.url = function(e, t, n) {
            var i = this.string([ e, 47, t.join("/"), 46, n ]), o = i.substring(i.lastIndexOf("/") + 1), s = this.string([ "application", 47, n ]);
            return {
                fileName: o,
                fileExtension: n,
                fileUrl: i,
                fileCharset: s + ";charset=utf-8",
                fileContentType: s
            };
        };
        f.prototype.hash = function(e) {
            return this.string([ 35, config.page[e], 63 ]);
        };
        f.prototype.dot = function(e) {};
        f.prototype.num = function(e, t) {
            if (!t) t = s.query.bible;
            if (s.lang.hasOwnProperty(t)) {
                if (s.lang[t].hasOwnProperty("n")) {
                    return Object.getOwnPropertyNames(s.lang[t].n).length === 0 ? e : e.toString().replace(/[0-9]/g, function(e) {
                        return s.lang[t].n[e];
                    });
                } else {
                    return e;
                }
            } else {
                return e;
            }
        };
        f.prototype.hashURI = function(e) {
            var t = location.hash, n = {
                page: t.split("?")[0].replace("#", "")
            }, i, o = /([^\?#&=]+)=([^&]*)/g, s = function(e) {
                return decodeURIComponent(e.replace(/\+/g, " "));
            };
            while (i = o.exec(t)) n[s(i[1])] = s(i[2]);
            e(n);
        };
        f.prototype.string = function(t) {
            return e.map(t, function(t) {
                return e.isNumeric(t) ? String.fromCharCode(t) : t;
            }).join("").toString();
        };
        f.prototype.index = function() {
            config.bible.available = [];
            e.map(s.lang, function(e, t) {
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
        f.prototype.array = function(t, n) {
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
        f.prototype.working = function(t) {
            if (s.msg.info.is(":hidden")) {
                e("body").addClass(config.css.working).promise().done(s.msg.info.slideDown(200));
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
            return t.msg ? s.msg.info.html(t.msg) : s.msg.info;
        };
        f.prototype.done = function(t) {
            s.msg.info.slideUp(200).empty().promise().done(function() {
                e("body").removeClass(config.css.working).removeClass(config.css.wait).removeClass(config.css.disable).promise().done(function() {
                    if (t) t();
                });
            });
        };
        f.prototype.activeClass = function(t) {
            return t.find(u(config.css.active).is("class").name).removeClass(config.css.active).promise().done(e(config.css.currentPage).addClass(config.css.active));
        };
        f.prototype.loop = function(e) {
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
            var n = typeof this.arg[0];
            return t[n](this.arg[0]);
        };
        f.prototype.HTML = function() {
            return {
                ol: u("ol").is("tag").name,
                ul: u("ul").is("tag").name,
                li: u("li").is("tag").name,
                a: u("a").is("tag").name,
                div: u("div").is("tag").name,
                p: u("p").is("tag").name,
                h1: u("h1").is("tag").name,
                h2: u("h2").is("tag").name,
                h3: u("h3").is("tag").name,
                h4: u("h4").is("tag").name,
                h5: u("h5").is("tag").name,
                span: u("span").is("tag").name,
                em: u("em").is("tag").name,
                sup: u("sup").is("tag").name
            };
        };
        f.prototype.init = function() {
            var t = {
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
            this.hashURI(function(n) {
                var i = {
                    page: function(t, n, i) {
                        s.query[t] = e.inArray(n.toLowerCase(), config.page) >= 0 ? n : i;
                        config.css.currentPage = u(s.query[t]).is("class").name;
                    },
                    bible: function(t, n, i) {
                        s.query[t] = e.inArray(n.toLowerCase(), config.bible.available) >= 0 ? n : i;
                    },
                    book: function(t, i, o) {
                        if (e.isNumeric(i)) {
                            s.query[t] = bible.book[i] ? i : o;
                        } else {
                            s.query[t] = o;
                            var i = i.replace(new RegExp("-", "g"), " ").toLowerCase(), a = s.lang[s.query.bible].b;
                            for (var l in a) {
                                if (a[l].toLowerCase() == n || lang.b[l].toLowerCase() == i) {
                                    s.query[t] = l;
                                    break;
                                }
                            }
                        }
                    },
                    testament: function(e, t, n) {
                        s.query[e] = bible.info[s.query.book].t;
                    },
                    catalog: function(e, t, n) {
                        s.query[e] = bible.info[s.query.book].s;
                    },
                    chapter: function(e, t, n) {
                        s.query[e] = bible.info[s.query.book].c >= t && t > 0 ? t : n;
                    },
                    verse: function(e, t, n) {
                        s.query[e] = bible.info[s.query.book].v[s.query.chapter - 1] >= t ? t : n;
                    },
                    verses: function(e, t, n) {},
                    q: function(e, t, i) {
                        if (n.q) {
                            s.query.q = n.q;
                        }
                    },
                    bookmark: function() {}
                };
                if (e.isEmptyObject(s.query)) {
                    s.query = e.extend({}, t, n);
                } else {
                    n.page = n.page ? n.page : s.query.page;
                    e.extend(s.query, n);
                }
                u(s.query).loop(function(n, o) {
                    if (e.isFunction(i[n])) i[n](n, o, t[n]);
                });
            });
            e(config.css.header).find("*").removeClass(config.css.active).siblings(config.css.currentPage).addClass(config.css.active);
            var n = u("lookup").is("form").element;
            if (n.length) {
                n.off().on("submit", function() {
                    var t = e(this);
                    t.serializeObject(s.query);
                    if (s.query.page == t.attr("name")) {
                        t.find(u("q").is("input").name).attr("autocomplete", "off").focus().select().promise().done(function() {
                            if (s.todo.lookup) {
                                console.log("already enter");
                            } else {
                                u().page.lookup();
                            }
                        });
                    } else {
                        t.attr("action").hashChange({
                            q: s.query.q
                        });
                    }
                    return false;
                });
                u("search").is("input").element.off().on(s.Click, function() {
                    e(this.form).submit();
                }).promise().done(function() {
                    u("q").is("input").element.val(s.query.q).attr("autocomplete", "off").focus().select();
                });
            }
            s.container.main = e(config.css.content).children(config.css.currentPage);
            s.container.main.addClass(config.css.active).siblings().removeClass(config.css.active).promise().always(function() {
                l.page[e.isFunction(l.page[s.query.page]) ? s.query.page : e(config.page).get(-1)]();
            });
            u("fn").is("attr").element.each(function(t, n) {
                var i = e(n), o = u(i).get("fn"), s = o.get("class").element, a = o.get("fn").split();
                if (l[s[0]]) {
                    a.unshift(s[0]);
                    u(i).exe(a);
                }
            }).promise().done(function() {
                r.update.query();
            });
            if (s.todo.Orientation) {
                c.Orientation();
                delete s.todo.Orientation;
            }
        };
        f.prototype.xml = function(t) {
            var n = this, i = this.arg[0];
            var o = s.lang[i.bible], l = o.l, c = o.b;
            var f = this.url(config.id, [ i.bible ], config.file.bible);
            var u = [];
            this.has = function() {
                if (e.isEmptyObject(s[i.bible].bible)) {
                    if (a.support) {
                        a.get({
                            fileOption: {},
                            fileUrlLocal: f.fileUrl,
                            fileReadAs: true,
                            before: function() {
                                u.push(i.bible.toUpperCase());
                            },
                            success: function(e) {
                                u.push("Found");
                                n.file.read(e.fileContent);
                            },
                            fail: function(e) {
                                u.push("NotFound");
                                if (i.bible == i.downloading) {
                                    u.push("SendTo");
                                    n.file.download(true);
                                } else {
                                    u.push("Sendback");
                                    n.ResponseGood(false);
                                }
                            }
                        });
                    } else if (window.indexedDB) {
                        u.push("Store");
                        r.get({
                            table: i.bible
                        }).then(function(t) {
                            if (t) {
                                if (e.isEmptyObject(t)) {
                                    u.push("Empty");
                                    if (i.bible == i.downloading) {
                                        u.push("SendTo");
                                        n.file.download(false);
                                    } else {
                                        u.push("Sendback");
                                        n.ResponseGood(false);
                                    }
                                } else {
                                    u.push("Reading");
                                    if (i.bible == i.reading) {
                                        s[i.bible].bible = t;
                                        u.push("Success");
                                        n.ResponseGood(true);
                                    } else {
                                        u.push("Disabled");
                                        n.ResponseGood(true);
                                    }
                                }
                            } else {
                                u.push("NotFound");
                                if (i.bible == i.downloading) {
                                    u.push("SendTo");
                                    n.file.download(false);
                                } else {
                                    u.push("Sendback");
                                    n.ResponseGood(false);
                                }
                            }
                        });
                    } else {
                        u.push("fileSystemNotOk", "indexedDBNotOK");
                        if (i.bible == i.downloading) {
                            u.push("CanNotSetDownloadingTRUE");
                        }
                        u.push("Sendback");
                        n.ResponseGood(false);
                    }
                } else {
                    u.push("AlreadyInObject");
                    n.ResponseGood(true);
                }
                return this;
            };
            this.get = function() {
                if (e.isEmptyObject(s[i.bible].bible)) {
                    if (a.support) {
                        a.get({
                            fileOption: {},
                            fileUrlLocal: f.fileUrl,
                            fileReadAs: true,
                            before: function() {
                                u.push(i.bible.toUpperCase());
                                n.working({
                                    msg: l.PleaseWait,
                                    wait: true
                                });
                            },
                            success: function(e) {
                                u.push("Found");
                                n.file.read(e.fileContent);
                            },
                            fail: function(e) {
                                u.push("NotFound", "SendTo");
                                n.file.download(true);
                            }
                        });
                    } else if (window.indexedDB) {
                        u.push("Store");
                        r.get({
                            table: i.bible
                        }).then(function(t) {
                            if (t) {
                                if (e.isEmptyObject(t)) {
                                    u.push("Empty", "SendTo");
                                    n.file.download(false);
                                } else {
                                    u.push("Reading");
                                    if (i.bible == i.reading) {
                                        s[i.bible].bible = t;
                                        u.push("Success");
                                        n.ResponseGood(true);
                                    } else {
                                        u.push("Disabled");
                                        n.ResponseGood(true);
                                    }
                                }
                            } else {
                                u.push("NotFound", "SendTo");
                                n.ResponseGood(false);
                            }
                        });
                    } else {
                        u.push("fileSystemNotOk", "indexedDBNotOK");
                        u.push("GettingReadyForWeb");
                        n.file.download(false);
                    }
                } else {
                    u.push("AlreadyInObject");
                    n.ResponseCallbacks(true);
                }
                return this;
            };
            this.remove = function() {
                u.push(i.bible.toUpperCase());
                if (a.support) {
                    a.remove({
                        fileOption: {},
                        fileUrlLocal: f.fileUrl,
                        fileNotFound: true,
                        success: function(e) {
                            u.push("Removed");
                            n.ResponseBad(true);
                        },
                        fail: function(e) {
                            u.push("Fail");
                            n.ResponseBad(false);
                        }
                    });
                } else if (window.indexedDB) {
                    u.push("Store");
                    r.delete({
                        table: i.bible
                    }).then(function() {
                        u.push("Removed");
                        n.ResponseBad(true);
                    });
                } else {
                    u.push("fileSystemNotOk", "indexedDBNotOK");
                    u.push("NothingToRemove", "Sendback");
                    n.ResponseBad(false);
                }
            };
            this.file = {
                download: function(e) {
                    a.download({
                        fileOption: {
                            create: e
                        },
                        fileUrl: f.fileUrl,
                        fileUrlLocal: true,
                        before: function(e) {
                            u.push("Downloading");
                            n.working({
                                msg: l.Downloading,
                                wait: true
                            });
                        },
                        progress: function(e) {
                            n.working({
                                msg: l.PercentLoaded.replace(/{Percent}/, n.num(e, i.bible))
                            });
                        },
                        fail: function(e) {
                            u.push("Fail");
                            n.ResponseGood(false);
                        },
                        success: function(e) {
                            u.push("Success");
                            if (e.fileCreation === true) {
                                u.push("AndSaved");
                            } else {
                                u.push("NotSaved");
                            }
                            n.file.read(e.fileContent);
                        }
                    });
                },
                read: function(e) {
                    u.push("Reading");
                    if (!i.downloading || i.bible == i.reading) {
                        this.content(e);
                    } else {
                        u.push("Disabled");
                        n.ResponseGood(true);
                    }
                },
                content: function(e) {
                    u.push(f.fileExtension.toUpperCase());
                    n.JobType(new DOMParser().parseFromString(e, f.fileContentType));
                }
            };
            this.JobType = function(t) {
                var n = e(t).children().get(0).tagName;
                u.push(n);
                if (e.isFunction(this.Job[n])) {
                    s[i.bible].bible = {
                        info: {},
                        book: {}
                    };
                    this.Job[n](t);
                } else {
                    u.push("NotFound");
                    this.ResponseGood(false);
                }
            };
            this.Job = {
                bible: function(t) {
                    var o = [], l = [], f = 0;
                    e(t).children().each(function(t, o) {
                        var l = e(o), f = l.children(), p = l.attr("id");
                        if (f.length) {
                            f.each(function(t, o) {
                                var l = e(o), p = l.children(), o = l.attr("id"), d = l.get(0).tagName.toLowerCase(), h = 0;
                                if (e.type(s[i.bible].bible[d]) === "undefined") s[i.bible].bible[d] = {};
                                if (p.length) {
                                    s[i.bible].bible[d][o] = {};
                                    setTimeout(function() {
                                        p.each(function(l, c) {
                                            var g = e(c), b = g.children(), c = g.attr("id"), m = g.get(0).tagName.toLowerCase();
                                            if (e.type(s[i.bible].bible[d][o][m]) === "undefined") s[i.bible].bible[d][o][m] = {};
                                            if (b.length) {
                                                s[i.bible].bible[d][o][m][c] = {};
                                                s[i.bible].bible[d][o][m][c].verse = {};
                                                setTimeout(function() {
                                                    b.each(function(h, g) {
                                                        var v = e(g), y = v.children(), g = v.attr("id"), w = v.get(0).tagName.toLowerCase();
                                                        g = "v" + g;
                                                        s[i.bible].bible[d][o][m][c].verse[g] = {};
                                                        s[i.bible].bible[d][o][m][c].verse[g].text = v.text();
                                                        if (v.attr("ref")) s[i.bible].bible[d][o][m][c].verse[g].ref = v.attr("ref").split(",");
                                                        if (v.attr("title")) s[i.bible].bible[d][o][m][c].verse[g].title = v.attr("title").split(",");
                                                        if (f.length == t + 1) {
                                                            if (p.length == l + 1) {
                                                                if (b.length == h + 1) {
                                                                    if (a.support) {
                                                                        u.push("Success");
                                                                        n.ResponseGood(true);
                                                                    } else if (window.indexedDB) {
                                                                        u.push("Stored");
                                                                        r.add({
                                                                            table: i.bible,
                                                                            data: s[i.bible].bible
                                                                        }).then(n.ResponseGood(true));
                                                                    } else {
                                                                        u.push("NotStored");
                                                                        n.ResponseGood(true);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    });
                                                }, 30 / t * l);
                                            } else if (c) {
                                                s[i.bible].bible[d][o][m][c] = g.text();
                                            } else {
                                                h++;
                                                s[i.bible].bible[d][o][m][h] = {
                                                    title: g.text()
                                                };
                                                if (g.attr("ref")) s[i.bible].bible[d][o][m][h].ref = g.attr("ref").split(",");
                                            }
                                        }).promise().done(function() {
                                            s.msg.info.html(c[o]);
                                        });
                                    }, 90 * t);
                                } else {
                                    s[i.bible].bible[d][o] = l.text();
                                }
                            });
                        } else {
                            var d = l.attr("id"), h = l.text();
                        }
                    });
                }
            };
            this.ResponseGood = function(e) {
                o.local = e;
                var t = o.local.toString().toUpperCase();
                u.push("LangVariableUpdatedAs", t);
                u.push("LangDB");
                if (i.reading) {
                    u.push("NotUpdatedDueToReadingIsTrue");
                    n.ResponseCallbacks(e);
                } else {
                    r.update.lang().then(function() {
                        u.push("UpdatedAs", t);
                        n.done();
                        n.ResponseCallbacks(e);
                    });
                }
                return this;
            };
            this.ResponseBad = function(e) {
                delete s[i.bible].bible;
                u.push("Lang");
                if (e) o.local = false;
                var t = o.local.toString().toUpperCase();
                if (e) {
                    u.push("Removed");
                    r.update.lang().then(function() {
                        u.push("AndVariableUpdatedAs", t);
                        n.done();
                        n.ResponseCallbacks(true);
                    });
                } else {
                    u.push("ButVariableUpdatedAs", t);
                    n.ResponseCallbacks(true);
                }
                return this;
            };
            this.ResponseCallbacks = function(e) {
                this.msg = u.join(" ");
                t({
                    msg: this.msg,
                    status: e
                });
            };
            return this;
        };
        f.prototype.page = {
            bible: function() {
                var t = l.hash(1);
                s.container.main.html(e(h.div, {
                    "class": "wrp wrp-bible"
                })).children().html(new l.menu(function(n) {
                    return e(h.li, {
                        id: n.bID,
                        "class": n.classActive
                    }).html(e(h.p).append(e(h.span, {
                        "class": n.isAvailable
                    }).on(s.Click, function(t) {
                        t.preventDefault();
                        var i = e(this), o = i.parents("li");
                        if (s.msg.info.is(":hidden")) s.todo.bibleOption = false;
                        if (s.todo.bibleOption === n.bID) {
                            l.done(function() {
                                delete s.todo.bibleOption;
                            });
                        } else if (o.hasClass(config.css.notAvailable)) {
                            l.working({
                                msg: e(h.ul, {
                                    "class": "data-dialog"
                                }).append(e(h.li).append(e(h.p).html(s.lang[n.bID].l.WouldYouLikeToAdd.replace(/{is}/, i.parent().children("a").text()))), e(h.li).append(e(h.span, {
                                    "class": "yes icon-thumbs-up-alt"
                                }).on(s.Click, function(e) {
                                    e.preventDefault();
                                    new u({
                                        bible: n.bID
                                    }).xml(function(e) {
                                        if (e.status) {
                                            o.removeClass(config.css.notAvailable).addClass(config.css.available);
                                            i.removeClass(n.classOnline).addClass(n.classOffline);
                                        }
                                    }).get();
                                }), e(h.span, {
                                    "class": "no icon-thumbs-down-alt"
                                }).on(s.Click, function(e) {
                                    e.preventDefault();
                                    l.done(function() {
                                        delete s.todo.bibleOption;
                                    });
                                }))),
                                wait: true
                            });
                        } else {
                            s.todo.bibleOption = n.bID;
                            l.working({
                                msg: e(h.ul, {
                                    "class": "data-dialog"
                                }).append(e(h.li).append(e(h.p).html(s.lang[n.bID].l.WouldYouLikeToRemove.replace(/{is}/, i.parent().children("a").text()))), e(h.li).append(e(h.span, {
                                    "class": "yes icon-thumbs-up-alt"
                                }).on(s.Click, function(e) {
                                    e.preventDefault();
                                    o.removeClass(config.css.available).addClass(config.css.notAvailable);
                                    i.removeClass(n.classOffline).addClass(n.classOnline);
                                    l.working({
                                        msg: s.lang[n.bID].l.PleaseWait,
                                        wait: true
                                    }).promise().done(function() {
                                        o.removeClass(config.css.available).addClass(config.css.notAvailable);
                                        i.removeClass(n.classOffline).addClass(n.classOnline);
                                        new u({
                                            bible: n.bID
                                        }).xml(function(e) {
                                            l.done(function() {
                                                delete s.todo.bibleOption;
                                            });
                                        }).remove();
                                    });
                                }), e(h.span, {
                                    "class": "no icon-thumbs-down-alt"
                                }).on(s.Click, function(e) {
                                    e.preventDefault();
                                    l.done(function() {
                                        delete s.todo.bibleOption;
                                    });
                                }))),
                                wait: true
                            });
                        }
                    }), e(h.a, {
                        href: t + e.param({
                            bible: n.bID
                        })
                    }).html(n.lang.name), e(h.span, {
                        "class": "icon-menu drag"
                    })));
                }).bible(e(h.ol, {
                    id: "dragable",
                    "class": "row row-bible"
                }))).promise().done(function(t) {
                    this.children().sortable({
                        handle: ".drag",
                        containment: "parent",
                        helper: ".dsdfd",
                        placeholder: "ghost",
                        forcePlaceholderSize: true,
                        opacity: .7,
                        update: function(t, n) {
                            e(this).children().each(function(t, n) {
                                s.lang[e(n).get(0).id].index = e(n).index();
                            }).promise().done(function() {
                                r.update.lang().then(l.index);
                            });
                        }
                    });
                });
            },
            book: function() {
                var t = l.hash(2), n = s.lang[s.query.bible];
                s.container.main.html(e(h.div, {
                    "class": "wrp wrp-book"
                }));
                e.each(bible.catalog, function(i, o) {
                    var a = n.t[i];
                    e(h.ol, {
                        "class": "testament",
                        id: i
                    }).append(e(h.li, {
                        id: "t-" + i
                    }).html(e(h.h1, {
                        text: a
                    }))).appendTo(s.container.main.children()).promise().done(function() {
                        e(h.ol, {
                            "class": "catalog"
                        }).appendTo(this.children()).promise().done(function(i) {
                            e.each(o, function(o, a) {
                                var l = n.s[o];
                                e(h.li, {
                                    id: "c-" + o
                                }).append(e(h.h2, {
                                    text: l
                                })).appendTo(i).promise().done(function(i) {
                                    e(h.ol, {
                                        "class": "book"
                                    }).appendTo(this);
                                    a.forEach(function(o) {
                                        var a = n.b[o];
                                        e(h.li, {
                                            id: "b-" + o,
                                            "class": s.query.book == o ? config.css.active : ""
                                        }).append(e(h.p).append(e(h.a, {
                                            href: t + e.param({
                                                book: o
                                            })
                                        }).html(a))).appendTo(i.children()[1]);
                                    });
                                });
                            });
                        });
                    });
                });
            },
            reader: function() {
                new p(s.query).chapter(s.container.main.children());
            },
            lookup: function() {
                new p(s.query).lookup(s.container.main.children());
            },
            note: function() {
                new d(s.query).page(s.container.main.children());
            },
            todo: function() {
                console.log("nothing todo?");
            }
        };
        function p(t, n) {
            var i = this, o = s.lang[t.bible], a = o.l, c = o.b;
            this.Num = function(e) {
                return u().num(e, t.bible);
            };
            function f(n) {
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
                    new u({
                        bible: t.bible
                    }).xml(function(t) {
                        e(t);
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
                this.verseReference = function() {
                    if ((this.LIST.length ? this.verseMerge(this.LIST, this.VID) : [ this.VID ]).length) {
                        return true;
                    }
                };
                this.Query = {
                    list: function() {
                        return o.Result.BooklistName = Object.keys(o.Result.Booklist).join();
                    },
                    book: function() {
                        o.Result.Booklist = {};
                        if (Object.getOwnPropertyNames(s.lookup.book).length > 0) {
                            e.each(s.lookup.book, function(t, n) {
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
                        return o.Result.Booklist = new g(t).is(t.q);
                    },
                    prev: function() {
                        if (t.booklist) {
                            o.Result.Booklist = t.booklist;
                            return o.Result.Booklist;
                        }
                    },
                    chapter: function() {
                        o.Result.Booklist[t.book] = {};
                        o.Result.Booklist[t.book][t.chapter] = [];
                        this.is = function() {
                            return s.previous.bible !== t.bible || s.previous.chapter !== t.chapter;
                        };
                        return o.Result.Booklist;
                    },
                    lookup: function(e) {
                        this.callbackBibleBefore = e;
                        this.is = function() {
                            var e = s.previous.booklist != this.list() || s.previous.q != t.q;
                            this.callbackBibleBeforeHas = new g(t).is(t.q) ? "" : t.q;
                            if (e) {}
                            return e;
                        };
                        return this.prev() || this.regex() || this.book();
                    },
                    reference: function(e) {
                        this.callbackBibleBefore = e;
                        return o.Result.Booklist = new g(t).is(t.ref);
                    },
                    note: function(e) {
                        this.callbackBibleBefore = e;
                        return o.Result.Booklist = t.ref;
                    }
                };
                this.book = function(a) {
                    var l = new e.Deferred(), r = {
                        task: {
                            bible: Object.keys(a),
                            chapter: [],
                            verse: []
                        },
                        BookID: function() {
                            o.BID = r.task.bible.shift();
                            o.BNA = c[o.BID];
                            r.task.chapter = Object.keys(a[o.BID]);
                        },
                        ChapterID: function() {
                            o.CID = r.task.chapter.shift();
                            o.CNA = i.Num(o.CID);
                            o.LIST = a[o.BID][o.CID];
                            r.task.verse = Object.keys(o.LIST);
                        },
                        VerseID: function() {
                            o.VID = r.task.verse.shift();
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
                            s.todo.lookup = true;
                            delete s.todo.pause;
                            r.BookID();
                            r.next();
                        },
                        next: function() {
                            r.ChapterID();
                            r.done().progress(function() {
                                l.notify();
                            }).fail(function() {
                                l.reject();
                                delete s.todo.lookup;
                            }).done(function() {
                                if (r.task.chapter.length) {
                                    r.next();
                                } else if (r.task.bible.length) {
                                    r.start();
                                } else {
                                    l.resolve();
                                    delete s.todo.lookup;
                                }
                            });
                        },
                        done: function() {
                            var a = s[t.bible].bible.book[o.BID], l = a.chapter[o.CID], c = l.verse;
                            var f = new e.Deferred();
                            (function u(e) {
                                setTimeout(function() {
                                    if (e.length) {
                                        var t = e.shift();
                                        o.VID = t.slice(1);
                                        o.VNA = i.Num(o.VID);
                                        o.VERSE = c[t];
                                        if (s.todo.pause) {
                                            f.reject();
                                            delete s.todo.pause;
                                        } else {
                                            if (o.Query.callbackBibleBefore) {
                                                if (o[o.Query.callbackBibleBefore](o.Query.callbackBibleBeforeHas)) {
                                                    r.isNew();
                                                    n(o).progress(function() {
                                                        f.notify();
                                                    }).fail(function() {
                                                        f.reject();
                                                    }).done(function() {
                                                        u(e);
                                                    });
                                                } else {
                                                    f.notify();
                                                    u(e);
                                                }
                                            } else {
                                                r.isNew();
                                                n(o).progress(function() {
                                                    f.notify();
                                                }).fail(function() {
                                                    f.reject();
                                                }).done(function() {
                                                    u(e);
                                                });
                                            }
                                        }
                                    } else {
                                        f.resolve();
                                    }
                                });
                            })(Object.keys(c));
                            return f.promise();
                        }
                    };
                    return l.promise(r.start());
                };
            }
            this.example = function(e) {};
            this.chapter = function(n) {
                var o, a, l, r;
                new f(function(l) {
                    var c = new e.Deferred();
                    if (l.Result.NewBook) {
                        o = e(h.ol, {
                            "class": "Oc"
                        }).appendTo(e(h.li, {
                            id: l.BID,
                            "class": "bID"
                        }).append(e(h.div).append(e(h.h2).text(l.BNA))).appendTo(r));
                    }
                    if (l.Result.NewChapter) {
                        a = e(h.ol, {
                            "class": "Ov"
                        }).appendTo(e(h.li, {
                            id: l.CID,
                            "class": "cID"
                        }).append(e(h.div).append(e(h.h3, {
                            "class": "no"
                        }).text(l.CNA).on(s.Click, function() {
                            e(this).parents("li").children("ol").children().each(function() {
                                if (e(this).attr("id")) e(this).toggleClass(config.css.active);
                            });
                        }), typeof i[s.Deploy].Menu.Chapter === "function" && i[s.Deploy].Menu.Chapter(n))).appendTo(o));
                    }
                    if (l.VERSE.title) {
                        e(h.li, {
                            "class": "title"
                        }).html(l.VERSE.title.join(", ")).appendTo(a);
                    }
                    e(h.li, {
                        id: l.VID,
                        "data-verse": l.VNA
                    }).html(l.verseReplace(l.VERSE.text, t.q)).appendTo(a).on(s.Click, function() {
                        e(this).toggleClass(config.css.active);
                    }).promise().always(function() {
                        if (l.VERSE.ref) {
                            new d(a).Reference(l.VERSE.ref).promise().always(function() {
                                c.resolve();
                            });
                        } else {
                            c.resolve();
                        }
                    });
                    return c.promise();
                }).get(function(i) {
                    i.xml(function(o) {
                        if (o.status) {
                            if (i.Query.chapter()) {
                                if (i.Query.is()) {
                                    if (s.todo.containerEmpty) {
                                        delete s.todo.containerEmpty;
                                    } else {
                                        n.empty();
                                    }
                                    r = e(h.ol, {
                                        "class": t.bible
                                    }).addClass("Ob").appendTo(n);
                                    i.book(i.Result.Booklist).progress(function() {}).done(function() {}).always(function() {
                                        s.previous.bible = t.bible;
                                        s.previous.book = t.book;
                                        s.previous.chapter = t.chapter;
                                        n.promise().done(function() {
                                            var t = this.children().length, n = u(this).get("class").element[3];
                                            e(this).removeClass(n);
                                            e(this).addClass(n.charAt(0) + t);
                                        });
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
                var o, l, r, c;
                new f(function(a) {
                    var r = new e.Deferred();
                    r.notify();
                    if (a.Result.NewBook) {
                        o = e(h.ol, {
                            "class": "Oc"
                        }).appendTo(e(h.li, {
                            id: a.BID,
                            "class": "bID"
                        }).append(e(h.div).append(e(h.h2).text(a.BNA))).appendTo(c));
                    }
                    if (a.Result.NewChapter) {
                        l = e(h.ol, {
                            "class": "Ov"
                        }).appendTo(e(h.li, {
                            id: a.CID,
                            "class": "cID"
                        }).append(e(h.div).append(e(h.h3, {
                            "class": "no"
                        }).text(a.CNA).on(s.Click, function() {
                            e(this).parents("li").children("ol").children().each(function() {
                                if (e(this).attr("id")) e(this).toggleClass(config.css.active);
                            });
                        }), typeof i[s.Deploy].Menu.Lookup === "function" && i[s.Deploy].Menu.Lookup(n))).appendTo(o));
                    }
                    if (a.VERSE.title) {
                        e(h.li, {
                            "class": "title"
                        }).html(a.VERSE.title.join(", ")).appendTo(l);
                    }
                    e(h.li, {
                        id: a.VID,
                        "data-verse": a.VNA
                    }).html(a.verseReplace(a.VERSE.text, t.q)).appendTo(l).on(s.Click, function() {
                        e(this).toggleClass(config.css.active);
                    }).promise().always(function() {
                        r.resolve();
                    });
                    return r.promise();
                }).get(function(o) {
                    o.xml(function(l) {
                        if (l.status) {
                            if (o.Query.lookup("verseSearch")) {
                                if (o.Query.is()) {
                                    if (s.todo.containerEmpty) {
                                        delete s.todo.containerEmpty;
                                    } else {
                                        n.empty();
                                    }
                                    c = e(h.ol, {
                                        "class": t.bible
                                    }).addClass("Ob").appendTo(n);
                                    o.book(o.Result.Booklist).progress(function(e) {
                                        var t = a.BFVBC.replace(/{b}/, o.BNA).replace(/{c}/, o.CNA);
                                        s.msg.lookup.html(i.Num(o.Result.Verse));
                                        u().working({
                                            msg: t
                                        });
                                    }).done(function() {}).fail(function() {}).always(function() {
                                        s.previous.booklist = o.Result.BooklistName;
                                        s.previous.q = t.q;
                                        t.result = o.Result.Verse;
                                        s.msg.lookup.attr("title", t.q);
                                        u().done();
                                    });
                                } else {
                                    console.log("Ob.Query.is same");
                                }
                            } else {
                                console.log("Ob.Query.lookup empty");
                            }
                        } else {
                            console.log("download fail");
                        }
                    });
                });
            };
            this.note = function(n) {
                var o, a, l, r;
                new f(function(n) {
                    var i = new e.Deferred();
                    i.notify();
                    if (n.Result.NewBook) {
                        o = e(h.ol, {
                            "class": "Oc"
                        }).appendTo(e(h.li, {
                            id: n.BID,
                            "class": "bID"
                        }).append(e(h.div).append(e(h.h2).text(n.BNA))).appendTo(r));
                    }
                    if (n.Result.NewChapter) {
                        a = e(h.ol, {
                            "class": "Ov"
                        }).appendTo(e(h.li, {
                            id: n.CID,
                            "class": "cID"
                        }).append(e(h.div).append(e(h.h3, {
                            "class": "no"
                        }).text(n.CNA))).appendTo(o));
                    }
                    if (n.VERSE.title) {
                        e(h.li, {
                            "class": "title"
                        }).html(n.VERSE.title.join(", ")).appendTo(a);
                    }
                    e(h.li, {
                        id: n.VID,
                        "data-verse": n.VNA
                    }).html(n.verseReplace(n.VERSE.text, t.q)).appendTo(a).promise().always(function() {
                        i.resolve();
                    });
                    return i.promise();
                }).get(function(o) {
                    o.xml(function(a) {
                        if (a.status) {
                            if (t.ref) {
                                if (o.Query.note("verseReference")) {
                                    r = e(h.ol, {
                                        "class": t.bible
                                    }).addClass("Ob").appendTo(n);
                                    o.book(o.Result.Booklist).progress(function() {
                                        s.msg.lookup.html(i.Num(o.Result.Verse));
                                    }).done(function() {
                                        n.addClass(config.css.active);
                                    }).always(function() {
                                        delete t.ref;
                                    });
                                } else {
                                    delete t.ref;
                                }
                            }
                        } else {
                            delete t.ref;
                        }
                    });
                });
            };
            this.reference = function(n) {
                var o, a, l, r;
                new f(function(n) {
                    var i = new e.Deferred();
                    i.notify();
                    if (n.Result.NewBook) {
                        o = e(h.ol, {
                            "class": "Oc"
                        }).appendTo(e(h.li, {
                            id: n.BID,
                            "class": "bID"
                        }).append(e(h.div).append(e(h.h4).text(n.BNA))).appendTo(r));
                    }
                    if (n.Result.NewChapter) {
                        a = e(h.ol, {
                            "class": "Ov"
                        }).appendTo(e(h.li, {
                            id: n.CID,
                            "class": "cID"
                        }).append(e(h.div).append(e(h.h5, {
                            "class": "no"
                        }).text(n.CNA))).appendTo(o));
                    }
                    if (n.VERSE.title) {
                        e(h.li, {
                            "class": "title"
                        }).html(n.VERSE.title.join(", ")).appendTo(a);
                    }
                    e(h.li, {
                        id: n.VID,
                        "data-verse": n.VNA
                    }).html(n.verseReplace(n.VERSE.text, t.q)).appendTo(a).promise().always(function() {
                        i.resolve();
                    });
                    return i.promise();
                }).get(function(o) {
                    o.xml(function(a) {
                        if (a.status) {
                            if (o.Query.reference("verseReference")) {
                                if (s.todo.containerEmpty) {
                                    delete s.todo.containerEmpty;
                                } else {
                                    n.empty();
                                }
                                r = e(h.ol, {
                                    "class": t.bible
                                }).addClass("Ob").appendTo(n);
                                o.book(o.Result.Booklist).progress(function() {
                                    s.msg.lookup.html(i.Num(o.Result.Verse));
                                }).done(function() {
                                    n.addClass(config.css.active);
                                }).always(function() {
                                    delete t.ref;
                                });
                            } else {
                                delete t.ref;
                            }
                        } else {
                            delete t.ref;
                        }
                    });
                });
            };
            this.desktop = {
                Menu: {
                    Chapter: function(n) {
                        return e(h.ul).append(e(h.li).addClass(s.query.bible).append(new d(n).Parallel(function(i, o, a, l) {
                            var r = n.children(a), c = n.children().length;
                            if (r.length) {
                                if (c > 1) {
                                    var f = u(n).get("class").element[3];
                                    n.removeClass(f).addClass(f.charAt(0) + (c - 1));
                                    r.remove();
                                    i.removeClass("has");
                                    if (s.previous.bible === o) s.previous.bible = n.children().eq(0).attr("class");
                                }
                            } else {
                                s.todo.containerEmpty = true;
                                i.addClass("has");
                                new p(e.extend({}, t, {
                                    bible: l
                                })).chapter(n);
                            }
                        })), e(h.li).append(new d(n).Note()));
                    },
                    Lookup: function(e) {},
                    Note: function(e) {}
                }
            };
            this.tablet = {
                Menu: {}
            };
            this.mobile = {
                Menu: {}
            };
            function d(n) {
                this.Parallel = function(t) {
                    return e(h.span, {
                        "class": "icon-language"
                    }).on(s.Click, function(i) {
                        var o = e(i.target), a = o.parent(), r = a.children().eq(1), c = a.attr("class");
                        if (r.length) {
                            r.fadeOut(200).remove();
                        } else {
                            r = e(h.ul, {
                                "class": "mO parallel"
                            }).appendTo(a);
                            new l.menu(function(i) {
                                var o = u(i.bID).is("class").name;
                                return e(h.li, {
                                    "class": c === i.bID ? config.css.active : n.children(o).length ? "has" : i.bID
                                }).html(i.lang.name).on(s.Click, function() {
                                    t(e(this), i.lang.name, o, i.bID);
                                });
                            }).bible(r);
                            u().doClick(function(t) {
                                if (!e(t.target).closest(a).length) r.remove();
                            });
                        }
                    });
                };
                this.Note = function(t) {
                    return e(h.span, {
                        "class": s.todo.ChapterNoteActive ? "icon-pin " + config.css.active : "icon-pin"
                    }).on(s.Click, function(t) {
                        var n = e(t.target), i = n.parent(), o = i.children().eq(1);
                        if (o.length) {
                            o.fadeOut(200).remove();
                        } else {
                            var a = n.parents(u("cID").is("class").name), l = u(a.parents(u("bID").is("class").name)).get("id").element[0], c = u(a).get("id").element[0];
                            o = e(h.ul, {
                                "class": "mO note"
                            }).appendTo(i);
                            if (s.note) {
                                function f() {
                                    e.each(s.note, function(t, n) {
                                        if (n.name) {
                                            e(h.li, {
                                                id: t
                                            }).append(e(h.p, {
                                                "class": "add icon-right"
                                            }).on(s.Click, function() {
                                                var t = [], i = e(this);
                                                a.children("ol").children().each(function() {
                                                    if (e(this).attr("id") && e(this).hasClass(config.css.active)) {
                                                        t.push(e(this).attr("id"));
                                                    }
                                                }).promise().done(function() {
                                                    if (t.length) {
                                                        if (e.isEmptyObject(n.data)) n.data = {};
                                                        if (e.isEmptyObject(n.data[l])) n.data[l] = {};
                                                        n.data[l][c] = t;
                                                    } else if (n.data) {
                                                        if (n.data[l] && n.data[l][c]) delete n.data[l][c];
                                                        if (e.isEmptyObject(n.data[l])) delete n.data[l];
                                                        if (e.isEmptyObject(n.data)) delete n.data;
                                                    }
                                                    r.update.note().then(function() {
                                                        o.empty();
                                                        f();
                                                    });
                                                });
                                            }), e(h.p, {
                                                "class": "name"
                                            }).html(n.name).on(s.Click, function() {
                                                a.children("ol").children().each(function(t, i) {
                                                    var o = e(this).attr("id");
                                                    if (o) {
                                                        if (n.data && n.data[l] && e.inArray(o, n.data[l][c]) >= 0) {
                                                            e(this).addClass(config.css.active);
                                                        } else {
                                                            e(this).removeClass(config.css.active);
                                                        }
                                                    }
                                                });
                                            })).appendTo(o).promise().done(function(e) {
                                                if (n.data) {
                                                    if (n.data[l]) {
                                                        if (n.data[l][c]) {
                                                            this.addClass(config.css.active);
                                                        } else {
                                                            delete n.data[l];
                                                        }
                                                    }
                                                }
                                            });
                                        }
                                    });
                                }
                                f();
                            } else {
                                e(h.li).append(e(h.p, {
                                    "class": "indexedb"
                                }).html("Your browser does not support Indexedb!")).appendTo(o);
                            }
                            u().doClick(function(t) {
                                if (!e(t.target).closest(i).length) o.remove();
                            });
                        }
                    });
                };
                this.Reference = function(o) {
                    var l = e(h.li, {
                        "class": "ref"
                    }).appendTo(n), r = new g(t).ref(o).result;
                    e.each(r, function(n, r) {
                        e.each(r, function(r, f) {
                            if (f.length) e(h.a).html(a.BFBCV.replace(/{b}/, c[n]).replace(/{c}/, i.Num(r)).replace(/{v}/, i.Num(new g(t).nameVerse(f)))).on(s.Click, function() {
                                e.extend(t, {
                                    ref: o
                                });
                                i.reference(l);
                            }).appendTo(l);
                        });
                    });
                    return l;
                };
            }
        }
        function d(t) {
            this.page = function(n) {
                var i = s.lang[t.bible], o;
                (function a() {
                    o = e(h.ol, {
                        "class": "nobg"
                    }).appendTo(n.attr({
                        "class": "wrp wrp-content wrp-note d1"
                    }).empty());
                    if (s.note) {
                        var i = Object.keys(s.note).length;
                        e.each(s.note, function(n, i) {
                            if (i.name) {
                                var l = e.isNumeric(n) ? true : false;
                                var c = l ? "icon-list" : "icon-" + n;
                                var f = i.data ? Object.keys(i.data).length : 0;
                                e(h.li, {
                                    id: n,
                                    "class": l ? "yes" : "no",
                                    "data-title": f
                                }).append(e(h.ul).append(e(h.li, {
                                    "class": c
                                }), e(h.li, {
                                    text: i.name,
                                    "class": f > 0 ? "yes" : "no",
                                    "data-count": f
                                }).on(s.Click, function(n) {
                                    var o = e(this), s = o.parent(), a = s.parent().children().eq(1);
                                    if (!o.attr("contenteditable")) {
                                        if (a.length) {
                                            a.remove();
                                            s.removeClass(config.css.active);
                                        } else {
                                            s.addClass(config.css.active);
                                            a = s.parent();
                                            if (i.data) {
                                                new p(e.extend({}, t, {
                                                    ref: i.data
                                                })).note(a);
                                            } else {
                                                e(h.ol, {
                                                    "class": "norecord"
                                                }).append(e(h.li).html("No record found!")).appendTo(a);
                                            }
                                        }
                                    }
                                }))).appendTo(o).promise().done(function(t) {
                                    t.children().append(e(h.li).append(e(h.span, {
                                        "class": "icon-dot3",
                                        title: "Option"
                                    }).on(s.Click, function(i) {
                                        var o = e(this).parent();
                                        if (o.children().eq(1).length) {
                                            o.children().eq(1).remove();
                                        } else {
                                            e(h.ul, {
                                                "class": "mO other"
                                            }).append(e(h.li, {
                                                "class": "delete icon-trash",
                                                title: "Empty"
                                            }).on(s.Click, function() {
                                                delete s.note[n].data;
                                                r.update.note().then(a);
                                            }), e(h.li, {
                                                "class": "delete icon-edit",
                                                title: "Rename"
                                            }).on(s.Click, function() {
                                                var t = e(this), i = t.parent().parent().parent(), o = i.children().eq(1), a = o.text();
                                                if (o.attr("contenteditable")) {
                                                    l().html(a);
                                                } else {
                                                    l(a).focus().on("keydown", function(e) {
                                                        if (e.keyCode === 27) {
                                                            l().html(a);
                                                        } else if (e.keyCode === 13) {
                                                            s.note[n].name = l().text();
                                                            r.update.note();
                                                        }
                                                    });
                                                }
                                                function l(e) {
                                                    if (e) {
                                                        i.addClass("editing");
                                                        return o.attr({
                                                            "data-title": e,
                                                            contenteditable: true
                                                        });
                                                    } else {
                                                        i.removeClass("editing");
                                                        return o.removeAttr("contenteditable", "autocomplete");
                                                    }
                                                }
                                            })).appendTo(o).promise().done(function(i) {
                                                if (l) {
                                                    e(h.li, {
                                                        "class": "delete icon-wrong",
                                                        title: "Delete"
                                                    }).on(s.Click, function() {
                                                        delete s.note[n];
                                                        r.update.note().then(t.remove());
                                                    }).appendTo(i);
                                                }
                                            });
                                            u().doClick(function(t) {
                                                if (!e(t.target).closest(o).length) o.children().eq(1).remove();
                                            });
                                        }
                                    })));
                                });
                            }
                        });
                    } else {
                        e(h.li).html("No records were found!").appendTo(o);
                    }
                    e(h.li).append(e(h.ul).append(e(h.li, {
                        "class": "icon-tag"
                    }), e(h.li, {
                        contenteditable: true,
                        "data-title": "Add"
                    }).on("keydown", function(t) {
                        if (t.keyCode === 13) {
                            var n = e(this).text(), i = Math.random().toString().substr(2, 9);
                            if (n && !s.note[i]) {
                                s.note[i] = {
                                    name: n
                                };
                                r.update.note().then(a);
                            }
                        } else if (t.keyCode === 27) {
                            e(this).empty();
                        }
                    }))).appendTo(o);
                })();
            };
            this.search = function(n) {
                if (s.note) {
                    e.each(s.note, function(e, i) {
                        if (i.data) {
                            if (i.data[t.bID]) {
                                if (i.data[t.bID][t.cID]) {
                                    n(true);
                                } else {
                                    n(false);
                                }
                                return;
                            }
                        }
                    });
                } else {
                    n(false);
                }
            };
        }
        function g(e) {
            var t = s.lang[e.bible].name, n = bible.info, o, a, l, r, c = {
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
                if (a <= n[o].c) {
                    var e = n[o].v[a - 1];
                    if (!this.result[o][a]) this.result[o][a] = [];
                    if (l && r) {
                        var t = l <= e ? l : e, s = r <= e ? r : e;
                        for (i = t; i < s + 1; i++) {
                            this.push(this.result[o][a], i);
                        }
                    } else if (l) {
                        this.push(this.result[o][a], l <= e ? l : e);
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
                    var n = e.toString().slice(-1) != c.verse ? c.verse : "";
                    return e + n + t;
                }
                e.filter(function(e, i, o) {
                    var s = parseInt(e), a = parseInt(o[i - 1]), l = parseInt(o[i + 1]);
                    if (i == 0) {
                        t = s;
                    } else if (s >= a + 1) {
                        if (s > a + 1) {
                            t = t + c.chapter + s;
                        } else if (s + 1 < l) {
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
                        a = n;
                        for (var i in e[t][n]) {
                            var s = e[t][n][i].split(c.verse);
                            l = parseInt(s[0]), r = s.length > 1 ? parseInt(s[1]) : false;
                            this.options();
                        }
                    }
                }
                return this;
            };
            this.ref = function(e) {
                if (!Array.isArray(e)) e = e.split(c.book);
                for (var t in e) {
                    var n = /(((\w+)\.(\d+)\.(\d+))([\-–]?)?((\w+)\.(\d+)\.(\d+))?)/.exec(e[t]);
                    if (Array.isArray(n)) {
                        o = this.search(n[3]);
                        if (o) {
                            a = parseInt(n[4]), l = parseInt(n[5]), r = parseInt(n[10]);
                            this.options();
                        }
                    }
                }
                return this;
            };
            this.str = function(e) {
                if (!Array.isArray(e)) e = e.split(c.book);
                for (var t in e) {
                    if (e[t]) {
                        var n = e[t].trim().split(c.chapter);
                        for (var i in n) {
                            if (i == 0) {
                                var s = /(\d?(\w+?)?(\s?)\w+(\s+?)?(\s?)\w+(\s+?))?((\d+)((\s+)?\:?(\s+)?)?)((\d+)([\-–])?(\d+)?)?/.exec(n[i]);
                                if (s && s[1]) {
                                    o = this.search(s[1]);
                                    if (o) {
                                        a = parseInt(s[8]), l = parseInt(s[13]), r = parseInt(s[15]);
                                        this.options();
                                    } else {
                                        break;
                                    }
                                } else {
                                    break;
                                }
                            } else if (o) {
                                var s = /(\s?(\d+?)(\s+)?\:(\s+)?)?(\s?\d+)?(\s?(\d+?)?([\-–])?(\s?\d+)?)/.exec(n[i]);
                                if (s) {
                                    a = parseInt(s[2]) || a, l = parseInt(s[5]), r = parseInt(s[9]);
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
        f.prototype.watch = function() {
            e(document).on(s.Click, u(s.On).is("class").name, function(t) {
                u(e(this)).exe(u(e(this)).get("class").element);
            });
        };
        f.prototype.metalink = function() {
            u(this.arg[0]).loop(function(e, t) {
                window[t] = u(t).is("link").get("href").name;
            });
        };
        f.prototype.metacontent = function() {
            u(this.arg[0]).loop(function(e, t) {
                window[t] = u(t).is("meta").get("content");
            });
        };
        f.prototype.exe = function(t) {
            var n = this.arg[0], i = this[t[0]];
            if (i) {
                if (e.isFunction(i)) {
                    return u(n)[t[0]](this);
                } else {
                    i = i[t[1]];
                    if (i) {
                        if (e.isFunction(i)) {
                            return u(n)[t[0]][t[1]](this);
                        } else {
                            i = i[t[2]];
                            if (i) {
                                if (e.isFunction(i)) {
                                    return u(n)[t[0]][t[1]][t[2]](this);
                                }
                            }
                        }
                    }
                }
            }
            return false;
        };
        f.prototype.is = function(t) {
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
        f.prototype.get = function(t) {
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
            s.Orientation.evt = Object.prototype.hasOwnProperty.call(window, "onorientationchange") ? "orientationchange" : "resize";
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
                    var t = e.shift(), i = t.type, o = (t.dir || n.type[i].dir) + t.name + n.type[i].extension, a = document.createElement(i);
                    u(n.type[i].attr).loop(function(e, t) {
                        a[e] = t || o;
                    });
                    a.onload = function() {
                        s.msg.info.html(t.name);
                        if (e.length) {
                            n.go(e);
                        } else {
                            n.m.Listen();
                        }
                    };
                    document.head.appendChild(a);
                }
            };
            n.go(e.merge(n.meta, new b(this).get()));
            this.createProperty("Orientation", function() {
                e(config.css.content).css({
                    top: e(config.css.header).outerHeight(),
                    bottom: e(config.css.footer).outerHeight()
                });
            });
        };
        this.Listen = function() {
            if (s.isCordova) {
                s.msg.info.html("getting Device ready").attr({
                    "class": "icon-database"
                });
                document.addEventListener("deviceready", this.Initiate, false);
            } else {
                s.msg.info.attr({
                    "class": "icon-database"
                });
                this.Initiate();
            }
        };
        this.Initiate = function() {
            u(s.E).loop(function(t, n) {
                t = e.type(n) === "object" ? Object.keys(n)[0] : n;
                u(n[t]).exe(t.split(" "));
            });
        };
        function b(n) {
            this.name = {
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
                    return s.Platform === "chrome";
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
            };
            this.listen = function() {
                if (window.addEventListener) {
                    window.addEventListener(s.Orientation.evt, this.f2, false);
                } else if (window.attachEvent) {
                    window.attachEvent(s.Orientation.evt, this.f2);
                } else {
                    window[s.Orientation.evt] = this.f2;
                }
                this.f2();
            }, this.f2 = function() {
                e(window.document.documentElement).attr({
                    "class": window.innerHeight < window.innerWidth ? s.Orientation.landscape : s.Orientation.portrait
                });
                if (Object.prototype.hasOwnProperty.call(n, "Orientation")) n.Orientation();
            }, this.get = function() {
                this.listen();
                var t = [], n = [], i = "mobile", o = "tablet", a = "ios", l = "android";
                s.isCordova = this.name.cordova();
                s.isChrome = this.name.chrome();
                if (!s.Platform) s.Platform = "web";
                if (!s.Deploy) s.Deploy = "desktop";
                if (this.name.mobile()) {
                    s.Deploy = "mobile";
                } else if (this.name.tablet()) {
                    s.Deploy = "tablet";
                } else {
                    if (e.isFunction(this.name[s.Device])) {}
                }
                t.push(s.Deploy, s.Platform);
                if (this.name.ios()) {
                    s.Device = "ios";
                } else if (this.name.android()) {
                    s.Device = "android";
                } else if (e.isFunction(this.name[s.Device])) {} else {
                    if (s.Deploy != "desktop") {
                        s.Deploy = "desktop";
                    }
                    s.Device = "default";
                }
                t.push(s.Device);
                s.DeviceTemplate = [ s.Device, s.Platform, s.Deploy ];
                var r = [], c = [];
                for (var f in t) {
                    c.push(t[f]);
                    var u = c.join(".");
                    r.push({
                        type: "link",
                        name: u
                    }, {
                        type: "script",
                        name: u
                    });
                }
                return r;
            };
        }
        return this;
    };
})(jQuery, navigator.userAgent);

(function() {
    "use strict";
    Object.defineProperties(Object.prototype, {
        hashChange: {
            value: function(e) {
                window.location.hash = this.toString() + jQuery.param(e);
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
                    c(e, t, function(e, t) {
                        n(e, t);
                    });
                } else {
                    l(e, t, function(e, t) {
                        n(e, t);
                    });
                }
            }, function(e) {
                n(false, e);
            });
        }
        function l(e, t, n) {
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
        function r(e, t, n) {
            e.remove(function(e) {
                n(true, e);
            }, function(e) {
                n(false, e);
            });
        }
        function c(e, t, n) {
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
        function f(e, t, n) {
            if (t[0] == "." || t[0] == "") {
                t = t.slice(1);
            }
            e.getDirectory(t[0], {
                create: true
            }, function(e) {
                if (t.length) {
                    f(e, t.slice(1), n);
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
                            c(o, e, function(i, o) {
                                if (i) {
                                    t(e);
                                } else {
                                    n(o);
                                }
                            });
                        } else {
                            l(o, e, function(i, o) {
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
                            f(o, s, function(i, s) {
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
                        r(o, e, function(e, i) {
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
                var l = window.XMLHttpRequest ? new XMLHttpRequest() : new ActiveXObject("Microsoft.XMLHTTP");
                var r = 0;
                l.addEventListener("progress", function(t) {
                    r++;
                    if (t.lengthComputable) {
                        r = Math.floor(t.loaded / t.total * 100);
                        e.progress(r);
                    } else if (l.readyState == XMLHttpRequest.DONE) {
                        e.progress(100);
                    } else if (l.status != 200) {
                        e.progress(Math.floor(r / 7 * 100));
                        r++;
                    }
                }, false);
                l.addEventListener("load", function(r) {
                    e.fileUrlResponse = r.target.responseURL;
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
                    if (r.target.responseXML) {
                        e.fileCharset = r.target.responseXML.charset;
                        e.fileContentType = r.target.responseXML.contentType;
                    } else {
                        e.fileCharset = "UTF-8";
                        if (o.extension[e.fileExtension]) {
                            e.fileContentType = o.extension[e.fileExtension].ContentType;
                        }
                    }
                    e.responseXML = r.target.responseXML;
                    e.responseURL = r.target.responseURL;
                    if (l.status == 200) {
                        e.fileSize = r.total;
                        e.fileContent = r.target.responseText;
                        if (typeof e.fileOption == "object" && e.fileOption.create === true && e.fileUrlLocal && i.Ok === true) {
                            s(e, function(i, o) {
                                if (i == 1) {
                                    c(o, e, function(i, o) {
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
                                        f(o, s, function(i, s) {
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
                    } else if (l.statusText) {
                        n({
                            message: l.statusText + ": " + e.fileUrl,
                            code: l.status
                        });
                    } else if (l.status) {
                        n({
                            message: "Error",
                            code: l.status
                        });
                    } else {
                        n({
                            message: "Unknown Error",
                            code: 0
                        });
                    }
                }, false);
                l.addEventListener("error", function(e) {
                    n(e);
                }, false);
                l.addEventListener("abort", function(e) {
                    n(e);
                }, false);
                if (e.fileCache) {
                    e.fileUrlRequest = e.fileUrl + (e.fileUrl.indexOf("?") > 0 ? "&" : "?") + "_=" + new Date().getTime();
                } else {
                    e.fileUrlRequest = e.fileUrl;
                }
                if (e.fileUrl) {
                    l.open(e.requestMethod ? e.requestMethod : "GET", e.fileUrlRequest, true);
                    e.before(l);
                    l.send();
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
                        c(o, e, function(i, o) {
                            if (i) {
                                t(e);
                            } else {
                                n(o);
                            }
                        });
                    } else if (i == 2) {
                        var s = u(e.fileUrlLocal);
                        if (s) {
                            f(o, s, function(i, s) {
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