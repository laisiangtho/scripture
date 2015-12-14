/*!
    laisiangtho -- the Holy Bible in languages
    Version 1.1.9
    https://khensolomonlethil.github.io/laisiangtho
    (c) 2013-2015
*/
(function(e, t) {
    var n = "laisiangtho", o = "1.9.86.2015.8.28";
    e.fn[n] = function(n) {
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
                Load: {
                    o: [ "fO", "config" ],
                    f: [ "new Database(db,fO,config)", "other", "init" ]
                },
                Watch: {
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
            App: r,
            Click: "click",
            On: r,
            Hash: "hashchange",
            Device: "desktop",
            Platform: "web",
            Layout: r,
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
                info: e("li:first-child")
            }
        }, n);
        var o, s = this, a = function() {
            this.arg = arguments;
            return this;
        };
        var r = window[fO.App] = function() {
            var e = arguments;
            function t() {
                a.apply(this, e);
            }
            t.prototype = Object.create(a.prototype);
            t.prototype.constructor = a;
            return new t();
        };
        a.prototype.tmp = function() {
            console.log("tmp");
        };
        a.prototype.ClickTest = function(e) {
            this.arg[0].append("...");
        };
        a.prototype.Load = function() {
            e("p").addClass(config.css.active).html(config.version);
            e("h1").attr({
                title: config.build
            }).attr({
                "class": "icon-fire"
            });
            var t = this, n = [], i = {}, s = {
                reading: function(e) {
                    if (config.bible.ready && fO.query.bible) {
                        if (config.bible.ready == 1) {
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
                            if (s.reading(t) == t) {
                                new r({
                                    bible: t,
                                    reading: t,
                                    downloading: t
                                }).xml(function(e) {
                                    s.next();
                                }).has();
                            } else {
                                s.next();
                            }
                        });
                    } else {
                        this.json(t, this.next);
                    }
                },
                json: function(o, a, f) {
                    var l = t.url(config.id, [ o ], config.file.lang);
                    var c = e.ajax({
                        url: (f ? f : "") + l.fileUrl,
                        dataType: l.fileExtension,
                        contentType: l.fileContentType,
                        cache: false
                    });
                    c.done(function(n) {
                        var f = n.info.lang = n.info.lang || config.language.info.lang;
                        fO.msg.info.html(n.info.name);
                        var l = function(n, i) {
                            var l = {};
                            return {
                                is: {
                                    index: function(e) {
                                        l[e] = fO.lang[o].index;
                                    },
                                    name: function(o) {
                                        l[o] = {};
                                        for (var s in n[o]) {
                                            var a = typeof i.b === "undefined" || typeof i.b[s] === "undefined" ? [] : [ i.b[s] ];
                                            var r = typeof i.name === "undefined" || typeof i.name[s] === "undefined" ? [] : i.name[s];
                                            e.merge(a, r);
                                            l[o][s] = e.unique(t.array(n[o][s]).merge(a).data);
                                        }
                                    }
                                },
                                merge: function() {
                                    for (var t in n) {
                                        if (this.is[t]) {
                                            this.is[t](t);
                                        } else {
                                            l[t] = i[t] ? e.extend({}, n[t], i[t]) : n[t];
                                        }
                                    }
                                    return l;
                                },
                                next: function() {
                                    e.extend(fO.lang[o], this.merge());
                                    e("p").html(f).attr({
                                        "class": "icon-database"
                                    }).promise().done(function() {
                                        new r({
                                            bible: o,
                                            reading: s.reading(o),
                                            downloading: null
                                        }).xml(function(e) {
                                            a();
                                        }).has();
                                    });
                                }
                            };
                        };
                        if (i[f]) {
                            l(i[f], n).next();
                        } else {
                            var c = t.url("lang", [ f ], config.file.lang), u = e.ajax({
                                url: c.fileUrl,
                                dataType: c.fileExtension,
                                contentType: c.fileContentType,
                                cache: false
                            });
                            u.done(function(e) {
                                i[f] = l(config.language, e).merge();
                                l(i[f], n).next();
                            });
                            u.fail(function(e, t) {
                                l(config.language, n).next();
                            });
                        }
                    });
                    c.fail(function(e, t) {
                        if (api.name) {
                            if (f) {
                                db.RemoveLang(o, function() {
                                    n.splice(n.indexOf(o), 1);
                                    a();
                                });
                            } else {
                                s.json(o, a, api.name);
                            }
                        } else {
                            db.RemoveLang(o, function() {
                                n.splice(n.indexOf(o), 1);
                                a();
                            });
                        }
                    });
                },
                next: function() {
                    if (n.length) {
                        s.start();
                    } else {
                        e(window).bind(fO.Hash, function() {
                            r().init();
                        });
                        function t() {
                            db.get({
                                table: config.store.note
                            }).then(function(e) {
                                if (e) {
                                    fO.note = e;
                                    s.done();
                                } else {
                                    db.add({
                                        table: config.store.note,
                                        data: config.store.noteData
                                    }).then(function(e) {
                                        fO.note = e;
                                        s.done();
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
                        e(document.body).load(config.file.template.replace(/{Deploy}/, fO.Deploy).replace(/{Platform}/, fO.Platform), function() {
                            t.init();
                        }).promise().done(function() {
                            this.attr("id", fO.App);
                        });
                    } else {
                        t.init();
                    }
                    e(document.body).keydown(function(e) {
                        if (e.which == 27) fO.todo.pause = true; else if (e.which == 13) fO.todo.enter = true;
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
                                s.available(e);
                                a();
                            }
                        } else {
                            fO.Ready = 1;
                            s.available();
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
                        o = new fileSystask({
                            Base: "Other",
                            RequestQuota: 1073741824,
                            Permission: 1
                        }, {
                            success: function(e) {},
                            fail: function(e) {},
                            done: function(e) {
                                fO.query.bible = "tedim";
                                if (fO.Ready == 3) {
                                    s.start();
                                } else {
                                    db.add({
                                        table: config.store.info,
                                        data: {
                                            build: config.build,
                                            version: config.version
                                        }
                                    }).then(s.start());
                                }
                            }
                        });
                    }
                });
            });
        };
        a.prototype.Database = function(e) {
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
            localforage.setDriver([ localforage.INDEXEDDB, localforage.WEBSQL, localforage.LOCALSTORAGE ]).then(function() {
                return true;
            });
            localforage.ready().then(function() {
                return e.apply(t);
            });
            return "!";
        };
        a.prototype.hash = function(e) {
            var t = location.hash, n = {
                page: t.split("?")[0].replace("#", "")
            }, i, o = /([^\?#&=]+)=([^&]*)/g, s = function(e) {
                return decodeURIComponent(e.replace(/\+/g, " "));
            };
            while (i = o.exec(t)) n[s(i[1])] = s(i[2]);
            e(n);
        };
        a.prototype.url = function(e, t, n) {
            var i = this.string([ e, 47, t.join("/"), 46, n ]), o = i.substring(i.lastIndexOf("/") + 1), s = this.string([ "application", 47, n ]), a = null, r = null;
            if (fO.isCordova) {} else if (fO.isChrome) {}
            return {
                fileName: o,
                fileExtension: n,
                fileUrl: i,
                fileCharset: s + ";charset=utf-8",
                fileContentType: s
            };
        };
        a.prototype.num = function(e, t) {
            if (!t) t = fO.query.bible;
            return Object.getOwnPropertyNames(fO.lang[t].n).length === 0 ? e : e.toString().replace(/[0123456789]/g, function(e) {
                return fO.lang[t].n[e];
            });
        };
        a.prototype.string = function(t) {
            return e.map(t, function(t) {
                return e.isNumeric(t) ? String.fromCharCode(t) : t;
            }).join("").toString();
        };
        a.prototype.index = function() {
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
        a.prototype.array = function(t, n) {
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
        a.prototype.working = function(t) {
            if (fO.msg.info.is(":hidden")) {
                e("body").addClass(config.css.working).promise().done(fO.msg.info.slideDown(200));
            }
            if (t.wait === true) {
                e("body").addClass(config.css.wait);
            }
            if (t.disable === true) {
                e("body").addClass(config.css.disable);
            }
            return t.msg ? fO.msg.info.html(t.msg) : fO.msg.info;
        };
        a.prototype.done = function(e) {
            var t = this;
            fO.msg.info.slideUp(200).empty().promise().done(function() {
                t.body().promise().done(function() {
                    if (e) e();
                });
            });
        };
        a.prototype.template = function(t, n) {
            var o = e(), s = this.obj;
            var a = this;
            e.each(this.arg[0], function(t, n) {
                (function s(t, n, a, f) {
                    var l = n.attr, c = n.text, u = false, d = e(r(t).is("tag").name, l);
                    if (l && l.fn) {
                        u = n.attr.fn.split(" ");
                        delete l.fn;
                    }
                    if (e.type(c) === "string") {
                        d.html(c);
                    } else if (n.value) {
                        d.val(n.value);
                    } else if (!c) {} else {
                        for (i in c) {
                            if (e.isNumeric(i)) {
                                var t = Object.keys(c[i]);
                                s(t, c[i][t], d);
                            } else {
                                s(i, c[i], d);
                            }
                        }
                    }
                    if (f) {
                        o = a.add(d);
                    } else {
                        a.append(d);
                    }
                })(t, n, o, true);
            });
            if (t) {
                (e.type(t) !== "object" ? e(t) : t)[n || "append"](o);
            }
            return o;
        };
        a.prototype.activeClass = function(t) {
            return t.find(r(config.css.active).is("class").name).removeClass(config.css.active).promise().done(e(config.css.currentPage).addClass(config.css.active));
        };
        a.prototype.header = function(e) {
            if (config.header[fO.query.page]) {
                if (fO.todo.headerChanged != fO.query.page) {
                    e.replaceWith(r({
                        header: config.header[fO.query.page]
                    }).template()).promise().done(function() {
                        fO.todo.headerChanged = fO.query.page;
                        e.find(config.css.currentPage).addClass(config.css.active).siblings().removeClass(config.css.active);
                        fO.todo.Orientation = true;
                    });
                }
            } else if (fO.todo.headerChanged) {
                e.replaceWith(r({
                    header: config.body.header
                }).template()).promise().done(function() {
                    delete fO.todo.headerChanged;
                    e.find(config.css.currentPage).addClass(config.css.active).siblings().removeClass(config.css.active);
                    fO.todo.Orientation = true;
                });
            } else {
                this.activeClass(e);
            }
        };
        a.prototype.footer = function(t) {
            if (config.footer[fO.query.page]) {
                if (fO.todo.footerChanged != fO.query.page) {
                    t.replaceWith(r({
                        footer: config.footer[fO.query.page]
                    }).template()).promise().done(function() {
                        fO.todo.footerChanged = fO.query.page;
                        e(config.css.currentPage).addClass(config.css.active);
                        fO.todo.Orientation = true;
                    });
                }
            } else if (fO.todo.footerChanged) {
                t.replaceWith(r({
                    footer: config.body.footer
                }).template()).promise().done(function() {
                    delete fO.todo.footerChanged;
                    e(config.css.currentPage).addClass(config.css.active);
                    fO.todo.Orientation = true;
                });
            } else {
                this.activeClass(t);
            }
        };
        a.prototype.init = function() {
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
            this.hash(function(t) {
                var i = {
                    page: function(t, n, i) {
                        fO.query[t] = e.inArray(n.toLowerCase(), config.page) >= 0 ? n : i;
                        config.css.currentPage = r(fO.query[t]).is("class").name;
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
            if (fO.todo.Template) {
                e(config.css.header).find("*").removeClass(config.css.active).siblings(config.css.currentPage).addClass(config.css.active);
            }
            var i = r("lookup").is("form").element;
            if (i.length) {
                i.off().on("submit", function() {
                    var t = e(this);
                    t.serializeObject(fO.query);
                    if (fO.query.page == t.attr("name")) {
                        t.find(r("q").is("input").name).attr("autocomplete", "off").focus().select().promise().done(r().lookup());
                    } else {
                        t.attr("action").hashChange({
                            q: fO.query.q
                        });
                    }
                    return false;
                });
                r("search").is("input").element.off().on(fO.Click, function() {
                    e(this.form).submit();
                }).promise().done(function() {
                    r("q").is("input").element.attr("autocomplete", "off").focus().select();
                });
            }
            fO.container.main = e(config.css.content).children(config.css.currentPage);
            fO.container.main.fadeIn(300).siblings().hide().promise().done(this[e.isFunction(this[fO.query.page]) ? fO.query.page : e(config.page).get(-1)]());
            r("fn").is("attr").get("fn").element.each(function() {}).promise().done(function() {
                db.update.query();
            });
            if (fO.todo.Orientation) {
                s.Orientation();
                delete fO.todo.Orientation;
            }
        };
        a.prototype.bible = function() {
            console.log("no bible?", config.bible.available);
        };
        a.prototype.book = function() {
            console.log("no book?");
        };
        a.prototype.reader = function() {
            console.log("no reader?");
        };
        a.prototype.lookup = function() {
            console.log("no lookup?");
        };
        a.prototype.note = function() {
            console.log("no note?");
        };
        a.prototype.todo = function() {
            console.log("nothing todo?");
        };
        a.prototype.xml = function(t) {
            var n = this, i = this.arg[0];
            var s = fO.lang[i.bible], a = s.l, r = s.b;
            var f = this.url(config.id, [ i.bible ], config.file.bible);
            this.has = function() {
                if (e.isEmptyObject(fO[i.bible].bible)) {
                    if (o.support) {
                        o.get({
                            fileName: f.fileUrl,
                            fileOption: {},
                            fileObject: function() {
                                n.file.read(this.fileEntry);
                            },
                            fileNotExists: function() {
                                if (i.bible == i.downloading) {
                                    n.file.download();
                                } else {
                                    n.ResponseGood({
                                        msg: "fileNotExists",
                                        status: false
                                    });
                                }
                            },
                            fileError: function(e) {
                                n.ResponseGood({
                                    msg: "to fileSystem.fileError",
                                    status: false
                                });
                            }
                        });
                    } else {
                        n.ResponseGood({
                            msg: "fileSystem NotOk, process ot db ",
                            status: false
                        });
                    }
                } else {
                    n.ResponseGood({
                        msg: "from Object",
                        status: true
                    });
                }
                return this;
            };
            this.get = function() {
                if (e.isEmptyObject(fO[i.bible].bible)) {
                    if (fO.isCordova) {
                        n.working({
                            msg: a.PleaseWait,
                            wait: true
                        }).promise().done(function() {
                            f.local.resolveFileSystem(n.file.Cordova().get, n.file.Cordova().download);
                        });
                    } else if (fO.isChrome) {
                        n.ResponseGood({
                            msg: "to Webkit",
                            status: false
                        });
                    } else {
                        db.get({
                            table: i.bible
                        }).then(function(t) {
                            if (t) {
                                fO[i.bible].bible = t;
                                if (e.isEmptyObject(fO[i.bible].bible)) {
                                    n.file.IndexDb().download();
                                } else {
                                    n.ResponseGood({
                                        msg: "from Store",
                                        status: true
                                    });
                                }
                            } else {
                                n.file.IndexDb().download();
                            }
                        });
                    }
                } else {
                    n.ResponseCallbacks({
                        msg: "from Object",
                        status: true
                    });
                }
            };
            this.remove = function() {
                if (fO.isCordova) {
                    f.local.resolveFileSystem(n.file.Cordova().remove, function(e) {
                        n.ResponseGood({
                            status: true
                        });
                    });
                } else {
                    db.delete({
                        table: i.bible
                    }).then(function() {
                        n.ResponseBad({
                            status: true
                        });
                    });
                }
            };
            this.file = {
                IndexDb: function() {
                    this.download = function(t) {
                        e.ajax({
                            beforeSend: function(e) {
                                n.working({
                                    msg: a.Downloading,
                                    wait: true
                                });
                                e.setRequestHeader("Access-Control-Allow-Origin", "*");
                            },
                            xhr: function() {
                                var e = new window.XMLHttpRequest();
                                e.addEventListener("progress", function(e) {
                                    if (e.lengthComputable) {
                                        var t = Math.floor(e.loaded / e.total * 100);
                                        n.working({
                                            msg: a.PercentLoaded.replace(/{Percent}/, n.num(t))
                                        });
                                    }
                                }, false);
                                return e;
                            },
                            url: t ? t + f.url : f.url,
                            dataType: f.data,
                            contentType: f.content,
                            cache: true,
                            crossDomain: true,
                            async: true
                        }).done(function(e, t, i) {
                            n.JobType(e);
                        }).fail(function(e, i) {
                            if (api) {
                                if (t) {
                                    n.ResponseGood({
                                        msg: i,
                                        status: false
                                    });
                                } else {
                                    n.file.IndexDb().download(api);
                                }
                            } else {
                                n.ResponseGood({
                                    msg: i,
                                    status: false
                                });
                            }
                        }).always(function() {});
                    };
                    this.read = function() {};
                    this.get = function() {};
                    this.content = function() {};
                    this.remove = function() {};
                    return this;
                },
                Cordova: function() {
                    this.download = function() {};
                    this.read = function(e) {
                        if (i.bible == i.reading) {
                            this.content(e);
                        } else {
                            n.ResponseGood({
                                msg: "from Reading",
                                status: true
                            });
                        }
                    };
                    this.get = function(e) {
                        this.content(e);
                    };
                    this.content = function(e, t) {
                        e.file(function(e) {
                            var t = new FileReader();
                            t.onloadend = function(e) {
                                var t = new DOMParser();
                                n.JobType(t.parseFromString(e.target.result, f.type));
                            };
                            t.readAsText(e);
                        }, function() {
                            n.ResponseGood({
                                msg: "fail to read Local",
                                status: false
                            });
                        });
                    };
                    this.remove = function(e) {
                        e.remove(function() {
                            n.ResponseBad({
                                status: true
                            });
                        }, function(e) {
                            n.ResponseBad({
                                status: false
                            });
                        });
                    };
                    return this;
                },
                Chrome: function() {
                    this.download = function() {};
                    return this;
                },
                Web: function() {
                    this.download = function() {};
                    return this;
                },
                download: function() {
                    o.download({
                        Method: "GET",
                        fileUrl: f.fileUrl,
                        fileUrlLocal: f.fileUrl,
                        fileCache: false,
                        progress: function(e) {
                            console.log(e);
                        },
                        done: function(e) {
                            console.log("done", e);
                        },
                        fail: function(e) {
                            console.log("fail", e);
                        },
                        success: function(e) {
                            console.log("success", e);
                            o.save(Object.assign(e, {
                                success: function(e) {
                                    n.has();
                                },
                                fail: function(e) {
                                    n.ResponseGood({
                                        msg: "fail saving",
                                        status: false
                                    });
                                },
                                done: function(e) {}
                            })).then(function(e) {
                                console.log("save.then.success", e);
                            });
                        }
                    }).then(function(e) {
                        console.log("download.then", e);
                    });
                },
                read: function(e) {
                    if (i.bible == i.reading) {
                        this.content(e);
                    } else {
                        n.ResponseGood({
                            msg: "from Reading",
                            status: true
                        });
                    }
                },
                content: function(e) {
                    e.file(function(e) {
                        var t = new FileReader();
                        t.onloadend = function() {
                            n.JobType(new DOMParser().parseFromString(this.result, f.fileContentType));
                        };
                        t.readAsText(e);
                    }, function() {
                        n.ResponseGood({
                            msg: "fail to read Local",
                            status: false
                        });
                    });
                },
                remove: function(e) {
                    e.remove(function() {
                        n.ResponseBad({
                            status: true
                        });
                    }, function(e) {
                        n.ResponseBad({
                            status: false
                        });
                    });
                }
            };
            this.JobType = function(t) {
                var n = e(t).children().get(0).tagName;
                if (e.isFunction(this.Job[n])) {
                    fO[i.bible].bible = {
                        info: {},
                        book: {}
                    };
                    this.Job[n](t);
                } else {
                    this.ResponseGood({
                        msg: a.IsNotFoundIn.replace(/{is}/, n).replace(/{in}/, "jobType"),
                        status: false
                    });
                }
            };
            this.Job = {
                bible: function(t) {
                    var s = [], a = [], f = 0;
                    e(t).children().each(function(t, s) {
                        var a = e(s), f = a.children(), l = a.attr("id");
                        if (f.length) {
                            f.each(function(t, s) {
                                var a = e(s), l = a.children(), s = a.attr("id"), c = a.get(0).tagName.toLowerCase(), u = 0;
                                if (e.type(fO[i.bible].bible[c]) === "undefined") fO[i.bible].bible[c] = {};
                                if (l.length) {
                                    fO[i.bible].bible[c][s] = {};
                                    setTimeout(function() {
                                        l.each(function(a, r) {
                                            var d = e(r), p = d.children(), r = d.attr("id"), h = d.get(0).tagName.toLowerCase();
                                            if (e.type(fO[i.bible].bible[c][s][h]) === "undefined") fO[i.bible].bible[c][s][h] = {};
                                            if (p.length) {
                                                fO[i.bible].bible[c][s][h][r] = {};
                                                fO[i.bible].bible[c][s][h][r].verse = {};
                                                setTimeout(function() {
                                                    p.each(function(u, d) {
                                                        var g = e(d), b = g.children(), d = g.attr("id"), m = g.get(0).tagName.toLowerCase();
                                                        d = "v" + d;
                                                        fO[i.bible].bible[c][s][h][r].verse[d] = {};
                                                        fO[i.bible].bible[c][s][h][r].verse[d].text = g.text();
                                                        if (g.attr("ref")) fO[i.bible].bible[c][s][h][r].verse[d].ref = g.attr("ref").split(",");
                                                        if (g.attr("title")) fO[i.bible].bible[c][s][h][r].verse[d].title = g.attr("title").split(",");
                                                        if (f.length == t + 1) {
                                                            if (l.length == a + 1) {
                                                                if (p.length == u + 1) {
                                                                    if (o.support) {
                                                                        n.ResponseGood({
                                                                            msg: "Saved",
                                                                            status: true
                                                                        });
                                                                    } else {
                                                                        db.add({
                                                                            table: i.bible,
                                                                            data: fO[i.bible].bible
                                                                        }).then(n.ResponseGood({
                                                                            msg: "Stored",
                                                                            status: true
                                                                        }));
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    });
                                                }, 30 / t * a);
                                            } else if (r) {
                                                fO[i.bible].bible[c][s][h][r] = d.text();
                                            } else {
                                                u++;
                                                fO[i.bible].bible[c][s][h][u] = {
                                                    title: d.text()
                                                };
                                                if (d.attr("ref")) fO[i.bible].bible[c][s][h][u].ref = d.attr("ref").split(",");
                                            }
                                        }).promise().done(function() {
                                            fO.msg.info.html(r[s]);
                                        });
                                    }, 90 * t);
                                } else {
                                    fO[i.bible].bible[c][s] = a.text();
                                }
                            });
                        } else {
                            var c = a.attr("id"), u = a.text();
                        }
                    });
                }
            };
            this.ResponseGood = function(e) {
                s.local = e.status;
                if (i.reading) {
                    n.ResponseCallbacks(e);
                } else {
                    db.update.lang().then(function() {
                        n.done();
                        n.ResponseCallbacks(e);
                    });
                }
                return this;
            };
            this.ResponseBad = function(e) {
                delete fO[i.bible].bible;
                if (e.status) s.local = false;
                db.update.lang().then(function() {
                    n.ResponseCallbacks(e);
                });
                return this;
            };
            this.ResponseCallbacks = function(e) {
                this.msg = e;
                t(e);
            };
            return this;
        };
        a.prototype.Watch = function() {
            s.on(fO.Click, r(fO.On).is("class").name, function() {
                r(e(this)).exe(r(e(this)).get("class"));
            });
        };
        a.prototype.Metalink = function() {
            this.arg[0].loop(function(e, t) {
                window[t] = r(t).is("link").get("href");
            });
        };
        a.prototype.Metacontent = function() {
            this.arg[0].loop(function(e, t) {
                window[t] = r(t).is("meta").get("content");
            });
        };
        a.prototype.exe = function(t) {
            var n = this.arg[0], i = this[t[0]];
            if (i) {
                if (e.isFunction(i)) {
                    return r(n)[t[0]](t);
                } else {
                    i = i[t[1]];
                    if (i) {
                        if (e.isFunction(i)) {
                            return r(n)[t[0]][t[1]](t);
                        } else {
                            i = i[t[2]];
                            if (i) {
                                if (e.isFunction(i)) {
                                    return r(n)[t[0]][t[1]][t[2]](t);
                                }
                            }
                        }
                    }
                }
            }
            return false;
        };
        a.prototype.is = function(t) {
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
        a.prototype.get = function(t) {
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
                return this.check().split(e);
            };
            this.fn = function(e) {
                if (i[t]) {
                    this.element = this.split(i[t]);
                }
                return this;
            };
            if (e.isFunction(this[t])) {
                return this.fn(this[t]());
            } else if (this[t]) {
                return this[t];
            } else if (t) {
                return this.fn(this.attr());
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
                r(n[t]).exe(t.split(" "));
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
                var t = [];
                fO.isCordova = this.name.cordova();
                fO.isChrome = this.name.chrome();
                if (this.name.mobile()) {
                    fO.Deploy = "mobile";
                    t.push(fO.Deploy, fO.Platform);
                } else if (this.name.tablet()) {
                    fO.Deploy = "tablet";
                    t.push(fO.Deploy, fO.Platform);
                } else {
                    if (e.isFunction(this.name[fO.Device])) {
                        t.push(fO.Deploy, fO.Platform);
                    } else {
                        fO.Deploy = fO.Device;
                        t.push(fO.Deploy, fO.Platform);
                    }
                }
                if (this.name.ios()) {
                    t.push("ios");
                } else if (this.name.android()) {
                    t.push("android");
                } else if (e.isFunction(this.name[fO.Device])) {
                    t.push(fO.Device);
                }
                var n = [], i = [];
                for (var o in t) {
                    i.push(t[o]);
                    var s = i.join(".");
                    n.push({
                        type: "link",
                        name: s
                    }, {
                        type: "script",
                        name: s
                    });
                }
                return n;
            }
        };
        return this;
    };
})(jQuery, navigator.userAgent);

"use strict";

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
        requestFileSystem: {
            value: function(e, t) {
                window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, e, t);
            }
        },
        resolveFileSystem: {
            value: function(e, t) {
                window.resolveLocalFileSystemURL(this, e, t);
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
                window.location.hash = this + jQuery.param(e);
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
    window.requestFileSystask;
    window.resolveFileSystask;
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
                var a = Object.keys(this.base).pop();
                if (e) {
                    if (typeof e === "object") {
                        if (e.Base && this.base.hasOwnProperty(e.Base)) {
                            Object.assign(i, this.base[e.Base], e);
                        } else {
                            Object.assign(i, this.base[a], e, {
                                Base: a
                            });
                        }
                    } else if (typeof e === "string" && this.base[e]) {
                        Object.assign(i, this.base[e], {
                            Base: e
                        });
                    } else {
                        Object.assign(i, this.base[a], {
                            Base: a
                        });
                    }
                } else {
                    Object.assign(i, this.base[a], {
                        Base: a
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
                    s(t.success, e);
                }, function(e) {
                    s(t.fail, e);
                }).then(function() {
                    n.support = i.Ok;
                    s(t.done, i);
                });
            },
            Initiate: {
                Chrome: function(e, t) {
                    try {
                        navigator.webkitPersistentStorage.requestQuota(i.RequestQuota, function(n) {
                            i.ResponseQuota = n;
                            window.requestFileSystask = window.webkitRequestFileSystem;
                            window.resolveFileSystask = window.webkitResolveLocalFileSystemURL;
                            window.requestFileSystask(i.Permission > 0 ? window.PERSISTENT : window.TEMPORARY, n, function(t) {
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
                        window.requestFileSystask = window.requestFileSystem || window.webkitRequestFileSystem;
                        window.resolveFileSystask = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        if (window.requestFileSystask) {
                            if (window.LocalFileSystem) {
                                window.PERSISTENT = window.LocalFileSystem.PERSISTENT;
                                window.TEMPORARY = window.LocalFileSystem.TEMPORARY;
                            } else if (window.cordova && location.protocol === "file:") {}
                            window.requestFileSystask(i.Permission > 0 ? window.PERSISTENT : window.TEMPORARY, i.RequestQuota, function(t) {
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
                        window.requestFileSystask = window.requestFileSystem || window.webkitRequestFileSystem;
                        window.resolveFileSystask = window.resolveLocalFileSystemURL || window.webkitResolveLocalFileSystemURL;
                        window.requestFileSystask(i.Permission > 0 ? window.PERSISTENT : window.TEMPORARY, i.RequestQuota, function(t) {
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
                            window.requestFileSystask(i.Permission > 0 ? window.PERSISTENT : window.TEMPORARY, n, function(t) {
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
                        return window.requestFileSystask;
                    }
                },
                Cordova: function(e, t) {
                    try {
                        if (window.requestFileSystask) {
                            window.requestFileSystask(i.Permission > 0 ? window.PERSISTENT : window.TEMPORARY, i.RequestQuota, function(t) {
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
                        return window.requestFileSystask;
                    }
                },
                Other: function(e, t) {
                    try {
                        if (window.requestFileSystask) {
                            window.requestFileSystask(window.PERSISTENT, i.RequestQuota, function(t) {
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
                        return window.requestFileSystask;
                    }
                }
            },
            Resolve: {
                Chrome: function(e, t, n) {
                    try {
                        navigator.webkitPersistentStorage.requestQuota(i.RequestQuota, function(o) {
                            i.ResponseQuota = o;
                            window.resolveFileSystask(e, t, n);
                        }, function(e) {
                            n(e);
                        });
                    } catch (o) {
                        n(o);
                    } finally {
                        return window.resolveFileSystask;
                    }
                },
                Cordova: function(e, t, n) {
                    try {
                        window.resolveFileSystask(e, t, n);
                    } catch (i) {
                        n(i);
                    } finally {
                        return window.resolveFileSystask;
                    }
                },
                Other: function(e, t, n) {
                    try {
                        window.resolveFileSystask(e, t, n);
                    } catch (i) {
                        n(i);
                    } finally {
                        return window.resolveFileSystask;
                    }
                }
            }
        };
        o.Assigns(e);
        this.setting = function(e) {
            return o.Assigns(e);
        };
        this.permission = function() {};
        this.request = function(e, t) {
            if (i.Ok === false) {
                return s(t, i);
            }
            return o.Request[i.Base](function(t) {
                return s(e, t);
            }, function(e) {
                if (typeof e !== "string") {
                    if (e.message) {
                        e = e.message;
                    }
                }
                return s(t, e);
            });
        };
        this.resolve = function(e, t, n) {
            if (i.Ok === false) {
                return s(n, i);
            }
            return o.Resolve[i.Base](e, function(e) {
                return s(t, e);
            }, function(e) {
                if (typeof e !== "string") {
                    if (e.message) {
                        e = e.message;
                    }
                }
                return s(n, e);
            });
        };
        this.get = function(e) {
            return new Promise(function(t, i) {
                e.fileSystem = {};
                n.request(function(n, o) {
                    try {
                        e.fileSystem = n;
                        e.fileStatus = {};
                        n.root.getFile(e.fileName, e.fileOption, function(n) {
                            e.fileEntry = n;
                            if (typeof e.fileObject === "function") {
                                e.fileObject.apply(e);
                            }
                            t(e);
                        }, function(n) {
                            e.fileStatus = n;
                            if (typeof e.fileNotExists === "function") {
                                e.fileNotExists.apply(e);
                            }
                            t(e);
                        });
                    } catch (a) {
                        s(e.fileError, a.message ? a.message : {
                            message: a
                        });
                        i(e);
                    } finally {}
                }, function(t) {
                    s(e.fileError, t.message ? t : {
                        message: t
                    });
                    i(e);
                });
            }).then(function(e) {
                return e;
            }, function(e) {
                return e;
            });
        };
        this.download = function(e) {
            e = Object.assign({}, o.Callback, e);
            return new Promise(function(t, n) {
                var i = window.XMLHttpRequest ? new XMLHttpRequest() : new ActiveXObject("Microsoft.XMLHTTP");
                var s = 0;
                i.addEventListener("progress", function(t) {
                    s++;
                    if (t.lengthComputable) {
                        s = Math.floor(t.loaded / t.total * 100);
                        e.progress(s);
                    } else if (i.readyState == XMLHttpRequest.DONE) {
                        e.progress(100);
                    } else if (i.status != 200) {
                        e.progress(Math.floor(s / 7 * 100));
                        s++;
                    }
                }, false);
                i.addEventListener("load", function(s) {
                    var a = e.fileUrl;
                    var r = s.target.responseURL;
                    var f = a.replace(/[\#\?].*$/, "").substring(a.lastIndexOf("/") + 1);
                    var l = e.fileUrlLocal ? e.fileUrlLocal : f;
                    var c = f.split(".").pop();
                    var u, d;
                    if (s.target.responseXML) {
                        u = s.target.responseXML.charset;
                        d = s.target.responseXML.contentType;
                    } else {
                        u = "UTF-8";
                        if (o.extension[c]) {
                            d = o.extension[c].ContentType;
                        }
                    }
                    e.done(s);
                    if (i.status == 200) {
                        t({
                            fileName: f,
                            fileOption: {
                                create: true,
                                exclusive: true
                            },
                            fileExtension: c,
                            fileUrl: a,
                            fileCharset: u,
                            fileContentType: d,
                            fileSize: s.total,
                            fileUrlLocal: l,
                            fileContent: s.target.responseText,
                            responseXML: s.target.responseXML
                        });
                    } else if (i.statusText) {
                        n({
                            message: i.statusText + ": " + a,
                            code: i.status
                        });
                    } else if (i.status) {
                        n({
                            message: "Error",
                            code: i.status
                        });
                    } else {
                        n({
                            message: "Unknown Error",
                            code: 0
                        });
                    }
                }, false);
                i.addEventListener("error", function(e) {
                    n(e);
                }, false);
                i.addEventListener("abort", function(e) {
                    n(e);
                }, false);
                if (e.fileCache) {
                    e.fileUrlRequest = e.fileUrl + (e.fileUrl.indexOf("?") > 0 ? "&" : "?") + "_=" + new Date().getTime();
                } else {
                    e.fileUrlRequest = e.fileUrl;
                }
                i.open(e.Method ? e.Method : "GET", e.fileUrlRequest, true);
                e.before(i);
                i.send();
            }).then(function(t) {
                e.success(t);
                return t;
            }, function(t) {
                e.fail(t);
                return t;
            });
        };
        this.save = function(e) {
            e = Object.assign({}, o.Callback, e);
            return new Promise(function(t, i) {
                n.request(function(s, a) {
                    try {
                        if (typeof e !== "object" || !e.fileName) {
                            return i(e);
                        }
                        e.fileUrlLocal = e.fileUrlLocal ? e.fileUrlLocal : e.fileName;
                        s.root.getFile(e.fileUrlLocal, e.fileOption, function(n) {
                            n.createWriter(function(s) {
                                s.onwriteend = function() {
                                    this.onwriteend = null;
                                    this.truncate(this.position);
                                    e.filefoldersCreatedFinal = true;
                                    t(n);
                                };
                                s.onerror = function(e) {
                                    i(e.message ? e : {
                                        message: e
                                    });
                                };
                                if (!e.fileContentType) {
                                    if (o.extension[e.fileExtension]) {
                                        e.fileContentType = o.extension[e.fileExtension].ContentType;
                                    } else {
                                        e.fileContentType = o.extension.other.ContentType;
                                    }
                                }
                                s.write(new Blob([ e.fileContent ], {
                                    type: e.fileContentType
                                }));
                            });
                        }, function(o) {
                            if (e.filefoldersCreated) {
                                if (typeof e === "object") {
                                    e.fileStatus = o;
                                } else {
                                    e = o;
                                }
                                i(e);
                            } else {
                                e.filefolders = e.fileUrlLocal.split("/").slice(0, -1);
                                if (e.filefolders.length >= 1) {
                                    e.filefoldersCreated = true;
                                    function a(o, s) {
                                        if (s[0] == "." || s[0] == "") {
                                            s = s.slice(1);
                                        }
                                        o.getDirectory(s[0], {
                                            create: true
                                        }, function(i) {
                                            if (s.length) {
                                                a(i, s.slice(1));
                                            } else {
                                                t(n.save(e));
                                            }
                                        }, function(t) {
                                            if (typeof e === "object") {
                                                e.fileStatus = t;
                                            } else {
                                                e = t;
                                            }
                                            i(e);
                                        });
                                    }
                                    a(s.root, e.filefolders);
                                } else {
                                    if (typeof e === "object") {
                                        e.fileStatus = o;
                                    } else {
                                        e = o;
                                    }
                                    i(e);
                                }
                            }
                        });
                    } catch (r) {
                        i(r.message ? r.message : {
                            message: r
                        });
                    } finally {
                        if (e.filefoldersCreated) {
                            if (e.filefoldersCreatedFinal) {
                                e.done(e);
                            }
                        } else {
                            e.done(e);
                        }
                    }
                }, function(t) {
                    e.done(t);
                    i(t.message ? t : {
                        message: t
                    });
                });
            }).then(function(t) {
                if (e.filefoldersCreated) {
                    if (e.filefoldersCreatedFinal) {
                        e.success(t);
                    }
                } else {
                    e.success(t);
                }
                return t;
            }, function(t) {
                if (e.filefoldersCreated) {
                    if (e.filefoldersCreatedFinal) {
                        e.fail(t);
                    }
                } else {
                    e.fail(t);
                }
                return t;
            });
        };
        function s(e, t) {
            if (typeof e === "function") {
                return e(t);
            } else {
                return t;
            }
        }
    };
})("fileSystask");