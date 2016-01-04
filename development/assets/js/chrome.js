var app, isUpgraded="upgraded";
chrome.runtime.onInstalled.addListener(function(e){
    //chrome.storage.local.set(object items, function callback);
    var manifest = chrome.runtime.getManifest();
    if(e.previousVersion){
        if(e.previousVersion != manifest.version){
            //UPGRADE
            chrome.notifications.create(isUpgraded,{
                type: "basic",
                iconUrl: "img/icon.128.png",
                title:manifest.name+" has been upgraded",
                //message: "Version "+manifest.version+". Thoughts and opinions are most welcome via Chrome Web Store!",
                message: "Version "+manifest.version+". Thoughts and opinions are most welcome via Chrome Web Store!",
                isClickable: true
            });
        }else{
            //RE INSTALLATION
        }
    }else{
        //NEW INSTALLATION
    }
});
chrome.notifications.onClicked.addListener(function(id){
    if(id == "upgraded"){
        window.open("https://chrome.google.com/webstore/detail/lai-siangtho/ahbpjkapcngbdcenpkflgmbpeigjlbpc", "target=_blank");
    }
});
chrome.runtime.onSuspend.addListener(function(){
  // Do some simple clean-up tasks.
});
chrome.runtime.onUpdateAvailable.addListener(function(){
});
chrome.app.runtime.onLaunched.addListener(function(){
    chrome.app.window.create(
        'index.html',{
            frame: "none",
            id: "laisiangtho",
            innerBounds:{width:700,height:500, left:600, minWidth:330, minHeight:400}
        },
        function(win) {
            app=win.contentWindow;
            var laisiangtho={
                data:{
                    'jquery':{type:'script'},
                    'jquery.ui':{type:'script'},
                    'jquery.ui.touchpunch.min':{type:'script'},
                    'chrome.google-analytics-bundle':{type:'script'},
                    'laisiangtho':{type:'script'}
                },
                script:{
                    attr:{src:''},extension:'.js',dir:'js/'
                },
                link:{
                    attr:{rel:"stylesheet",type:"text/css",href:''},extension:'.css',dir:'css/'
                },
                init:function(){
                    this.load(Object.keys(this.data));
                },
                load:function(meta){
                    var x=meta.shift(), type=this.data[x].type, self=this,
                        metaURL=this[type].dir+(this.data[x].dir?this.data[x].dir:'')+x+this[type].extension;
                    var req=app.document.createElement(type);
                    for(var i in this[type].attr){
                        req[i]=(this[type].attr[i])?this[type].attr[i]:metaURL;
                    }
                    req.onload=function(){
                        if(meta.length){
                            self.load(meta);
                        }else{
                            self.done();
                        }
                    };
                    app.document.head.appendChild(req);
                },
                done:function(){
                    app.localStorage=chrome.storage.local;
                    app.screenStatus=win;
                    // app.laisiangtho={};
                },
                ready:function(){
                    app.jQuery(app.document.body).laisiangtho({
                        E:[{'metalink':['api']},'load','watch'],
                        Device:'chrome',Platform:'app',
                        App:'laisiangtho',Click:'click',On:'fO'
                    }).Agent();
                    /*
                    {
                        analytics:{
                            config:function(obj){
                                //obj.isTrackingPermitted();
                                obj.setTrackingPermitted(app.config.google.analytics.permission);
                            },
                            service:function(){
                                this.service=app.analytics.getService(app.config.name);
                                this.service.getConfig().addCallback(this.config);
                                this.tracker = this.service.getTracker(app.config.google.analytics.tracker);
                            },
                            sendPage:function(q){
                                //this.tracker.sendAppView(q);
                            },
                            sendEvent:function(q){
                                //this.tracker.sendEvent(q.bible,q.key,q.result);
                            }
                        }
                    }
                    */
                }
        };
        app.addEventListener('DOMContentLoaded', function(event){
            laisiangtho.init(event);
        });
        app.addEventListener('load', function(event){
            laisiangtho.ready(event);
        }, false);
        // win.onBoundsChanged.addListener(function(){
        // });
        // win.onClosed.addListener(function(){
        // });
        // win.onRestored.addListener(function(){
        // });
        // win.onFullscreened.addListener(function(){
        // });
        // win.onMaximized.addListener(function(){
        // });
        // win.onMinimized.addListener(function(){
        // });
        // win.focus();
    });
});
