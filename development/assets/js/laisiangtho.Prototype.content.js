Core.prototype.content=function(q,callbackContent){
    var Oa = this, lO=fO.lang[q.bible], lA=lO.l, lB=lO.b; //bO=fO[q.bible].bible
    this.Num=function(n){
        return f().num(n,q.bible);
    };
    function HolyBible(callbackBible) {
        var Oj=this;
        this.result={book:0,chapter:0,verse:0,str:''};
        this.booklist={};
        this.get=function(callback){
            return callback(this);
        };
        this.xml=function(callback){
            new f({bible:q.bible}).xml(function(response){
                callback(response);
            }).get();
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
        this.query={
            chapter:function(){
                Oj.booklist[q.book]={};
                Oj.booklist[q.book][q.chapter]=[];
                this.is=function(){
                    return fO.previous.booklist!==this.list() || fO.previous.bible!==q.bible || fO.previous.chapter!==q.chapter;
                };
                return Oj.booklist;
            },
            list:function(){
                // return Object.keys(Oj.booklist).join();
                this.resultId=Object.keys(Oj.booklist);
                // NOTE: this.current used to check on page
                return this.current=this.resultId.join();
            },
            book:function(){
                Oj.booklist={};
                if(Object.getOwnPropertyNames(fO.lookup.book).length > 0){
                    $.each(fO.lookup.book,function(bID,d){
                        Oj.booklist[bID]={};
                        if($.isEmptyObject(d)){
                            $.each(bible.info[bID].v,function(cID,f){
                                cID++;
                                Oj.booklist[bID][cID]=[];
                            });
                        }else{
                            Oj.booklist[bID]=d;
                        }
                    });
                    return Oj.booklist;
                }
            },
            regex:function(){
                return Oj.booklist=new regex(q).is(q.q);
            },
            prev:function(){
                if(q.booklist){
                    Oj.booklist=q.booklist;
                    return Oj.booklist;
                }
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
        };
        this.book=function(dQ){
            var d1=new $.Deferred(), o={
                task:{
                  bible:Object.keys(dQ),
                  chapter:[],
                  verse:[]
                },
                bID:function(){
                    Oj.BID=o.task.bible.shift();
                    Oj.BNA=lB[Oj.BID];
                    o.task.chapter=Object.keys(dQ[Oj.BID]);
                },
                cID:function(){
                    Oj.CID=o.task.chapter.shift();
                    Oj.CNA=Oa.Num(Oj.CID);
                    Oj.LIST=dQ[Oj.BID][Oj.CID];
                    o.task.verse=Object.keys(Oj.LIST);
                    //console.log(Oj.LIST);
                },
                vID:function(){
                    Oj.VID=o.task.verse.shift();
                },
                start:function(){
                    fO.todo.lookup=true;
                    delete fO.todo.pause;
                    o.bID();
                    o.next();
                },
                next:function(){
                    o.cID();
                    o.done().progress(function(){
                        // NOTE: Verse reading, this is working if callbackBible().promise notify()
                        // d1.notify('verse->');
                    }).fail(function(){
                        // NOTE: fail
                        delete fO.todo.lookup;
                        console.log('lookup delete as fail');
                        d1.reject();
                    }).done(function(){
                        // NOTE: Chapter reading
                        //  d1.notify('chapter->');
                        if(o.task.chapter.length){
                            o.next();
                        }else if(o.task.bible.length){
                            // NOTE: new Book start reading
                            o.start();
                        }else{
                            delete fO.todo.lookup;
                            console.log('lookup delete, as done');
                            d1.resolve();
                        }
                    });
                },
                done:function(){
                    var b=fO[q.bible].bible.book[Oj.BID],c=b.chapter[Oj.CID],v=c.verse;
                    var d=new $.Deferred();
                    (function eachVerse(task) {
                        setTimeout(function(){
                            if(task.length){
                                // NOTE: progress
                                var i = task.shift();
                                Oj.VID=i.slice(1);Oj.VNA=Oa.Num(Oj.VID);Oj.VERSE=v[i];
                                if(fO.todo.pause){
                                    d.reject();
                                    delete fO.todo.pause;
                                } else {
                                    callbackBible(Oj).progress(function(){
                                        d.notify();
                                    }).fail(function(){
                                        d.reject();
                                    }).done(function(){
                                        // console.log(notifyChapter);
                                        eachVerse(task);
                                    });
                                }
                            } else {
                                // NOTE: done
                                d.resolve();
                            }
                        },3);
                    })(Object.keys(v));
                    return d.promise();
                }
            };

            o.start();
            return d1.promise();
        };
    };
    this.tmp=function(container) {
        // delete fO.todo.enter;
        // delete fO.todo.pause;
        // delete fO.todo.enter;
        var olb, olc, olv, ol;
        new HolyBible(function(Oj) {

            var d=new $.Deferred();
            // var msg=lA.BFBCV.replace(/{b}/, Oj.BNA).replace(/{c}/, Oj.CNA).replace(/{v}/,Oj.VNA);
            var msg=lA.BFVBC.replace(/{b}/, Oj.BNA).replace(/{c}/, Oj.CNA);
            // fO.msg.info.html(msg).promise().done(function(){});
            Oj.result.verse++;
            // console.log(msg);
            // d.notify();
            f().working({msg:msg}).promise().done(function(){
                d.resolve();
            });

            return d.promise();
        }).get(function(Oj) {
            Oj.xml(function(response){
                if(response.status){
                    if(Oj.query.lookup()){
                        // console.log('----',Oj.booklist);
                        if(Oj.query.is()){
                            // f().working({wait:true});
                            ol=$(h.ol,{class:q.bible}).appendTo(container);
                            Oj.book(Oj.booklist).progress(function(e){
                                // NOTE: reading bible, 'lookup.progress'
                                // var msg=lA.BFBCV.replace(/{b}/, Oj.BNA).replace(/{c}/, Oj.CNA).replace(/{v}/,Oj.VNA);
                                var msg=lA.BFBCV.replace(/{b}/, Oj.BNA).replace(/{c}/, Oj.CNA).replace(/{v}/,Oj.VNA);
                                // console.log('lookup.progress',e,Oj.BNA, Oj.CNA, Oj.VNA);
                                // fO.msg.info.html(msg);
                                // f().working({msg:msg,wait:true});
                            }).done(function(){
                                // NOTE: reading done
                                console.log('lookup.done');
                            }).fail(function(){
                                // NOTE: reading fail
                                // f().working({msg:lA.Paused,wait:false}).promise().done(function(){
                                //     delete fO.todo.pause;
                                // });
                            }).always(function(){
                                // NOTE: task completed
                                f().done();
                                console.log('lookup.always');
                            });
                        } else {
                            console.log('Oj.query.is empty');
                        }
                    } else {
                        console.log('Oj.query.lookup empty');
                    }
                } else {
                    console.log('download fail');
                }
            });
        });
    };
    this.chapter=function(container) {
        var olb, olc, olv, ol;
        new HolyBible(function(Oj){
            // console.log('new bible content reading start now..........');
            var d=new $.Deferred();
            var msg=lA.BFBCV.replace(/{b}/, Oj.BNA).replace(/{c}/, Oj.CNA).replace(/{v}/,Oj.VNA);
            // fO.msg.info.html(msg).promise().done(function(){});
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
                        })
                        //TODO
                        // typeof Oj[fO.Deploy].menuChapter === 'function' && Oj[fO.Deploy].menuChapter(container)
                    )
                ).appendTo(olb));
            }
            if(Oj.VERSE.title){
                $(h.li,{class:'title'}).html(Oj.VERSE.title.join(', ')).appendTo(olc);
            }
            $(h.li,{id:Oj.VID,'data-verse':Oj.VNA}).html(Oj.replace(Oj.VERSE.text,q.q)).appendTo(olc).on(fO.Click,function(){
                $(this).toggleClass(config.css.active);
            }).promise().always(function(){
                d.resolve();
                // if(Oj.VERSE.ref){
                //     Oj.Option(olc).Reference(Oj.VERSE.ref).promise().always(function(){
                //         d.resolve();
                //     });
                // }else{
                //     d.resolve();
                // }
            });
            return d.promise();
        }).get(function(Oj){
            Oj.xml(function(response){
                if(response.status){
                    // NOTE: xml / bible is ready!
                    if(Oj.query.chapter()){
                        //var msg=lA.BFVBC.replace(/{b}/, lB[q.book]).replace(/{c}/, Oa.Num(q.chapter));
                        if(Oj.query.is()){
                            if(fO.todo.containerEmpty){
                                delete fO.todo.containerEmpty;
                            }else{
                                container.empty();
                            }
                            // console.log(Oj.booklist);
                            ol=$(h.ol,{class:q.bible}).appendTo(container);
                            Oj.book(Oj.booklist).progress(function(){
                                console.log('book.progress');
                            }).done(function(){
                                console.log('book.done');
                            }).always(function(){
                                // console.log('book.always');
                                fO.previous.booklist=Oj.query.current;
                                fO.previous.bible=q.bible;
                                fO.previous.book=q.book;
                                fO.previous.chapter=q.chapter;
                                q.result=Oj.result.verse;
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
        new HolyBible(function(Oj) {
            var d=new $.Deferred();
            var msg=lA.BFBCV.replace(/{b}/, Oj.BNA).replace(/{c}/, Oj.CNA).replace(/{v}/,Oj.VNA);
            // fO.msg.info.html(msg).promise().done(function(){});
            Oj.result.verse++;
            // console.log(msg);
            d.notify();
            d.resolve();
            return d.promise();
        }).get(function(Oj) {
            Oj.xml(function(response){
                if(response.status){
                    if(Oj.query.lookup()){
                        // console.log('----',Oj.booklist);
                        if(Oj.query.is()){
                            ol=$(h.ol,{class:q.bible}).appendTo(container);
                            Oj.book(Oj.booklist).progress(function(e){
                                // NOTE: reading bible
                                // var msg=lA.BFBCV.replace(/{b}/, e.BNA).replace(/{c}/, e.CNA).replace(/{v}/,e.VNA);
                                console.log('lookup.progress',e);
                            }).done(function(){
                                // NOTE: reading done
                                console.log('lookup.done');
                            }).always(function(){
                                // NOTE: task completed
                                console.log('lookup.always');
                            });
                        } else {
                            console.log('Oj.query.is empty');
                        }
                    } else {
                        console.log('Oj.query.lookup empty');
                    }
                } else {
                    console.log('download fail');
                }
            });
        });
    };
}
