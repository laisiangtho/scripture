Core.prototype.content=function(q,callbackContent){
    var Oa = this, lO=fO.lang[q.bible], lA=lO.l, lB=lO.b; //bO=fO[q.bible].bible
    this.Num=function(n){
        return f().num(n,q.bible);
    };
    function HolyBible(callbackBible) {
        var Ob=this;//Ob
        /*
        fO.previous.booklist=Ob.query.current;
        fO.previous.bible=q.bible;
        fO.previous.book=q.book;
        fO.previous.chapter=q.chapter;
        fO.previous.q=q.q;
        q.result=Ob.Result.Verse;

        fO.previous.booklist=Ob.query.booklist;
        fO.previous.bible=q.bible;
        fO.previous.book=q.book;
        fO.previous.chapter=q.chapter;
        fO.previous.q=q.q;
        q.result=Ob.Result.Verse;
        */
        // this.Result={Book:0,Chapter:0,Verse:0,str:''};
        // this.booklist={};
        this.Result={Book:0,Chapter:0,Verse:0,Str:'',Booklist:{}};
        this.get=function(callback){
            return callback(this);
        };
        this.xml=function(callback){
            new f({bible:q.bible}).xml(function(response){
                callback(response);
            }).get();
        };
        this.verseMerge=function(list,vID){
            return $(list).map(function(t,i){
                var v1=vID, v2=v1.split('-');
                if(v1==i){return i;}else if(v2.length>1 && v2[0] <= i && v2[1] >= i){return i;}
            }).get();
        };
        this.verseRegex=function(s,n){
            //TODO
            if($.type(n) === "string"){
                if(s.search(new RegExp(n, "gi")) > -1) {
                    return true;
                } else {
                    return false;
                }
            }else{
                return true;
            }
        };
        this.verseReplace=function(s,n){
            //TODO s.replace(/(([^\s]+\s\s*){20})(.*)/,"$1…")
            if($.type(n) === "string"){
                return s.replace(new RegExp(n, "i"), '<b>$&</b>');
            }else{
                return s;
            }
        };
        this.verseSearch=function(nQ){
            if((this.LIST.length?this.verseMerge(this.LIST,this.VID):[this.VID]).length && this.verseRegex(this.VERSE.text,nQ)){
                return true;
            }
        };

        this.query={
            chapter:function(){
                Ob.Result.Booklist[q.book]={};
                Ob.Result.Booklist[q.book][q.chapter]=[];
                this.is=function(){
                    // return fO.previous.booklist!==this.list() || fO.previous.bible!==q.bible || fO.previous.chapter!==q.chapter;
                    return fO.previous.bible!==q.bible || fO.previous.chapter!==q.chapter;
                };
                return Ob.Result.Booklist;
            },
            list:function(){
                return Ob.Result.BooklistName=Object.keys(Ob.Result.Booklist).join();
            },
            book:function(){
                Ob.Result.Booklist={};
                if(Object.getOwnPropertyNames(fO.lookup.book).length > 0){
                    $.each(fO.lookup.book,function(bID,d){
                        Ob.Result.Booklist[bID]={};
                        if($.isEmptyObject(d)){
                            $.each(bible.info[bID].v,function(cID,f){
                                cID++;
                                Ob.Result.Booklist[bID][cID]=[];
                            });
                        }else{
                            Ob.Result.Booklist[bID]=d;
                        }
                    });
                    return Ob.Result.Booklist;
                }
            },
            regex:function(){
                return Ob.Result.Booklist=new regex(q).is(q.q);
            },
            prev:function(){
                if(q.booklist){
                    Ob.Result.Booklist=q.booklist;
                    return Ob.Result.Booklist;
                }
            },
            lookup:function(callbackBibleBefore){
                this.callbackBibleBefore = callbackBibleBefore;
                this.is=function(){
                    //callbackBibleBeforeHas
                    var i=fO.previous.booklist!=this.list() || fO.previous.q!=q.q;
                    this.callbackBibleBeforeHas = (new regex(q).is(q.q))?'':q.q;
                    if(i){
                        //fN.Working({msg:lA.PleaseWait,wait:true});
                        //var nQ=(new regex(q).is(q.q))?'':q.q;
                    }
                    return i;
                };
                return this.prev() || this.regex() || this.book();
            },
        };
        this.book=function(dQ){
            var deferred=new $.Deferred(), o={
                task:{
                  bible:Object.keys(dQ),
                  chapter:[],
                  verse:[]
                },
                BookID:function(){
                    Ob.BID=o.task.bible.shift();
                    Ob.BNA=lB[Ob.BID];
                    o.task.chapter=Object.keys(dQ[Ob.BID]);
                },
                ChapterID:function(){
                    Ob.CID=o.task.chapter.shift();
                    Ob.CNA=Oa.Num(Ob.CID);
                    Ob.LIST=dQ[Ob.BID][Ob.CID];
                    o.task.verse=Object.keys(Ob.LIST);
                    //console.log(Ob.LIST);
                },
                VerseID:function(){
                    Ob.VID=o.task.verse.shift();
                },
                isNew:function(){
                    Ob.Result.Verse++;
                    if(Ob.Result.b!==Ob.BID){
                        Ob.Result.b=Ob.BID; Ob.Result.Book++;
                        Ob.Result.NewBook=true;
                    } else {
                        Ob.Result.NewBook=false;
                    }
                    if(Ob.Result.b!==Ob.BID || Ob.Result.c!==Ob.CID){
                        Ob.Result.c=Ob.CID; Ob.Result.Chapter++;
                        Ob.Result.NewChapter=true;
                    } else {
                        Ob.Result.NewChapter=false;
                    }
                },
                start:function(){
                    // NOTE: as its just start, we set lookup:true and delete any pauses!
                    fO.todo.lookup=true;
                    delete fO.todo.pause;
                    o.BookID();
                    o.next();
                },
                next:function(){
                    o.ChapterID();
                    o.done().progress(function(){
                        // NOTE: Verse reading, this is working if callbackBible().promise notify()
                        deferred.notify();
                    }).fail(function(){
                        // NOTE: as fail task need to know that there is no more todo
                        deferred.reject();
                        delete fO.todo.lookup;
                    }).done(function(){
                        // NOTE: Chapter reading
                        //  d1.notify('chapter->');
                        if(o.task.chapter.length){
                            o.next();
                        }else if(o.task.bible.length){
                            // NOTE: new Book start reading
                            o.start();
                        }else{
                            // NOTE: as done, lookup task we removed!
                            deferred.resolve();
                            delete fO.todo.lookup;
                        }
                    });
                },
                done:function(){
                    var b=fO[q.bible].bible.book[Ob.BID],c=b.chapter[Ob.CID],v=c.verse;
                    var d=new $.Deferred();
                    (function eachVerse(task) {
                        setTimeout(function(){
                            if(task.length){
                                // NOTE: progress
                                var i = task.shift();
                                Ob.VID=i.slice(1);Ob.VNA=Oa.Num(Ob.VID);Ob.VERSE=v[i];
                                if(fO.todo.pause){
                                    d.reject();
                                    delete fO.todo.pause;
                                } else {
                                    if(Ob.query.callbackBibleBefore){
                                        if(Ob[Ob.query.callbackBibleBefore](Ob.query.callbackBibleBeforeHas)){
                                            o.isNew();
                                            callbackBible(Ob).progress(function(){
                                                d.notify();
                                            }).fail(function(){
                                                d.reject();
                                            }).done(function(){
                                                eachVerse(task);
                                            });
                                        } else {
                                            d.notify();
                                            eachVerse(task);
                                        }
                                    } else {
                                        o.isNew();
                                        callbackBible(Ob).progress(function(){
                                            d.notify();
                                        }).fail(function(){
                                            d.reject();
                                        }).done(function(){
                                            // console.log(notifyChapter);
                                            eachVerse(task);
                                        });
                                    }
                                }
                            } else {
                                // NOTE: done
                                d.resolve();
                            }
                        });
                    })(Object.keys(v));
                    return d.promise();
                }
            };
            return deferred.promise(o.start());
        };
    };
    this.Example=function(container) {
        var olb, olc, olv, ol;
        new HolyBible(function(Ob) {
            var d=new $.Deferred();
            // var msg=lA.BFBCV.replace(/{b}/, Ob.BNA).replace(/{c}/, Ob.CNA).replace(/{v}/,Ob.VNA);
            // f().working({msg:msg});
            var msg=lA.BFVBC.replace(/{b}/, Ob.BNA).replace(/{c}/, Ob.CNA);
            // console.log(msg);
            // Ob.Result.verse++;
            if(Ob.Result.NewBook){
                console.log('yes new book', Ob.BNA);
            } else {
                console.log('no old book', Ob.BNA);
            }
            d.notify();
            d.resolve();
            return d.promise();
        }).get(function(Ob) {
            Ob.xml(function(response){
                if(response.status){
                    if(Ob.query.lookup('verseSearch')){
                        if(Ob.query.is()){
                            ol=$(h.ol,{class:q.bible}).appendTo(container);
                            Ob.book(Ob.Result.Booklist).progress(function(e){
                                // NOTE: reading bible, 'lookup.progress'
                                // NOTE: progress only return if callbackBible has notify!
                                // console.log('Example.process');
                                // var msg=lA.BFBCV.replace(/{b}/, Ob.BNA).replace(/{c}/, Ob.CNA).replace(/{v}/,Ob.VNA);
                                var msg=lA.BFVBC.replace(/{b}/, Ob.BNA).replace(/{c}/, Ob.CNA);
                                f().working({msg:msg});
                            }).done(function(){
                                // NOTE: reading done
                                // NOTE: done only return if callbackBible has resolve!
                                console.log('Example.done');
                            }).fail(function(){
                                // NOTE: reading fail
                            }).always(function(){
                                // NOTE: task completed
                                f().done();
                            });
                        } else {
                            // NOTE: Ob.query.is empty!
                            console.log('Ob.query.is empty');
                        }
                    } else {
                        // NOTE: Ob.query.* is empty
                        console.log('Ob.query.lookup empty');
                    }
                } else {
                    // NOTE: download fail
                    console.log('download fail');
                }
            });
        });
    };
    this.chapter=function(container) {
        var olb, olc, olv, ol;
        new HolyBible(function(Ob){
            var d=new $.Deferred();
            if(Ob.Result.NewBook){
                olb=$(h.ol).appendTo($(h.li,{id:Ob.BID,class:'bID'}).append(
                    $(h.div).append(
                        $(h.h2).text(Ob.BNA)
                    )
                ).appendTo(ol));
            }
            if(Ob.Result.NewChapter){
                olc=$(h.ol,{class:'verse'}).appendTo($(h.li,{id:Ob.CID,class:'cID'}).append(
                    $(h.div).append(
                        $(h.h3,{class:'no'}).text(Ob.CNA).on(fO.Click,function(){
                            $(this).parents('li').children('ol').children().each(function(){
                                if($(this).attr("id"))$(this).toggleClass(config.css.active);
                            });
                        })
                        //TODO
                        // typeof Ob[fO.Deploy].menuChapter === 'function' && Ob[fO.Deploy].menuChapter(container)
                    )
                ).appendTo(olb));
            }
            if(Ob.VERSE.title){
                $(h.li,{class:'title'}).html(Ob.VERSE.title.join(', ')).appendTo(olc);
            }
            $(h.li,{id:Ob.VID,'data-verse':Ob.VNA}).html(Ob.verseReplace(Ob.VERSE.text,q.q)).appendTo(olc).on(fO.Click,function(){
                $(this).toggleClass(config.css.active);
            }).promise().always(function(){
                d.resolve();
                // if(Ob.VERSE.ref){
                //     Ob.Option(olc).Reference(Ob.VERSE.ref).promise().always(function(){
                //         d.resolve();
                //     });
                // }else{
                //     d.resolve();
                // }
            });
            return d.promise();
        }).get(function(Ob){
            Ob.xml(function(response){
                if(response.status){
                    if(Ob.query.chapter()){
                        if(Ob.query.is()){
                            if(fO.todo.containerEmpty){
                                delete fO.todo.containerEmpty;
                            }else{
                                container.empty();
                            }
                            // console.log(Ob.Result.Booklist);
                            ol=$(h.ol,{class:q.bible}).appendTo(container);
                            Ob.book(Ob.Result.Booklist).progress(function(){
                                // console.log('book.progress');
                            }).done(function(){
                                // console.log('book.done');
                            }).always(function(){
                                fO.previous.bible=q.bible;
                                fO.previous.book=q.book;
                                fO.previous.chapter=q.chapter;
                            });
                        } else {
                            // NOTE: previous task -> same chapter
                            // console.log('PREVIOUS TASK');
                            // o.msg('same chapter');
                            console.log('same chapter');
                        }
                    } else {
                        // NOTE: selected chapter could not find
                        console.log('selected chapter could not find');
                    }
                } else {
                    // NOTE: xml/ bible is not ready
                    console.log('DownloadNotSuccess');
                }
            });
        });
    };
    this.lookup=function(container) {
        var olb, olc, olv, ol;
        new HolyBible(function(Ob) {
            var d=new $.Deferred();
            d.notify();
            if(Ob.Result.NewBook){
                olb=$(h.ol).appendTo($(h.li,{id:Ob.BID,class:'bID'}).append(
                    $(h.div).append(
                        $(h.h2).text(Ob.BNA)
                    )
                ).appendTo(ol));
            }
            if(Ob.Result.NewChapter){
                olc=$(h.ol,{class:'verse'}).appendTo($(h.li,{id:Ob.CID,class:'cID'}).append(
                    $(h.div).append(
                        $(h.h3,{class:'no'}).text(Ob.CNA).on(fO.Click,function(){
                            $(this).parents('li').children('ol').children().each(function(){
                                if($(this).attr("id"))$(this).toggleClass(config.css.active);
                            });
                        })
                        //TODO
                        // typeof Ob[fO.Deploy].menuChapter === 'function' && Ob[fO.Deploy].menuChapter(container)
                    )
                ).appendTo(olb));
            }
            if(Ob.VERSE.title){
                $(h.li,{class:'title'}).html(Ob.VERSE.title.join(', ')).appendTo(olc);
            }
            $(h.li,{id:Ob.VID,'data-verse':Ob.VNA}).html(Ob.verseReplace(Ob.VERSE.text,q.q)).appendTo(olc).on(fO.Click,function(){
                $(this).toggleClass(config.css.active);
            }).promise().always(function(){
                d.resolve();
                // if(Ob.VERSE.ref){
                //     Ob.Option(olc).Reference(Ob.VERSE.ref).promise().always(function(){
                //         d.resolve();
                //     });
                // }else{
                //     d.resolve();
                // }
            });
            return d.promise();
        }).get(function(Ob) {
            Ob.xml(function(response){
                if(response.status){
                    if(Ob.query.lookup('verseSearch')){
                        if(Ob.query.is()){
                            if(fO.todo.containerEmpty){
                                delete fO.todo.containerEmpty;
                            }else{
                                container.empty();
                            }
                            ol=$(h.ol,{class:q.bible}).appendTo(container);
                            Ob.book(Ob.Result.Booklist).progress(function(e){
                                // NOTE: reading bible, 'lookup.progress'
                                // NOTE: progress only return if callbackBible has notify!
                                var msg=lA.BFVBC.replace(/{b}/, Ob.BNA).replace(/{c}/, Ob.CNA);
                                fO.msg.lookup.html(Oa.Num(Ob.Result.Verse));
                                f().working({msg:msg});
                            }).done(function(){
                                // NOTE: reading done
                                // NOTE: done only return if callbackBible has resolve!
                            }).fail(function(){
                                // NOTE: reading fail
                            }).always(function(){
                                // NOTE: task completed
                                fO.previous.booklist=Ob.Result.BooklistName;
                                fO.previous.q=q.q;
                                q.result=Ob.Result.Verse;
                                fO.msg.lookup.attr('title',q.q);
                                f().done();
                            });
                        } else {
                            // NOTE: Ob.query.is empty!
                            console.log('Ob.query.is same');
                        }
                    } else {
                        // NOTE: Ob.query.* is empty
                        console.log('Ob.query.lookup empty');
                    }
                } else {
                    // NOTE: download fail
                    console.log('download fail');
                }
            });
        });
    };
}
