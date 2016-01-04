function Device(main) {
    this.name = {
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
        // desktop: function() {
        //     return !this.tablet() && !this.mobile();
        // }
    };
    this.listen=function() {
        if (window.addEventListener) {
            window.addEventListener(fO.Orientation.evt, this.f2, false);
        } else if (window.attachEvent) {
            window.attachEvent(fO.Orientation.evt, this.f2);
        } else {
            window[fO.Orientation.evt] = this.f2;
        }
        this.f2();
    },
    this.f2=function() {
        $(window.document.documentElement).attr({
            class: (window.innerHeight < window.innerWidth) ? fO.Orientation.landscape : fO.Orientation.portrait
        });
        if (Object.prototype.hasOwnProperty.call(main, "Orientation")) main.Orientation();
    },
    this.get=function() {
        this.listen();
        var d = [],
            template = [],
            mobile = 'mobile',
            tablet = 'tablet',
            ios = 'ios',
            android = 'android';
        fO.isCordova = this.name.cordova();
        fO.isChrome = this.name.chrome();
        if (!fO.Platform) fO.Platform = 'web';
        if (!fO.Deploy) fO.Deploy = 'desktop';
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
            fO.Device = 'ios';
        } else if (this.name.android()) {
            fO.Device = 'android';
        } else if ($.isFunction(this.name[fO.Device])) {
            // NOTE: only deploying
        } else {
            // NOTE: if fO.Deploy is not equal to desktop, {default.web.mobile} to avoid error, but need to update later
            if (fO.Deploy != 'desktop') {
                fO.Deploy = 'desktop';
            }
            fO.Device = 'default';
        }
        d.push(fO.Device);
        fO.DeviceTemplate = [fO.Device, fO.Platform, fO.Deploy];
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
