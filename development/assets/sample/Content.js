function Content(q){
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
            return $(h.span,{class:'icon-language'}).on(fO.Click,function(event){
                var e=$(event.target), li=e.parent(), ul=li.children().eq(1), y=li.attr('class');
                if(ul.length){
                    ul.fadeOut(200).remove();
                }else{
                    ul=$(h.ul,{class:'parallel'}).appendTo(li);
                    fN.Menu(ul).Bible(function(Om){
                        var ic=fN.is(Om.bID).class;
                        return $(h.li,{class:(y===Om.bID)?config.css.active:(container.children(ic).length)?'has':Om.bID}).html(Om.lang.name).on(fO.Click,function(){
                            callback($(this),Om.lang.name,ic,Om.bID);
                        });
                    });
                    fN.Click(function(evt){
                        if(!$(evt.target).closest(li).length)ul.remove();
                    });
                }
            });
        };
        this.Reference=function(d){
            //Oj.Option(olc).Reference(Oj.VERSE.ref)
            var li=$(h.li,{class:'ref'}).appendTo(container), reference=fN.Regex(q).ref(d).result; 
            $.each(reference,function(bID,ref){
                $.each(ref,function(cID,vID){
                    if(vID.length)$(h.a).html(lA.BFBCV.replace(/{b}/, lB[bID]).replace(/{c}/, Oa.Num(cID)).replace(/{v}/,Oa.Num(fN.Regex(q).nameVerse(vID)))).on(fO.Click,function(){
                        $.extend(q,{ref:d}); Oa.reference(li);
                    }).appendTo(li);
                });
            }); return li;
        };
        this.Note=function(){
            return $(h.span,{class:'icon-pin active'}).on(fO.Click,function(event){
                var x=$(event.target), li=x.parent(), ul=li.children().eq(1);
                if(ul.length){
                    ul.fadeOut(200).remove();
                }else{
                    var row=x.parents(fN.is('cID').class), bID=fN.Attr(row.parents(fN.is('bID').class)).id()[0], cID=fN.Attr(row).id()[0];
                    ul=$(h.ul,{class:'note'}).appendTo(li);
                    if(fO.note){
                        function notefn(){
                            $.each(fO.note,function(id,note){
                                if(note.name){
                                    $(h.li,{id:id}).append(
                                        $(h.p,{class:'add icon-right'}).on(fO.Click,function(){
                                            var vIDs=[], liRow=$(this);
                                            row.children('ol').children().each(function(){
                                                if($(this).attr("id") && $(this).hasClass(config.css.active)){
                                                    vIDs.push($(this).attr("id"));
                                                }
                                            }).promise().done(function(){
                                                if(vIDs.length){
                                                    if($.isEmptyObject(note.data))note.data={};
                                                    if($.isEmptyObject(note.data[bID]))note.data[bID]={};
                                                    note.data[bID][cID]=vIDs;	
                                                }else if(note.data){
                                                    if(note.data[bID] && note.data[bID][cID]) delete note.data[bID][cID];
                                                    if($.isEmptyObject(note.data[bID])) delete note.data[bID];
                                                    if($.isEmptyObject(note.data)) delete note.data;
                                                }
                                                fD.UpdateNote().then(function(){
                                                    ul.empty(); notefn();
                                                });
                                            });
                                        }),
                                        $(h.p,{class:'name'}).html(note.name).on(fO.Click,function(){
                                            row.children('ol').children().each(function(i,e){
                                                var ids=$(this).attr("id");
                                                if(ids){
                                                    if(note.data && note.data[bID] && $.inArray(ids, note.data[bID][cID]) >= 0){
                                                        $(this).addClass(config.css.active);
                                                    }else{
                                                        $(this).removeClass(config.css.active);
                                                    }
                                                }
                                            });
                                        })
                                    ).appendTo(ul).promise().done(function(){
                                        if(note.data){
                                            if(note.data[bID]){
                                                if(note.data[bID][cID]){
                                                    this.addClass(config.css.active);
                                                }else{
                                                    delete note.data[bID];
                                                }
                                            }
                                        }
                                    });
                                }
                            });
                        }
                        notefn();
                    }else{
                        $(h.li).append(
                            $(h.p,{class:'indexedb'}).html('Your browser does not support Indexedb!')
                        ).appendTo(ul);
                    }
                    fN.Click(function(evt){
                        if(!$(evt.target).closest(li).length)ul.remove();
                    });
                }
            });
        };
        return this;
    };
    this.desktop={
            menuChapter:function(container){
                return $(h.ul).append(
                    $(h.li).addClass(fO.query.bible).append(
                        Oa.Option(container).Parallel(function(li,i,ic,bID){
                            var newChapter=container.children(ic), aP=container.children().length;
                            if(newChapter.length){
                                if(aP > 1){
                                    var oldClass=fN.Attr(container).class()[2];
                                    container.removeClass(oldClass).addClass(oldClass.charAt(0)+(aP-1));
                                    newChapter.remove();
                                    li.removeClass('has');
                                    if(fO.previous.bible===i)fO.previous.bible=container.children().eq(0).attr('class');
                                }
                            }else{
                                fO.todo.containerEmpty=true; li.addClass('has'); new Content($.extend({},q,{bible:bID})).chapter(container);
                            }
                        })
                    ),
                    $(h.li).append(Oa.Option(container).Note())
                );
            },
            menuLookup:function(container){
                return $(h.ul).append(
                    $(h.li).append(Oa.Option(container).Note())
                );
            },
            menuNote:function(container){
                return $(h.ul).append(
                    $(h.li).append(Oa.Option(container).Note())
                );
            }
    };
    this.tablet={
    };
    this.mobile={
    };
    this.chapter=function(container){
        var olb, olc, olv, ol;
        //if used in other function lA, lB required to modify as lA=fO.lang[q.bible].l, lB=fO.lang[q.bible].b
        this.Bible(function(Oj){
            var df=new $.Deferred();
            var msg=lA.BFBCV.replace(/{b}/, Oj.BNA).replace(/{c}/, Oj.CNA).replace(/{v}/,Oj.VNA);
            //fO.msg.info.html(msg).promise().done(function(){});
            Oj.result.verse++;
            if(Oj.result.b!==Oj.BID){
                Oj.result.b=Oj.BID; Oj.result.book++;
                olb=$(h.ol).appendTo($(h.li,{id:Oj.BID,class:'bID'}).append(
                    $(h.div).append(
                        $(h.h2).text(Oj.BNA)
                    )
                ).appendTo(ol));
            }
            if(Oj.result.b!==Oj.BID || Oj.result.c!==Oj.CID){
                Oj.result.c=Oj.CID; Oj.result.chapter++;
                olc=$(h.ol,{class:'verse'}).appendTo($(h.li,{id:Oj.CID,class:'cID'}).append(
                    $(h.div).append(
                        $(h.h3,{class:'no'}).text(Oj.CNA).on(fO.Click,function(){
                            $(this).parents('li').children('ol').children().each(function(){
                                if($(this).attr("id"))$(this).toggleClass(config.css.active);
                            });
                        }),
                        //TODO
                        typeof Oj[fO.Deploy].menuChapter === 'function' && Oj[fO.Deploy].menuChapter(container)
                    )
                ).appendTo(olb));
            }
            if(Oj.VERSE.title){
                $(h.li,{class:'title'}).html(Oj.VERSE.title.join(', ')).appendTo(olc);
            }
            $(h.li,{id:Oj.VID,'data-verse':Oj.VNA}).html(Oj.replace(Oj.VERSE.text,q.q)).appendTo(olc).on(fO.Click,function(){
                $(this).toggleClass(config.css.active);
            }).promise().always(function(){
                if(Oj.VERSE.ref){
                    Oj.Option(olc).Reference(Oj.VERSE.ref).promise().always(function(){
                        df.resolve();
                    });
                }else{
                    df.resolve();
                }
            });
            return df.promise();
        }).get(function(Oj){
            Oj.XML(function(response){
                if(response.status){
                    if(Oj.Query.chapter()){
                        //var msg=lA.BFVBC.replace(/{b}/, lB[q.book]).replace(/{c}/, Oj.Num(q.chapter));
                        if(Oj.Query.is()){
                            if(fO.todo.containerEmpty){
                                delete fO.todo.containerEmpty;
                            }else{
                                container.empty();
                            }
                            ol=$(h.ol,{class:q.bible}).appendTo(container);
                            Oj.Bok(Oj.Query.booklist).progress(function(){
                                //fO.msg.lookup.html(Oj.Num(Oj.result.verse));
                            }).done(function(){
                                fO.previous.booklist=Oj.Query.result;
                                fO.previous.bible=q.bible;
                                fO.previous.book=q.book;
                                fO.previous.chapter=q.chapter;
                                q.result=Oj.result.verse;
                                //Oj.msg(msg);
                                /*
                                fO.msg.lookup.attr('title',q.q).text(Oj.Num(q.result)).promise().done(function(){
                                    if(!Oj.result.verse){
                                        ol.addClass(config.css.deactivate).append(
                                            $(h.li).html(lA.IsNotFound.replace(/{is}/, q.q))
                                        );
                                    }
                                });
                                */
                                if(!Oj.result.verse){
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
                        }else{
                            console.log('PREVIOUS TASK');
                            //Oj.msg(msg);
                        }
                    }
                }
            }).get();
        });
    };
    this.lookup=function(container){
        var olb, olc, olv, ol;
        var nQ=(fN.Regex(q).is(q.q))?'':q.q;
        this.Bible(function(Oj){
            var df=new $.Deferred(), msg=lA.BFBCV.replace(/{b}/, Oj.BNA).replace(/{c}/, Oj.CNA).replace(/{v}/,Oj.VNA);
            fO.msg.title.html(msg);
            //fO.msg.title.html(msg).promise().done(function(){
                var tmpid=(Oj.LIST.length)?Oj.verseMerged(Oj.LIST,Oj.VID):[Oj.VID];
                if(tmpid.length && Oj.search(Oj.VERSE.text,nQ)){
                    Oj.result.verse++;
                    if(Oj.result.b!==Oj.BID){
                        Oj.result.b=Oj.BID; Oj.result.book++;
                        olb=$(h.ol).appendTo($(h.li,{id:Oj.BID,class:'bID'}).append(
                            $(h.div).append(
                                $(h.h2).text(Oj.BNA)
                            )
                        ).appendTo(ol));
                    }
                    if(Oj.result.b!==Oj.BID || Oj.result.c!==Oj.CID){
                        Oj.result.c=Oj.CID; Oj.result.chapter++;
                        olc=$(h.ol,{class:'verse'}).appendTo($(h.li,{id:Oj.CID,class:'cID'}).append(
                            $(h.div).append(
                                $(h.h3).append(
                                    $(h.a,{href:fN.Page(2)+$.param({book:Oj.BID,chapter:Oj.CID})}).text(Oj.CNA)
                                ),
                                typeof Oj[fO.Deploy].menuLookup === 'function' && Oj[fO.Deploy].menuLookup(container)
                            )
                        ).appendTo(olb));
                    }
                    $(h.li,{id:Oj.VID,'data-verse':Oj.VNA}).html(Oj.replace(Oj.VERSE.text,q.q)).appendTo(olc).on(fO.Click,function(){
                        $(this).toggleClass(config.css.active);
                    }).promise().done(function(){
                        if(Oj.VERSE.ref){
                            Oj.Option(olc).Reference(Oj.VERSE.ref).promise().always(function(){
                                df.resolve();
                            });
                        }else{
                            df.resolve();
                        }
                    });
                }else{
                    df.resolve();
                    //console.log('sss');
                }
            //});
            return df.promise();
        }).get(function(Oj){
            Oj.XML(function(response){
                if(response.status){
                    if(Oj.Query.lookup()){
                        if(Oj.Query.is()){
                            ol=$(h.ol,{class:q.bible}).appendTo(container.empty());
                            Oj.Bok(Oj.Query.booklist).progress(function(){
                                //fO.msg.lookup.html(Oj.Num(Oj.result.verse));
                                //fO.msg.info.html(Oj.Num(Oj.result.verse));
                                //console.log(Oj.result.verse);
                                //fO.msg.title.html(Oj.result.verse);
                                //$('.laisiangtho').html(Oj.result.verse);
                                //console.log('final progress');
                            }).done(function(){
                                //fO.previous.booklist=Oj.Query.result;
                                //fO.previous.q=q.q;
                                //fO.msg.title.html(lA.FoundBCV.replace(/{b}/, Oj.Num(Oj.result.book)).replace(/{c}/, Oj.Num(Oj.result.chapter)).replace(/{v}/,Oj.Num(Oj.result.verse)));
                                q.result=Oj.result.verse;
                                fO.msg.lookup.attr('title',q.q).text(Oj.Num(q.result)).promise().done(function(){
                                    if(!Oj.result.verse){
                                        var booklistName=fN.Array(Oj.Query.listName(Oj.Query.resultId)).to().sentence();
                                        ol.addClass(config.css.deactivate).append(
                                            $(h.li).html(lA.IsNotFoundIn.replace(/{is}/, q.q).replace(/{in}/, booklistName))
                                        );
                                    }
                                });
                                /*
                                container.promise().done(function(){
                                    var aP=this.children().length, oldClass=fN.Attr(this).class()[2];
                                    $(this).removeClass(oldClass);
                                    $(this).addClass(oldClass.charAt(0)+aP);
                                });
                                */
                               //console.log('final done');
                            }).always(function(){
                                //TODO laisiangtho to z
                                laisiangtho.isAnalytics(function(o){
                                    o.sendEvent({bible:q.bible,key:q.q,result:Oj.result.verse});
                                });
                                fN.Done();
                                //console.log('final always');
                            });
                        }else{
                           console.log('PREVIOUS TASK');
                        }
                    }else if($.isEmptyObject(fO.lookup.book)){
                        fO.previous.q=q.q; fO.previous.booklist=false;
                        ol=$(h.ol,{class:q.bible}).appendTo(container.empty());
                        ol.addClass(config.css.deactivate).append(
                            $(h.li).html(lA.NoBookSelected),
                            $(h.li,{class:'showme'}).html(lA.ShowMe).on(fO.Click,function(){
                                $('.lookup.setting').trigger(fO.Click);
                            })
                        );
                    }
                }
            }).get();
        });
    };
    this.note=function(container,data){
        var olb, olc, olv, ol;
        this.Bible(function(Oj){
            var df = new $.Deferred();
            fO.msg.info.html(lA.BFBCV.replace(/{b}/, Oj.BNA).replace(/{c}/, Oj.CNA).replace(/{v}/,Oj.VNA)).promise().done(function(){
                var tmpid=(Oj.LIST.length)?Oj.verseMerged(Oj.LIST,Oj.VID):[Oj.VID];
                if(tmpid.length){
                    Oj.result.verse++;
                    if(Oj.result.b!==Oj.BID){
                        Oj.result.b=Oj.BID; Oj.result.book++;
                        olb=$(h.ol).appendTo($(h.li,{id:Oj.BID,class:'bID'}).append(
                            $(h.div).append(
                                $(h.h3).text(Oj.BNA)
                            )
                        ).appendTo(ol));
                    }
                    if(Oj.result.b!==Oj.BID || Oj.result.c!==Oj.CID){
                        Oj.result.c=Oj.CID; Oj.result.chapter++;
                        olc=$(h.ol,{class:'verse'}).appendTo($(h.li,{id:Oj.CID,class:'cID'}).append(
                            $(h.div).append(
                                $(h.h4,{class:'no'}).text(Oj.CNA).on(fO.Click,function(){
                                    $(this).parent().parent().children('ol').children().each(function(){
                                        if($(this).attr("id"))$(this).toggleClass(config.css.active);
                                    });
                                }),
                                typeof Oj[fO.Deploy].menuNote === 'function' && Oj[fO.Deploy].menuNote(container)
                            )
                        ).appendTo(olb));
                    }
                    if(Oj.VERSE.title){
                        $(h.li,{class:'title'}).html(Oj.VERSE.title.join(', ')).appendTo(olc);
                    }
                    $(h.li,{id:Oj.VID,'data-verse':Oj.VNA}).html(Oj.replace(Oj.VERSE.text,q.q)).appendTo(olc).on(fO.Click,function(){
                        $(this).toggleClass(config.css.active);
                    }).promise().always(function(){
                        if(Oj.VERSE.ref){
                            Oj.Option(olc).Reference(Oj.VERSE.ref).promise().always(function(){
                                df.resolve();
                            });
                        }else{
                            df.resolve();
                        }
                    });
                }
            });
            return df.promise();
        }).get(function(Oj){
            Oj.XML(function(response){
                if(response.status){
                    ol=$(h.ol,{class:q.bible}).appendTo(container);
                    if(data){
                        Oj.Bok(data).progress(function(){
                            fO.msg.lookup.text(Oj.Num(Oj.result.verse));
                        }).done(function(){
                            container.addClass(config.css.active);
                        }).always(function(){
                        });
                    }
                }
            }).get();
        });
    };
    this.reference=function(container){
        var olb, olc, olv, ol;
        this.Bible(function(Oj){
            var df = new $.Deferred();
            var tmpid=(Oj.LIST.length)?Oj.verseMerged(Oj.LIST,Oj.VID):[Oj.VID];
            if(tmpid.length){
                Oj.result.verse++;
                if(Oj.result.b!==Oj.BID){
                    Oj.result.b=Oj.BID; Oj.result.book++;
                    olb=$(h.ol).appendTo($(h.li,{id:Oj.BID,class:'bID'}).append(
                        $(h.div).append(
                            $(h.h3).text(Oj.BNA)
                        )
                    ).appendTo(ol));
                }
                if(Oj.result.b!==Oj.BID || Oj.result.c!==Oj.CID){
                    Oj.result.c=Oj.CID; Oj.result.chapter++;
                    olc=$(h.ol,{class:'verse'}).appendTo($(h.li,{id:Oj.CID,class:'cID'}).append(
                        $(h.div).append(
                            $(h.h4,{class:'no'}).text(Oj.CNA)
                        )
                    ).appendTo(olb));
                }
                if(Oj.VERSE.title){
                    $(h.li,{class:'title'}).html(Oj.VERSE.title.join(', ')).appendTo(olc);
                }
                $(h.li,{id:Oj.VID,'data-verse':Oj.VNA}).html(Oj.replace(Oj.VERSE.text,q.q)).appendTo(olc).promise().always(function(){
                    df.resolve();
                });
            }else{
                df.resolve();
            }
            return df.promise();
        }).get(function(Oj){
            Oj.XML(function(response){
                if(response.status){
                    if(Oj.Query.reference()){
                        ol=$(h.ol,{class:q.bible}).appendTo(container.empty());
                        Oj.Bok(Oj.Query.result).progress(function(){
                            fO.msg.lookup.html(Oj.Num(Oj.result.verse));
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
}
//laisiangtho.createProperty('content',function(q){});