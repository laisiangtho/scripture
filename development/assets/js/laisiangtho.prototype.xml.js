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
Core.prototype.xml = function(callback) {
    // NOTE new f('arg').xml();
    // TODO: for Storage for Chrome using Webkit
    var fn=this, q=this.arg[0];
    var lO=fO.lang[q.bible], lA=lO.l, lB=lO.b;
    var urlInfo=this.url(config.id,[q.bible],config.file.bible);
    // NOTE: is, get, read, remove, check
    this.is=function(){
        if($.isEmptyObject(fO[q.bible].bible)){
            if(fO.isCordova){
                // NOTE: for Mobile and Tablet
                // NOTE: fn.file.Cordova().read =Oa.XLO.reading
                urlInfo.local.resolveFileSystem(fn.file.Cordova().read, function(error){
                    fn.ResponseGood({msg:'to Local',status:false});
                });
            }else if(fO.isChrome){
                // NOTE: for Chrome Package App using webkitRequestFileSystem
                fn.ResponseGood({msg:'to Webkit',status:false});
            }else{
                // NOTE: ather that support INDEXDB
                db.get({table:q.bible}).then(function(storeBible){
                    if(storeBible){
                        if($.isEmptyObject(storeBible)){
                            fn.ResponseGood({msg:'to Store',status:false});
                        }else{
                            if(q.reading==q.bible){
                                fO[q.bible].bible=storeBible;
                                fn.ResponseGood({msg:'from Store',status:true});
                            }else{
                                fn.ResponseGood({msg:'to Store',status:true});
                            }
                        }
                    }else{
                        fn.ResponseGood({msg:'to Store',status:false});
                    }
                });
            }
        }else{
            // TODO: must check why object is empty
            fn.ResponseGood({msg:'from Object',status:true});
        }
        return this;
    };
    this.get=function(){
        if($.isEmptyObject(fO[q.bible].bible)){
            if(fO.isCordova){
                // NOTE: fn.file.Cordova().get=Oa.XLO.getting, fn.file.Cordova().download=Oa.XLO.downloading
                fn.working({msg:lA.PleaseWait,wait:true}).promise().done(function(){
                    urlInfo.local.resolveFileSystem(fn.file.Cordova().get, fn.file.Cordova().download);
                });
            }else if(fO.isChrome){
                // NOTE: for Chrome Package App using webkitRequestFileSystem
                fn.ResponseGood({msg:'to Webkit',status:false});
            }else{
                // NOTE: ather that support INDEXDB
                db.get({table:q.bible}).then(function(storeBible){
                    if(storeBible){
                        fO[q.bible].bible=storeBible;
                        if($.isEmptyObject(fO[q.bible].bible)){
                            // NOTE: storage has this, but was empty
                            fn.file.IndexDb().download();
                        }else{
                            // NOTE: storage has bible for this ID
                            fn.ResponseGood({msg:'from Store',status:true});
                        }
                    }else{
                        // NOTE: storage has no bible this ID
                        fn.file.IndexDb().download();
                    }
                });
            }
        }else{
            fn.ResponseCallbacks({msg:'from Object',status:true});
        }
    };
    this.remove=function(){
        if(fO.isCordova){
            urlInfo.local.resolveFileSystem(fn.file.Cordova().remove, function(error){
                fn.ResponseGood({status:true});
            });
        }else{
            db.delete({table:q.bible}).then(function(){
                fn.ResponseBad({status:true});
            });
        }
    };
    this.file={
        // NOTE: IndexDb, Web(Cordova, Chrome,None)
        IndexDb:function(){
            this.download=function(secondRequest){
                $.ajax({
                    //TODO headers:{}, xhrFields:{"withCredentials": true},
                    beforeSend:function(xhr){
                        fn.working({msg:lA.Downloading,wait:true});
                        xhr.setRequestHeader("Access-Control-Allow-Origin", "*");
                    },
                    xhr:function(){
                        var xhr=new window.XMLHttpRequest();
                        xhr.addEventListener("progress", function(evt){
                            if(evt.lengthComputable) {
                                var Percentage=Math.floor(evt.loaded / evt.total * 100);
                                fn.working({msg:lA.PercentLoaded.replace(/{Percent}/, fn.num(Percentage))});
                            }
                        }, false);
                        //TODO uploading
                        /*
                        XMLHttpRequest.upload.addEventListener("progress", function(evt){
                            if(evt.lengthComputable){
                                var Percent=Math.floor(evt.loaded / evt.total * 100);
                                fn.working({
                                    msg:lA.PercentLoaded.replace(/{Percent}/, fn.num(Percentage)),
                                    class:true
                                });
                            }
                        }, false);
                        */
                        return xhr;
                    },
                    url:(secondRequest)?secondRequest+urlInfo.url:urlInfo.url,dataType:urlInfo.data,contentType:urlInfo.content,cache:true,crossDomain:true,async:true
                }).done(function(j, status, d){
                    fn.JobType(j);
                }).fail(function(jqXHR, textStatus){
                    if(api){
                        // NOTE NodeJs might be confused!
                        if(secondRequest){
                            fn.ResponseGood({msg:textStatus,status:false});
                        }else{
                            fn.file.IndexDb().download(api);
                        }
                    }else{
                        fn.ResponseGood({msg:textStatus,status:false});
                    }
                }).always(function(){});
            }
            this.read=function(){}
            this.get=function(){}
            this.content=function(){}
            this.remove=function(){}
            return this;
        },
        Cordova:function(){
            this.download=function(){
                fn.working({msg:lA.Downloading});
                var fileTransfer = new FileTransfer();
                fileTransfer.onprogress=function(evt) {
                    if(evt.lengthComputable){
                        var Percentage = Math.floor(evt.loaded / evt.total * 100);
                        fn.working({msg:lA.PercentLoaded.replace(/{Percent}/, fn.num(Percentage))});
                    }
                };
                // NOTE this.content=fn.file.Cordova().content
                fileTransfer.download(encodeURI(api+urlInfo.url), urlInfo.local, fn.file.Cordova().content, function(error){
                    fn.ResponseGood({msg:error.code,status:false});
                });
            };
            this.read=function(fileEntry){
                if(q.reading==q.bible){
                    this.content(fileEntry);
                }else{
                    fn.ResponseGood({msg:'from Reading',status:true});
                }
            };
            this.get=function(fileEntry){
                this.content(fileEntry);
            };
            this.content=function(fileEntry,error){
                fileEntry.file(function(file) {
                    // NOTE file.name, file.localURL, file.type, new Date(file.lastModifiedDate), file.size
                    var reader=new FileReader();
                    reader.onloadend=function(e){
                        var parser=new DOMParser();
                        fn.JobType(parser.parseFromString(e.target.result,urlInfo.type));
                    };
                    reader.readAsText(file);
                },function(){
                    fn.ResponseGood({msg:'fail to read Local',status:false});
                });
            };
            this.remove=function(fileEntry){
                fileEntry.remove(function() {
                    fn.ResponseBad({status:true});
                },function(error){
                    fn.ResponseBad({status:false});
                });
            };
            return this;
        },
        Chrome:function(){
            // TODO: webkitResolveLocalFileSystemURL
            this.download=function(){
            }
            return this;
        },
        Web:function(){
            // TODO: load XML
            this.download=function(){
            }
            return this;
        }
    };
    this.JobType=function(j){
        // NOTE child
        var jobTypeFormat=$(j).children().get(0).tagName;
        if($.isFunction(this.Job[jobTypeFormat])){
            fO[q.bible].bible={info:{},book:{}};
            this.Job[jobTypeFormat](j);
        }else{
            this.ResponseGood({msg:lA.IsNotFoundIn.replace(/{is}/,jobTypeFormat).replace(/{in}/,'jobType'),status:false});
        }
    };
    this.Job={
        // NOTE generate Object from XML <bible>
        bible:function(j){
            var theTitle=[], theRef=[], index=0;
            $(j).children().each(function(o,i1){
                var j1=$(i1), d1=j1.children(), id=j1.attr('id');
                if(d1.length){
                    d1.each(function(b,i2){
                        var j2=$(i2), d2=j2.children(), i2=j2.attr('id'), t2=j2.get(0).tagName.toLowerCase(), contentIndex=0;
                        if($.type(fO[q.bible].bible[t2]) ==='undefined')fO[q.bible].bible[t2]={};
                        if(d2.length){
                            fO[q.bible].bible[t2][i2]={};
                            setTimeout(function(){
                                d2.each(function(c,i3){
                                    var j3=$(i3), d3=j3.children(), i3=j3.attr('id'), t3=j3.get(0).tagName.toLowerCase();
                                    if($.type(fO[q.bible].bible[t2][i2][t3]) ==='undefined')fO[q.bible].bible[t2][i2][t3]={};
                                    if(d3.length){
                                        fO[q.bible].bible[t2][i2][t3][i3]={};
                                        fO[q.bible].bible[t2][i2][t3][i3].verse={};
                                        setTimeout(function(){
                                            d3.each(function(v,i4){
                                                var j4=$(i4), d4=j4.children(), i4=j4.attr('id'), t4=j4.get(0).tagName.toLowerCase();
                                                i4='v'+i4;
                                                fO[q.bible].bible[t2][i2][t3][i3].verse[i4]={};
                                                fO[q.bible].bible[t2][i2][t3][i3].verse[i4].text=j4.text();
                                                if(j4.attr('ref'))fO[q.bible].bible[t2][i2][t3][i3].verse[i4].ref=j4.attr('ref').split(',');
                                                if(j4.attr('title'))fO[q.bible].bible[t2][i2][t3][i3].verse[i4].title=j4.attr('title').split(',');
                                                if(d1.length == b+1){
                                                    if(d2.length == c+1){
                                                        if(d3.length == v+1){
                                                            if(fO.isCordova){
                                                                fn.ResponseGood({msg:'Saved',status:true});
                                                            }else{
                                                                db.add({table:q.bible,data:fO[q.bible].bible}).then(fn.ResponseGood({msg:'Stored',status:true}));
                                                            }
                                                        }
                                                    }
                                                }
                                            });
                                        },30/b*c);
                                        // NOTE chapter
                                    }else if(i3){
                                        // NOTE info
                                        fO[q.bible].bible[t2][i2][t3][i3]=j3.text();
                                    }else{
                                        // NOTE content
                                        contentIndex++;
                                        //TODO fO[q.bible].bible[t2][i2][t3][contentIndex]={ref:j3.attr('ref').split(','), title:j3.text()};
                                        fO[q.bible].bible[t2][i2][t3][contentIndex]={title:j3.text()};
                                        if(j3.attr('ref'))fO[q.bible].bible[t2][i2][t3][contentIndex].ref=j3.attr('ref').split(',');
                                    }
                                }).promise().done(function(){
                                    // NOTE: notify status
                                    fO.msg.info.html(lB[i2]);
                                });
                            },90*b);
                        }else{
                            fO[q.bible].bible[t2][i2]=j2.text();
                        }
                    });
                }else{
                    var name=j1.attr('id'), text=j1.text();
                }
            });
        }
    };
    // TODO: see if you can do smarter for the return Method
    this.ResponseGood=function(response){
        lO.local=response.status;
        if(q.reading){
            fn.ResponseCallbacks(response);
        }else{
            db.update.lang().then(function(){
                fn.done(); fn.ResponseCallbacks(response);
            });
        }
        return this;
    };
    this.ResponseBad=function(response){
        // REVIEW: ?
        // delete fO[q.bible].bible;
        // if(response.status)fO.lang[q.bible].local=false;
        delete fO[q.bible].bible;
        if(response.status)lO.local=false;
        db.update.lang().then(function(){
            fn.ResponseCallbacks(response);
        });
        return this;
    };
    this.ResponseCallbacks=function(response){
        this.msg=response;
        // callback.apply(this,response);
        callback(response);
    };
    return this;
};
