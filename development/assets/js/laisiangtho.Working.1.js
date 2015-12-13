/*
TODO
Content Menu, lookup, note, variables and object
z,fO,fA,fN,fD
*/
(function($,uA){
var z='laisiangtho', version='1.9.86.2015.8.28';
$.fn[z]=function(options){
    var application=this;
    fO=$.extend({
        E:['Action'],App:z,Click:'click',On:z,Hash:'hashchange',Device:'desktop',Platform:'web',Layout:z,Browser:'chrome',
        Orientation:{change:'D1699',landscape:'landscape',portrait:'portrait'},
        note:{},lang:{},query:{},lookup:{setting:{},book:{}},previous:{},todo:{Orientation:true},
        container:{},
        msg:{info:$('li')}
    }, options);
    z=window[fO.App]=new Core(this);
    Core.prototype.bible=function(){
    };
    Core.prototype.book=function(){
    };
    Core.prototype.reader=function(){
    };
    Core.prototype.lookup=function(){
    };
    Core.prototype.note=function(){
    };
    Core.prototype.Load=function(){
    };
    Core.prototype.Init=function(){
    };
    function Core(app){
        this.Watch=function(){
            app.on(fO.Click,fN.is(fO.On).class,fN.Watch().class);
        };
        this.Meta={
            link:function(x){x.forEach(function(y){window[y]=fN.Attr(fN.Tag(y).is(4)).href();});},
            meta:function(x){x.forEach(function(y){window[y]=fN.Attr(fN.Tag(y).is(7)).content();});}
        };
        this.todo=function(){
            console.log('//TODO');
        };
    };
    function Action(){
        this.iQ=arguments[0]; this.obj=arguments[1];
        this.about={
            version:function(){
            }
        };
    };
    fA=new Action();
    function Utility(){
        this.iQ=arguments[0]; this.obj=arguments[1];
        this.requestFileSystem=function(success,error){
            window.requestFileSystem(LocalFileSystem.PERSISTENT, 0,success,error);
        };
        this.resolveFileSystem=function(url,success,error){
            window.resolveLocalFileSystemURL(url,success,error);
        };
        this.UniqueID=function(){
            return new Date().getTime();
        };
        this.String=function(x){
            return $.map(x,function(v){
                return $.isNumeric(v)?String.fromCharCode(v):v;
            }).join('');
        };
        this.Click=function(callback){
            $(document).on(fO.Click,callback);
        };
        this.Watch=function(x){
            var o=this;
            return{id:function(){o[0](o[1]($(this)).id);},class:function(){o[0](o[1]($(this)).class,$(this));},go:function(q){o[0](x,q);}};
        };
        this[0]=function(x,q){
            if(z[x[0]] && $.isFunction(z[x[0]][x[1]])){return z[x[0]][x[1]](q,x);}
            else if(z[x[0]] && $.isFunction(z[x[0]])){return z[x[0]](q,x);}
            else if(z[x[0]] && $.isFunction(z[x[0]][0])){return z[x[0]][0](q,x);}
            else if(z[x[0]] && z[x[0]][x[1]] && $.isFunction(z[x[0]][x[1]][x[2]])){return z[x[0]][x[1]][x[2]](q,x);}
            else{return false;}
        };
        this[1]=function(x){
            return {element:x, name:x.get(0).tagName, class:this.Attr(x).class(), id:this.Attr(x).id()};
        };
        this.Attr=function(x){
            if(x && $.type(x) !== 'object')x=$(x);
            return {
                d:{id:'-',class:' '},
                of:function(y,s){return this.do(y,s);},
                class:function(){return this.do('class',this.d.class);},
                id:function(){return this.do('id',this.d.id);},
                href:function(){return this.do('href',true).done;},
                content:function(){return this.do('content',true).done;},
                do:function(y,s){this.done=x=x.attr(y); if(s === true){return this; }else if(s){return this.split(s);}else{return this.split(this.d[y]||this.d.class);}},
                check:function(y){return ($.type(y) !== 'undefined')?y:'';},
                split:function(y){return this.check(x).split(y);}
            };
        };
        this.Tag=function(x){
            return{name:{0:'*',1:'.*',2:'#*',3:' <*>',4:'link[rel="*"]',5:'form[name="*"]',6:'input[name="*"]',7:'meta[name="*"]',8:'meta[name="z:*"]'},is:function(y){return this.name[y].replace('*',x);}};
        };
        this.is=function(x){
            return {class:this.Tag(x).is(1), id:this.Tag(x).is(2), tag:this.Tag(x).is(3),form:this.Tag(x).is(5),input:this.Tag(x).is(6)};
        };
        this.HTML=function(){
            return {ol:this.is('ol').tag, ul:this.is('ul').tag, li:this.is('li').tag, a:this.is('a').tag, div:this.is('div').tag,p:this.is('p').tag,h1:this.is('h1').tag, h2:this.is('h2').tag,h3:this.is('h3').tag,h4:this.is('h4').tag, span:this.is('span').tag,em:this.is('em').tag,sup:this.is('sup').tag};
        };
        this.Array=function(d,o){
            return {
                merge:function(y){
                    if($.type(y) === 'array')o=y;
                    this.data=d=d.concat(o).sort(function(a,b){return a - b;}); return this;
                },
                unique:function(){
                    return d.filter(function(item, index){return d.indexOf(item) === index;});
                },
                removeIfduplicate:function(y){
                    return $.map(d,function (v,i) {
                        d[i] === d[i+1] && (d[i] = d[i+1] = null);  return d[i];
                    });
                },
                to:function(y){
                    return {
                        sentence:function(x){return (d.length>1)?[d.slice(0, -1).join(y||', '), d.slice(-1)[0]].join(x||' & '):d[0];}
                    };
                }
            };
        };
        this.Content=function(dl,position){
        };
        this.Hash=function(callback){
            var q=location.hash,r={page:q.split("?")[0].replace('#','')}, m, search=/([^\?#&=]+)=([^&]*)/g, d=function(s){ return decodeURIComponent(s.replace(/\+/g," ")); };
            while(m = search.exec(q)) r[d(m[1])]=d(m[2]);
            callback(r);
        };
    };
    fN=new Utility();
    fN.__proto__={
        Num:function(n,l){
            if(!l)l=fO.query.bible;
            return (Object.getOwnPropertyNames(fO.lang[l].n).length === 0)?n:n.toString().replace(/[0123456789]/g,function(s){return fO.lang[l].n[s];});
        },
        Url:function(l,x,y){
            var Url=this.String([l,47,x.join('/'),46,y]), Filename=Url.substring(Url.lastIndexOf('/')+1), Type=this.String(['application',47,y]), Path=null, Local=null;
            if(fO.isCordova){Path=cordova.file.dataDirectory; Local=cordova.file.dataDirectory+Filename;}
            return {url:Url,data:y,content:Type+';charset=utf-8',filename:Filename,type:Type,path:Path,local:Local};
        },
        Working:function(q){
        },
        Done:function(callback){
        },
        Body:function(){
            return $('body').attr({id:fO.query.page,class:''});
        },
        Page:function(n){
            return this.String([35,config.page[n],63]);
        },
        Go:function(page,q){
            window.location.hash=page+$.param(q);
        },
        Header:function(container){
        },
        Footer:function(container){
        },
        ActiveClass:function(container){
        }
    };
    fN.__proto__.Container={
        Closest:function(container,x,y){
        },
        FadeOut:function(container,x,y){
        }
    };
    fN.__proto__.Menu=function(Oq){
    };
    fN.__proto__.Regex=function(q){
    };
    function Database(){
    };
    fD=new Database();
    this.createProperty('Device',{
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
            var d=[fO.App];
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
    });
    this.createProperty('Agent',function(obj){
        h=fN.HTML(); fO.Orientation.evt=(Object.prototype.hasOwnProperty.call(window, "onorientationchange"))?"orientationchange":"resize";
        var o={
            meta:[{type:'script',name:'localforage.min'},{type:'script',name:'jquery.ui.touchpunch.min'},{type:'script',name:'data.bible'},{type:'script',name:'data.config'},{type:'link',name:fO.App,dir:'fontello/'}],
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
        if(obj)z.extend(obj);
    });
    this.createProperty('Listen',function(){
        if(fO.isCordova){
            fO.msg.info.html('getting Device ready').attr({class:'icon-database'});
            document.addEventListener("deviceready", this.Initiate, false);
        }else{
            this.Initiate();
        }
    });
    this.createProperty('Initiate',function(){
        fO.E.forEach(function(j){var x=($.type(j) === 'object')?Object.keys(j)[0]:j; fN[0](x.split(' '),j[x]);});
    });
    return this;
};})(jQuery,navigator.userAgent);
Object.defineProperties(Object.prototype,{
    fN:{value:function(){return new Utility(arguments,this);}},
    serializeObject:{value:function(o){this.serializeArray().forEach(function(v){o[v.name]=v.value;});return o;}},
    serializeJSON:{value:function(o){}},
    isAnalytics:{value:function(callback){if(Object.prototype.hasOwnProperty.call(this, "analytics"))callback(this.analytics);}},
    extend:{enumerable:false,value:function(x){var o=this;Object.getOwnPropertyNames(x).forEach(function(n){o.dProperty(n,Object.getOwnPropertyDescriptor(x,n));});return o;}},
    dProperty:{value:function(n,v){Object.defineProperty(this, n, v);}},
    dProperties:{value:function(v){Object.defineProperties(this,v);}},
    createProperty:{value:function(n,v){this.dProperty(n, {value:v});}}
});
