Core.prototype.pagebible = function(fn) {
    var p=this.hash(1);
    // fO.container.main.html(new this.menu(function(Om){}).bible($(h.ol,{id:'dragable',class:'row row-bible'}))).promise().done(function(e){});
    // fO.container.main.html($(h.div,{class:'wrp wrp-bible'}));
    fO.container.main.html($(h.div,{class:'wrp wrp-bible'})).children().html(new this.menu(function(Om){
        return $(h.li,{id:Om.bID,class:Om.classActive}).html(
            $(h.p).append(
                $(h.span,{class:Om.isAvailable}).on(fO.Click,function(evt){
                    evt.preventDefault(); //evt.stopPropagation();  evt.stopImmediatePropagation();
                    var x=$(this), li=x.parents('li');
                    if(fO.msg.info.is(":hidden"))fO.todo.bibleOption=false;
                    if(fO.todo.bibleOption===Om.bID){
                        fn.done(function(){
                            delete fO.todo.bibleOption;
                        });
                    } else if(li.hasClass(config.css.notAvailable)){
                        fn.working({
                            msg:$(h.ul,{class:'data-dialog'}).append(
                                $(h.li).append(
                                    $(h.p).html(fO.lang[Om.bID].l.WouldYouLikeToAdd.replace(/{is}/, x.parent().children('a').text()))
                                ),
                                $(h.li).append(
                                    $(h.span,{class:'yes icon-thumbs-up-alt'}).on(fO.Click,function(evt){
                                        evt.preventDefault();
                                        new f({bible:Om.bID}).xml(function(response){
                                            if(response.status){
                                                li.removeClass(config.css.notAvailable).addClass(config.css.available);
                                                x.removeClass(Om.classOnline).addClass(Om.classOffline);
                                            }
                                            // console.log(response.status);
                                        }).get();
                                    }),
                                    $(h.span,{class:'no icon-thumbs-down-alt'}).on(fO.Click,function(evt){
                                        evt.preventDefault();
                                        fn.done(function(){
                                            delete fO.todo.bibleOption;
                                        });
                                    })
                                )
                            ),
                            wait:true
                        });
                    } else {
                        fO.todo.bibleOption=Om.bID;
                        fn.working({
                            msg:$(h.ul,{class:'data-dialog'}).append(
                                $(h.li).append(
                                    $(h.p).html(fO.lang[Om.bID].l.WouldYouLikeToRemove.replace(/{is}/, x.parent().children('a').text()))
                                ),
                                $(h.li).append(
                                    $(h.span,{class:'yes icon-thumbs-up-alt'}).on(fO.Click,function(evt){
                                        evt.preventDefault();
                                        li.removeClass(config.css.available).addClass(config.css.notAvailable);
                                        x.removeClass(Om.classOffline).addClass(Om.classOnline);
                                        fn.working({msg:fO.lang[Om.bID].l.PleaseWait,wait:true}).promise().done(function(){
                                            li.removeClass(config.css.available).addClass(config.css.notAvailable);
                                            x.removeClass(Om.classOffline).addClass(Om.classOnline);
                                            new f({bible:Om.bID}).xml(function(response){
                                                fn.done(function(){
                                                    delete fO.todo.bibleOption;
                                                });
                                            }).remove();
                                        });
                                    }),
                                    $(h.span,{class:'no icon-thumbs-down-alt'}).on(fO.Click,function(evt){
                                        evt.preventDefault();
                                        fn.done(function(){
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
    }).bible()).promise().done(function(e){
        this.children().sortable({
            handle: ".drag",containment: "parent",helper: ".dsdfd",placeholder:"ghost",forcePlaceholderSize: true,opacity: 0.7,
            update: function(event,ui){
                $(this).children().each(function(i,e){
                    fO.lang[$(e).get(0).id].index=$(e).index();
                }).promise().done(function(){
                    db.update.lang().then(fn.index);
                });
            }
        });
    });
};
