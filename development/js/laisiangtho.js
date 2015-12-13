/*
name: laisiangtho
update: 2015.12.7
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
            App: s,
            Click: "click",
            On: s,
            Hash: "hashchange",
            Device: "desktop",
            Platform: "web",
            Layout: s,
            Browser: "chrome",
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
                Design: false
            },
            container: {},
            msg: {
                info: e("li:first-child")
            }
        }, n);
        var o = this, a = function() {
            this.arg = arguments;
            return this;
        };
        var s = window[fO.App] = function() {
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
            var t = this, n = [], i = {}, o = {
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
                            if (o.reading(t) == t) {
                                o.next();
                            } else {
                                o.next();
                            }
                        });
                    } else {
                        this.json(t, this.next);
                    }
                },
                json: function(a, s, r) {
                    console.log("json");
                    var f = t.url(config.id, [ a ], config.file.lang);
                    var l = e.ajax({
                        url: r ? r + f.url : f.url,
                        dataType: f.data,
                        contentType: f.content,
                        cache: false
                    });
                    l.done(function(n) {
                        var o = n.info.lang = n.info.lang || config.language.info.lang;
                        fO.msg.info.html(n.info.name);
                        var r = function(n, i) {
                            var r = {};
                            return {
                                is: {
                                    index: function(e) {
                                        r[e] = fO.lang[a].index;
                                    },
                                    name: function(o) {
                                        r[o] = {};
                                        for (var a in n[o]) {
                                            var s = typeof i.b === "undefined" || typeof i.b[a] === "undefined" ? [] : [ i.b[a] ];
                                            var f = typeof i.name === "undefined" || typeof i.name[a] === "undefined" ? [] : i.name[a];
                                            e.merge(s, f);
                                            r[o][a] = e.unique(t.array(n[o][a]).merge(s).data);
                                        }
                                    }
                                },
                                merge: function() {
                                    for (var t in n) {
                                        if (this.is[t]) {
                                            this.is[t](t);
                                        } else {
                                            r[t] = i[t] ? e.extend({}, n[t], i[t]) : n[t];
                                        }
                                    }
                                    return r;
                                },
                                next: function() {
                                    e.extend(fO.lang[a], this.merge());
                                    e("p").html(o).attr({
                                        "class": "icon-database"
                                    }).promise().done(function() {
                                        s();
                                    });
                                }
                            };
                        };
                        if (i[o]) {
                            r(i[o], n).next();
                        } else {
                            var f = t.url("lang", [ o ], config.file.lang), l = e.ajax({
                                url: f.url,
                                dataType: f.data,
                                contentType: f.content,
                                cache: false
                            });
                            l.done(function(e) {
                                i[o] = r(config.language, e).merge();
                                r(i[o], n).next();
                            });
                            l.fail(function(e, t) {
                                r(config.language, n).next();
                            });
                        }
                    });
                    l.fail(function(e, t) {
                        if (api) {
                            if (r) {
                                db.RemoveLang(a, function() {
                                    n.splice(n.indexOf(a), 1);
                                    s();
                                });
                            } else {
                                o.json(a, s, api);
                            }
                        } else {
                            db.RemoveLang(a, function() {
                                n.splice(n.indexOf(a), 1);
                                s();
                            });
                        }
                    });
                },
                next: function() {
                    if (n.length) {
                        o.start();
                    } else {
                        e(window).bind(fO.Hash, function() {
                            s().init();
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
                    if (fO.todo.Design) {
                        e(document.body).load("Desktop.design.html header, main, footer", function() {
                            t.init();
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
                                s();
                            } else {
                                s();
                            }
                        });
                    }
                    function s() {
                        t.index();
                        n = config.bible.available.concat();
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
            return "...!";
        };
        a.prototype.hash = function(e) {
            var t = location.hash, n = {
                page: t.split("?")[0].replace("#", "")
            }, i, o = /([^\?#&=]+)=([^&]*)/g, a = function(e) {
                return decodeURIComponent(e.replace(/\+/g, " "));
            };
            while (i = o.exec(t)) n[a(i[1])] = a(i[2]);
            e(n);
        };
        a.prototype.url = function(e, t, n) {
            var i = this.string([ e, 47, t.join("/"), 46, n ]), o = i.substring(i.lastIndexOf("/") + 1), a = this.string([ "application", 47, n ]), s = null, r = null;
            if (fO.isCordova) {
                s = cordova.file.dataDirectory;
                r = cordova.file.dataDirectory + o;
            }
            return {
                url: i,
                data: n,
                content: a + ";charset=utf-8",
                filename: o,
                type: a,
                path: s,
                local: r
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
            }).join("");
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
            var o = e(), a = this.obj;
            var r = this;
            e.each(this.arg[0], function(t, n) {
                (function a(t, n, r, f) {
                    var l = n.attr, c = n.text, u = false, d = e(s(t).is("tag").name, l);
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
                                a(t, c[i][t], d);
                            } else {
                                a(i, c[i], d);
                            }
                        }
                    }
                    if (f) {
                        o = r.add(d);
                    } else {
                        r.append(d);
                    }
                })(t, n, o, true);
            });
            if (t) {
                (e.type(t) !== "object" ? e(t) : t)[n || "append"](o);
            }
            return o;
        };
        a.prototype.activeClass = function(t) {
            return t.find(s(config.css.active).is("class").name).removeClass(config.css.active).promise().done(e(config.css.currentPage).addClass(config.css.active));
        };
        a.prototype.header = function(e) {
            if (config.header[fO.query.page]) {
                if (fO.todo.headerChanged != fO.query.page) {
                    e.replaceWith(s({
                        header: config.header[fO.query.page]
                    }).template()).promise().done(function() {
                        fO.todo.headerChanged = fO.query.page;
                        e.find(config.css.currentPage).addClass(config.css.active).siblings().removeClass(config.css.active);
                        fO.todo.Orientation = true;
                    });
                }
            } else if (fO.todo.headerChanged) {
                e.replaceWith(s({
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
                    t.replaceWith(s({
                        footer: config.footer[fO.query.page]
                    }).template()).promise().done(function() {
                        fO.todo.footerChanged = fO.query.page;
                        e(config.css.currentPage).addClass(config.css.active);
                        fO.todo.Orientation = true;
                    });
                }
            } else if (fO.todo.footerChanged) {
                t.replaceWith(s({
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
                        config.css.currentPage = s(fO.query[t]).is("class").name;
                    },
                    bible: function(t, n, i) {
                        fO.query[t] = e.inArray(n.toLowerCase(), config.bible.available) >= 0 ? n : i;
                    },
                    book: function(n, i, o) {
                        if (e.isNumeric(i)) {
                            fO.query[n] = bible.book[i] ? i : o;
                        } else {
                            fO.query[n] = o;
                            var i = i.replace(new RegExp("-", "g"), " ").toLowerCase(), a = fO.lang[fO.query.bible].b;
                            for (var s in a) {
                                if (a[s].toLowerCase() == t || lang.b[s].toLowerCase() == i) {
                                    fO.query[n] = s;
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
            var i = s("lookup").is("form").element;
            if (i.length) {
                i.off().on("submit", function() {
                    var t = e(this);
                    t.serializeObject(fO.query);
                    if (fO.query.page == t.attr("name")) {
                        t.find(s("q").is("input").name).attr("autocomplete", "off").focus().select().promise().done(s().lookup());
                    } else {
                        t.attr("action").hashChange({
                            q: fO.query.q
                        });
                    }
                    return false;
                });
                s("search").is("input").element.off().on(fO.Click, function() {
                    e(this.form).submit();
                }).promise().done(function() {
                    s("q").is("input").element.attr("autocomplete", "off").focus().select();
                });
            }
            fO.container.main = e(config.css.content).children(config.css.currentPage);
            fO.container.main.fadeIn(300).siblings().hide().promise().done(this[e.isFunction(this[fO.query.page]) ? fO.query.page : e(config.page).get(-1)]());
            s("fn").is("attr").get("fn").element.each(function() {
                e(this).append("...");
            }).promise().done(function() {
                db.update.query();
            });
            if (fO.todo.Orientation) {
                o.Orientation();
                delete fO.todo.Orientation;
            }
            var a = new s({
                bible: "tedim",
                reading: 1
            }).xml(function(e) {
                console.log(e);
            }).is();
            console.log(a);
        };
        a.prototype.bible = function() {};
        a.prototype.book = function() {};
        a.prototype.lookup = function() {};
        a.prototype.note = function() {};
        a.prototype.todo = function() {};
        a.prototype.xml = function(t) {
            var n = this, i = this.arg[0];
            var o = fO.lang[i.bible], a = o.l, s = o.b;
            var r = this.url(config.id, [ i.bible ], config.file.bible);
            this.is = function() {
                if (e.isEmptyObject(fO[i.bible].bible)) {
                    if (fO.isCordova) {
                        r.local.resolveFileSystem(n.file.Cordova().read, function(e) {
                            n.ResponseGood({
                                msg: "to Local",
                                status: false
                            });
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
                                if (e.isEmptyObject(t)) {
                                    n.ResponseGood({
                                        msg: "to Store",
                                        status: false
                                    });
                                } else {
                                    if (i.reading == i.bible) {
                                        fO[i.bible].bible = t;
                                        n.ResponseGood({
                                            msg: "from Store",
                                            status: true
                                        });
                                    } else {
                                        n.ResponseGood({
                                            msg: "to Store",
                                            status: true
                                        });
                                    }
                                }
                            } else {
                                n.ResponseGood({
                                    msg: "to Store",
                                    status: false
                                });
                            }
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
                            r.local.resolveFileSystem(n.file.Cordova().get, n.file.Cordova().download);
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
                    r.local.resolveFileSystem(n.file.Cordova().remove, function(e) {
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
                            url: t ? t + r.url : r.url,
                            dataType: r.data,
                            contentType: r.content,
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
                    this.download = function() {
                        n.working({
                            msg: a.Downloading
                        });
                        var e = new FileTransfer();
                        e.onprogress = function(e) {
                            if (e.lengthComputable) {
                                var t = Math.floor(e.loaded / e.total * 100);
                                n.working({
                                    msg: a.PercentLoaded.replace(/{Percent}/, n.num(t))
                                });
                            }
                        };
                        e.download(encodeURI(api + r.url), r.local, n.file.Cordova().content, function(e) {
                            n.ResponseGood({
                                msg: e.code,
                                status: false
                            });
                        });
                    };
                    this.read = function(e) {
                        if (i.reading == i.bible) {
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
                                n.JobType(t.parseFromString(e.target.result, r.type));
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
                    var o = [], a = [], r = 0;
                    e(t).children().each(function(t, o) {
                        var a = e(o), r = a.children(), f = a.attr("id");
                        if (r.length) {
                            r.each(function(t, o) {
                                var a = e(o), f = a.children(), o = a.attr("id"), l = a.get(0).tagName.toLowerCase(), c = 0;
                                if (e.type(fO[i.bible].bible[l]) === "undefined") fO[i.bible].bible[l] = {};
                                if (f.length) {
                                    fO[i.bible].bible[l][o] = {};
                                    setTimeout(function() {
                                        f.each(function(a, s) {
                                            var u = e(s), d = u.children(), s = u.attr("id"), h = u.get(0).tagName.toLowerCase();
                                            if (e.type(fO[i.bible].bible[l][o][h]) === "undefined") fO[i.bible].bible[l][o][h] = {};
                                            if (d.length) {
                                                fO[i.bible].bible[l][o][h][s] = {};
                                                fO[i.bible].bible[l][o][h][s].verse = {};
                                                setTimeout(function() {
                                                    d.each(function(c, u) {
                                                        var g = e(u), p = g.children(), u = g.attr("id"), b = g.get(0).tagName.toLowerCase();
                                                        u = "v" + u;
                                                        fO[i.bible].bible[l][o][h][s].verse[u] = {};
                                                        fO[i.bible].bible[l][o][h][s].verse[u].text = g.text();
                                                        if (g.attr("ref")) fO[i.bible].bible[l][o][h][s].verse[u].ref = g.attr("ref").split(",");
                                                        if (g.attr("title")) fO[i.bible].bible[l][o][h][s].verse[u].title = g.attr("title").split(",");
                                                        if (r.length == t + 1) {
                                                            if (f.length == a + 1) {
                                                                if (d.length == c + 1) {
                                                                    if (fO.isCordova) {
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
                                            } else if (s) {
                                                fO[i.bible].bible[l][o][h][s] = u.text();
                                            } else {
                                                c++;
                                                fO[i.bible].bible[l][o][h][c] = {
                                                    title: u.text()
                                                };
                                                if (u.attr("ref")) fO[i.bible].bible[l][o][h][c].ref = u.attr("ref").split(",");
                                            }
                                        }).promise().done(function() {
                                            fO.msg.info.html(s[o]);
                                        });
                                    }, 90 * t);
                                } else {
                                    fO[i.bible].bible[l][o] = a.text();
                                }
                            });
                        } else {
                            var l = a.attr("id"), c = a.text();
                        }
                    });
                }
            };
            this.ResponseGood = function(e) {
                o.local = e.status;
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
                if (e.status) o.local = false;
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
            o.on(fO.Click, s(fO.On).is("class").name, function() {
                s(e(this)).exe(s(e(this)).get("class"));
            });
        };
        a.prototype.Metalink = function() {
            this.arg[0].loop(function(e, t) {
                window[t] = s(t).is("link").get("href");
            });
        };
        a.prototype.Metacontent = function() {
            this.arg[0].loop(function(e, t) {
                window[t] = s(t).is("meta").get("content");
            });
        };
        a.prototype.exe = function(t) {
            var n = this.arg[0], i = this[t[0]];
            if (i) {
                if (e.isFunction(i)) {
                    return s(n)[t[0]](t);
                } else {
                    i = i[t[1]];
                    if (i) {
                        if (e.isFunction(i)) {
                            return s(n)[t[0]][t[1]](t);
                        } else {
                            i = i[t[2]];
                            if (i) {
                                if (e.isFunction(i)) {
                                    return s(n)[t[0]][t[1]][t[2]](t);
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
                    var t = e.shift(), i = t.type, o = (t.dir || n.type[i].dir) + t.name + n.type[i].extension, a = document.createElement(i);
                    n.type[i].attr.loop(function(e, t) {
                        a[e] = t || o;
                    });
                    a.onload = function() {
                        fO.msg.info.html(t.name);
                        if (e.length) {
                            n.go(e);
                        } else {
                            n.m.Listen();
                        }
                    };
                    document.head.appendChild(a);
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
                s(n[t]).exe(t.split(" "));
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
                    var a = i.join(".");
                    n.push({
                        type: "link",
                        name: a
                    }, {
                        type: "script",
                        name: a
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