        bible:function(callback){
            config.bible.available.forEach(function(bID){
                var lang=lai.store.lang[bID].info, isLocal=lai.store.lang[bID].local, availableClass=(isLocal)?config.css.available:config.css.notAvailable,
                offlineClass='icon-ok offline',onlineClass='icon-logout offline', isAvailable=(isLocal)?offlineClass:onlineClass,
                activeClass=(lai.store.query.bible===bID)?config.css.active+' '+availableClass:availableClass;
                callback(bID,lang,isLocal,availableClass,offlineClass,onlineClass,isAvailable,activeClass);
            });
        },
--
            Parallel:function(e){
                //DONE - DESIGN REQUIRED
                this.Common(e,function(){
                    var p=z.utility.Page(2);
                    return {
                        msg:z.menu.bible({class:'rows row-parallel'},function(bID,lang,isLocal,availableClass,offlineClass,onlineClass,isAvailable){
                            return $(h.p).append(
                                $(h.span,{class:isAvailable}), $(h.a,{href:p+$.param({bible:bID})}).html(lang.name)
                            );
                        })
                    };
                });
            },
-
                                ul=$(h.ul,{class:'parallel'}).appendTo(li);
                                z.menu.bible(function(bID,lang,isLocal,availableClass,offlineClass,onlineClass,isAvailable){
                                    var ic=z.is(bID).class;
                                    $(h.li,{class:(y===bID)?config.css.active:(container.children(ic).length)?'has':bID}).html(lang.name).on(sO.Click,function(){
                                        callback($(this),lang.name,ic);
                                    }).appendTo(ul);
                                });
-
this.containerMain.html(this.menu.bible(function(bID,lang,isLocal,availableClass,offlineClass,onlineClass,isAvailable,activeClass){
            $(h.li,{id:bID,class:activeClass}).html(