/*!
    laisiangtho -- the Holy Bible in languages
    Version 1.2.0
    https://khensolomonlethil.github.io/laisiangtho
    (c) 2013-2016
*/
(function($, uA) {
    var laisiangtho = 'laisiangtho',version = '2.1.23.2016.1.5';
    $.fn[laisiangtho] = function(options) {
        help={
            Agent:{
                o:'config',
                f:'Device'
            },
            Listen:{
                o:{},
                f:{}
            },
            Initiate:{
                o:{},
                f:['exe']
            },
            exe:{
                description:'exe only apply Prototype!',
                load:{
                    o:['fO','config'],
                    f:['new Database(db,fO,config)','other','init']
                },
                watch:{
                    o:{},
                    f:['exe','is','get']
                },
                Metalink:{
                    o:{},
                    f:['is','get']
                }
            }
        };
        window.indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;
        //??? add VAR on production
        var fO=$.extend({
            E: ['Action'],
            App: laisiangtho,
            Click: 'click',
            On: null,
            Hash: 'hashchange',
            Device: 'desktop',
            Platform: 'web',
            Layout: null,
            Browser: 'chrome',
            fileSystask:'Chrome', //temporary
            Orientation: {
                change: 'D1699',landscape: 'landscape',portrait: 'portrait'
            },
            note: {},
            lang: {},
            query: {},
            lookup: {
                setting: {},book: {}
            },
            previous: {},
            todo: {
                Orientation: true,
                // NOTE: if Template=true will be loaded Template!
                Template: true
            },
            container: {},
            msg: {
                info: $('li:first-child')//li:first-child,li#msg
                // REVIEW: lookup
            }
        }, options),
        fileSystem, fn, db={}, application=this, Core = function() {
            this.arg = arguments;
            return (this);
        },
        f=function() {
            var args = arguments;
            function x(){
                 Core.apply(this, args);
            }
            x.prototype = Object.create(Core.prototype);
            x.prototype.constructor = Core;
            return new x;
        };
        window[fO.App]=Core;
        // var f=window[fO.App];
        // TODO: remove this
        Core.prototype.tmp = function() {
            console.log('tmp');
        };
        // TODO: remove this
        Core.prototype.ClickTest = function(x) {
            console.log('aaa');
            // this.arg[0].append('...');
        };
        //=require laisiangtho.Prototype.load.js
        //=require laisiangtho.Prototype.database.js
        //=require laisiangtho.Prototype.other.js
        //=require laisiangtho.Prototype.init.js
        //=require laisiangtho.Prototype.xml.js
        //=require laisiangtho.Prototype.page.js
        //=require laisiangtho.Content.js
        //=require laisiangtho.Note.js
        //=require laisiangtho.Regex.js
        Core.prototype.watch = function() {
            $(document).on(fO.Click, f(fO.On).is('class').name, function(e) {
                f($(this)).exe(f($(this)).get('class').element);
            });
        };
        Core.prototype.metalink = function() {
            f(this.arg[0]).loop(function(i,v){
                window[v] = f(v).is('link').get('href').name;
            });
        };
        Core.prototype.metacontent = function() {
            f(this.arg[0]).loop(function(i,v){
                window[v] = f(v).is('meta').get('content');
            });
        };
        Core.prototype.exe = function(x) {
            var o=this.arg[0], y=this[x[0]];
            if (y){
                if ($.isFunction(y)) {
                    return f(o)[x[0]](this);
                } else {
                    y=y[x[1]];
                    if(y){
                        if ($.isFunction(y)) {
                            return f(o)[x[0]][x[1]](this);
                        }else{
                            y=y[x[2]];
                            if(y){
                                if($.isFunction(y)) {
                                    return f(o)[x[0]][x[1]][x[2]](this);
                                }
                            }
                        }
                    }
                }
            }
            return false;
        };
        //=require laisiangtho.Prototype.is.js
        //=require laisiangtho.Prototype.get.js
        this.Agent = function(obj) {
            fO.Orientation.evt = (Object.prototype.hasOwnProperty.call(window, "onorientationchange")) ? "orientationchange" : "resize";
            var o = {
                meta: [{
                    type: 'script',
                    name: 'localforage.min'
                }, {
                    type: 'script',
                    name: 'data.bible'
                }, {
                    type: 'script',
                    name: 'data.config'
                }],
                type: {
                    script: {
                        attr: {
                            src: null
                        },
                        extension: '.js',
                        dir: 'js/'
                    },
                    link: {
                        attr: {
                            rel: 'stylesheet',
                            href: null
                        },
                        extension: '.css',
                        dir: 'css/'
                    }
                },
                m: this,
                go: function(q) {
                    var x = q.shift(),
                        y = x.type,
                        url = (x.dir || o.type[y].dir) + x.name + o.type[y].extension,
                    req = document.createElement(y);
                    f(o.type[y].attr).loop(function(i,v){
                        req[i] = v || url;
                    })
                    req.onload = function() {
                        fO.msg.info.html(x.name);
                        if (q.length) {
                            o.go(q);
                        } else {
                            o.m.Listen();
                        }
                    };
                    document.head.appendChild(req);
                    //document.getElementsByTagName('head')[0].appendChild(req);
                }
            };
            o.go($.merge(o.meta, new Device(this).get()));
            this.createProperty('Orientation',function(){
                $(config.css.content).css({
                    'top': $(config.css.header).outerHeight(),
                    'bottom': $(config.css.footer).outerHeight()
                });
            });
            //used in chrome
            //if(obj)f.extend(obj);
        };
        this.Listen = function() {
            if (fO.isCordova) {
                fO.msg.info.html('getting Device ready').attr({
                    class: 'icon-database'
                });
                document.addEventListener("deviceready", this.Initiate, false);
            } else {
                fO.msg.info.attr({
                    class: 'icon-database'
                });
                this.Initiate();
            }
        };
        this.Initiate = function() {
            f(fO.E).loop(function(i,v){
                i = ($.type(v) === 'object') ? Object.keys(v)[0] : v;
                f(v[i]).exe(i.split(' '));
            });
            // f(fO.E).each(function(i,v){
            //     i = ($.type(v) === 'object') ? Object.keys(v)[0] : v;
            //     f(v[i]).exe(i.split(' '));
            // });
        };
        //=require laisiangtho.Device.js
        return this;
    };
})(jQuery, navigator.userAgent);

//=require laisiangtho.defineProperties.js
//=require laisiangtho.Prototype.custom.js
//=require ../filesystask/fileSystask.min.js
