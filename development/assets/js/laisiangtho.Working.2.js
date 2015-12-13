/*
TODO
Content Menu, lookup, note, variables and object
z,zO,zA,zN,zD
f,fO,fA,fN,fD
lai().index
*/
//laisiangtho;
(function($,uA){
    var f='laisiangtho', version='1.9.86.2015.8.28';
    $.fn[f]=function(options){
        var application=this;
        fO=$.extend({
            E:['Action'],App:f,Click:'click',On:f,Hash:'hashchange',Device:'desktop',Platform:'web',Layout:f,Browser:'chrome',
            Orientation:{change:'D1699',landscape:'landscape',portrait:'portrait'},
            note:{},lang:{},query:{},lookup:{setting:{},book:{}},previous:{},todo:{Orientation:true},
            container:{},
            msg:{info:$('li')}
        }, options);
        //z=window[fO.App]=new Core(this);
        /*
        function Core(){
            //z().*();
            this.arg=arguments;
        }
        Core.prototype.Init=function(){
            console.log('Core.__proto__.Init',this.arg);
        };
        function z(){
            //z.*();
            return new Core(arguments);
        };
        z.__proto__={
            Index:function(){
                console.log('z.__proto__.Index');
            }
        };
        z.prototype.bible=function(){
            console.log('z.prototype.bible');
        }
        //f=window[fO.App]=new Core(this);
        f.__proto__.index=function(){
            console.log('f.__proto__.index');
        };
        f.__proto__.apple=function(){
            console.log('f.__proto__.apple',this.arg);
        };
        f.function();
        f().function();
        */
        var fN=window[fO.App]=function(){
            this.arg=arguments;
        }
        fN.prototype.apple=function(){
            console.log('fN.prototype.apple',this.arg);
        };
        fN.__proto__.init=function(){
            console.log('fN.__proto__.init');
        };
        //f=window[fO.App]=function(){
        function f(){
            //f.*();__proto__
            //f().*();prototype
            this.love=function(){
                console.log('love');
            }
            this.__proto__=new fN(arguments);
            return this;
        };
        f.__proto__.orange=function(){
            console.log('f.__proto__.orange');
        };
        this.Test=function(){
            //f().love();
            //f(1,2,3).apple();
            //f.init();
            //f.orange();//ok
        };
        this.Listen=function(){
            if(fO.isCordova){
                fO.msg.info.html('getting Device ready').attr({class:'icon-database'});
                document.addEventListener("deviceready", this.Initiate, false);
            }else{
                fO.msg.info.attr({class:'icon-database'});
                this.Initiate();
            }
        }
        this.Initiate=function(){
            console.log('Initiate');
            //f.init();
            f(1,2,3).apple();
            /*
            fO.E.forEach(function(j){
                var x=($.type(j) === 'object')?Object.keys(j)[0]:j;
                fN[0](x.split(' '),j[x]);
            });
            */
        }
        this.Agent=function(obj){
            //h=fN.HTML();
            fO.Orientation.evt=(Object.prototype.hasOwnProperty.call(window, "onorientationchange"))?"orientationchange":"resize";
            var o={
                meta:[{type:'script',name:'localforage.min'},{type:'script',name:'data.bible'},{type:'script',name:'data.config'},{type:'link',name:fO.App,dir:'fontello/'}],
                type:{script:{attr:{src:null}, extension:'.js', dir:'js/'},link:{attr:{rel:'stylesheet',href:null}, extension:'.css', dir:'css/'}},
                m:this,
                go:function(q){
                    var x=q.shift(), y=x.type, url=(x.dir||o.type[y].dir)+x.name+o.type[y].extension,
                    req=document.createElement(y);
                    for(var i in o.type[y].attr){req[i]=o.type[y].attr[i]||url;}
                    req.onload=function(){
                        fO.msg.info.html(x.name);
                        if(q.length){o.go(q);}else{o.m.Listen();}
                    };
                    document.head.appendChild(req);
                }
            };
            o.go($.merge(o.meta, this.Device.f1()));
            this.dProperty('Orientation',{
                value:function(){
                    $(config.css.content).css({'top':$(config.css.header).outerHeight(),'bottom':$(config.css.footer).outerHeight()});
                }
            });
            if(obj)f.extend(obj);
        };
        this.Device={
            name:{
                is:function(needle){return uA.toLowerCase().indexOf(needle) !== -1;},
                ios:function(){return this.iphone() || this.ipod() || this.ipad();},
                iphone:function(){return !this.windows() && this.is('iphone');},
                ipod:function(){return this.is('ipod');},
                ipad:function(){return this.is('ipad');},
                android:function(){return !this.windows() && this.is('android');},
                androidPhone:function(){return this.android() && this.is('mobile');},
                androidTablet:function(){return this.android() && !this.is('mobile');},
                blackberry:function(){return this.is('blackberry') || this.is('bb10') || this.is('rim');},
                blackberryPhone:function(){return this.blackberry() && !this.is('tablet');},
                blackberryTablet:function(){return this.blackberry() && this.is('tablet');},
                windows:function(){return this.is('windows');},
                windowsPhone:function(){return this.windows() && this.is('phone');},
                windowsTablet:function(){return this.windows() && (this.is('touch') && !this.windowsPhone());},
                fxos:function(){return (this.is('(mobile;') || this.is('(tablet;')) && this.is('; rv:');},
                fxosPhone:function(){return this.fxos() && this.is('mobile');},
                fxosTablet:function(){return this.fxos() && this.is('tablet');},
                meego:function(){return this.is('meego');},
                cordova:function(){return window.cordova && location.protocol === 'file:';},
                chrome:function(){return fO.Platform === 'chrome';},
                nodeWebkit:function(){return typeof window.process === 'object';},
                mobile:function(){return this.androidPhone() || this.iphone() || this.ipod() || this.windowsPhone() || this.blackberryPhone() || this.fxosPhone() || this.meego();},
                tablet:function(){return this.ipad() || this.androidTablet() || this.blackberryTablet() || this.windowsTablet() || this.fxosTablet();}
                //desktop:function(){return !this.tablet() && !this.mobile();}
            },
            f3:function(){
                if(window.addEventListener){window.addEventListener(fO.Orientation.evt, this.f2, false);}
                else if(window.attachEvent){window.attachEvent(fO.Orientation.evt,this.f2);}
                else{window[fO.Orientation.evt]=this.f2;}
                this.f2();
            },
            f2:function(){
                $(window.document.documentElement).attr({class:((window.innerHeight / window.innerWidth) < 1)?fO.Orientation.landscape:fO.Orientation.portrait});
                if(Object.prototype.hasOwnProperty.call(this, "Orientation"))this.Orientation();
            },
            f1:function(){
                this.f3();
                //var d=[fO.App];
                var d=[];
                fO.isCordova=this.name.cordova();
                fO.isChrome=this.name.chrome();
                if(this.name.mobile()){
                    fO.Deploy='mobile'; d.push(fO.Deploy,fO.Platform);
                }else if(this.name.tablet()) {
                    fO.Deploy='tablet'; d.push(fO.Deploy,fO.Platform);
                }else{
                    if($.isFunction(this.name[fO.Device])){
                        d.push(fO.Deploy,fO.Platform);//console.log('//DEPLOY');
                    }else{
                        fO.Deploy=fO.Device; d.push(fO.Deploy,fO.Platform);//console.log('//DESKTOP');
                    }
                }
                if(this.name.ios()){d.push('ios');}else if(this.name.android()){d.push('android');}else if($.isFunction(this.name[fO.Device])){d.push(fO.Device);}
                var file=[], df=[];
                for(var i in d){
                    df.push(d[i]);
                    var fl=df.join('.');
                    file.push({type:'link',name:fl},{type:'script',name:fl});
                }
                return file;
            }
        };
        return this;
    };
})(jQuery,navigator.userAgent);
Object.defineProperties(Object.prototype,{
    //fN:{value:function(){return new Utility(arguments,this);}},
    // serializeObject:{value:function(o){this.serializeArray().forEach(function(v){o[v.name]=v.value;});return o;}},
    // serializeJSON:{value:function(o){}},
    // isAnalytics:{value:function(callback){if(Object.prototype.hasOwnProperty.call(this, "analytics"))callback(this.analytics);}},
    // extend:{enumerable:false,value:function(x){var o=this;Object.getOwnPropertyNames(x).forEach(function(n){o.dProperty(n,Object.getOwnPropertyDescriptor(x,n));});return o;}},
    dProperty:{value:function(n,v){Object.defineProperty(this, n, v);}},
    dProperties:{value:function(v){Object.defineProperties(this,v);}},
    createProperty:{value:function(n,v){this.dProperty(n, {value:v});}}
});
