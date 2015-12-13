{


screen:{
    Full:{
        name:function(x){
                this.screen=x;
        },
        is:function(is){
                //this.screen.toggleClass('icon-screen-small');
                if(is){this.screen.addClass('icon-screen-small');}else{this.screen.removeClass('icon-screen-small');}
        }
    },
    Max:{
        name:function(x){
                this.screen=x;
        },
        is:function(is){
                //this.screen.toggleClass(config.css.active);
                if(is){this.screen.addClass(config.css.winActive);}else{this.screen.removeClass(config.css.winActive);}
        }
    },
    Status:function(){
            if(window.screenStatus){
                    if(screenStatus.isFullscreen())z.screen.Full.is(true);
                    if(screenStatus.isMaximized())z.screen.Max.is(true);
            }		
    }
},

menu:{
    bible:function(container,callback){
        config.bible.available.forEach(function(bID){
            var lang=fO.lang[bID].info, isLocal=fO.lang[bID].local, availableClass=(isLocal)?config.css.available:config.css.notAvailable,
            offlineClass='icon-ok offline',onlineClass='icon-logout offline', isAvailable=(isLocal)?offlineClass:onlineClass,
            activeClass=(fO.query.bible===bID)?config.css.active+' '+availableClass:availableClass;
            callback(bID,lang,isLocal,availableClass,offlineClass,onlineClass,isAvailable,activeClass).appendTo(container);
        });
        return container;
    },
    chapter:function(bID){
        var container=$(h.ol,{class:'list-chapter'});
        $.each(bible.info[bID].v,function(chapter,verse){
            chapter++;
            $(h.li,{id:chapter,class:(fO.query.chapter==chapter?config.css.active:'')}).append(
                $(h.a,{href:z.utility.Page(2)+$.param({chapter:chapter})}).html(z.utility.Num(chapter)).append(
                    $(h.sup).html(z.utility.Num(verse))
                )
            ).appendTo(container);
        });
        return container;
    },
    lookup:function(container){
        var fn={
            Query:function(o){
                o.each(function(){
                    var ol=$(this);
                    ol.children().each(function(a,y){
                        var y=$(y), id=z.get(y).id()[0]; y.toggleClass(config.css.active); fn.ID(id);
                    }).promise().done(function(){
                        fn.Class(ol);
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
                db.UpdateLookUp();
            },
            Class:function(o){
                var total=o.children().length, active=o.children(z.is(config.css.active).class).length, catalog=o.parent().children().eq(0);
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
        }, container=$(h.ol,{class:'list-lookup'}).appendTo(container), lD=fO.lang[fO.query.bible];
        $.each(bible.catalog,function(tID,cL){
            var tTD=Object.keys(config.language)[0]+tID, tClass=(fO.lookup.setting[tTD]?config.css.active:'testament');
            $(h.li,{id:tTD,class:tClass}).html(
                $(h.p,{text:lD.t[tID]}).on(fO.Click,function(e){
                    fn.Click(e,$(this).parent().children('ol').find('ol'));
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
                                fn.Click(e,$(this).parent().children('ol'));
                            }).append(
                                $(h.span,{text:'+'}).addClass(sClass)
                            )
                        ).appendTo(it).promise().done(function(){
                            var ol=$(h.ol,{class:'book'}).appendTo(this);
                            bL.forEach(function(bID){
                                $(h.li,{id:bID,class:(fO.lookup.book[bID]?config.css.active:'')}).text(lD.b[bID]).on(fO.Click,function(){
                                    $(this).toggleClass(config.css.active); fn.ID(bID); db.UpdateLookUp();
                                }).appendTo(ol);
                            });
                            ol.promise().done(function(){
                                fn.Class(ol);
                            });
                        });
                    });
                });
            });
        });
        return container;
    },
    note:function(){

    }
},
content:function(q){
    var lD=fO.lang[q.bible], fn={
        xml:function(callback){
            var o=z.utility.Url(config.id,[q.bible],config.file.bible);
            var xml={
                read:function(){
                    // TODO
                    if($.isEmptyObject(fO[q.bible].bible)){
                        if(fO.isCordova){
                            z.resolveFileSystem(o.local,xml.local.reading, function(error){
                                xml.done.getting({msg:'to Local',status:false});
                            });
                        }else{
                            db.get({table:q.bible}).then(function(storeBible){
                                if(storeBible){
                                    if($.isEmptyObject(storeBible)){
                                        xml.done.getting({msg:'to Store',status:false});
                                    }else{
                                        if(q.reading==q.bible){
                                            fO[q.bible].bible=storeBible; xml.done.getting({msg:'from Store',status:true});
                                        }else{
                                            xml.done.getting({msg:'to Store',status:true});
                                        }
                                    }
                                }else{
                                    xml.done.getting({msg:'to Store',status:false});
                                }
                            });
                        }
                    }else{
                        xml.done.getting({msg:'from Object',status:true});
                    }
                },
                remove:function(){
                    if(fO.isCordova){
                        z.resolveFileSystem(o.local,xml.local.removing, function(error){
                            xml.done.removing({status:true});
                        });
                    }else{
                        db.delete({table:q.bible}).then(function(){
                            xml.done.removing({status:true});
                        });
                    }
                },
                get:function(){
                    if($.isEmptyObject(fO[q.bible].bible)){
                        if(fO.isCordova){
                            z.utility.Working({msg:lD.l.PleaseWait,wait:true}).promise().done(function(){
                                z.resolveFileSystem(o.local, xml.local.getting, xml.local.downloading)
                            });
                        }else{
                            db.get({table:q.bible}).then(function(storeBible){
                                if(storeBible){
                                    fO[q.bible].bible=storeBible;
                                    if($.isEmptyObject(fO[q.bible].bible)){
                                        xml.load();
                                    }else{
                                        xml.done.getting({msg:'from Store',status:true});
                                    }
                                }else{
                                    xml.load();
                                }
                            });
                        }
                    }else{
                        callback({msg:'from Object',status:true});
                    }
                },
                load:function(x){
                    $.ajax({
                        //headers:{}, xhrFields:{"withCredentials": true},
                        beforeSend:function(xhr){
                            z.utility.Working({msg:lD.l.Downloading,wait:true});
                            xhr.setRequestHeader("Access-Control-Allow-Origin", "*");
                        },
                        xhr:function(){
                            var xhr=new window.XMLHttpRequest();
                            xhr.addEventListener("progress", function(evt){
                                if(evt.lengthComputable) {
                                    var Percentage=Math.floor(evt.loaded / evt.total * 100);
                                    z.utility.Working({msg:lD.l.PercentLoaded.replace(/{Percent}/, z.utility.Num(Percentage))});
                                }
                            }, false);
                            /*
                            //Upload progress
                            XMLHttpRequest.upload.addEventListener("progress", function(evt){
                                if(evt.lengthComputable) {
                                    var Percent=Math.floor(evt.loaded / evt.total * 100);
                                    z.utility.Working({
                                        msg:lD.l.PercentLoaded.replace(/{Percent}/, z.utility.Num(Percentage)),
                                        class:true
                                    });
                                }
                            }, false); 
                            */
                            return xhr;
                        },
                        url:(x)?x+o.url:o.url,dataType:o.data,contentType:o.content,cache:false,crossDomain:true,async:true
                    }).done(function(j, status, d){
                        xml.jobType(j);
                    }).fail(function(jqXHR, textStatus){
                        if(api){
                            if(x){
                                xml.done({msg:textStatus,status:false});
                            }else{
                                xml.load(api);
                            }
                        }else{
                            xml.done({msg:textStatus,status:false});
                        }
                    }).always(function(){});
                },
                local:{
                    downloading:function(){
                        z.utility.Working({msg:lD.l.Downloading});
                        var fileTransfer = new FileTransfer();
                        fileTransfer.onprogress=function(evt) {
                            if(evt.lengthComputable){
                                var Percentage = Math.floor(evt.loaded / evt.total * 100);
                                z.utility.Working({msg:lD.l.PercentLoaded.replace(/{Percent}/, z.utility.Num(Percentage))});
                            }
                        };
                        fileTransfer.download(encodeURI(api+o.url), o.local, xml.local.content, function(error){
                            xml.done.getting({msg:error.code,status:false});
                        });
                    },
                    content:function(fileEntry,error){
                        fileEntry.file(function(file) {
                            //file.name, file.localURL, file.type, new Date(file.lastModifiedDate), file.size
                            var reader=new FileReader();
                            reader.onloadend=function(e){
                                var parser=new DOMParser();
                                xml.jobType(parser.parseFromString(e.target.result,o.type));
                            };
                            reader.readAsText(file);
                        },function(){
                            xml.done.getting({msg:'fail to read Local',status:false});
                        });
                    },
                    reading:function(fileEntry){
                        if(q.reading==q.bible){
                            xml.local.content(fileEntry);
                        }else{
                            xml.done.getting({msg:'from Reading',status:true});
                        }
                    },
                    removing:function(fileEntry){
                        fileEntry.remove(function() {
                            xml.done.removing({status:true});
                        },function(error){
                            xml.done.removing({status:false});
                        });
                    },
                    getting:function(fileEntry){
                        xml.local.content(fileEntry);
                    }
                },
                jobType:function(j){
                    var jobType=$(j).children().get(0).tagName;
                    if($.isFunction(this.job[jobType])){
                        fO[q.bible].bible={info:{},book:{}};
                        this.job[jobType](j);
                    }else{
                        this.done.getting({msg:'no '+jobType+' Method found',status:false});
                    }
                },
                job:{
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
                                                                            xml.done.getting({msg:'Localed',status:true});
                                                                        }else{
                                                                            db.put({table:q.bible,data:fO[q.bible].bible}).then(xml.done.getting({msg:'Stored',status:true}));
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
                                                MsgInfo.html(lD.b[i2]);
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
                },
                done:{
                    getting:function(response){
                        fO.lang[q.bible].local=response.status;
                        if(q.reading){
                            callback(response);
                        }else{
                            db.UpdateLang().then(function(){
                                callback(response); z.utility.Done();
                            });
                        }
                    },
                    removing:function(response){
                        delete fO[q.bible].bible;
                        if(response.status)fO.lang[q.bible].local=false;
                        db.UpdateLang().then(function(){
                            callback(response);
                        });
                    }
                }
            }; return xml;
        },
        msg:function(m){
            console.log(m);
        },
        get:function(callback){
            var obj={
                data:function(callback){
                    return callback(fn,this);
                },
                result:{book:0,chapter:0,verse:0,str:''},
                verseMerged:function(list,vID){
                    return $(list).map(function(t,i){
                        var v1=vID, v2=v1.split('-');
                        if(v1==i){ return i;}else if(v2.length>1 && v2[0] <= i && v2[1] >= i){ return i;} 
                    }).get();
                },
                search:function(str,nQ){
                    //TODO
                    if($.type(nQ) === "string"){
                        if(str.search(new RegExp(nQ, "gi")) > -1)return true;
                    }else{
                        return true;
                    }
                },
                replace:function(str,nQ){
                    //TODO str.replace(/(([^\s]+\s\s*){20})(.*)/,"$1…")
                    if($.type(nQ) === "string"){
                        return str.replace(new RegExp(nQ, "i"), '<b>$&</b>');
                    }else{
                        return str;
                    }
                },
                booklistID:function(){
                    return Object.keys(this.booklist);
                },
                booklistName:function(o){
                    return $.map(o, function(i) {
                        return fO.lang[q.bible].b[i];
                    });
                },
                queryRegex:function(){
                    return this.booklist=z.regex(q).is(q.q);
                },
                queryBook:function(){
                    if(Object.getOwnPropertyNames(fO.lookup.book).length > 0){
                        this.booklist={}; 
                        $.each(fO.lookup.book,function(bID,d){
                            obj.booklist[bID]={};
                            if($.isEmptyObject(d)){
                                $.each(bible.info[bID].v,function(cID,f){
                                    cID++;
                                    obj.booklist[bID][cID]=[];
                                });
                            }else{
                                obj.booklist[bID]=d;
                            }
                        });
                        return this.booklist;
                    }
                },
                queryChapter:function(){
                    this.booklist={};
                    this.booklist[q.book]={};
                    this.booklist[q.book][q.chapter]=[];
                    return this.booklist;
                },
                queryCheck:function(){
                    if(q.booklist){
                        this.booklist=q.booklist;
                        delete q.booklist;
                        return this.booklist;
                    } else if(this.queryRegex()){
                        return this.booklist;
                    } else if(this.queryBook()){
                        return this.booklist;
                    } 
                },
                bible:function(dQ){
                    var Def = new $.Deferred();
                    var i=0, total=Object.keys(dQ).length;
                    $.each(dQ,function(bID,data){
                        setTimeout(function(){
                            var book=fO[q.bible].bible.book[bID];
                            if(book){
                                if(fO.todo.pause)return MsgInfo.text(fO.lang[q.bible].l.Paused);
                                obj.chapter(book,bID,data,function(cID,vID,verse,list){
                                    var df = new $.Deferred();
                                    callback(fn,obj,bID,cID,vID,verse,list).progress(function(){
                                        df.notify();
                                    }).done(function(){
                                        df.resolve();
                                    });
                                    return df.promise();
                                }).progress(function(){
                                    Def.notify();
                                }).done(function(){
                                    i++;
                                    if(total==i)Def.resolve();
                                });
                            }else{
                                i++;
                                Def.notify();
                                if(total==i)Def.resolve();
                            }
                        },(200/total*i));
                    });
                    return Def.promise();
                },
                chapter:function(book,bID,list,callback){
                    var Def = new $.Deferred();
                    var i=0, total=Object.keys(list).length;
                    $.each(list,function(cID,data){
                        setTimeout(function(){
                            var chapter=book.chapter[cID];
                            if(chapter){
                                if(fO.todo.pause)return MsgInfo.text(fO.lang[q.bible].l.Paused);
                                Def.notify();
                                obj.verse(chapter,bID,cID,data,function(vID,verse,list){
                                    var df = new $.Deferred();
                                    callback(cID,vID,verse,list).progress(function(){
                                        df.notify();
                                    }).done(function(){
                                        df.resolve();
                                    });
                                    return df.promise();
                                }).progress(function(){
                                    Def.notify();
                                }).done(function(){
                                    i++;
                                    if(total == i)Def.resolve();
                                });
                            }else{
                                i++;
                                Def.notify();
                                if(total==i)Def.resolve();
                            }
                        },100/total*i);
                    });
                    return Def.promise();
                },
                verse:function(chapter,bID,cID,list,callback){
                    var Def = new $.Deferred();
                    var i=0, total = Object.keys(chapter.verse).length;
                    $.each(chapter.verse,function(vID,verse){
                        setTimeout(function(){
                            Def.notify();
                            i++;
                            callback(vID,verse,list).progress(function(){
                                Def.notify();
                            }).done(function(){
                                if(total == i)Def.resolve();
                            });
                        },(50/total*i));
                    });
                    return Def.promise();
                }
            }; return obj;
        },
        option:function(container){
            return {
                parallel:function(callback){
                    return $(h.span,{class:'icon-language'}).on(fO.Click,function(event){
                        var e=$(event.target), li=e.parent(), ul=li.children().eq(1), y=li.attr('class');
                        if(ul.length){
                            ul.fadeOut(200).remove();
                        }else{
                            /*

                            ul=$(h.ul,{class:'parallel'}).appendTo(li);
                            config.bible.available.forEach(function(i){
                                var ic=z.is(i).class;
                                $(h.li,{class:(y===i)?config.css.active:(container.children(ic).length)?'has':i}).html(fO.lang[i].info.name).on(fO.Click,function(){
                                    callback($(this),i,ic);
                                }).appendTo(ul);
                            });
                            */
                            ul=$(h.ul,{class:'parallel'}).appendTo(li);
                            z.menu.bible(ul,function(bID,lang,isLocal,availableClass,offlineClass,onlineClass,isAvailable){
                                var ic=z.is(bID).class;
                                return $(h.li,{class:(y===bID)?config.css.active:(container.children(ic).length)?'has':bID}).html(lang.name).on(fO.Click,function(){
                                    callback($(this),lang.name,ic);
                                });
                            });
                            z.utility.Click(function(evt){
                                if(!$(evt.target).closest(li).length)ul.remove();
                            });
                        }
                    });
                },
                reference:function(data){
                    var li=$(h.li,{class:'ref'}).appendTo(container), reference=z.regex(q).ref(data).result; 
                    $.each(reference,function(bID,ref){
                        $.each(ref,function(cID,vID){
                            $(h.a).html(lD.l.BFBCV.replace(/{b}/, lD.b[bID]).replace(/{c}/, z.utility.Num(cID)).replace(/{v}/,z.utility.Num(z.regex(q).nameVerse(vID)))).on(fO.Click,function(){
                                $.extend(q,{ref:data}); fn.reference(li);
                            }).appendTo(li);
                        });
                    }); return li;
                },
                note:function(){
                    return $(h.span,{class:'icon-pin active'}).on(fO.Click,function(event){
                        var x=$(event.target), li=x.parent(), ul=li.children().eq(1);
                        if(ul.length){
                            ul.fadeOut(200).remove();
                        }else{
                            var row=x.parents(z.is('cID').class), bID=z.get(row.parents(z.is('bID').class)).id()[0], cID=z.get(row).id()[0];
                            ul=$(h.ul,{class:'note'}).appendTo(li);
                            if(fO.note){
                                var notefn=function(){
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
                                                        db.UpdateNote().then(function(){
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
                            z.utility.Click(function(evt){
                                if(!$(evt.target).closest(li).length)ul.remove();
                            });
                        }
                    });
                }
            };
        },
        desktop:{
            MenuChapter:function(container){//o,container
                return $(h.ul).append(
                    $(h.li).addClass(fO.query.bible).append(
                        fn.option(container).parallel(function(li,i,ic){
                            var newChapter=container.children(ic), aP=container.children().length;
                            if(newChapter.length){
                                if(aP > 1){
                                    var oldClass=z.get(container).class()[2];
                                    container.removeClass(oldClass).addClass(oldClass.charAt(0)+(aP-1));
                                    newChapter.remove();
                                    li.removeClass('has');
                                    if(fO.previous.bible===i)fO.previous.bible=container.children().eq(0).attr('class');
                                }
                            }else{
                                fO.todo.containerEmpty=true; $.extend(fO.query,{bible:i}); li.addClass('has'); fn.chapter(container);
                            }
                        })
                    ),
                    $(h.li).append(fn.option(container).note())
                );
            },
            MenuLookUp:function(container){
                return $(h.ul).append(
                    $(h.li).append(fn.option(container).note())
                );
            },
            MenuNote:function(container){
                return $(h.ul).append(
                    $(h.li).append(fn.option(container).note())
                );
            }
        },
        tablet:{
        },
        mobile:{
        },
        chapter:function(container){
            var olb, olc, olv, ol; lD=fO.lang[q.bible];
            this.get(function(o,obj,bID,cID,vID,verse,list){
                var df = new $.Deferred();
                var bD=fO[q.bible].bible;
                var vID=vID.slice(1);
                var bookName=lD.b[bID], chapterName=z.utility.Num(cID), verseName=z.utility.Num(vID);
                var msg=lD.l.BFBCV.replace(/{b}/, bookName).replace(/{c}/, chapterName).replace(/{v}/,verseName);
                //MsgInfo.text(msg).promise().done(function(){});
                obj.result.verse++;
                if(obj.result.b!==bID){
                    obj.result.b=bID; obj.result.book++;
                    olb=$(h.ol).appendTo($(h.li,{id:bID,class:'bID'}).append(
                        $(h.div).append(
                            $(h.h2).text(bookName)
                        )
                    ).appendTo(ol));
                }
                if(obj.result.b!==bID || obj.result.c!==cID){
                    obj.result.c=cID; obj.result.chapter++;
                    olc=$(h.ol,{class:'verse'}).appendTo($(h.li,{id:cID,class:'cID'}).append(
                        $(h.div).append(
                            $(h.h3,{class:'no'}).text(chapterName).on(fO.Click,function(){
                                $(this).parents('li').children('ol').children().each(function(){
                                    if($(this).attr("id"))$(this).toggleClass(config.css.active);
                                });
                            }),
                            typeof o[fO.Deploy].MenuChapter === 'function' && o[fO.Deploy].MenuChapter(container)
                        )
                    ).appendTo(olb));
                }
                if(verse.title){
                    $(h.li,{class:'title'}).html(verse.title.join(', ')).appendTo(olc);
                }
                $(h.li,{id:vID,'data-verse':verseName}).html(obj.replace(verse.text,q.q)).appendTo(olc).on(fO.Click,function(){
                    $(this).toggleClass(config.css.active);
                }).promise().always(function(){
                    if(verse.ref){
                        o.option(olc).reference(verse.ref).promise().always(function(){
                            df.resolve();
                        });
                    }else{
                        df.resolve();
                    }
                });
                return df.promise();
            }).data(function(o,obj){
                o.xml(function(response){
                    if(response.status){
                        if(obj.queryChapter()){
                            var current_booklistId=obj.booklistID();
                            var current_booklist=current_booklistId.join();
                            var msg=lD.l.BFVBC.replace(/{b}/, lD.b[q.book]).replace(/{c}/, z.utility.Num(q.chapter));
                            if(fO.previous.bible===q.bible && fO.previous.booklist===current_booklist && fO.previous.chapter===q.chapter){
                                //console.log('PREVIOUS TASK');
                                //o.msg(msg);
                            }else{
                                if(fO.todo.containerEmpty){
                                    delete fO.todo.containerEmpty;
                                }else{
                                    container.empty();
                                }
                                ol=$(h.ol,{class:q.bible}).appendTo(container);
                                obj.bible(obj.booklist).progress(function(){
                                    //MsgLookup.text(z.utility.Num(obj.result.verse));
                                }).done(function(){
                                    fO.previous.booklist=current_booklist;
                                    fO.previous.bible=q.bible;
                                    fO.previous.book=q.book;
                                    fO.previous.chapter=q.chapter;
                                    //fO.query.result=obj.result.verse;
                                    //o.msg(msg);
                                    /*
                                    MsgLookup.attr('title',q.q).text(z.utility.Num(q.result)).promise().done(function(){
                                        if(!obj.result.verse){
                                            ol.addClass(config.css.deactivate).append(
                                                $(h.li).html(lD.l.IsNotFound.replace(/{is}/, q.q))
                                            );
                                        }
                                    });
                                    */
                                    if(!obj.result.verse){
                                        ol.addClass(config.css.deactivate).append(
                                            $(h.li).html(lD.l.IsNotFound.replace(/{is}/, q.q))
                                        );
                                    }
                                    container.promise().done(function(){
                                        var aP=this.children().length, oldClass=z.get(this).class()[2];
                                        $(this).removeClass(oldClass);
                                        $(this).addClass(oldClass.charAt(0)+aP);
                                    });
                                }).always(function(){
                                    if(z.analytics)z.analytics.sendEvent({bible:q.bible,key:q.book,result:q.chapter});
                                });	
                            }
                        }
                    }
                }).get();
            });
        },
        lookup:function(container){
            var olb, olc, olv, ol, nQ=(z.regex(q).is(q.q))?'':q.q, lD=fO.lang[q.bible];
            this.get(function(o,obj,bID,cID,vID,verse,list){
                var df = new $.Deferred();
                var bD=fO[q.bible].bible;
                var vID=vID.slice(1);
                var bookName=lD.b[bID], chapterName=z.utility.Num(cID), verseName=z.utility.Num(vID);
                MsgInfo.text(lD.l.BFBCV.replace(/{b}/, bookName).replace(/{c}/, chapterName).replace(/{v}/,verseName)).promise().done(function(){
                    if(list.length){
                        var tmpid=obj.verseMerged(list,vID);
                    }else{
                        var tmpid=[vID];
                    }
                    if(tmpid.length && obj.search(verse.text,nQ)){
                        obj.result.verse++;
                        if(obj.result.b!==bID){
                            obj.result.b=bID; obj.result.book++;
                            olb=$(h.ol).appendTo($(h.li,{id:bID,class:'bID'}).append(
                                $(h.div).append(
                                    $(h.h2).text(bookName)
                                )
                            ).appendTo(ol));
                        }
                        if(obj.result.b!==bID || obj.result.c!==cID){
                            obj.result.c=cID; obj.result.chapter++;
                            olc=$(h.ol,{class:'verse'}).appendTo($(h.li,{id:cID,class:'cID'}).append(
                                $(h.div).append(
                                    $(h.h3).append(
                                        $(h.a,{href:z.utility.Page(2)+$.param({book:bID,chapter:cID})}).text(chapterName)
                                    ),
                                    typeof o[fO.Deploy].MenuLookUp === 'function' && o[fO.Deploy].MenuLookUp(container)
                                )
                            ).appendTo(olb));
                        }
                        $(h.li,{id:vID,'data-verse':verseName}).html(obj.replace(verse.text,q.q)).appendTo(olc).on(fO.Click,function(){
                            $(this).toggleClass(config.css.active);
                        }).promise().always(function(){
                            if(verse.ref){
                                o.option(olc).reference(verse.ref).promise().always(function(){
                                    df.resolve();
                                });
                            }else{
                                df.resolve();
                            }
                        });
                    }else{
                        df.resolve();
                    }
                }); return df.promise();
            }).data(function(o,obj){
                o.xml(function(response){
                    if(response.status){
                        if(obj.queryCheck()){
                            var current_booklistId=obj.booklistID();
                            var current_booklist=current_booklistId.join();
                            if(fO.previous.q!==q.q || fO.previous.booklist!==current_booklist){
                                ol=$(h.ol,{class:q.bible}).appendTo(container.empty());
                                obj.bible(obj.booklist).progress(function(){
                                    MsgLookup.text(z.utility.Num(obj.result.verse));
                                }).done(function(){
                                    fO.previous.booklist=current_booklist;
                                    fO.previous.q=q.q;
                                    o.msg(lD.l.FoundBCV.replace(/{b}/, z.utility.Num(obj.result.book)).replace(/{c}/, z.utility.Num(obj.result.chapter)).replace(/{v}/,z.utility.Num(obj.result.verse)));
                                    q.result=obj.result.verse;
                                    MsgLookup.attr('title',q.q).text(z.utility.Num(q.result)).promise().done(function(){
                                        var booklistName=z.array(obj.booklistName(current_booklistId)).to().sentence();
                                        if(!obj.result.verse){
                                            ol.addClass(config.css.deactivate).append(
                                                $(h.li).html(lD.l.IsNotFoundIn.replace(/{is}/, q.q).replace(/{in}/, booklistName))
                                            );
                                        }
                                    });
                                    container.promise().done(function(){
                                        var aP=this.children().length, oldClass=z.get(this).class()[2];
                                        $(this).removeClass(oldClass);
                                        $(this).addClass(oldClass.charAt(0)+aP);
                                    });
                                }).always(function(){
                                    if(z.analytics)z.analytics.sendEvent({bible:q.bible,key:q.q,result:obj.result.verse});
                                });
                            }else{
                                //console.log('PREVIOUS TASK');
                            }
                        }else if($.isEmptyObject(fO.lookup.book)){
                            fO.previous.q=q.q; fO.previous.booklist=false;
                            ol=$(h.ol,{class:q.bible}).appendTo(container.empty());
                            ol.addClass(config.css.deactivate).append(
                                $(h.li).html(lD.l.NoBookSelected),
                                $(h.li,{class:'showme'}).html(lD.l.ShowMe).on(fO.Click,function(){
                                    $('.lookup.setting').trigger(fO.Click);
                                })
                            );
                        }
                    }
                }).get();
            });
        },
        note:function(container,data){
            var olb, olc, olv, ol; lD=fO.lang[q.bible];
            this.get(function(o,obj,bID,cID,vID,verse,list){
                var df = new $.Deferred();
                var bD=fO[q.bible].bible;
                var vID=vID.slice(1);
                var bookName=lD.b[bID], chapterName=z.utility.Num(cID), verseName=z.utility.Num(vID);
                MsgInfo.text(lD.l.BFBCV.replace(/{b}/, bookName).replace(/{c}/, chapterName).replace(/{v}/,verseName)).promise().done(function(){
                    var tmpid=(list.length)?obj.verseMerged(list,vID):[vID];
                    if(tmpid.length){
                        obj.result.verse++;
                        if(obj.result.b!==bID){
                                obj.result.b=bID; obj.result.book++;
                                olb=$(h.ol).appendTo($(h.li,{id:bID,class:'bID'}).append(
                                        $(h.div).append(
                                                $(h.h3).text(bookName)
                                        )
                                ).appendTo(ol));
                        }
                        if(obj.result.b!==bID || obj.result.c!==cID){
                            obj.result.c=cID; obj.result.chapter++;
                            olc=$(h.ol,{class:'verse'}).appendTo($(h.li,{id:cID,class:'cID'}).append(
                                $(h.div).append(
                                    $(h.h4,{class:'no'}).text(chapterName).on(fO.Click,function(){
                                            $(this).parent().parent().children('ol').children().each(function(){
                                                    if($(this).attr("id"))$(this).toggleClass(config.css.active);
                                            });
                                    }),
                                    typeof o[fO.Deploy].MenuNote === 'function' && o[fO.Deploy].MenuNote(container)
                                )
                            ).appendTo(olb));
                        }
                        if(verse.title){
                            $(h.li,{class:'title'}).html(verse.title.join(', ')).appendTo(olc);
                        }
                        $(h.li,{id:vID,'data-verse':verseName}).html(obj.replace(verse.text,q.q)).appendTo(olc).on(fO.Click,function(){
                            $(this).toggleClass(config.css.active);
                        }).promise().always(function(){
                            if(verse.ref){
                                o.option(olc).reference(verse.ref).promise().always(function(){
                                    df.resolve();
                                });
                            }else{
                                df.resolve();
                            }
                        });
                    }
                });
                return df.promise();
            }).data(function(o,obj){
                o.xml(function(response){
                    if(response.status){
                        ol=$(h.ol,{class:q.bible}).appendTo(container);
                        if(data){
                            obj.bible(data).progress(function(){
                                MsgLookup.text(z.utility.Num(obj.result.verse));
                            }).done(function(){
                                container.addClass(config.css.active);
                            }).always(function(){

                            });
                        }
                    }
                }).get();
            });
        },
        reference:function(container){
            var olb, ol; lD=fO.lang[q.bible];
            this.get(function(o,obj,bID,cID,vID,verse,list){
                var df = new $.Deferred();
                var bD=fO[q.bible].bible;
                var vID=vID.slice(1);
                var bookName=lD.b[bID], chapterName=z.utility.Num(cID), verseName=z.utility.Num(vID);
                var tmpid=(list.length)?obj.verseMerged(list,vID):[vID];
                if(tmpid.length){
                    obj.result.verse++;
                    if(obj.result.b!==bID){
                        obj.result.b=bID; obj.result.book++;
                        olb=$(h.ol).appendTo($(h.li,{id:bID,class:'bID'}).append(
                            $(h.div).append(
                                $(h.h3).text(bookName)
                            )
                        ).appendTo(ol));
                    }
                    if(obj.result.b!==bID || obj.result.c!==cID){
                        obj.result.c=cID; obj.result.chapter++;
                        olc=$(h.ol,{class:'verse'}).appendTo($(h.li,{id:cID,class:'cID'}).append(
                            $(h.div).append(
                                $(h.h4,{class:'no'}).text(chapterName)
                            )
                        ).appendTo(olb));
                    }
                    if(verse.title){
                        $(h.li,{class:'title'}).html(verse.title.join(', ')).appendTo(olc);
                    }
                    $(h.li,{id:vID,'data-verse':verseName}).html(obj.replace(verse.text,q.q)).appendTo(olc).promise().always(function(){
                        df.resolve();
                    });
                }else{
                    df.resolve();
                }
                return df.promise();
            }).data(function(o,obj){
                o.xml(function(response){
                    if(response.status){
                        var reference=z.regex(q).is(q.ref);
                        if(reference){
                            ol=$(h.ol,{class:q.bible}).appendTo(container.empty());
                            obj.bible(reference).progress(function(){
                                MsgLookup.text(z.utility.Num(obj.result.verse));
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
        }
    }; return fn;
},
bible:function(){

},
book:function(){

},
reader:function(){
    //TODO
    delete fO.todo.pause;
    this.content(fO.query).chapter(this.containerMain.children());
},
lookup:function(){
    //TODO
    //delete fO.todo.pause;
    this.content(fO.query).lookup(this.containerMain.children());
},
note:function(){

}