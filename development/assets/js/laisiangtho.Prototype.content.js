Core.prototype.Content=function(q){
    var Oa=this, lO=fO.lang[q.bible], lA=lO.l, lB=lO.b; //bO=fO[q.bible].bible
    this.Num=function(n){
        return fN.Num(n,q.bible);
    },
    this.XML=function(callback){
        this.URL=fN.Url(config.id,[q.bible],config.file.bible);
        this.read=function(){
            if($.isEmptyObject(fO[q.bible].bible)){
                if(fO.isCordova){
                    fN.resolveFileSystem(Oa.URL.local,Oa.XLO.reading, function(error){
                        Oa.XdG({msg:'to Local',status:false});
                    });
                }else{
                    fD.get({table:q.bible}).then(function(storeBible){
                        if(storeBible){
                            if($.isEmptyObject(storeBible)){
                                Oa.XdG({msg:'to Store',status:false});
                            }else{
                                if(q.reading==q.bible){
                                    fO[q.bible].bible=storeBible; Oa.XdG({msg:'from Store',status:true});
                                }else{
                                    Oa.XdG({msg:'to Store',status:true});
                                }
                            }
                        }else{
                            Oa.XdG({msg:'to Store',status:false});
                        }
                    });
                }
            }else{
                Oa.XdG({msg:'from Object',status:true});
            }
        };
        this.remove=function(){
            if(fO.isCordova){
                fN.resolveFileSystem(Oa.URL.local,Oa.XLO.removing, function(error){
                    Oa.XdD({status:true});
                });
            }else{
                fD.delete({table:q.bible}).then(function(){
                    Oa.XdD({status:true});
                });
            }
        };
        this.get=function(){
            if($.isEmptyObject(fO[q.bible].bible)){
                if(fO.isCordova){
                    fN.Working({msg:lA.PleaseWait,wait:true}).promise().done(function(){
                        fN.resolveFileSystem(Oa.URL.local, Oa.XLO.getting, Oa.XLO.downloading);
                    });
                }else{
                    fD.get({table:q.bible}).then(function(storeBible){
                        if(storeBible){
                            fO[q.bible].bible=storeBible;
                            if($.isEmptyObject(fO[q.bible].bible)){
                                Oa.XLA();
                            }else{
                                Oa.XdG({msg:'from Store',status:true});
                            }
                        }else{
                            Oa.XLA();
                        }
                    });
                }
            }else{
                callback({msg:'from Object',status:true});
            }
        };
        this.XLA=function(x){
            $.ajax({
                //headers:{}, xhrFields:{"withCredentials": true},
                beforeSend:function(xhr){
                    fN.Working({msg:lA.Downloading,wait:true});
                    xhr.setRequestHeader("Access-Control-Allow-Origin", "*");
                },
                xhr:function(){
                    var xhr=new window.XMLHttpRequest();
                    xhr.addEventListener("progress", function(evt){
                        if(evt.lengthComputable) {
                            var Percentage=Math.floor(evt.loaded / evt.total * 100);
                            fN.Working({msg:lA.PercentLoaded.replace(/{Percent}/, Oa.Num(Percentage))});
                        }
                    }, false);
                    /*
                    XMLHttpRequest.upload.addEventListener("progress", function(evt){
                        if(evt.lengthComputable){
                            var Percent=Math.floor(evt.loaded / evt.total * 100);
                            fN.Working({
                                msg:lA.PercentLoaded.replace(/{Percent}/, Oa.Num(Percentage)),
                                class:true
                            });
                        }
                    }, false);
                    */
                    return xhr;
                },
                url:(x)?x+Oa.URL.url:Oa.URL.url,dataType:Oa.URL.data,contentType:Oa.URL.content,cache:true,crossDomain:true,async:true
            }).done(function(j, status, d){
                Oa.jobType(j);
            }).fail(function(jqXHR, textStatus){
                if(api){
                    if(x){
                        Oa.XdG({msg:textStatus,status:false});
                    }else{
                        Oa.XLA(api);
                    }
                }else{
                    Oa.XdG({msg:textStatus,status:false});
                }
            }).always(function(){});
        };
        this.XLO={ //local to Local
            downloading:function(){
                fN.Working({msg:lA.Downloading});
                var fileTransfer = new FileTransfer();
                fileTransfer.onprogress=function(evt) {
                    if(evt.lengthComputable){
                        var Percentage = Math.floor(evt.loaded / evt.total * 100);
                        fN.Working({msg:lA.PercentLoaded.replace(/{Percent}/, Oa.Num(Percentage))});
                    }
                };
                fileTransfer.download(encodeURI(api+Oa.URL.url), Oa.URL.local, Oa.XLO.content, function(error){
                    Oa.XdG({msg:error.code,status:false});
                });
            },
            content:function(fileEntry,error){
                fileEntry.file(function(file) {
                    //file.name, file.localURL, file.type, new Date(file.lastModifiedDate), file.size
                    var reader=new FileReader();
                    reader.onloadend=function(e){
                        var parser=new DOMParser();
                        Oa.jobType(parser.parseFromString(e.target.result,Oa.URL.type));
                    };
                    reader.readAsText(file);
                },function(){
                    Oa.XdG({msg:'fail to read Local',status:false});
                });
            },
            reading:function(fileEntry){
                if(q.reading==q.bible){
                    Oa.XLO.content(fileEntry);
                }else{
                    Oa.XdG({msg:'from Reading',status:true});
                }
            },
            removing:function(fileEntry){
                fileEntry.remove(function() {
                    Oa.XdD({status:true});
                },function(error){
                    Oa.XdD({status:false});
                });
            },
            getting:function(fileEntry){
                Oa.XLO.content(fileEntry);
            }
        },
        this.jobType=function(j){
            var jobType=$(j).children().get(0).tagName;
            if($.isFunction(this.job[jobType])){
                fO[q.bible].bible={info:{},book:{}};
                this.job[jobType](j);
            }else{
                this.XdG({msg:lA.IsNotFoundIn.replace(/{is}/,jobType).replace(/{in}/,'jobType'),status:false});
            }
        };
        this.job={
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
                                                                    Oa.XdG({msg:'Localed',status:true});
                                                                }else{
                                                                    fD.put({table:q.bible,data:fO[q.bible].bible}).then(Oa.XdG({msg:'Stored',status:true}));
                                                                }
                                                            }
                                                        }
                                                    }
                                                });
                                            },30/b*c);
                                            //chapter
                                        }else if(i3){
                                            //info
                                            fO[q.bible].bible[t2][i2][t3][i3]=j3.text();
                                        }else{
                                            //content
                                            contentIndex++;
                                            //fO[q.bible].bible[t2][i2][t3][contentIndex]={ref:j3.attr('ref').split(','), title:j3.text()};
                                            fO[q.bible].bible[t2][i2][t3][contentIndex]={title:j3.text()};
                                            if(j3.attr('ref'))fO[q.bible].bible[t2][i2][t3][contentIndex].ref=j3.attr('ref').split(',');
                                        }
                                    }).promise().done(function(){
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
        this.XdG=function(response){
            //fO.lang[q.bible].local=response.status;
            lO.local=response.status;
            if(q.reading){
                callback(response);
            }else{
                fD.UpdateLang().then(function(){
                    callback(response); fN.Done();
                });
            }
        };
        this.XdD=function(response){
            /*
            delete fO[q.bible].bible;
            if(response.status)fO.lang[q.bible].local=false;
            */
            delete fO[q.bible].bible;
            if(response.status)lO.local=false;
            fD.UpdateLang().then(function(){
                callback(response);
            });
        };
        return this;
    };
    this.Bible=function(callback){
        this.result={book:0,chapter:0,verse:0,str:''};
        this.get=function(callback){
            return callback(this);
        };
        this.verseMerged=function(list,vID){
            return $(list).map(function(t,i){
                var v1=vID, v2=v1.split('-');
                if(v1==i){return i;}else if(v2.length>1 && v2[0] <= i && v2[1] >= i){return i;}
            }).get();
        };
        this.search=function(s,n){
            //TODO
            if($.type(n) === "string"){
                if(s.search(new RegExp(n, "gi")) > -1)return true;
            }else{
                return true;
            }
        };
        this.replace=function(s,n){
            //TODO s.replace(/(([^\s]+\s\s*){20})(.*)/,"$1…")
            if($.type(n) === "string"){
                return s.replace(new RegExp(n, "i"), '<b>$&</b>');
            }else{
                return s;
            }
        };
        this.Query={
            booklist:{},
            book:function(){
                var o=this.booklist={};
                if(Object.getOwnPropertyNames(fO.lookup.book).length > 0){
                    $.each(fO.lookup.book,function(bID,d){
                        o[bID]={};
                        if($.isEmptyObject(d)){
                            $.each(bible.info[bID].v,function(cID,f){
                                cID++;
                                o[bID][cID]=[];
                            });
                        }else{
                            o[bID]=d;
                        }
                    });
                    return o;
                }
            },
            regex:function(){
                return this.booklist=fN.Regex(q).is(q.q);
            },
            prev:function(){
                if(q.booklist){
                    this.booklist=q.booklist;
                    //delete q.booklist;
                    return this.booklist;
                }
            },
            list:function(){
                this.resultId=Object.keys(this.booklist);
                return this.result=this.resultId.join();
            },
            listName:function(o){
                return $.map(o, function(i) {
                    return lB[i];
                });
            },
            chapter:function(){
                this.booklist[q.book]={};
                this.booklist[q.book][q.chapter]=[];
                this.is=function(){
                    return fO.previous.booklist!==this.list() || fO.previous.bible!==q.bible || fO.previous.chapter!==q.chapter;
                };
                return this.booklist;
            },
            lookup:function(){
                this.is=function(){
                    var i=fO.previous.booklist!==this.list() || fO.previous.q!==q.q;
                    if(i){
                        //fN.Working({msg:lA.PleaseWait,wait:true});
                    }
                    return i;
                };
                return this.prev() || this.regex() || this.book();
            },
            reference:function(){
                return this.result=fN.Regex(q).is(q.ref);
            }
        };
        this.Bok=function(dQ){
            var Def=new $.Deferred(), Obj={
                task:{
                  bible:Object.keys(dQ),
                  chapter:[],
                  verse:[]
                },
                bID:function(){
                    Oa.BID=this.task.bible.shift();
                    Oa.BNA=lB[Oa.BID];
                    this.task.chapter=Object.keys(dQ[Oa.BID]);
                },
                cID:function(){
                    Oa.CID=this.task.chapter.shift();
                    Oa.CNA=Oa.Num(Oa.CID);
                    Oa.LIST=dQ[Oa.BID][Oa.CID];
                    this.task.verse=Object.keys(Oa.LIST);
                    //console.log(Oa.LIST);
                },
                vID:function(){
                    Oa.VID=this.task.verse.shift();
                },
                start:function(){
                    this.bID();
                    this.next();
                },
                next:function(){
                    var d=new $.Deferred();
                    this.cID();
                    this.final().progress(function(){
                        d.notify();
                    }).fail(function(){
                        console.log(lA.Paused);
                        d.notify();
                    }).done(function(){
                        if(Obj.task.chapter.length){
                            Obj.next();d.notify();
                        }else if(Obj.task.bible.length){
                            Obj.start();d.notify();
                        }else{
                            d.resolve();Def.resolve();
                        }
                    });
                    return d.promise();
                },
                final:function(){
                    var b=fO[q.bible].bible.book[Oa.BID],c=b.chapter[Oa.CID],v=c.verse;
                    var d=new $.Deferred(),i=0, total=Object.keys(v).length;
                    $.each(v,function(vID,verse){
                        var db=setTimeout(function(){
                            i++;
                            if(fO.todo.pause)fO.msg.info.text(lA.Paused).promise().done(function(){
                                delete fO.todo.pause;
                                d.reject();
                            });
                            Oa.VID=vID.slice(1);Oa.VNA=Oa.Num(Oa.VID);Oa.VERSE=verse;
                            callback(Oa).progress(function(){
                                d.notify();Def.notify();
                            }).done(function(){
                                if(total == i){
                                    d.resolve();
                                }
                            });
                        },25);
                    });
                    return d.promise();
                }
            };
            Def.notify();
            Obj.start();
            return Def.promise();
        };
        return this;
    };
    this.Option=function(container){
        this.Parallel=function(callback){
        };
        this.Reference=function(d){
        };
        this.Note=function(){
        };
        return this;
    };
    this.desktop={
            menuChapter:function(container){
            },
            menuLookup:function(container){
            },
            menuNote:function(container){
            }
    };
    this.tablet={
    };
    this.mobile={
    };
    this.chapter=function(container){
    };
    this.lookup=function(container){
    };
    this.note=function(container,data){
    };
    this.reference=function(container){
    };
}
