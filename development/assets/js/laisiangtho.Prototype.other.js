//container, info, chapter, hasHash,url(string), haspage, num, string, index, array, working, done, body, header
Core.prototype.chapter={
    note:{
        active:function(e){
            new Note({bID:fO.query.book,cID:fO.query.chapter}).search(function(y){
                if(y){
                    e.arg[0].addClass(config.css.active);
                    fO.todo.ChapterNoteActive=true;
                } else {
                    fO.todo.ChapterNoteActive=false;
                }
            });
        }
    },
    name:{
        previous:function(e){
            e.arg[0].attr('title',this.text('next'));
        },
        current:function(e){
            e.arg[0].html(e.num(fO.query.chapter));
            if(fO.todo.ActiveChapter){
                // NOTE: while chapter list displaying and click
                //TODO if(fO.isCordova)-> REMOVE or empty it container
                fO.todo.ActiveChapter.addClass(config.css.active).promise().done(function(){
                    delete fO.todo.ActiveChapter;
                });
            }
        },
        next:function(e){
            e.arg[0].attr('title',this.text('previous'));
        },
        has:{
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
        text:function(x) {
            var q=this.has[x](), lD=fO.lang[fO.query.bible];
            return lD.l.BFVBC.replace(/{b}/,lD.b[q.book]).replace(/{c}/,f().num(q.chapter));
        }
    },
    next:function(e){
        e.hash(2).hashChange(this.name.has.next());
    },
    previous:function(e){
        e.hash(2).hashChange(this.name.has.previous());
    },
    book:function(bID){
        //TODO
        // return $(h.span).html(fN.Num(bible.info[bID].c)).on(fO.Click,function(){
        //     var container=$(this).parent().parent();
        //     if(container.children('ol').length){
        //         container.children().eq(1).fadeOut(300).remove();
        //         $(this).removeClass(config.css.active);
        //     }else{
        //         fN.Menu(bID).Chapter().appendTo(container).promise().done($(this).addClass(config.css.active));
        //     }
        // });
    },
    list:function(e){
        var ul=e.arg[0].next();
        if(ul.is(':hidden')){
            new e.menu(fO.query.book).chapter($(h.ol,{class:'list-chapter'})).appendTo(ul.fadeToggle(100).children().empty()).promise().always(function(){
                this.children().on(fO.Click,function(){
                    fO.todo.ActiveChapter=$(this);
                });
                f(ul).doClick(function(y){
                    if(e.container.closest(ul,y,e.arg[0])){
                        e.container.fade(ul,e.arg[0]);
                        return true;
                    }
                });
            });
        }else{
            e.container.fade(ul,e.arg[0]);
        }
    }
};
Core.prototype.lookup={
    setting:function(e){
        var ul=e.arg[0].next();
        if(ul.is(':hidden')){
            new e.menu(fO.query.book).lookup(ul.fadeToggle(100).children().empty()).promise().always(function(){
                f(ul).doClick(function(y){
                    if(e.container.closest(ul,y,e.arg[0])){
                        e.container.fade(ul,e.arg[0]);
                        return true;
                    }
                });
            });
        }else{
            e.container.fade(ul,e.arg[0]);
        }

    },
    query:function(e){
        e.arg[0].val(fO.query.q);
    },
    msg:function(e){
        fO.msg.lookup=e.arg[0];
        if (fO.query.result > 0) {
            e.arg[0].text(e.num(fO.query.result)).attr('title',fO.query.q);
        } else {
            e.arg[0].empty();
        }
    }
};
Core.prototype.menu=function(o){
    this.bible=function(ol){
        // var ol = $(h.ol,{id:'dragable',class:'row row-bible'});
        config.bible.available.forEach(function(id){
            var Om={bID:id,lang:fO.lang[id].info,local:fO.lang[id].local,classOffline:'icon-ok offline',classOnline:'icon-logout offline'};
            Om.classAvailable=Om.local?config.css.available:config.css.notAvailable;
            Om.isAvailable=(Om.local?Om.classOffline:Om.classOnline);
            Om.classActive=(fO.query.bible==id?config.css.active:'')+' '+Om.classAvailable;
            o(Om).appendTo(ol);
        });
        return ol;
    };
    this.chapter=function(ol){
        // var ol=$(h.ol,{class:'list-chapter'});
        $.each(bible.info[o].v,function(chapter,verse){
            chapter++;
            $(h.li,{id:chapter,class:(fO.query.chapter==chapter?config.css.active:'')}).append(
                $(h.a,{href:f().hash(2)+$.param({chapter:chapter})}).html(f().num(chapter)).append(
                    $(h.sup).html(f().num(verse))
                )
            ).appendTo(ol);
        });
        return ol;
    };
    this.lookup=function(container){
        var O2={
            Query:function(o){
                o.each(function(){
                    var ol=$(this);
                    ol.children().each(function(a,y){
                        var y=$(y), id=f(y).get('id').element[0];//id=fN.Attr(y).id()[0];
                        y.toggleClass(config.css.active); O2.ID(id);
                    }).promise().always(function(){
                        O2.Class(ol);
                    });
                });
            },
            Click:function(e,o){
                var x=$(e.target);
                if(x.get(0).tagName.toLowerCase()==='p'){
                    this.Query(o);
                }else{
                    var li=x.parent().parent().toggleClass(config.css.active), sID=li.attr('id'); //li.toggleClass(config.css.active);
                    x.toggleClass(config.css.active).promise().done(function(){
                        if(this.hasClass(config.css.active)){
                            fO.lookup.setting[sID]=true;
                        }else{
                            delete fO.lookup.setting[sID];
                        }
                    });
                }
                db.update.lookup();
            },
            Class:function(o){
                var total=o.children().length, active=o.children(f(config.css.active).is('class').name).length, catalog=o.parent().children().eq(0);
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
        container=$(h.ol,{class:'list-lookup'}).appendTo(container), lD=fO.lang[fO.query.bible];
        $.each(bible.catalog,function(tID,cL){
            var tTD=Object.keys(config.language)[0]+tID, tClass=(fO.lookup.setting[tTD]?config.css.active:'testament');
            $(h.li,{id:tTD,class:tClass}).html(
                $(h.p,{text:lD.t[tID]}).on(fO.Click,function(e){
                    O2.Click(e,$(this).parent().children('ol').find('ol'));
                }).append(
                    $(h.span).text('+').addClass(tClass)
                )
            ).appendTo(container).promise().always(function(){
                $(h.ol,{class:'section'}).appendTo(this).promise().always(function(){
                    var it=this;
                    $.each(cL,function(sID,bL){
                        var sTD=Object.keys(config.language)[1]+sID, sClass=(fO.lookup.setting[sTD]?config.css.active:'');
                        $(h.li,{id:sTD,class:sClass}).append(
                            $(h.p,{text:lD.s[sID]}).on(fO.Click,function(e){
                                O2.Click(e,$(this).parent().children('ol'));
                            }).append(
                                $(h.span,{text:'+'}).addClass(sClass)
                            )
                        ).appendTo(it).promise().always(function(){
                            var ol=$(h.ol,{class:'book'}).appendTo(this);
                            bL.forEach(function(bID){
                                $(h.li,{id:bID,class:(fO.lookup.book[bID]?config.css.active:'')}).text(lD.b[bID]).on(fO.Click,function(){
                                    $(this).toggleClass(config.css.active); O2.ID(bID); db.update.lookup();
                                }).appendTo(ol);
                            });
                            ol.promise().always(function(){
                                O2.Class(ol);
                            });
                        });
                    });
                });
            });
        });
        return container;
    };
    this.tmp=function(container){
        console.log('OK...');
    };
};
Core.prototype.container={
    msg:{
        info:function(e){
            fO.msg.info=e.arg[0];
            // NOTE: return true if you want to stop
            return true;
        }
    },
    closest:function(container,x,y){
        if(container.is(':visible') && !$(x.target).closest('#dialog, .misc').length && !$(x.target).closest(container).length && !$(x.target).closest(y).length) return true;
    },
    fade:function(container,x,y){
        container.fadeOut(100).promise().always(function(){
            x.removeClass(config.css.active); if(y)y.removeAttr("style");
        });
    }
};
Core.prototype.info={
    about:{
        version:function(){
            $(h.div,{id:'dialog',class:'version'}).append(
                $(h.div,{id:'window'}).append(
                    $(h.h1,{title:config.build}).text(config.name),
                    $(h.h2).text(config.version),
                    $(h.p).html(config.aboutcontent),
                    $(h.p,{id:'by'}).append($(h.a,{target:'_blank',href:config.developerlink}).text(config.developer)),
                    $(h.div,{id:'clickme'}).html('Ok').on(fO.Click,function(e){
                        e.stopImmediatePropagation();
                        $(this).parents('div').remove();
                    })
                )
            ).appendTo('body').on(fO.Click,function(evt){
                if(!$(evt.target).closest('#window').length){
                    $('#clickme').effect( "highlight", {color:"#F30C10"}, 100 );
                }
            });
        }
    }
};
Core.prototype.doClick=function(callback){
    var container = this.arg[0];
    $(document.body).on(fO.Click,function(e){
        if(container){
            if(container.is(':visible')){
                // e.preventDefault(); e.stopPropagation(); //e.stopImmediatePropagation();
                if($.isFunction(callback) && callback(e)){
                    // NOTE: container is now close
                } else {
                    // NOTE: container is busy
                }
            }
        } else {
            callback(e);
        }
    });
};
Core.prototype.url = function(l, x, fileExtension) {
    // TODO: object key need to merge and fix where its using...
    var fileUrl = this.string([l, 47, x.join('/'), 46, fileExtension]),
        fileName = fileUrl.substring(fileUrl.lastIndexOf('/') + 1),
        fileContentType = this.string(['application', 47, fileExtension]);
    return {
        fileName: fileName,
        // fileOption: {create: false},
        fileExtension: fileExtension,
        fileUrl: fileUrl,
        fileCharset: fileContentType + ';charset=utf-8',
        fileContentType: fileContentType
    };
};
Core.prototype.hash=function(n){
    return this.string([35,config.page[n],63]);
};
Core.prototype.dot=function(n){
    // return this.string([35,config.page[n],63]);
};
Core.prototype.num = function(n, l) {
    if(!l) l = fO.query.bible;
    if(fO.lang.hasOwnProperty(l)){
        if(fO.lang[l].hasOwnProperty('n')){
            return (Object.getOwnPropertyNames(fO.lang[l].n).length === 0) ? n : n.toString().replace(/[0-9]/g, function(s) {
                return fO.lang[l].n[s];
            });
        } else {
            return n;
        }
    } else {
        return n;
    }
};
Core.prototype.hashURI= function(callback) {
    //hash
    var q = location.hash,
        r = {
            page: q.split("?")[0].replace('#', '')
        },
        m, search = /([^\?#&=]+)=([^&]*)/g,
        d = function(s) {
            return decodeURIComponent(s.replace(/\+/g, " "));
        };
    while (m = search.exec(q)) r[d(m[1])] = d(m[2]);
    callback(r);
};
Core.prototype.string = function(x) {
    return $.map(x, function(v) {
        return $.isNumeric(v) ? String.fromCharCode(v) : v;
    }).join('').toString();
};
Core.prototype.index = function() {
    config.bible.available = [];
    $.map(fO.lang, function(e, i) {
        return {
            id: i,
            index: e.index
        };
    }).sort(function(a, b) {
        return a.index - b.index;
    }).forEach(function(e) {
        config.bible.available.push(e.id);
    });
};
Core.prototype.array = function(d, o) {
    //f.array(lC[n][i]).merge(jB).data
    return {
        merge: function(y) {
            if ($.type(y) === 'array') o = y;
            this.data = d = d.concat(o).sort(function(a, b) {
                return a - b;
            });
            return this;
        },
        unique: function() {
            return d.filter(function(item, index) {
                return d.indexOf(item) === index;
            });
        },
        removeIfduplicate: function(y) {
            return $.map(d, function(v, i) {
                d[i] === d[i + 1] && (d[i] = d[i + 1] = null);
                return d[i];
            });
        },
        to: function(y) {
            return {
                sentence: function(x) {
                    return (d.length > 1) ? [d.slice(0, -1).join(y || ', '), d.slice(-1)[0]].join(x || ' & ') : d[0];
                }
            };
        }
    };
};
Core.prototype.working = function(q) {
    // this.args[0].msg, this.args[0].wait
    // f({wait:'',disable:'',msg:''}).working();
    if (fO.msg.info.is(":hidden")) {
        $('body').addClass(config.css.working).promise().done(fO.msg.info.slideDown(200));
    }
    if (q.wait === true) {
        $('body').addClass(config.css.wait);
    }
    if (q.wait === false) {
        $('body').removeClass(config.css.wait);
    }
    if (q.disable === true) {
        $('body').addClass(config.css.disable);
    }
    return (q.msg) ? fO.msg.info.html(q.msg) : fO.msg.info;
};
Core.prototype.done = function(callback) {
    fO.msg.info.slideUp(200).empty().promise().done(function() {
        $('body').removeClass(config.css.working).removeClass(config.css.wait).removeClass(config.css.disable).promise().done(function() {
            if(callback)callback();
        });
    });
};
Core.prototype.activeClass = function(container) {
    return container.find(f(config.css.active).is('class').name).removeClass(config.css.active).promise().done($(config.css.currentPage).addClass(config.css.active));
};
Core.prototype.loop= function(callback) {
    var tmp={
        object: function(o) {
            for (var i in o) {
                callback(i, o[i], o);
            }
        },
        array: function(o) {
            for (var i = 0, len = o.length; i < len; i++) {
                callback(o, i, o[i]);
            }
        }
    };
    var tmpIs=typeof this.arg[0];
    return tmp[tmpIs](this.arg[0]);
};
// NOTE: previously used
Core.prototype.HTML = function() {
    return {
        ol: f('ol').is('tag').name,
        ul: f('ul').is('tag').name,
        li: f('li').is('tag').name,
        a: f('a').is('tag').name,
        div: f('div').is('tag').name,
        p: f('p').is('tag').name,
        h1: f('h1').is('tag').name,
        h2: f('h2').is('tag').name,
        h3: f('h3').is('tag').name,
        h4: f('h4').is('tag').name,
        h5: f('h5').is('tag').name,
        span: f('span').is('tag').name,
        em: f('em').is('tag').name,
        sup: f('sup').is('tag').name
    };
};
/*
Core.prototype.template = function(dl, position) {
    // NOTE: not using at the moment!
    //this.iQ=arguments[0]; this.obj=arguments[1];
    //f().template();
    //fN.fN({header:config.header[fO.query.page]}).Content();
    var j = $(),
        o = this.obj;
    var fn = this;
    $.each(this.arg[0], function(key, v) {
        (function mmm(k, item, container, x) {
            //f(k).is('tag').name
            //o.is(k).tag
            var attr = item.attr,
                child = item.text,
                y = false,
                tag = $(f(k).is('tag').name, attr);
            if (attr && attr.fn) {
                y = item.attr.fn.split(' ');
                delete attr.fn;
            }
            if ($.type(child) === 'string') {
                tag.html(child);
            } else if (item.value) {
                tag.val(item.value);
            } else if (!child) {} else {
                for (i in child) {
                    if ($.isNumeric(i)) {
                        var k = Object.keys(child[i]);
                        mmm(k, child[i][k], tag);
                    } else {
                        mmm(i, child[i], tag);
                    }
                }
            }
            // if(y && Object.prototype.hasOwnProperty.call(o, "Watch"))o.Watch(y).go(tag);
            if (x) {
                j = container.add(tag);
            } else {
                container.append(tag);
            }
        })(key, v, j, true);
    });
    if (dl) {
        ($.type(dl) !== 'object' ? $(dl) : dl)[position || 'append'](j);
    }
    return j;
};
*/
