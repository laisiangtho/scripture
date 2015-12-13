/*
name: laisiangtho
update: 2015.12.7
*/
/*
Agent(Device)->Listen->Initiate{exe}
f.exe->Load{???}->Watch{exe,is,get}->Meta{is,get}
*/
/*
Common Prototype
    is
    get
*/
(function($, uA) {
    var f = 'laisiangtho',version = '1.9.86.2015.8.28';
    $.fn[f] = function(options) {
        fO = $.extend({
            E: ['Action'],
            App: f,
            Click: 'click',
            On: f,
            Hash: 'hashchange',
            Device: 'desktop',
            Platform: 'web',
            Layout: f,
            Browser: 'chrome',
            Orientation: {
                change: 'D1699',
                landscape: 'landscape',
                portrait: 'portrait'
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
                Orientation: true
            },
            container: {},
            msg: {
                info: $('li')
            }
        }, options);
        var application=this, Core = window[fO.App] = function() {
            this.arg = arguments;
        }
        // var application=this, Core = window[fO.App] = function() {
        //     this.arg = arguments;
        //     return (this);
        // }
        // //for Watch, exe (f.*())
        // //Object.prototype.f = Object.create(Core.prototype);
        // function f() {
        //     //f.*();__proto__ f().*();prototype
        //     var args = arguments;
        //     function x(){
        //          Core.apply(this, args);
        //     }
        //     x.prototype = Object.create(Core.prototype);
        //     x.prototype.constructor = Core;
        //     return new x;
        //     Core.apply(this, arguments);
        //     Object.create(Core.prototype);
        //     Core.prototype.constructor = Core;
        //     return new Core;
        //
        // };
        function f() {
            //f.*();__proto__ f().*();prototype
            this.__proto__ = new Core(arguments);
            return this;
        };
        Core.prototype.tmp = function() {
            console.log('tmp');
        };
        f.__proto__.ClickTest = function(x, y) {
            //console.log('ClickTest',x,y);
            //this('ClickTest').is('class').element.append('...');
            x.append('...');
        };
        f.__proto__.Load = function() {
            console.log('load: where to start line: 37');
        };
        f.__proto__.Watch = function() {
            application.on(fO.Click, f(fO.On).is('class').name, function() {
                f.exe(f($(this)).get('class'), $(this));
            });
        };
        f.__proto__.Meta = {
            link: function(x) {
                x.forEach(function(y) {
                    this[y] = f(y).is('link').get('href');
                });
            },
            meta: function(x) {
                x.forEach(function(y) {
                    this[y] = f(y).is('meta').get('content');
                });
            }
        };
        f.__proto__.exe = function(x, y) {
            if (f[x[0]] && $.isFunction(f[x[0]][x[1]])) {
                return f[x[0]][x[1]](y, x);
            } else if (f[x[0]] && $.isFunction(f[x[0]])) {
                return f[x[0]](y, x);
            } else if (f[x[0]] && $.isFunction(f[x[0]][0])) {
                return f[x[0]][0](y, x);
            } else if (f[x[0]] && f[x[0]][x[1]] && $.isFunction(f[x[0]][x[1]][x[2]])) {
                return f[x[0]][x[1]][x[2]](y, x);
            } else {
                return false;
            }
        };
        //=require laisiangtho.Prototype.is.js
        //=require laisiangtho.Prototype.get.js
        /*
        Example
        f($(.ClickTest)).get(class);
        f(ClickTest).is(class).name -> .ClickTest
        f(ClickTest).is(class).element -> $(.ClickTest)
        f(ClickTest).is(class).get([id,class,href,content,tag]) -> []
        */
        /*
        f.__proto__.tag=function(x){
            //return {element:x, name:x.get(0).tagName, class:this.attr(x).class(), id:this.attr(x).id()};
        };
        */
        this.Test = function() {
            //f().love();
            //f(1,2,3).apple();
            //f.init();
            //f.orange();//ok
        };
        this.Agent = function(obj) {
            //h=fN.HTML();
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
                    for (var i in o.type[y].attr) {
                        req[i] = o.type[y].attr[i] || url;
                    }
                    req.onload = function() {
                        fO.msg.info.html(x.name);
                        if (q.length) {
                            o.go(q);
                        } else {
                            o.m.Listen();
                        }
                    };
                    document.head.appendChild(req);
                }
            };
            o.go($.merge(o.meta, this.Device.f1()));
            this.dProperty('Orientation', {
                value: function() {
                    $(config.css.content).css({
                        'top': $(config.css.header).outerHeight(),
                        'bottom': $(config.css.footer).outerHeight()
                    });
                }
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
        }
        this.Initiate = function() {
            fO.E.forEach(function(j) {
                var x = ($.type(j) === 'object') ? Object.keys(j)[0] : j;
                f.exe(x.split(' '), j[x]);
            });
        }
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
                var d = [];
                fO.isCordova = this.name.cordova();
                fO.isChrome = this.name.chrome();
                if (this.name.mobile()) {
                    fO.Deploy = 'mobile';
                    d.push(fO.Deploy, fO.Platform);
                } else if (this.name.tablet()) {
                    fO.Deploy = 'tablet';
                    d.push(fO.Deploy, fO.Platform);
                } else {
                    if ($.isFunction(this.name[fO.Device])) {
                        d.push(fO.Deploy, fO.Platform); //console.log('//DEPLOY');
                    } else {
                        fO.Deploy = fO.Device;
                        d.push(fO.Deploy, fO.Platform); //console.log('//DESKTOP');
                    }
                }
                if (this.name.ios()) {
                    d.push('ios');
                } else if (this.name.android()) {
                    d.push('android');
                } else if ($.isFunction(this.name[fO.Device])) {
                    d.push(fO.Device);
                }
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
//=require laisiangtho.defineProperties.js
