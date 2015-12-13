// NOTE: Example
// *** CHECK IS-FILE READY
// var x=new f({bible:'tedim',reading:1}).xml(function(response){
//     return response;
// }).is();
// *** GET DATA
// var x=new f({bible:'tedim',reading:1}).xml(function(response){
//     console.log(response);
//     return response;
// }).get();
// FIXME: storage
Core.prototype.xml = function(e) {
    var t = this, o = this.arg[0];
    var i = fO.lang[o.bible], s = i.l, n = i.b;
    var l = this.url(config.id, [ o.bible ], config.file.bible);
    this.is = function() {
        if ($.isEmptyObject(fO[o.bible].bible)) {
            if (fO.isCordova) {
                l.local.resolveFileSystem(t.file.Cordova().read, function(e) {
                    t.ResponseGood({
                        msg: "to Local",
                        status: false
                    });
                });
            } else if (fO.isChrome) {
                t.ResponseGood({
                    msg: "to Webkit",
                    status: false
                });
            } else {
                db.get({
                    table: o.bible
                }).then(function(e) {
                    if (e) {
                        if ($.isEmptyObject(e)) {
                            t.ResponseGood({
                                msg: "to Store",
                                status: false
                            });
                        } else {
                            if (o.reading == o.bible) {
                                fO[o.bible].bible = e;
                                t.ResponseGood({
                                    msg: "from Store",
                                    status: true
                                });
                            } else {
                                t.ResponseGood({
                                    msg: "to Store",
                                    status: true
                                });
                            }
                        }
                    } else {
                        t.ResponseGood({
                            msg: "to Store",
                            status: false
                        });
                    }
                });
            }
        } else {
            t.ResponseGood({
                msg: "from Object",
                status: true
            });
        }
        return this;
    };
    this.get = function() {
        if ($.isEmptyObject(fO[o.bible].bible)) {
            if (fO.isCordova) {
                t.working({
                    msg: s.PleaseWait,
                    wait: true
                }).promise().done(function() {
                    l.local.resolveFileSystem(t.file.Cordova().get, t.file.Cordova().download);
                });
            } else if (fO.isChrome) {
                t.ResponseGood({
                    msg: "to Webkit",
                    status: false
                });
            } else {
                db.get({
                    table: o.bible
                }).then(function(e) {
                    if (e) {
                        fO[o.bible].bible = e;
                        if ($.isEmptyObject(fO[o.bible].bible)) {
                            t.file.IndexDb().download();
                        } else {
                            t.ResponseGood({
                                msg: "from Store",
                                status: true
                            });
                        }
                    } else {
                        t.file.IndexDb().download();
                    }
                });
            }
        } else {
            t.ResponseCallbacks({
                msg: "from Object",
                status: true
            });
        }
    };
    this.remove = function() {
        if (fO.isCordova) {
            l.local.resolveFileSystem(t.file.Cordova().remove, function(e) {
                t.ResponseGood({
                    status: true
                });
            });
        } else {
            db.delete({
                table: o.bible
            }).then(function() {
                t.ResponseBad({
                    status: true
                });
            });
        }
    };
    this.file = {
        IndexDb: function() {
            this.download = function(e) {
                $.ajax({
                    beforeSend: function(e) {
                        t.working({
                            msg: s.Downloading,
                            wait: true
                        });
                        e.setRequestHeader("Access-Control-Allow-Origin", "*");
                    },
                    xhr: function() {
                        var e = new window.XMLHttpRequest();
                        e.addEventListener("progress", function(e) {
                            if (e.lengthComputable) {
                                var o = Math.floor(e.loaded / e.total * 100);
                                t.working({
                                    msg: s.PercentLoaded.replace(/{Percent}/, t.num(o))
                                });
                            }
                        }, false);
                        return e;
                    },
                    url: e ? e + l.url : l.url,
                    dataType: l.data,
                    contentType: l.content,
                    cache: true,
                    crossDomain: true,
                    async: true
                }).done(function(e, o, i) {
                    t.JobType(e);
                }).fail(function(o, i) {
                    if (api) {
                        if (e) {
                            t.ResponseGood({
                                msg: i,
                                status: false
                            });
                        } else {
                            t.file.IndexDb().download(api);
                        }
                    } else {
                        t.ResponseGood({
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
                t.working({
                    msg: s.Downloading
                });
                var e = new FileTransfer();
                e.onprogress = function(e) {
                    if (e.lengthComputable) {
                        var o = Math.floor(e.loaded / e.total * 100);
                        t.working({
                            msg: s.PercentLoaded.replace(/{Percent}/, t.num(o))
                        });
                    }
                };
                e.download(encodeURI(api + l.url), l.local, t.file.Cordova().content, function(e) {
                    t.ResponseGood({
                        msg: e.code,
                        status: false
                    });
                });
            };
            this.read = function(e) {
                if (o.reading == o.bible) {
                    this.content(e);
                } else {
                    t.ResponseGood({
                        msg: "from Reading",
                        status: true
                    });
                }
            };
            this.get = function(e) {
                this.content(e);
            };
            this.content = function(e, o) {
                e.file(function(e) {
                    var o = new FileReader();
                    o.onloadend = function(e) {
                        var o = new DOMParser();
                        t.JobType(o.parseFromString(e.target.result, l.type));
                    };
                    o.readAsText(e);
                }, function() {
                    t.ResponseGood({
                        msg: "fail to read Local",
                        status: false
                    });
                });
            };
            this.remove = function(e) {
                e.remove(function() {
                    t.ResponseBad({
                        status: true
                    });
                }, function(e) {
                    t.ResponseBad({
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
    this.JobType = function(e) {
        var t = $(e).children().get(0).tagName;
        if ($.isFunction(this.Job[t])) {
            fO[o.bible].bible = {
                info: {},
                book: {}
            };
            this.Job[t](e);
        } else {
            this.ResponseGood({
                msg: s.IsNotFoundIn.replace(/{is}/, t).replace(/{in}/, "jobType"),
                status: false
            });
        }
    };
    this.Job = {
        bible: function(e) {
            var i = [], s = [], l = 0;
            $(e).children().each(function(e, i) {
                var s = $(i), l = s.children(), a = s.attr("id");
                if (l.length) {
                    l.each(function(e, i) {
                        var s = $(i), a = s.children(), i = s.attr("id"), r = s.get(0).tagName.toLowerCase(), f = 0;
                        if ($.type(fO[o.bible].bible[r]) === "undefined") fO[o.bible].bible[r] = {};
                        if (a.length) {
                            fO[o.bible].bible[r][i] = {};
                            setTimeout(function() {
                                a.each(function(s, n) {
                                    var b = $(n), d = b.children(), n = b.attr("id"), u = b.get(0).tagName.toLowerCase();
                                    if ($.type(fO[o.bible].bible[r][i][u]) === "undefined") fO[o.bible].bible[r][i][u] = {};
                                    if (d.length) {
                                        fO[o.bible].bible[r][i][u][n] = {};
                                        fO[o.bible].bible[r][i][u][n].verse = {};
                                        setTimeout(function() {
                                            d.each(function(f, b) {
                                                var c = $(b), h = c.children(), b = c.attr("id"), g = c.get(0).tagName.toLowerCase();
                                                b = "v" + b;
                                                fO[o.bible].bible[r][i][u][n].verse[b] = {};
                                                fO[o.bible].bible[r][i][u][n].verse[b].text = c.text();
                                                if (c.attr("ref")) fO[o.bible].bible[r][i][u][n].verse[b].ref = c.attr("ref").split(",");
                                                if (c.attr("title")) fO[o.bible].bible[r][i][u][n].verse[b].title = c.attr("title").split(",");
                                                if (l.length == e + 1) {
                                                    if (a.length == s + 1) {
                                                        if (d.length == f + 1) {
                                                            if (fO.isCordova) {
                                                                t.ResponseGood({
                                                                    msg: "Saved",
                                                                    status: true
                                                                });
                                                            } else {
                                                                db.add({
                                                                    table: o.bible,
                                                                    data: fO[o.bible].bible
                                                                }).then(t.ResponseGood({
                                                                    msg: "Stored",
                                                                    status: true
                                                                }));
                                                            }
                                                        }
                                                    }
                                                }
                                            });
                                        }, 30 / e * s);
                                    } else if (n) {
                                        fO[o.bible].bible[r][i][u][n] = b.text();
                                    } else {
                                        f++;
                                        fO[o.bible].bible[r][i][u][f] = {
                                            title: b.text()
                                        };
                                        if (b.attr("ref")) fO[o.bible].bible[r][i][u][f].ref = b.attr("ref").split(",");
                                    }
                                }).promise().done(function() {
                                    fO.msg.info.html(n[i]);
                                });
                            }, 90 * e);
                        } else {
                            fO[o.bible].bible[r][i] = s.text();
                        }
                    });
                } else {
                    var r = s.attr("id"), f = s.text();
                }
            });
        }
    };
    this.ResponseGood = function(e) {
        i.local = e.status;
        if (o.reading) {
            t.ResponseCallbacks(e);
        } else {
            db.update.lang().then(function() {
                t.done();
                t.ResponseCallbacks(e);
            });
        }
        return this;
    };
    this.ResponseBad = function(e) {
        delete fO[o.bible].bible;
        if (e.status) i.local = false;
        db.update.lang().then(function() {
            t.ResponseCallbacks(e);
        });
        return this;
    };
    this.ResponseCallbacks = function(t) {
        this.msg = t;
        e(t);
    };
    return this;
};