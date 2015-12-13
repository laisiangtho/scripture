/*
name: laisiangtho
update: 2015.12.7
*/
/*
Agent(Device)->Listen->Initiate{exe}
f.exe->Load{???}->Watch{exe,is,get}->Meta{is,get}
*/
(function($, uA) {
    var f = 'laisiangtho',version = '1.9.86.2015.8.28';
    $.fn[f] = function(options) {
        var application = this;
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
        var Core = window[fO.App] = function() {
            this.arg = arguments;
        }

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
        Core.prototype.is = function(x) {
            //is
            var arg = this.arg[0][0],
                d = {
                    0: '*',
                    1: '.*',
                    2: '#*',
                    3: ' <*>',
                    4: 'link[rel="*"]',
                    5: 'form[name="*"]',
                    6: 'input[name="*"]',
                    7: 'meta[name="*"]',
                    8: 'meta[name="z:*"]'
                };
            this.class = function() {
                return this.name = d[1].replace(d[0], arg);
            };
            this.id = function() {
                return this.name = d[2].replace(d[0], arg);
            };
            this.tag = function() {
                this.name = d[3].replace(d[0], arg);
                return arg;
            };
            this.link = function() {
                return this.name = d[4].replace(d[0], arg);
            };
            this.form = function() {
                return this.name = d[5].replace(d[0], arg);
            };
            this.input = function() {
                return this.name = d[6].replace(d[0], arg);
            };
            this.meta = function() {
                return this.name = d[7].replace(d[0], arg);
            };
            this.fn = function(tmp) {
                this.element = $(tmp);
                this.arg[0][0] = this.element;
                return this;
            };
            if ($.isFunction(this[x])) {
                return this.fn(this[x]());
            } else if (this[x]) {
                return this[x];
            } else {
                return this;
            }
        };
        Core.prototype.get = function(x) {
            //get
            var arg = this.arg[0][0],
                d = {
                    id: '-',
                    class: ' '
                };
            this.class = function() {
                return arg.attr('class');
            };
            this.id = function() {
                return arg.attr('id');
            };
            this.content = function() {
                return arg.attr('content');
            };
            this.href = function() {
                return arg.attr('href');
            };
            this.tag = function() {
                return arg.get(0).tagName;
            };
            this.check = function(y) {
                return ($.type(y) !== 'undefined') ? y : '';
            };
            this.split = function(x, y) {
                return this.check(x).split(y);
            };
            if ($.isFunction(this[x])) {
                if (d[x]) {
                    return this.split(this[x](), d[x]);
                } else {
                    return this[x]();
                }
            } else if (this[x]) {
                return this[x];
            } else {
                return this;
            }
        };
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
Object.defineProperties(Object.prototype, {
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
            //document.querySelectorAll('[someAttr]')
            //document.querySelector('[someAttr]')
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
    // serializeObject:{value:function(o){this.serializeArray().forEach(function(v){o[v.name]=v.value;});return o;}},
    // serializeJSON:{value:function(o){}},
    // isAnalytics:{value:function(callback){if(Object.prototype.hasOwnProperty.call(this, "analytics"))callback(this.analytics);}},
    // extend:{enumerable:false,value:function(x){var o=this;Object.getOwnPropertyNames(x).forEach(function(n){o.dProperty(n,Object.getOwnPropertyDescriptor(x,n));});return o;}},
    dProperty: {
        value: function(n, v) {
            Object.defineProperty(this, n, v);
        }
    },
    dProperties: {
        value: function(v) {
            Object.defineProperties(this, v);
        }
    },
    createProperty: {
        value: function(n, v) {
            this.dProperty(n, {
                value: v
            });
        }
    }
});
/*
var As={
    Class:function(){
        this.name='.*'.replace('*',this);
        return this;
    }
}
var Love = new function(){

};
//cl,id,tg
document.addEventListener('DOMContentLoaded', function () {
    var objName='ClickTest';
    //var element=objName.zc().e.addClass('eeeee');
    //var element=laisiangtho(objName).class(true).element.addClass('eeeee');
    //console.log(laisiangtho(objName).class(true));
    //f('class').class(true)
    //$(objName.class().name).addClass('eeeee');
    //console.log(objName.class(true).element.classList.add("otherclass"));
    //console.log(objName.c(true).e.addClass('abcd'));
    //console.log(As.Class('abc').name);
    //'as'.as().class
    //'as'.class().name
    //As('as').Class().Name

});

f('#id').class(true).
f('id').is('class').
f('id').get('class').
f('id').is('class').get('name')
fG(name).class()
$('.class').attr();
$('.class').attr();
*/
