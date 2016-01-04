return $(h.span,{class:(fO.todo.ChapterNoteActive)?'icon-pin '+config.css.active:'icon-pin'}).on(fO.Click,function(event){
    var x=$(event.target), li=x.parent(), ul=li.children().eq(1);
    if(ul.length){
        ul.fadeOut(200).remove();
    }else{
        var row=x.parents(f('cID').is('class').name),
        bID=f(row.parents(f('bID').is('class').name)).get('id').element[0],
        cID=f(row).get('id').element[0];
        ul=$(h.ul,{class:'mO note'}).appendTo(li);
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
                                    db.update.note().then(function(){
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
                        ).appendTo(ul).promise().done(function(e){
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
         f().doClick(function(evt){
            if(!$(evt.target).closest(li).length)ul.remove();
        });
    }
});
