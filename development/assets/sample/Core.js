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
    var p=fN.Page(1), ol=$(h.ol,{id:'dragable',class:'row row-bible'});
    fO.container.main.html(fN.Menu(ol).Bible(function(Om){
        return $(h.li,{id:Om.bID,class:Om.classActive}).html(
            $(h.p).append(
                $(h.span,{class:Om.isAvailable}).on(fO.Click,function(evt){
                    evt.preventDefault(); //evt.stopPropagation();  evt.stopImmediatePropagation();
                    var x=$(this), li=x.parents('li');
                    if(fO.msg.info.is(":hidden"))fO.todo.bibleOption=false;
                    if(fO.todo.bibleOption===Om.bID){
                        fN.Done(function(){
                            delete fO.todo.bibleOption;
                        });
                    }else if(li.hasClass(config.css.notAvailable)){
                        fN.Working({
                            msg:$(h.ul,{class:'data-dialog'}).append(
                                $(h.li).append(
                                    $(h.p).html(fO.lang[Om.bID].l.WouldYouLikeToAdd.replace(/{is}/, x.parent().children('a').text()))
                                ),
                                $(h.li).append(
                                    $(h.span,{class:'yes icon-thumbs-up-alt'}).on(fO.Click,function(evt){
                                        evt.preventDefault();
                                        new Content({bible:Om.bID}).XML(function(response){
                                            if(response.status){
                                                li.removeClass(config.css.notAvailable).addClass(config.css.available);
                                                x.removeClass(Om.classOnline).addClass(Om.classOffline);
                                            }
                                        }).get();
                                    }),
                                    $(h.span,{class:'no icon-thumbs-down-alt'}).on(fO.Click,function(evt){
                                        evt.preventDefault();
                                        fN.Done(function(){
                                            delete fO.todo.bibleOption;
                                        });
                                    })
                                )
                            ),
                            wait:true
                        });
                    }else{
                        fO.todo.bibleOption=Om.bID;
                        fN.Working({
                            msg:$(h.ul,{class:'data-dialog'}).append(
                                $(h.li).append(
                                    $(h.p).html(fO.lang[Om.bID].l.WouldYouLikeToRemove.replace(/{is}/, x.parent().children('a').text()))
                                ),
                                $(h.li).append(
                                    $(h.span,{class:'yes icon-thumbs-up-alt'}).on(fO.Click,function(evt){
                                        evt.preventDefault();
                                        li.removeClass(config.css.available).addClass(config.css.notAvailable);
                                        x.removeClass(Om.classOffline).addClass(Om.classOnline);
                                        fN.Working({msg:fO.lang[Om.bID].l.PleaseWait,wait:true}).promise().done(function(){
                                            li.removeClass(config.css.available).addClass(config.css.notAvailable);
                                            x.removeClass(Om.classOffline).addClass(Om.classOnline);
                                            new Content({bible:Om.bID}).XML(function(response){
                                                fN.Done(function(){
                                                    delete fO.todo.bibleOption;
                                                });
                                            }).remove();
                                        });
                                    }),
                                    $(h.span,{class:'no icon-thumbs-down-alt'}).on(fO.Click,function(evt){
                                        evt.preventDefault();
                                        fN.Done(function(){
                                            delete fO.todo.bibleOption;
                                        });
                                    })
                                )
                            ),
                            wait:true
                        });
                    }
                }),
                $(h.a,{href:p+$.param({bible:Om.bID})}).html(Om.lang.name),
                $(h.span,{class:'icon-menu drag'})
            )
        );
    })).promise().done(function(e){
        this.children().sortable({
            handle: ".drag",containment: "parent",helper: ".dsdfd",placeholder:"ghost",forcePlaceholderSize: true,opacity: 0.7,
            update: function(event,ui){
                $(this).children().each(function(i,e){
                    fO.lang[$(e).get(0).id].index=$(e).index();
                }).promise().done(function(){
                    fD.UpdateLang().then(fN.Index);
                });
            }
        });
    });
};
Core.prototype.book=function(){
    var p=fN.Page(2), lD=fO.lang[fO.query.bible], div=$(h.div,{class:'con-book'}).appendTo(fO.container.main.empty());
    $.each(bible.catalog,function(testamentID,cL){
        var testamentName=lD.t[testamentID];
        $(h.ol,{class:'testament',id:testamentID}).append(
            $(h.li,{id:'t-'+testamentID}).html(
                $(h.h1,{text:testamentName})
            )
        ).appendTo(div).promise().done(function(){
            $(h.ol,{class:'catalog'}).appendTo(this.children()).promise().done(function(){
                var it=this;
                $.each(cL,function(catalogID,bL){
                    var catalogName=lD.s[catalogID];
                    $(h.li,{id:'c-'+catalogID}).append(
                        $(h.h2,{text:catalogName})
                    ).appendTo(it).promise().done(function(){
                        var it=$(h.ol,{class:'book'}).appendTo(this);
                        bL.forEach(function(bookID){
                            var bookName=lD.b[bookID];
                            $(h.li,{id:'b-'+bookID,class:(fO.query.book==bookID?config.css.active:'')}).append(
                                $(h.p).append(
                                    $(h.a,{href:p+$.param({book:bookID})}).html(bookName),
                                    fA.chapter.book(bookID)
                                )
                            ).appendTo(it);
                        });
                    });
                });
            });
        });
    });
};
Core.prototype.reader=function(){
    new Content(fO.query).chapter(fO.container.main.children());
};
Core.prototype.lookup=function(){
    new Content(fO.query).lookup(fO.container.main.children());
};
Core.prototype.note=function(){
    var container=$(h.div,{class:'con con-note d1'}).appendTo(fO.container.main.empty());
    var lB=fO.lang[fO.query.bible];
    var notelist=function(){
        var ol=$(h.ol,{class:'nobg'}).appendTo(container.empty());
        if(fO.note){
            var total=Object.keys(fO.note).length;
            $.each(fO.note,function(id,note){
                //console.log(id,note);
                if(note.name){
                    var iseditable=($.isNumeric(id))?'yes icon-list':'no icon-'+id;
                    var totalData=(note.data)?Object.keys(note.data).length:0;
                    $(h.li,{id:id, class:iseditable,'data-title':totalData}).append(
                        $(h.div).html(note.name).on(fO.Click,function(e) {
                            var x = $(this);
                            if(!x.attr('contenteditable')){
                                setTimeout(function() {
                                    var dblclick = parseInt(x.data('double'), 7);
                                    if(dblclick > 0){
                                        x.data('double', dblclick-1);
                                    }else{
                                        var olN=x.parent().children('ol');
                                        if(olN.length){
                                            olN.remove();x.parent().removeClass(config.css.active);
                                        }else{
                                            x.parent().addClass(config.css.active);
                                            if(note.data){
                                                new Content(fO.query).note(x.parent(),note.data);
                                            }else{
                                                $(h.ol,{class:'norecord'}).append($(h.li).html('No record found!')).appendTo(x.parent());
                                            }
                                        }
                                    }
                                },50);
                            }
                        }).dblclick(function(e) {
                            $(this).data('double', 1);
                            var x=$(this), label=x.text(), id=x.parent().attr('id');
                            if($.isNumeric(id)){
                                x.unbind(fO.Click+'.myEvents').attr({'data-title':label,contenteditable:true}).on('keydown',function(e){
                                    if(e.keyCode === 27){
                                        x.removeAttr('contenteditable','autocomplete').text(label).bind(fO.Click);
                                        delete fO.todo.pause;
                                    }else if(e.keyCode === 13){
                                        fO.note[id].name=$(this).removeAttr('contenteditable').text();
                                        fD.UpdateNote();
                                    }
                                });
                            }
                        })
                    ).appendTo(ol).promise().done(function(){
                        if($.isNumeric(id)){
                            var x=this;
                            $(h.span,{class:'delete icon-wrong',title:'delete'}).on(fO.Click,function(){
                                delete fO.note[id];
                                fD.UpdateNote().then(x.remove);
                            }).appendTo(this);
                        }
                    });
                }
            });
        }else{
            $(h.li).html('No records were found!').appendTo(ol);
        }
        $(h.li,{class:'add icon-tag',contenteditable:true}).on('keydown',function(e){
            if(e.keyCode === 13){
                var label=$(this).text(), uniqueid=Math.random().toString().substr(2, 9);
                if(label && !fO.note[uniqueid]){
                    fO.note[uniqueid]={name:label};
                    fD.UpdateNote().then(notelist);
                }
                e.preventDefault();
            }
        }).on(fO.Click,function(){
            $(this).addClass(config.css.active).empty();
        }).appendTo(ol);
    };
    notelist();
};
Core.prototype.Load=function(){
    $('p').addClass(config.css.active).html(config.version); $('h1').attr({title:config.build}).attr({class:'icon-fire'});
    var l7=[], l8={}, O1={
        reading:function(bID){
            if(config.bible.ready && fO.query.bible){
                if(config.bible.ready==1){return fO.query.bible;}
                else if(config.bible.ready==2){return bID;}
                else{ return true;}
            }else{
                return true;
            }
        },
        go:function(){
            var bID=l7.shift(); fO[bID]={};
            if(fO.lang[bID].info){
                $("p").html(fO.lang[bID].info.name).promise().done(function(){
                    if(O1.reading(bID) == bID){
                        new Content({bible:bID,reading:bID}).XML(function(response){
                            O1.next();
                        }).read();
                    }else{
                        O1.next();
                    }
                });
            }else{
                this.json(bID,this.next);
            }
        },
        next:function(){
            if(l7.length){
                O1.go();
            }else{
                $(window).bind(fO.Hash,function(){z.Init();});
                function fSN(){
                    fD.get({table:config.store.note}).then(function(storeNote){
                        if(storeNote){
                            fO.note=storeNote; O1.done();
                        }else{
                            fD.put({table:config.store.note,data:config.store.noteData}).then(function(storeNote){
                                fO.note=storeNote; O1.done();
                            });
                        }
                    });
                };
                function fSL(){
                    fD.get({table:config.store.lookup}).then(function(storeLookup){
                        if(storeLookup){
                            fO.lookup=storeLookup; fSN();
                        }else{
                            fD.put({table:config.store.lookup,data:{setting:fO.lookup.setting,book:fO.lookup.book}}).then(function(storeLookup){
                                fO.lookup=storeLookup; fSN();
                            });
                        }
                    });
                };
                fD.UpdateLang().then(fSL);
            }
        },
        json:function(bID,callback,x){
            var o=fN.Url(config.id,[bID],config.file.lang);
            var request=$.ajax({url:(x)?x+o.url:o.url,dataType:o.data,contentType:o.content,cache:false});
            request.done(function(j){
                var lID=j.info.lang=j.info.lang || config.language.info.lang;
                fO.msg.info.html(j.info.name);
                var prepare=function(lC,lN){
                    var l9={};
                    return {
                        is:{
                            index:function(n){
                                l9[n]=fO.lang[bID].index;
                            },
                            name:function(n){
                                l9[n]={};
                                for(var i in lC[n]){
                                    var jB=(typeof lN.b === "undefined" || typeof lN.b[i] === "undefined")?[]:[lN.b[i]];
                                    var jN=(typeof lN.name === "undefined" || typeof lN.name[i] === "undefined")?[]:lN.name[i];
                                    $.merge(jB,jN);
                                    l9[n][i]=$.unique(fN.Array(lC[n][i]).merge(jB).data);
                                }
                            }
                        },
                        merge:function(){
                            for(var f in lC){
                                if(this.is[f]){
                                    this.is[f](f);
                                }else{
                                    l9[f]=(lN[f])?$.extend({},lC[f],lN[f]):lC[f];
                                }
                            }
                            return l9;
                        },
                        next:function(){
                            $.extend(fO.lang[bID],this.merge());
                            $("p").html(lID).attr({class:'icon-database'}).promise().done(function(){
                                new Content({bible:bID,reading:O1.reading(bID)}).XML(function(response){
                                    callback();
                                }).read();
                            });
                        }
                    };
                };
                if(l8[lID]){
                    prepare(l8[lID],j).next();
                }else{
                    var o=fN.Url('lang',[lID],config.file.lang), get=$.ajax({url:o.url,dataType:o.data,contentType:o.content,cache:false});
                    get.done(function(langauge){
                        l8[lID]=prepare(config.language,langauge).merge();
                        prepare(l8[lID],j).next();
                    });
                    get.fail(function(jqXHR, textStatus){
                        prepare(config.language,j).next();
                    });
                }
            });
            request.fail(function(jqXHR, textStatus){
                if(api){
                    if(x){
                        fD.RemoveLang(bID,function(){
                            l7.splice(l7.indexOf(bID), 1); callback();
                        });
                    }else{
                        O1.json(bID,callback,api);
                    }
                }else{
                    fD.RemoveLang(bID,function(){
                        l7.splice(l7.indexOf(bID), 1); callback();
                    });
                }
            });
        },
        available:function(j){
            if(j){fO.lang=fN.Array(config.bible.available,Object.keys(j)).merge().unique().reduce(function(o,v,i){
                if($.isPlainObject(j[v])){o[v]={index:(j[v].index||j[v].index==0)||i};}else{o[v]={index:i};} return o;}, {});
            }else{fO.lang=config.bible.available.reduce(function(o,v,i){o[v]={index:i};return o;}, {});}
        },
        done:function(){
            $('body').html(fN.fN(config.body).Content()).promise().done(z.Init());
        }
    };
    fO.msg.info.html('getting Database ready').attr({class:'icon-database'});
    fD.init(function(){
        fO.msg.info.html('getting Configuration ready').attr({class:'icon-config'});
        fD.get({table:config.store.info}).then(function(storeInfo){
            fO.msg.info.html('getting Language ready').attr({class:'icon-language'});
            $('p').attr({class:'icon-language'}).html('One more moment please');
            fD.get({table:config.store.lang}).then(function(storeLang){
                fO.msg.info.attr({class:'icon-flag'});
                if(storeLang){
                    if(storeInfo && storeInfo.build == config.build){
                        fO.Ready=3; fO.lang=storeLang; process_query();//ONLOAD
                    }else{
                        fO.Ready=2; O1.available(storeLang); process_query();//ONUPDATE
                    }
                }else{
                    fO.Ready=1; O1.available(); process_query();//ONINSTALL
                }
            });
            function process_query(){
                fD.get({table:config.store.query}).then(function(storeQuery){
                    if(storeQuery){fO.query=storeQuery; process_trigger();}else{process_trigger();}
                });
            };
            function process_trigger(){
                fN.Index(); l7=config.bible.available.concat();
                if(fO.Ready==3){O1.go();}else{fD.add({table:config.store.info,data:{build:config.build,version:config.version}}).then(O1.go());}
            };
        });
    });
};
Core.prototype.Init=function(){
    var s0={page:config.page[0],bible:config.bible.available[0],book:1,testament:1,catalog:1,chapter:1,verses:'',verse:'',q:'',result:''};
    fN.Hash(function(q){
        var f0={
            page:function(i,o,d){
                fO.query[i]=($.inArray(o.toLowerCase(), config.page) >= 0)?o:d;
                config.css.currentPage=fN.is(fO.query[i]).class;
            },
            bible:function(i,o,d){
                fO.query[i]=($.inArray(o.toLowerCase(), config.bible.available) >= 0)?o:d;
            },
            book:function(i,o,d){
                if($.isNumeric(o)){
                    fO.query[i]=(bible.book[o])?o:d;
                }else{
                    fO.query[i]=d;
                    var o=o.replace(new RegExp('-', 'g'), ' ').toLowerCase(), books=fO.lang[fO.query.bible].b;
                    for(var k in books){
                        //TODO -> what is lang
                        if(books[k].toLowerCase() == q || lang.b[k].toLowerCase() == o){
                            fO.query[i]=k;
                            break;
                        }
                    }
                }
            },
            testament:function(i,o,d){
                fO.query[i]=bible.info[fO.query.book].t;
            },
            catalog:function(i,o,d){
                fO.query[i]=bible.info[fO.query.book].s;
            },
            chapter:function(i,o,d){
                fO.query[i]=(bible.info[fO.query.book].c >= o && o > 0)?o:d;
            },
            verse:function(i,o,d){
                fO.query[i]=(bible.info[fO.query.book].v[fO.query.chapter-1] >= o)?o:d;
            },
            verses:function(i,o,d){
            },
            q:function(i,o,d){
                if(q.q){
                    fO.query.q=q.q;
                }
            },
            bookmark:function(){
            }
        };
        if($.isEmptyObject(fO.query)){
            fO.query=$.extend({},s0,q);
        }else{
            q.page=(q.page)?q.page:fO.query.page;
            $.extend(fO.query,q);
        }
        for(var i in fO.query)if($.isFunction(f0[i]))f0[i](i,fO.query[i],s0[i]);
    });
    fN.Header($(config.css.header));
    fN.Footer($(config.css.footer));
    fN.Body().keydown(function(e){
        if(e.which == 27)fO.todo.pause=true;
        else if(e.which == 13)fO.todo.enter=true;
    });
    var form={name:fN.is('lookup').form,field:fN.is('q').input,button:fN.is('search').input};
    $(form.name).off().on('submit',function(){
        var x=$(this); x.serializeObject(fO.query);
        if(fO.query.page == x.attr('name')){
            x.find(form.field).attr('autocomplete', 'off').focus().select().promise().done(z.lookup());
        }else{
            fN.Go(x.attr('action'),{q:fO.query.q});
        }
        return false;
    }).find(form.field).val(fO.query.q).focusin(function(){
        //
    }).focusout(function(){
        //
    }).keyup(function(evt){
        //
    });
    $(form.name).find(form.button).off().on(fO.Click,function(){
        $(this.form).submit();
    }).promise().done(function(){
        $(form.field).attr('autocomplete', 'off').focus().select();
    });
    fO.container.main=$(config.css.content).children(config.css.currentPage);
    fO.container.main.fadeIn(300).siblings().hide().promise().done(
        this[$.isFunction(this[fO.query.page])?fO.query.page:$(config.page).get(-1)]()
    );
    $(fN.is('fA').class).each(function(){
        var y=$(this), d=fN.Attr(y).of('data-fa'), i=fN.Attr(y).class();
        if(fA[i[0]]){
            if(d[0] && $.isFunction(fA[i[0]][d[0]]))fA[i[0]][d[0]](y,d,i);
            if(i[1] && $.isFunction(fA[i[0]][i[1]]))y.off().on(fO.Click,function(e){fA[i[0]][i[1]](e);});
        }
    }).promise().done(function(){
        fD.UpdateQuery();
    });
    z.isAnalytics(function(o){
        o.sendPage(fO.query.page);
    });
    if(fO.todo.Orientation){
        application.Orientation();
        delete fO.todo.Orientation;
    }
};
function Core(app){
    this.Watch=function(){
        app.on(fO.Click,fN.is(fO.On).class,fN.Watch().class);
    };
    this.Meta={
        link:function(x){x.forEach(function(y){window[y]=fN.Attr(fN.Tag(y).is(4)).href();});},
        meta:function(x){x.forEach(function(y){window[y]=fN.Attr(fN.Tag(y).is(7)).content();});}
    };
    this.screen={
        Full:{
            name:function(x){
                this.screen=x;
            },
            is:function(x){
                //this.screen.toggleClass('icon-screen-small');
                if(x){this.screen.addClass('icon-screen-small');}else{this.screen.removeClass('icon-screen-small');}
            }
        },
        Max:{
            name:function(x){
                this.screen=x;
            },
            is:function(x){
                //this.screen.toggleClass(config.css.active);
                if(x){this.screen.addClass(config.css.winActive);}else{this.screen.removeClass(config.css.winActive);}
            }
        },
        Status:function(){
            if(window.screenStatus){
                if(screenStatus.isFullscreen())z.screen.Full.is(true);
                if(screenStatus.isMaximized())z.screen.Max.is(true);
            }
        }
    };
    this.todo=function(){
        console.log('//TODO');
        /*
        fD.deleteDatabase().then(function(){
            console.log('DB deleted');
        });
        */
    };
};
function Action(){
    this.iQ=arguments[0]; this.obj=arguments[1];
    this.about={
        version:function(){
            $(h.div,{id:'popup',class:'version'}).append(
                $(h.div,{id:'window'}).append(
                    $(h.h1,{title:config.build}).text(config.name),
                    $(h.h2).text(config.version),
                    $(h.p).html(config.aboutcontent),
                    $(h.p,{id:'by'}).append($(h.a,{target:'_blank',href:config.developerlink}).text(config.developer)),
                    $(h.div,{id:'clickme'}).html('Ok').on(fO.Click,function(evt){
                        evt.stopImmediatePropagation(); $(this).parents('div').remove();
                    })
                )
            ).appendTo('body').on(fO.Click,function(evt){
                if(!$(evt.target).closest('#window').length)$('#clickme').effect( "highlight", {color:"#F30C10"}, 100 );
            });
        }
    };
    this.chapter={
        get:{
            next:function(){
                var bID=parseInt(fO.query.book), cID=parseInt(fO.query.chapter)+1;
                if(bible.info[bID].c<cID){
                    bID++; bID=(bID>66)?1:bID; cID=1;
                }
                return {book:bID,chapter:cID};
            },
            previous:function(){
                var bID=parseInt(fO.query.book), cID=parseInt(fO.query.chapter)-1;
                if(cID<1){ bID--; bID=(bID<1)?66:bID; cID=bible.info[bID].c;}
                return {book:bID,chapter:cID};
            }
        },
        text:function(x){
            var q=this.get[x](), lD=fO.lang[fO.query.bible];
            return lD.l.BFVBC.replace(/{b}/,lD.b[q.book]).replace(/{c}/,fN.Num(q.chapter));
        },
        nameCurrent:function(e){
            e.html(fN.Num(fO.query.chapter));
            if(fO.todo.ActiveChapter){
                //TODO if(fO.isCordova)-> REMOVE or empty it container
                fO.todo.ActiveChapter.addClass(config.css.active).promise().done(function(){
                    delete fO.todo.ActiveChapter;
                });
            }
        },
        nameNext:function(e){
            e.attr('title',this.text('next'));
        },
        namePrevious:function(e){
            e.attr('title',this.text('previous'));
        },
        list:function(e){
            var x=$(e.target), container=x.parent().children().eq(1);
            if(container.is(':hidden')){
                x.addClass(config.css.active);
                fN.Menu(fO.query.book).Chapter().appendTo(container.fadeIn(200).find(fN.is(fN.Attr(x).class()[1]).id).empty()).promise().done(function(){
                    this.children().on(fO.Click,function(){
                        fO.todo.ActiveChapter=$(this);
                    });
                    fN.Click(function(y){
                        if(fN.Container.Closest(container,y,x))fN.Container.FadeOut(container,x);
                    });
                });
            }else{
                fN.Container.FadeOut(container,x);
            }
        },
        next:function(){
            fN.Go(fN.Page(2),this.get.next());
        },
        previous:function(){
            fN.Go(fN.Page(2),this.get.previous());
        },
        book:function(bID){
            //TODO
            return $(h.span).html(fN.Num(bible.info[bID].c)).on(fO.Click,function(){
                var container=$(this).parent().parent();
                if(container.children('ol').length){
                    container.children().eq(1).fadeOut(300).remove();
                    $(this).removeClass(config.css.active);
                }else{
                    fN.Menu(bID).Chapter().appendTo(container).promise().done($(this).addClass(config.css.active));
                }
            });
        }
    };
    this.lookup={
        setting:function(e){
            var x=$(e.target), container=x.parents('div').children().eq(1);
            if(container.is(':hidden')){
                x.addClass(config.css.active);
                fN.Menu(container.fadeIn(200).find(fN.is(fN.Attr(x).class()[1]).id).empty()).Lookup().promise().done(function(){
                    fN.Click(function(y){
                        if(fN.Container.Closest(container,y,x))fN.Container.FadeOut(container,x);
                    });
                });
            }else{
                fN.Container.FadeOut(container,x);
            }
        },
        msg:function(e){
            fO.msg.lookup=e; if(fO.query.result > 0){e.text(fN.Num(fO.query.result)).attr('title',fO.query.q);}else{e.empty();}
        }
    };
    this.container={
        msg:function(e){
            fO.msg.info=e;

        },
        title:function(e){
            fO.msg.title=e;
            e.html(fO.lang[fO.query.bible].l.BFVBC.replace(/{b}/,fO.lang[fO.query.bible].b[fO.query.book]).replace(/{c}/,fN.Num(fO.query.chapter)));
        }
    };
    this.Mobile={
        //MOBILE
        Common:function(x,callback){
            x.off().on(fO.Click,function(){
                if(x.hasClass(config.css.active)){
                    fN.Done();
                }else{
                    fN.Working(callback());
                    if(fO.todo.ActiveTab)fO.todo.ActiveTab.removeClass(config.css.active);
                    fO.todo.ActiveTab=x;
                }
                x.toggleClass(config.css.active);
            }).removeClass(config.css.active);
        },
        Testament:function(e){
            e.children().each(function(index,x){
                var container=$(x).children(), id=index+1;
                if(fO.query.testament===id)container.addClass(config.css.active);
                container.html(fO.lang[fO.query.bible].t[id]).on(fO.Click,function(){
                    e.children(x).children().removeClass(config.css.active).eq(index).addClass(config.css.active).promise().done(function(){
                        fO.container.main.find('ol.testament').hide().eq(index).fadeIn(300);
                    });
                });
            }).promise().done(function(){
                //fO.container.main.find('ol.testament').eq((fO.query.testament-1<=0)?1:0).hide();
                fO.container.main.children().children().eq((fO.query.testament-1<=0)?1:0).hide();
                //this.find('ol.testament').hide().eq(fO.query.testament-1).show();
                //fO.container.main.promise().done(function(){});
            });
        },
        Parallel:function(e){
            //DONE - DESIGN REQUIRED
            this.Common(e,function(){
                var p=fN.Page(2);
                return {
                    msg:fN.Menu($(h.ol,{class:'row row-parallel'})).Bible(function(Om){
                        return $(h.li).html($(h.p).append(
                            $(h.span,{class:Om.isAvailable}), $(h.a,{href:p+$.param({bible:Om.bID})}).html(Om.lang.name)
                        ));
                    })
                };
            });
        },
        Chapter:function(e){
            //DONE - DESIGN REQUIRED
            this.Common(e,function(){
                return {
                    msg:fN.Menu(fO.query.book).Chapter()
                };
            });
        },
        Bookmark:function(e){
            this.Common(e,function(){
                return {
                    msg:$(h.div).html('Bookmark<br>a')
                };
            });
        },
        LookUp:function(e){
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
        var j=$(), o=this.obj;
        $.each(this.iQ[0], function(key,v){
            (function f(k,item,container,x){
                var attr=item.attr,child=item.text,y=false,tag=$(o.is(k).tag,attr);
                if(attr && attr.fn){y=item.attr.fn.split(' '); delete attr.fn;}
                if($.type(child) === 'string'){
                    tag.html(child);
                }else if(item.value){
                    tag.val(item.value);
                }else if(!child){
                }else{
                    for(i in child){
                        if($.isNumeric(i)){
                            var k=Object.keys(child[i]); f(k,child[i][k], tag);
                        }else{
                            f(i,child[i], tag);
                        }
                    }
                }
                if(y && Object.prototype.hasOwnProperty.call(o, "Watch"))o.Watch(y).go(tag);
                if(x){j=container.add(tag);}else{container.append(tag);}
            })(key,v, j,true);
        });
        if(dl){($.type(dl) !== 'object'?$(dl):dl)[position||'append'](j);}
        return j;
    };
    this.Hash=function(callback){
        var q=location.hash,r={page:q.split("?")[0].replace('#','')}, m, search=/([^\?#&=]+)=([^&]*)/g, d=function(s){ return decodeURIComponent(s.replace(/\+/g," ")); };
        while(m = search.exec(q)) r[d(m[1])]=d(m[2]);
        callback(r);
    };
};
fN=new Utility();
fN.__proto__={
    Index:function(){
        config.bible.available=[];
        $.map(fO.lang, function(e, i) {
          return {id:i,index:e.index};
        }).sort(function (a, b){
            return a.index - b.index;
        }).forEach(function(e){
            config.bible.available.push(e.id);
        });
    },
    Num:function(n,l){
        if(!l)l=fO.query.bible;
        return (Object.getOwnPropertyNames(fO.lang[l].n).length === 0)?n:n.toString().replace(/[0123456789]/g,function(s){return fO.lang[l].n[s];});
        //return $.isEmptyObject(fO.lang[l].n)?n:n.toString().replace(/[0123456789]/g,function(s){return fO.lang[l].n[s];});
        //Percentage.Num(fO.lang[l].n)
        //$.isEmptyObject(o)?this:this.toString().replace(/[0123456789]/g,function(s){return o[s];});
    },
    Url:function(l,x,y){
        var Url=this.String([l,47,x.join('/'),46,y]), Filename=Url.substring(Url.lastIndexOf('/')+1), Type=this.String(['application',47,y]), Path=null, Local=null;
        if(fO.isCordova){Path=cordova.file.dataDirectory; Local=cordova.file.dataDirectory+Filename;}
        return {url:Url,data:y,content:Type+';charset=utf-8',filename:Filename,type:Type,path:Path,local:Local};
    },
    Working:function(q){
        if(fO.msg.info.is(":hidden")){$('body').addClass(config.css.working).promise().done(fO.msg.info.slideDown(200));}
        if(q.wait===true){$('body').addClass(config.css.wait);}
        if(q.disable===true){$('body').addClass(config.css.disable);}
        return (q.msg)?fO.msg.info.html(q.msg):fO.msg.info;
    },
    Done:function(callback){
        var o=this;
        fO.msg.info.slideUp(200).empty().promise().done(function(){
            o.Body().promise().done(function(){
                if(callback)callback();
            });
        });
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
        if(config.header[fO.query.page]){
            if(fO.todo.headerChanged !=fO.query.page){
                container.replaceWith(fN.fN({header:config.header[fO.query.page]}).Content()).promise().done(function(){
                    fO.todo.headerChanged=fO.query.page;
                    container.find(config.css.currentPage).addClass(config.css.active).siblings().removeClass(config.css.active);
                    //z.screen.Status();
                    fO.todo.Orientation=true;
                });
            }
        }else if(fO.todo.headerChanged){
            container.replaceWith(fN.fN({header:config.body.header}).Content()).promise().done(function(){
                delete fO.todo.headerChanged;
                container.find(config.css.currentPage).addClass(config.css.active).siblings().removeClass(config.css.active);
                //z.screen.Status();
                fO.todo.Orientation=true;
            });
        }else{
            this.ActiveClass(container);
        }
    },
    Footer:function(container){
        if(config.footer[fO.query.page]){
            if(fO.todo.footerChanged !=fO.query.page){
                container.replaceWith(fN.fN({footer:config.footer[fO.query.page]}).Content()).promise().done(function(){
                    fO.todo.footerChanged=fO.query.page;
                    $(config.css.currentPage).addClass(config.css.active);
                    fO.todo.Orientation=true;
                });
            }
        }else if(fO.todo.footerChanged){
            container.replaceWith(fN.fN({footer:config.body.footer}).Content()).promise().done(function(){
                delete fO.todo.footerChanged;
                $(config.css.currentPage).addClass(config.css.active);
                fO.todo.Orientation=true;
            });
        }else{
            this.ActiveClass(container);
        }
    },
    ActiveClass:function(container){
        container.find(fN.is(config.css.active).class).removeClass(config.css.active).promise().done($(config.css.currentPage).addClass(config.css.active));
    }
};
fN.__proto__.Container={
    Closest:function(container,x,y){
        if(container.is(':visible') && !$(x.target).closest('#popup, .win').length && !$(x.target).closest(container).length && !$(x.target).closest(y).length) return true;
    },
    FadeOut:function(container,x,y){
        container.fadeOut(1).promise().done(function(){
            x.removeClass(config.css.active); if(y)y.removeAttr("style");
        });
    }
};
fN.__proto__.Menu=function(Oq){
    return {
        Bible:function(callback){
            config.bible.available.forEach(function(id){
                var Om={bID:id,lang:fO.lang[id].info,local:fO.lang[id].local,classOffline:'icon-ok offline',classOnline:'icon-logout offline'};
                Om.classAvailable=Om.local?config.css.available:config.css.notAvailable;
                Om.isAvailable=(Om.local?Om.classOffline:Om.classOnline);
                Om.classActive=(fO.query.bible==id?config.css.active:'')+' '+Om.classAvailable;
                callback(Om).appendTo(Oq);
            }); return Oq;
        },
        Chapter:function(){
            var ol=$(h.ol,{class:'list-chapter'});
            $.each(bible.info[Oq].v,function(chapter,verse){
                chapter++;
                $(h.li,{id:chapter,class:(fO.query.chapter==chapter?config.css.active:'')}).append(
                    $(h.a,{href:fN.Page(2)+$.param({chapter:chapter})}).html(fN.Num(chapter)).append(
                        $(h.sup).html(fN.Num(verse))
                    )
                ).appendTo(ol);
            }); return ol;
        },
        Lookup:function(){
            var O2={
                Query:function(o){
                    o.each(function(){
                        var ol=$(this);
                        ol.children().each(function(a,y){
                            var y=$(y), id=fN.Attr(y).id()[0]; y.toggleClass(config.css.active); O2.ID(id);
                        }).promise().done(function(){
                            O2.Class(ol);
                        });
                    });
                },
                Click:function(e,o){
                    var x=$(e.target);
                    if(x.get(0).tagName.toLowerCase()==='p'){
                        this.Query(o);
                    }else{
                        var li=x.parents('li'),sID=li.attr('id'); o.fadeToggle(100);
                        x.toggleClass(config.css.active).promise().done(function(){
                            if(this.hasClass(config.css.active)){
                                fO.lookup.setting[sID]=true;
                            }else{
                                delete fO.lookup.setting[sID];
                            }
                        });
                    }
                    fD.UpdateLookUp();
                },
                Class:function(o){
                    var total=o.children().length, active=o.children(fN.is(config.css.active).class).length, catalog=o.parent().children().eq(0);
                    if(total===active){
                        catalog.removeClass().addClass('yes');
                    }else if(active>0){
                        catalog.removeClass().addClass('some');
                    }else{
                        catalog.removeClass().addClass('no');
                    }
                },
                ID:function(id){
                    if(fO.lookup.book[id]){
                        delete fO.lookup.book[id];
                    }else{
                        fO.lookup.book[id]={};
                    }
                }
            },
            container=$(h.ol,{class:'list-lookup'}).appendTo(Oq), lD=fO.lang[fO.query.bible];
            $.each(bible.catalog,function(tID,cL){
                var tTD=Object.keys(config.language)[0]+tID, tClass=(fO.lookup.setting[tTD]?config.css.active:'testament');
                $(h.li,{id:tTD,class:tClass}).html(
                    $(h.p,{text:lD.t[tID]}).on(fO.Click,function(e){
                        O2.Click(e,$(this).parent().children('ol').find('ol'));
                    }).append(
                        $(h.span).text('+').addClass(tClass)
                    )
                ).appendTo(container).promise().done(function(){
                    $(h.ol,{class:'section'}).appendTo(this).promise().done(function(){
                        var it=this;
                        $.each(cL,function(sID,bL){
                            var sTD=Object.keys(config.language)[1]+sID, sClass=(fO.lookup.setting[sTD]?config.css.active:'');
                            $(h.li,{id:sTD,class:sClass}).append(
                                $(h.p,{text:lD.s[sID]}).on(fO.Click,function(e){
                                    O2.Click(e,$(this).parent().children('ol'));
                                }).append(
                                    $(h.span,{text:'+'}).addClass(sClass)
                                )
                            ).appendTo(it).promise().done(function(){
                                var ol=$(h.ol,{class:'book'}).appendTo(this);
                                bL.forEach(function(bID){
                                    $(h.li,{id:bID,class:(fO.lookup.book[bID]?config.css.active:'')}).text(lD.b[bID]).on(fO.Click,function(){
                                        $(this).toggleClass(config.css.active); O2.ID(bID); fD.UpdateLookUp();
                                    }).appendTo(ol);
                                });
                                ol.promise().done(function(){
                                    O2.Class(ol);
                                });
                            });
                        });
                    });
                });
            });
            return container;
        },
        Note:function(){
            console.log('Menu.Note()');
        }
    };
};
fN.__proto__.Regex=function(q){
    var name=fO.lang[q.bible].name,info=bible.info,book,chapter,Start,End, setting={book:";",chapter:",",verse:"-"};
    return {
        result:{},
        search:function(e){
            var y;
            for(var i in name){
                var x=name[i].map(function(value){
                    return value.toLowerCase();
                }).indexOf(e.trim().toLowerCase());
                if(x >= 0){ y=i; break; }
            }
            return parseInt(y);
        },
        options:function(){
            if(!this.result[book])this.result[book]={};
            if(chapter <=info[book].c){
                var Verses=info[book].v[chapter-1];
                if(!this.result[book][chapter])this.result[book][chapter]=[];
                if(Start && End){
                    var vs=(Start <= Verses)?Start:Verses,ve=(End <= Verses)?End:Verses;
                    for (i = vs; i < ve+1; i++) { this.push(this.result[book][chapter],i); }
                }else if(Start){
                    this.push(this.result[book][chapter],(Start <= Verses)?Start:Verses);
                }
            }else if(Object.getOwnPropertyNames(this.result[book]).length === 0){
                delete this.result[book];
            }
        },
        push:function(o,i){
            if(o.indexOf(i) <= 0){
                o.push(i); o.sort( function(a,b) { return a > b ? 1 : a < b ? -1 : 0; } );
            }
        },
        nameVerse:function(e){
            var verse;
            var dashed=function(str,n){
                var d=(str.toString().slice(-1)!=setting.verse)?setting.verse:'';
                return str+d+n;
            };
            e.filter(function(v, k, a){
                var c=parseInt(v), o=parseInt(a[k-1]), n=parseInt(a[k+1]);
                if(k==0){
                    verse=c;
                }else if(c>=(o+1)){
                    if(c>(o+1)){
                        verse=verse+setting.chapter+c;
                    }else if((c+1)<n){
                        verse=dashed(verse,c);
                    }else{
                        if(k==a.length-1){
                            if(c>o){
                                verse=dashed(verse,c);
                            }
                        }else{
                            verse=dashed(verse,'');
                        }
                    }
                }
            });
            return verse;
        },
        //obj, object
        obj:function(e){
            for(var b in e) {
                book=b;
                for(var c in e[b]) {
                    chapter=c;
                    for(var v in e[b][c]) {
                        var R=e[b][c][v].split(setting.verse);
                        Start=parseInt(R[0]),End=(R.length>1)?parseInt(R[1]):false;
                        this.options();
                    }
                }
            }
            return this;
        },
        //ref,reference
        ref:function(e){
            if(!Array.isArray(e))e=e.split(setting.book);
            for(var i in e) {
                var R=/(((\w+)\.(\d+)\.(\d+))([\-–]?)?((\w+)\.(\d+)\.(\d+))?)/.exec(e[i]);
                if(Array.isArray(R)){
                    book=this.search(R[3]);
                    if(book){ chapter=parseInt(R[4]),Start=parseInt(R[5]),End=parseInt(R[10]); this.options();}
                }
            }
            return this;
        },
        //str, string
        str:function(e){
            if(!Array.isArray(e))e=e.split(setting.book);
            for(var i in e) {
                if(e[i]){
                    var c=e[i].trim().split(setting.chapter);
                    for (var x in c) {
                        if(x==0){
                            var R=/(\d?(\w+?)?(\s?)\w+(\s+?)?(\s?)\w+(\s+?))?((\d+)((\s+)?\:?(\s+)?)?)((\d+)([\-–])?(\d+)?)?/.exec(c[x]);
                            if(R && R[1]){
                                book=this.search(R[1]);
                                if(book){ chapter=parseInt(R[8]),Start=parseInt(R[13]),End=parseInt(R[15]); this.options();}
                                else{ break; }
                            }else{ break; }
                        }else if(book){
                            var R=/(\s?(\d+?)(\s+)?\:(\s+)?)?(\s?\d+)?(\s?(\d+?)?([\-–])?(\s?\d+)?)/.exec(c[x]);
                            if(R){ chapter=parseInt(R[2])||chapter,Start=parseInt(R[5]), End=parseInt(R[9]); this.options();}
                            else{break;}
                        }
                    }
                }
            }
            return this;
        },
        is:function(e){
            if(Object.getOwnPropertyNames(this.str(e).result).length > 0){
                return this.result;
            }else if(Object.getOwnPropertyNames(this.ref(e).result).length > 0){
                return this.result;
            }
        }
    };
};
fD=new Database();

};})(jQuery,navigator.userAgent);
