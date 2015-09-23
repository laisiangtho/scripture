if(!window.laisiangtho){ laisiangtho={};}
//content
function Content(q){
    var lO=fO.lang[q.bible], lA=lO.l, lB=lO.b, Oa=this, bO; //bO=fO[q.bible].bible, Oa, Ob
    this.Num=function(n){
        return fN.Num(n,q.bible);
    },
    this.XML=function(callback){
        var Ob=this;
        this.Url=fN.Url(config.id,[q.bible],config.file.bible);
        this.read=function(){
            if($.isEmptyObject(fO[q.bible].bible)){
                if(fO.isCordova){
                    fN.resolveFileSystem(Ob.Url.local,Ob.Local.reading, function(error){
                        Ob.dNG({msg:'to Local',status:false});
                    });
                }else{
                    fD.get({table:q.bible}).then(function(storeBible){
                        if(storeBible){
                            if($.isEmptyObject(storeBible)){
                                Ob.dNG({msg:'to Store',status:false});
                            }else{
                                if(q.reading==q.bible){
                                    fO[q.bible].bible=storeBible; Ob.dNG({msg:'from Store',status:true});
                                }else{
                                    Ob.dNG({msg:'to Store',status:true});
                                }
                            }
                        }else{
                            Ob.dNG({msg:'to Store',status:false});
                        }
                    });
                }
            }else{
                Ob.dNG({msg:'from Object',status:true});
            }
        };
        this.remove=function(){
            if(fO.isCordova){
                fN.resolveFileSystem(Ob.Url.local,Ob.Local.removing, function(error){
                    Ob.dND({status:true});
                });
            }else{
                fD.delete({table:q.bible}).then(function(){
                    Ob.dND({status:true});
                });
            }
        };
        this.get=function(){
            if($.isEmptyObject(fO[q.bible].bible)){
                if(fO.isCordova){
                    fN.Working({msg:lA.PleaseWait,wait:true}).promise().done(function(){
                        fN.resolveFileSystem(Ob.Url.local, Ob.Local.getting, Ob.Local.downloading);
                    });
                }else{
                    fD.get({table:q.bible}).then(function(storeBible){
                        if(storeBible){
                            fO[q.bible].bible=storeBible;
                            if($.isEmptyObject(fO[q.bible].bible)){
                                Ob.Load();
                            }else{
                                Ob.dNG({msg:'from Store',status:true});
                            }
                        }else{
                            Ob.Load();
                        }
                    });
                }
            }else{
                callback({msg:'from Object',status:true});
            }
        };
        this.Load=function(x){//load to Load
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
                url:(x)?x+Ob.Url.url:Ob.Url.url,dataType:Ob.Url.data,contentType:Ob.Url.content,cache:false,crossDomain:true,async:true
            }).done(function(j, status, d){
                Ob.jobType(j);
            }).fail(function(jqXHR, textStatus){
                if(api){
                    if(x){
                        Ob.dNG({msg:textStatus,status:false});
                    }else{
                        Ob.Load(api);
                    }
                }else{
                    Ob.dNG({msg:textStatus,status:false});
                }
            }).always(function(){});
        };
        this.Local={ //local to Local
            downloading:function(){
                fN.Working({msg:lA.Downloading});
                var fileTransfer = new FileTransfer();
                fileTransfer.onprogress=function(evt) {
                    if(evt.lengthComputable){
                        var Percentage = Math.floor(evt.loaded / evt.total * 100);
                        fN.Working({msg:lA.PercentLoaded.replace(/{Percent}/, Oa.Num(Percentage))});
                    }
                };
                fileTransfer.download(encodeURI(api+Ob.Url.url), Ob.Url.local, Ob.Local.content, function(error){
                    Ob.dNG({msg:error.code,status:false});
                });
            },
            content:function(fileEntry,error){
                fileEntry.file(function(file) {
                    //file.name, file.localURL, file.type, new Date(file.lastModifiedDate), file.size
                    var reader=new FileReader();
                    reader.onloadend=function(e){
                        var parser=new DOMParser();
                        Ob.jobType(parser.parseFromString(e.target.result,o.type));
                    };
                    reader.readAsText(file);
                },function(){
                    Ob.dNG({msg:'fail to read Local',status:false});
                });
            },
            reading:function(fileEntry){
                if(q.reading==q.bible){
                    Ob.Local.content(fileEntry);
                }else{
                    Ob.dNG({msg:'from Reading',status:true});
                }
            },
            removing:function(fileEntry){
                fileEntry.remove(function() {
                    Ob.dND({status:true});
                },function(error){
                    Ob.dND({status:false});
                });
            },
            getting:function(fileEntry){
                Ob.Local.content(fileEntry);
            }
        },
        this.jobType=function(j){
            var jobType=$(j).children().get(0).tagName;
            if($.isFunction(this.job[jobType])){
                fO[q.bible].bible={info:{},book:{}};
                this.job[jobType](j);
            }else{
                this.dNG({msg:lA.IsNotFoundIn.replace(/{is}/,jobType).replace(/{in}/,'jobType'),status:false});
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
                                                                    Ob.dNG({msg:'Localed',status:true});
                                                                }else{
                                                                    fD.put({table:q.bible,data:fO[q.bible].bible}).then(Ob.dNG({msg:'Stored',status:true}));
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
                                        MsgInfo.html(lB[i2]);
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
        this.dNG=function(response){
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
        this.dND=function(response){
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
        var Ob=this;
        this.result={book:0,chapter:0,verse:0,str:''};
        this.get=function(callback){
            return callback(Oa,this);
        };
        this.verseMerged=function(list,vID){
            return $(list).map(function(t,i){
                var v1=vID, v2=v1.split('-');
                if(v1==i){ return i;}else if(v2.length>1 && v2[0] <= i && v2[1] >= i){ return i;} 
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
        this.booklistID=function(){
            return Object.keys(this.booklist);
        };
        this.booklistName=function(o){
            return $.map(o, function(i) {
                return lB[i];
            });
        };
        this.queryRegex=function(){
            return this.booklist=fN.Regex(q).is(q.q);
        };
        this.queryBook=function(){
            if(Object.getOwnPropertyNames(fO.lookup.book).length > 0){
                this.booklist={}; 
                $.each(fO.lookup.book,function(bID,d){
                    Ob.booklist[bID]={};
                    if($.isEmptyObject(d)){
                        $.each(bible.info[bID].v,function(cID,f){
                            cID++;
                            Ob.booklist[bID][cID]=[];
                        });
                    }else{
                        Ob.booklist[bID]=d;
                    }
                });
                return this.booklist;
            }
        };
        this.queryChapter=function(){
            this.booklist={};
            this.booklist[q.book]={};
            this.booklist[q.book][q.chapter]=[];
            return this.booklist;
        };
        this.queryCheck=function(){
            if(q.booklist){
                this.booklist=q.booklist;
                delete q.booklist;
                return this.booklist;
            } else if(this.queryRegex()){
                return this.booklist;
            } else if(this.queryBook()){
                return this.booklist;
            } 
        };
        this.bible=function(dQ){
            var Def=new $.Deferred(), i=0, total=Object.keys(dQ).length;
            $.each(dQ,function(bID,data){
                setTimeout(function(){
                    var book=fO[q.bible].bible.book[bID];
                    if(book){
                        if(fO.todo.pause)return MsgInfo.text(lA.Paused).promise().done(function(){
                            delete fO.todo.pause;
                        });
                        Ob.chapter(book,bID,data,function(cID,vID,verse,list){
                            var df = new $.Deferred();
                            callback(Oa,Ob,bID,cID,vID,verse,list).progress(function(){df.notify();}).done(function(){df.resolve();});
                            return df.promise();
                        }).progress(function(){
                            Def.notify();
                        }).done(function(){
                            i++;
                            if(total==i)Def.resolve();
                        });
                    }else{
                        i++; Def.notify();
                        if(total==i)Def.resolve();
                    }
                },(200/total*i));
            });
            return Def.promise();
        };
        this.chapter=function(book,bID,list,callback){
            var Def=new $.Deferred(), i=0, total=Object.keys(list).length;
            $.each(list,function(cID,data){
                setTimeout(function(){
                    var chapter=book.chapter[cID];
                    if(chapter){
                        if(fO.todo.pause)return MsgInfo.html(lA.Paused).promise().done(function(){
                            delete fO.todo.pause;
                        });
                        Def.notify();
                        Ob.verse(chapter,bID,cID,data,function(vID,verse,list){
                            var df = new $.Deferred();
                            callback(cID,vID,verse,list).progress(function(){df.notify();}).done(function(){df.resolve();});
                            return df.promise();
                        }).progress(function(){
                            Def.notify();
                        }).done(function(){
                            i++;
                            if(total == i)Def.resolve();
                        });
                    }else{
                        i++; Def.notify();
                        if(total==i)Def.resolve();
                    }
                },100/total*i);
            });
            return Def.promise();
        };
        this.verse=function(chapter,bID,cID,list,callback){
            var Def=new $.Deferred(), i=0, total=Object.keys(chapter.verse).length;
            $.each(chapter.verse,function(vID,verse){
                setTimeout(function(){
                    i++; Def.notify();
                    callback(vID,verse,list).progress(function(){Def.notify();}).done(function(){if(total == i)Def.resolve();});
                },(50/total*i));
            });
            return Def.promise();
        };
        return this;
    };
    this.Option=function(container){
        var Ob=this;
        this.Parallel=function(callback){
            
        };
        this.Reference=function(d){
            var li=$(h.li,{class:'ref'}).appendTo(container), reference=fN.Regex(q).ref(d).result; 
            $.each(reference,function(bID,ref){
                $.each(ref,function(cID,vID){
                    $(h.a).html(lA.BFBCV.replace(/{b}/, lB[bID]).replace(/{c}/, Oa.Num(cID)).replace(/{v}/,Oa.Num(fN.Regex(q).nameVerse(vID)))).on(fO.Click,function(){
                        $.extend(q,{ref:d}); Oa.reference(li);
                    }).appendTo(li);
                });
            }); return li;
        };
        this.Note=function(){
            
        };
        return Ob;
    };
    this.desktop=function(){
        var Ob=this;
        return Ob;
    };
    this.tablet=function(){
        var Ob=this;
        return Ob;
    };
    this.mobile=function(){
        var Ob=this;
        return Ob;
    };
    this.chapter=function(container){
        var olb, olc, olv, ol;
        this.Bible(function(Oa,Ob,bID,cID,vID,verse,list){//o,obj,bID,cID,vID,verse,list
            var df = new $.Deferred();
            var vID=vID.slice(1);
            var bookName=lB[bID], chapterName=Oa.Num(cID), verseName=Oa.Num(vID);
            var msg=lA.BFBCV.replace(/{b}/, bookName).replace(/{c}/, chapterName).replace(/{v}/,verseName);
            //MsgInfo.html(msg).promise().done(function(){});
            Ob.result.verse++;
            if(Ob.result.b!==bID){
                Ob.result.b=bID; Ob.result.book++;
                olb=$(h.ol).appendTo($(h.li,{id:bID,class:'bID'}).append(
                    $(h.div).append(
                        $(h.h2).text(bookName)
                    )
                ).appendTo(ol));
            }
            if(Ob.result.b!==bID || Ob.result.c!==cID){
                Ob.result.c=cID; Ob.result.chapter++;
                olc=$(h.ol,{class:'verse'}).appendTo($(h.li,{id:cID,class:'cID'}).append(
                    $(h.div).append(
                        $(h.h3,{class:'no'}).text(chapterName).on(fO.Click,function(){
                            $(this).parents('li').children('ol').children().each(function(){
                                if($(this).attr("id"))$(this).toggleClass(config.css.active);
                            });
                        }),
                        //TODO
                        typeof Oa[fO.Deploy].MenuChapter === 'function' && Oa[fO.Deploy].MenuChapter(container)
                    )
                ).appendTo(olb));
            }
            if(verse.title){
                $(h.li,{class:'title'}).html(verse.title.join(', ')).appendTo(olc);
            }
            $(h.li,{id:vID,'data-verse':verseName}).html(Ob.replace(verse.text,q.q)).appendTo(olc).on(fO.Click,function(){
                $(this).toggleClass(config.css.active);
            }).promise().always(function(){
                if(verse.ref){
                    //TODO
                    Oa.Option(olc).Reference(verse.ref).promise().always(function(){
                        df.resolve();
                    });
                }else{
                    df.resolve();
                }
            });
            return df.promise();
        }).get(function(Oa,Ob){
            Ob.XML(function(response){
                if(response.status){
                    if(Ob.queryChapter()){
                        var current_booklistId=Ob.booklistID();
                        var current_booklist=current_booklistId.join();
                        var msg=lA.BFVBC.replace(/{b}/, lB[q.book]).replace(/{c}/, Oa.Num(q.chapter));
                        if(fO.previous.bible===q.bible && fO.previous.booklist===current_booklist && fO.previous.chapter===q.chapter){
                            //console.log('PREVIOUS TASK');
                            //Oa.msg(msg);
                        }else{
                            if(fO.todo.containerEmpty){
                                delete fO.todo.containerEmpty;
                            }else{
                                container.empty();
                            }
                            ol=$(h.ol,{class:q.bible}).appendTo(container);
                            Ob.bible(Ob.booklist).progress(function(){
                                //MsgLookup.html(Oa.Num(Ob.result.verse));
                            }).done(function(){
                                fO.previous.booklist=current_booklist;
                                fO.previous.bible=q.bible;
                                fO.previous.book=q.book;
                                fO.previous.chapter=q.chapter;
                                //fO.query.result=Ob.result.verse;
                                //Oa.msg(msg);
                                /*
                                MsgLookup.attr('title',q.q).text(Oa.Num(q.result)).promise().done(function(){
                                    if(!Ob.result.verse){
                                        ol.addClass(config.css.deactivate).append(
                                            $(h.li).html(lA.IsNotFound.replace(/{is}/, q.q))
                                        );
                                    }
                                });
                                */
                                if(!Ob.result.verse){
                                    ol.addClass(config.css.deactivate).append(
                                        $(h.li).html(lA.IsNotFound.replace(/{is}/, q.q))
                                    );
                                }
                                container.promise().done(function(){
                                    var aP=this.children().length, oldClass=fN.Attr(this).class()[2];
                                    $(this).removeClass(oldClass);
                                    $(this).addClass(oldClass.charAt(0)+aP);
                                });
                            }).always(function(){
                                //TODO laisiangtho to z
                                laisiangtho.isAnalytics(function(o){
                                    o.sendEvent({bible:q.bible,key:q.book,result:q.chapter});
                                });
                            });	
                        }
                    }
                }
            }).get();
        });
    };
    this.lookup=function(container){
        var Ob=this;
        return Ob;
    };
    this.note=function(container,data){
        var Ob=this;
        return Ob;
    };
    this.reference=function(container){
        var olb, olc, olv, ol;
        this.Bible(function(Oa,Ob,bID,cID,vID,verse,list){
            var df = new $.Deferred();
            var vID=vID.slice(1);
            var bookName=lB[bID], chapterName=Oa.Num(cID), verseName=Oa.Num(vID);
            var tmpid=(list.length)?Ob.verseMerged(list,vID):[vID];
            if(tmpid.length){
                Ob.result.verse++;
                if(Ob.result.b!==bID){
                    Ob.result.b=bID; Ob.result.book++;
                    olb=$(h.ol).appendTo($(h.li,{id:bID,class:'bID'}).append(
                        $(h.div).append(
                            $(h.h3).text(bookName)
                        )
                    ).appendTo(ol));
                }
                if(Ob.result.b!==bID || Ob.result.c!==cID){
                    Ob.result.c=cID; Ob.result.chapter++;
                    olc=$(h.ol,{class:'verse'}).appendTo($(h.li,{id:cID,class:'cID'}).append(
                        $(h.div).append(
                            $(h.h4,{class:'no'}).text(chapterName)
                        )
                    ).appendTo(olb));
                }
                if(verse.title){
                    $(h.li,{class:'title'}).html(verse.title.join(', ')).appendTo(olc);
                }
                $(h.li,{id:vID,'data-verse':verseName}).html(Ob.replace(verse.text,q.q)).appendTo(olc).promise().always(function(){
                    df.resolve();
                });
            }else{
                df.resolve();
            }
            return df.promise();
        }).get(function(Oa,Ob){
            Oa.XML(function(response){
                if(response.status){
                    var reference=fN.Regex(q).is(q.ref);
                    if(reference){
                        ol=$(h.ol,{class:q.bible}).appendTo(container.empty());
                        Ob.bible(reference).progress(function(){
                            MsgLookup.html(Oa.Num(Ob.result.verse));
                        }).done(function(){
                            container.addClass(config.css.active);
                        }).always(function(){
                            delete q.ref;
                        });
                    }else{
                        delete q.ref;
                    }
                }
            }).get();
        });
    };
    this._t1=function(){
        var Ob=this;
        return Ob;
    };
    this._t2=function(){
        var olb, olc, olv, ol;
        //var lO=fO.lang[q.bible], lA=lO.l, lB=lO.b, Oa=this, bO; //bO=fO[q.bible].bible, Oa, Ob
    };
}
//laisiangtho.createProperty('content',function(q){});