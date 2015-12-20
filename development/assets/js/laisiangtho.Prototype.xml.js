Core.prototype.xml = function(callback) {
    // NOTE new f('arg').xml();
    // TODO: for Storage for Chrome using Webkit
    var fn=this, q=this.arg[0];
    var lO=fO.lang[q.bible], lA=lO.l, lB=lO.b;
    var urlInfo=this.url(config.id,[q.bible],config.file.bible);
    var responseMsg =[];
    /*
    if(fileSystem.support){
    }else if(window.indexedDB){
    }else{
    }
    */
    // NOTE: has, get, remove
    this.has=function(){
        if($.isEmptyObject(fO[q.bible].bible)){
            if(fileSystem.support){
                fileSystem.get({
                    fileOption: {},
                    fileUrlLocal: urlInfo.fileUrl,
                    fileReadAs: true,
                    before:function () {
                        responseMsg.push(q.bible.toUpperCase());
                    },
                    success:function(Obj){
                        responseMsg.push('Found');
                        fn.file.read(Obj.fileContent);
                    },
                    fail:function(Obj/*String or Object*/){
                        responseMsg.push('NotFound');
                        if(q.bible==q.downloading){
                            responseMsg.push('SendTo');
                            fn.file.download(true);
                        }else{
                            responseMsg.push('Sendback');
                            fn.ResponseGood(false);
                        }
                    }
                });
            }else if(window.indexedDB){
                // TODO: db?
                responseMsg.push('Store');
                db.get({table:q.bible}).then(function(storeBible){
                    if(storeBible){
                        if($.isEmptyObject(storeBible)){
                            responseMsg.push('Empty');
                            if(q.bible==q.downloading){
                                responseMsg.push('SendTo');
                                fn.file.download(false);
                            }else{
                                responseMsg.push('Sendback');
                                fn.ResponseGood(false);
                            }
                        }else{
                            responseMsg.push('Reading');
                            if(q.bible==q.reading){
                                fO[q.bible].bible=storeBible;
                                responseMsg.push('Success');
                                fn.ResponseGood(true);
                            }else{
                                responseMsg.push('Disabled');
                                fn.ResponseGood(true);
                            }
                        }
                    }else{
                        responseMsg.push('NotFound');
                        if(q.bible==q.downloading){
                            responseMsg.push('SendTo');
                            fn.file.download(false);
                        }else{
                            responseMsg.push('Sendback');
                            fn.ResponseGood(false);
                        }
                    }
                });
            } else {
                responseMsg.push('fileSystemNotOk','indexedDBNotOK');
                if(q.bible==q.downloading){
                    responseMsg.push('CanNotSetDownloadingTRUE');
                }
                responseMsg.push('Sendback');
                fn.ResponseGood(false);
            }
        }else{
            // TODO: must check why object is empty
            responseMsg.push('AlreadyInObject');
            fn.ResponseGood(true);
        }
        return this;
    };
    this.get=function(){
        if($.isEmptyObject(fO[q.bible].bible)){
            if(fileSystem.support){
                fileSystem.get({
                    fileOption: {},
                    fileUrlLocal: urlInfo.fileUrl,
                    fileReadAs: true,
                    before:function () {
                        responseMsg.push(q.bible.toUpperCase());
                        fn.working({msg:lA.PleaseWait,wait:true});
                    },
                    success:function(Obj){
                        responseMsg.push('Found');
                        fn.file.read(Obj.fileContent);
                    },
                    fail:function(Obj){
                        responseMsg.push('NotFound','SendTo');
                        fn.file.download(true);
                    }
                });
            }else if(window.indexedDB){
                // TODO: db?
                responseMsg.push('Store');
                db.get({table:q.bible}).then(function(storeBible){
                    if(storeBible){
                        if($.isEmptyObject(storeBible)){
                            responseMsg.push('Empty','SendTo');
                            fn.file.download(false);
                        }else{
                            responseMsg.push('Reading');
                            if(q.bible==q.reading){
                                fO[q.bible].bible=storeBible;
                                responseMsg.push('Success');
                                fn.ResponseGood(true);
                            }else{
                                responseMsg.push('Disabled');
                                fn.ResponseGood(true);
                            }
                        }
                    }else{
                        responseMsg.push('NotFound','SendTo');
                        fn.ResponseGood(false);
                    }
                });
            } else {
                responseMsg.push('fileSystemNotOk','indexedDBNotOK');
                responseMsg.push('GettingReadyForWeb');
                fn.file.download(false);
            }
        }else{
            responseMsg.push('AlreadyInObject');
            // fn.ResponseGood(true);
            fn.ResponseCallbacks(true);
        }
        return this;
    };
    this.remove=function(){
        responseMsg.push(q.bible.toUpperCase());
        if(fileSystem.support){
            fileSystem.remove({
                fileOption: {},
                fileUrlLocal: urlInfo.fileUrl,
                fileNotFound: true,
                success:function(Obj){
                    responseMsg.push('Removed');
                    fn.ResponseBad(true);
                },
                fail:function(Obj){
                    responseMsg.push('Fail');
                    fn.ResponseBad(false);
                }
            });
        }else if(window.indexedDB){
            // TODO: db?
            responseMsg.push('Store');
            db.delete({table:q.bible}).then(function(){
                responseMsg.push('Removed');
                fn.ResponseBad(true);
            });
        } else {
            responseMsg.push('fileSystemNotOk','indexedDBNotOK');
            responseMsg.push('NothingToRemove','Sendback');
            fn.ResponseBad(false);
        }
    };
    this.file={
        // NOTE: IndexDb, Web(Cordova, Chrome,None)
        // fn.working({msg:lA.Downloading,wait:true});
        // fn.working({msg:lA.PleaseWait,wait:true});
        download:function(isfileToCreate){
            fileSystem.download({
                fileOption: {
                    create: isfileToCreate
                },
                fileUrl: urlInfo.fileUrl,
                fileUrlLocal: true,
                before: function(e) {
                    // NOTE: before task!
                    // e.setRequestHeader("Access-Control-Allow-Origin", "*");
                    responseMsg.push('Downloading');
                    fn.working({msg:lA.Downloading,wait:true});
                },
                progress: function(Percentage) {
                    // NOTE: task is in progress!
                    // fO.msg.info.html(e);
                    fn.working({msg:lA.PercentLoaded.replace(/{Percent}/, fn.num(Percentage,q.bible))});
                },
                fail: function(e) {
                    // NOTE: only task fail
                    responseMsg.push('Fail');
                    fn.ResponseGood(false);
                },
                success: function(Obj) {
                    // NOTE: only task successfully completed!
                    responseMsg.push('Success');
                    if(Obj.fileCreation === true){
                        responseMsg.push('AndSaved');
                    } else {
                        responseMsg.push('NotSaved');
                    }
                    fn.file.read(Obj.fileContent);
                }
            });
        },
        read:function(fileEntry){
            responseMsg.push('Reading');
            if(!q.downloading || q.bible==q.reading){
                this.content(fileEntry);
            }else{
                responseMsg.push('Disabled');
                fn.ResponseGood(true);
            }
        },
        content:function(file){
            responseMsg.push(urlInfo.fileExtension.toUpperCase());
            fn.JobType(new DOMParser().parseFromString(file,urlInfo.fileContentType));
        }
    };
    this.JobType=function(j){
        // NOTE child
        var jobTypeFormat=$(j).children().get(0).tagName;
        responseMsg.push(jobTypeFormat);
        if($.isFunction(this.Job[jobTypeFormat])){
            fO[q.bible].bible={info:{},book:{}};
            this.Job[jobTypeFormat](j);
        }else{
            responseMsg.push('NotFound');
            this.ResponseGood(false);
            // this.ResponseGood({msg:lA.IsNotFoundIn.replace(/{is}/,jobTypeFormat).replace(/{in}/,'jobType'),status:false});
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
                                                            if(fileSystem.support){
                                                                // fO.isCordova, fO.isChrome
                                                                responseMsg.push('Success');
                                                                fn.ResponseGood(true);
                                                            }else if(window.indexedDB){
                                                                responseMsg.push('Stored');
                                                                db.add({table:q.bible,data:fO[q.bible].bible}).then(fn.ResponseGood(true));
                                                            }else{
                                                                responseMsg.push('NotStored');
                                                                fn.ResponseGood(true);
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
    this.ResponseGood=function(status){
        lO.local=status;
        var responseStatus = lO.local.toString().toUpperCase();
        responseMsg.push('LangVariableUpdatedAs',responseStatus);
        responseMsg.push('LangDB');
        if(q.reading){
            responseMsg.push('NotUpdatedDueToReadingIsTrue');
            fn.ResponseCallbacks(status);
        }else{
            db.update.lang().then(function(){
                responseMsg.push('UpdatedAs',responseStatus);
                fn.done(); fn.ResponseCallbacks(status);
            });
        }
        return this;
    };
    this.ResponseBad=function(status){
        // REVIEW: ?
        delete fO[q.bible].bible;
        responseMsg.push('Lang');
        if(status)lO.local=false;
        var responseStatus = lO.local.toString().toUpperCase();
        if(status){
            responseMsg.push('Removed');
            db.update.lang().then(function(){
                responseMsg.push('AndVariableUpdatedAs',responseStatus);
                fn.done(); fn.ResponseCallbacks(true);
            });
        } else {
            responseMsg.push('ButVariableUpdatedAs',responseStatus);
            fn.ResponseCallbacks(true);
        }
        return this;
    };
    this.ResponseCallbacks=function(status){
        this.msg=responseMsg.join(' ');
        callback({msg:this.msg,status:status});
    };
    return this;
};
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
