/*!
    laisiangtho -- the Holy Bible in languages
    Version 1.1.9
    https://khensolomonlethil.github.io/laisiangtho
    (c) 2013-2015
*/
(function($, uA) {
    var f = 'laisiangtho',version = '1.9.86.2015.8.28';
    $.fn[f] = function(options) {
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
        //??? add VAR on production
        db={}, fO = $.extend({
            E: ['Action'],
            App: f,
            Click: 'click',
            On: f,
            Hash: 'hashchange',
            Device: 'desktop',
            Platform: 'web',
            Layout: f,
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
                Template:false
            },
            container: {},
            msg: {
                info: $('li:first-child')
            }
        }, options);
        var fileSystem, application=this, Core = function() {
            this.arg = arguments;
            return (this);
        }
        var f=window[fO.App]=function() {
            var args = arguments;
            function x(){
                 Core.apply(this, args);
            }
            x.prototype = Object.create(Core.prototype);
            x.prototype.constructor = Core;
            return new x;
        };
        Core.prototype.tmp = function() {
            console.log('tmp');
        };
        Core.prototype.ClickTest = function(x) {
            this.arg[0].append('...');
        };
        //=require laisiangtho.Prototype.load.js
        //=require laisiangtho.Prototype.database.js
        //=require laisiangtho.Prototype.other.js
        //=require laisiangtho.Prototype.init.js
        //=require laisiangtho.Prototype.xml.js
        //=require laisiangtho.Prototype.bible.js
        //???require laisiangtho.Prototype.content.js
        Core.prototype.watch = function() {
            application.on(fO.Click, f(fO.On).is('class').name, function() {
                f($(this)).exe(f($(this)).get('class'));
            });
        };
        Core.prototype.metalink = function() {
            this.arg[0].loop(function(i,v){
                window[v] = f(v).is('link').get('href');
            });
        };
        Core.prototype.metacontent = function() {
            this.arg[0].loop(function(i,v){
                window[v] = f(v).is('meta').get('content');
            });
        };
        Core.prototype.exe = function(x) {
            var z=this.arg[0], y=this[x[0]];
            if (y){
                if ($.isFunction(y)) {
                    return f(z)[x[0]](x);
                } else {
                    y=y[x[1]];
                    if(y){
                        if ($.isFunction(y)) {
                            return f(z)[x[0]][x[1]](x);
                        }else{
                            y=y[x[2]];
                            if(y){
                                if($.isFunction(y)) {
                                    return f(z)[x[0]][x[1]][x[2]](x);
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
                    o.type[y].attr.loop(function(i,v){
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
            // console.log(this.Device.f1());
            o.go($.merge(o.meta, this.Device.f1()));
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
            fO.E.loop(function(i,v){
                i = ($.type(v) === 'object') ? Object.keys(v)[0] : v;
                f(v[i]).exe(i.split(' '));
            });
        };
        this.Device = {
            name: {
                is: function(needle) {
                    return uA.toLowerCase().indexOf(needle) !== -1;
                },
                ios: function() {
                    return this.iphone() || this.ipod() || this.ipad();
                },
                iphone: function() {
                    return !this.windows() && this.is('iphone');
                },
                ipod: function() {
                    return this.is('ipod');
                },
                ipad: function() {
                    return this.is('ipad');
                },
                android: function() {
                    return !this.windows() && this.is('android');
                },
                androidPhone: function() {
                    return this.android() && this.is('mobile');
                },
                androidTablet: function() {
                    return this.android() && !this.is('mobile');
                },
                blackberry: function() {
                    return this.is('blackberry') || this.is('bb10') || this.is('rim');
                },
                blackberryPhone: function() {
                    return this.blackberry() && !this.is('tablet');
                },
                blackberryTablet: function() {
                    return this.blackberry() && this.is('tablet');
                },
                windows: function() {
                    return this.is('windows');
                },
                windowsPhone: function() {
                    return this.windows() && this.is('phone');
                },
                windowsTablet: function() {
                    return this.windows() && (this.is('touch') && !this.windowsPhone());
                },
                fxos: function() {
                    return (this.is('(mobile;') || this.is('(tablet;')) && this.is('; rv:');
                },
                fxosPhone: function() {
                    return this.fxos() && this.is('mobile');
                },
                fxosTablet: function() {
                    return this.fxos() && this.is('tablet');
                },
                meego: function() {
                    return this.is('meego');
                },
                cordova: function() {
                    return window.cordova && location.protocol === 'file:';
                },
                chrome: function() {
                    return fO.Platform === 'chrome';
                },
                nodeWebkit: function() {
                    return typeof window.process === 'object';
                },
                mobile: function() {
                    return this.androidPhone() || this.iphone() || this.ipod() || this.windowsPhone() || this.blackberryPhone() || this.fxosPhone() || this.meego();
                },
                tablet: function() {
                        return this.ipad() || this.androidTablet() || this.blackberryTablet() || this.windowsTablet() || this.fxosTablet();
                    }
                    //desktop:function(){return !this.tablet() && !this.mobile();}
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
                $(window.document.documentElement).attr({
                    class: ((window.innerHeight / window.innerWidth) < 1) ? fO.Orientation.landscape : fO.Orientation.portrait
                });
                if (Object.prototype.hasOwnProperty.call(this, "Orientation")) this.Orientation();
            },
            f1: function() {
                this.f3();
                //var d=[fO.App];
                var d = [], template=[], mobile='mobile', tablet='tablet',ios='ios',android='android';
                fO.isCordova = this.name.cordova();
                fO.isChrome = this.name.chrome();
                if(!fO.Platform)fO.Platform ='web';
                if(!fO.Deploy)fO.Deploy ='desktop';
                if (this.name.mobile()) {
                    fO.Deploy = 'mobile';
                } else if (this.name.tablet()) {
                    fO.Deploy = 'tablet';
                } else {
                    if ($.isFunction(this.name[fO.Device])) {
                        // d.push(fO.Deploy, fO.Platform);
                    }
                }
                // NOTE: for js, css
                d.push(fO.Deploy, fO.Platform);
                if (this.name.ios()) {
                    fO.Device='ios';
                } else if (this.name.android()) {
                    fO.Device='android';
                } else if ($.isFunction(this.name[fO.Device])) {
                    // NOTE: only deploying
                } else{
                    // NOTE: if fO.Deploy is not equal to desktop, {default.web.mobile} to avoid error, but need to update later
                    if(fO.Deploy != 'desktop'){
                        fO.Deploy ='desktop';
                    }
                    fO.Device='default';
                }
                d.push(fO.Device);
                fO.DeviceTemplate=[fO.Device,fO.Platform,fO.Deploy];
                // NOTE: for template {fO.Device,fO.Platform,fO.Deploy}
                /*
                chrome: Device:'desktop',Platform:'chrome', -> Device:'chrome',Platform:'app', Deploy:'desktop',
                ios: Device:'ios',Platform:'app',Deploy:'mobile',
                android: Device:'android',Platform:'app',Deploy:'mobile',
                default: Device:'desktop',Platform:'web',
                */
                var file = [],
                    df = [];
                for (var i in d) {
                    df.push(d[i]);
                    var fl = df.join('.');
                    file.push({
                        type: 'link',
                        name: fl
                    }, {
                        type: 'script',
                        name: fl
                    });
                }
                return file;
            }
        };
        return this;
    };
})(jQuery, navigator.userAgent);
//=require laisiangtho.Prototype.custom.js
//=require laisiangtho.defineProperties.js
//=require ../filesystask/fileSystask.min.js
