// NOTE: Example
// *** CHECK IS-FILE READY
// var x=new f({bible:'tedim',reading:1}).xml(function(response){
//     return response;
// }).has();
// *** GET DATA
// var x=new f({bible:'tedim',reading:1}).xml(function(response){
//     console.log(response);
//     return response;
// }).get();
// FIXME: storage
Core.prototype.xml = function(e) {
    var t = this, i = this.arg[0];
    var o = fO.lang[i.bible], s = o.l, n = o.b;
    var l = this.url(config.id, [ i.bible ], config.file.bible);
    this.has = function() {
        if ($.isEmptyObject(fO[i.bible].bible)) {
            if (fileSystem.support) {
                fileSystem.get({
                    fileName: l.fileUrl,
                    fileOption: {},
                    fileObject: function() {
                        t.file.read(this.fileEntry);
                    },
                    fileNotExists: function() {
                        if (i.bible == i.downloading) {
                            t.file.download();
                        } else {
                            t.ResponseGood({
                                msg: "fileNotExists",
                                status: false
                            });
                        }
                    },
                    fileError: function(e) {
                        t.ResponseGood({
                            msg: "to fileSystem.fileError",
                            status: false
                        });
                    }
                });
            } else {
                t.ResponseGood({
                    msg: "fileSystem NotOk, process ot db ",
                    status: false
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
        if ($.isEmptyObject(fO[i.bible].bible)) {
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
                    table: i.bible
                }).then(function(e) {
                    if (e) {
                        fO[i.bible].bible = e;
                        if ($.isEmptyObject(fO[i.bible].bible)) {
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
                table: i.bible
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
                                var i = Math.floor(e.loaded / e.total * 100);
                                t.working({
                                    msg: s.PercentLoaded.replace(/{Percent}/, t.num(i))
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
                }).done(function(e, i, o) {
                    t.JobType(e);
                }).fail(function(i, o) {
                    if (api) {
                        if (e) {
                            t.ResponseGood({
                                msg: o,
                                status: false
                            });
                        } else {
                            t.file.IndexDb().download(api);
                        }
                    } else {
                        t.ResponseGood({
                            msg: o,
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
                    t.ResponseGood({
                        msg: "from Reading",
                        status: true
                    });
                }
            };
            this.get = function(e) {
                this.content(e);
            };
            this.content = function(e, i) {
                e.file(function(e) {
                    var i = new FileReader();
                    i.onloadend = function(e) {
                        var i = new DOMParser();
                        t.JobType(i.parseFromString(e.target.result, l.type));
                    };
                    i.readAsText(e);
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
        },
        download: function() {
            fileSystem.download({
                Method: "GET",
                fileUrl: l.fileUrl,
                fileUrlLocal: l.fileUrl,
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
                    fileSystem.save(Object.assign(e, {
                        success: function(e) {
                            t.has();
                        },
                        fail: function(e) {
                            t.ResponseGood({
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
                t.ResponseGood({
                    msg: "from Reading",
                    status: true
                });
            }
        },
        content: function(e) {
            e.file(function(e) {
                var i = new FileReader();
                i.onloadend = function() {
                    t.JobType(new DOMParser().parseFromString(this.result, l.fileContentType));
                };
                i.readAsText(e);
            }, function() {
                t.ResponseGood({
                    msg: "fail to read Local",
                    status: false
                });
            });
        },
        remove: function(e) {
            e.remove(function() {
                t.ResponseBad({
                    status: true
                });
            }, function(e) {
                t.ResponseBad({
                    status: false
                });
            });
        }
    };
    this.JobType = function(e) {
        var t = $(e).children().get(0).tagName;
        if ($.isFunction(this.Job[t])) {
            fO[i.bible].bible = {
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
            var o = [], s = [], l = 0;
            $(e).children().each(function(e, o) {
                var s = $(o), l = s.children(), f = s.attr("id");
                if (l.length) {
                    l.each(function(e, o) {
                        var s = $(o), f = s.children(), o = s.attr("id"), a = s.get(0).tagName.toLowerCase(), r = 0;
                        if ($.type(fO[i.bible].bible[a]) === "undefined") fO[i.bible].bible[a] = {};
                        if (f.length) {
                            fO[i.bible].bible[a][o] = {};
                            setTimeout(function() {
                                f.each(function(s, n) {
                                    var b = $(n), u = b.children(), n = b.attr("id"), c = b.get(0).tagName.toLowerCase();
                                    if ($.type(fO[i.bible].bible[a][o][c]) === "undefined") fO[i.bible].bible[a][o][c] = {};
                                    if (u.length) {
                                        fO[i.bible].bible[a][o][c][n] = {};
                                        fO[i.bible].bible[a][o][c][n].verse = {};
                                        setTimeout(function() {
                                            u.each(function(r, b) {
                                                var d = $(b), h = d.children(), b = d.attr("id"), g = d.get(0).tagName.toLowerCase();
                                                b = "v" + b;
                                                fO[i.bible].bible[a][o][c][n].verse[b] = {};
                                                fO[i.bible].bible[a][o][c][n].verse[b].text = d.text();
                                                if (d.attr("ref")) fO[i.bible].bible[a][o][c][n].verse[b].ref = d.attr("ref").split(",");
                                                if (d.attr("title")) fO[i.bible].bible[a][o][c][n].verse[b].title = d.attr("title").split(",");
                                                if (l.length == e + 1) {
                                                    if (f.length == s + 1) {
                                                        if (u.length == r + 1) {
                                                            if (fileSystem.support) {
                                                                t.ResponseGood({
                                                                    msg: "Saved",
                                                                    status: true
                                                                });
                                                            } else {
                                                                db.add({
                                                                    table: i.bible,
                                                                    data: fO[i.bible].bible
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
                                        fO[i.bible].bible[a][o][c][n] = b.text();
                                    } else {
                                        r++;
                                        fO[i.bible].bible[a][o][c][r] = {
                                            title: b.text()
                                        };
                                        if (b.attr("ref")) fO[i.bible].bible[a][o][c][r].ref = b.attr("ref").split(",");
                                    }
                                }).promise().done(function() {
                                    fO.msg.info.html(n[o]);
                                });
                            }, 90 * e);
                        } else {
                            fO[i.bible].bible[a][o] = s.text();
                        }
                    });
                } else {
                    var a = s.attr("id"), r = s.text();
                }
            });
        }
    };
    this.ResponseGood = function(e) {
        o.local = e.status;
        if (i.reading) {
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
        delete fO[i.bible].bible;
        if (e.status) o.local = false;
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