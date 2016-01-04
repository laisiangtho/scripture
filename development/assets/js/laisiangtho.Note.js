function Note(q){
    this.page=function(container){
        var lB=fO.lang[q.bible], ol;
        (function notelist() {
            ol=$(h.ol,{class:'nobg'}).appendTo(container.attr({class:'wrp wrp-content wrp-note d1'}).empty());
            if(fO.note){
                var total=Object.keys(fO.note).length;
                $.each(fO.note,function(id,note){
                    if(note.name){
                        var isEditable=$.isNumeric(id)?true:false;
                        var isEditableIcon=isEditable?'icon-list':'icon-'+id;
                        var totalData=(note.data)?Object.keys(note.data).length:0;
                        $(h.li,{id:id, class:isEditable?'yes':'no','data-title':totalData}).append(
                            $(h.ul).append(
                                $(h.li,{class:isEditableIcon}),
                                $(h.li,{text:note.name,class:(totalData>0)?'yes':'no','data-count':totalData}).on(fO.Click,function(e) {
                                    var editor=$(this), editorMain=editor.parent(), container=editorMain.parent().children().eq(1);
                                    if(!editor.attr('contenteditable')){
                                        if(container.length){
                                            container.remove();editorMain.removeClass(config.css.active);
                                        }else{
                                            editorMain.addClass(config.css.active);
                                            container=editorMain.parent();
                                            if(note.data){
                                                new Content($.extend({},q,{ref:note.data})).note(container);
                                            }else{
                                                $(h.ol,{class:'norecord'}).append($(h.li).html('No record found!')).appendTo(container);
                                            }
                                        }
                                    }
                                })
                            )
                        ).appendTo(ol).promise().done(function(e){
                            e.children().append(
                                $(h.li).append(
                                    $(h.span,{class:'icon-dot3',title:'Option'}).on(fO.Click,function(y) {
                                        // editorContainer:li, editorMain:ul, optionContainer:li, optionMain:ul
                                        var editorContainer=$(this).parent();
                                        if(editorContainer.children().eq(1).length){
                                            editorContainer.children().eq(1).remove();
                                        } else {
                                            $(h.ul,{class:'mO other'}).append(
                                                $(h.li,{class:'delete icon-trash',title:'Empty'}).on(fO.Click,function(){
                                                    delete fO.note[id].data;
                                                    db.update.note().then(notelist);
                                                }),
                                                $(h.li,{class:'delete icon-edit',title:'Rename'}).on(fO.Click,function(){
                                                    var x=$(this), editorMain=x.parent().parent().parent(), editor=editorMain.children().eq(1), label=editor.text();
                                                    if(editor.attr('contenteditable')){
                                                        labelEditor().html(label);
                                                    } else {
                                                        labelEditor(label).focus().on('keydown',function(e){
                                                            if(e.keyCode === 27){
                                                                labelEditor().html(label);
                                                            }else if(e.keyCode === 13){
                                                                fO.note[id].name=labelEditor().text();
                                                                db.update.note();
                                                            }
                                                        });
                                                    }
                                                    function labelEditor(txt){
                                                        if(txt){
                                                            editorMain.addClass('editing');
                                                            return editor.attr({'data-title':txt,contenteditable:true});
                                                        } else {
                                                            editorMain.removeClass('editing');
                                                            return editor.removeAttr('contenteditable','autocomplete');
                                                        }
                                                    }
                                                })
                                            ).appendTo(editorContainer).promise().done(function(ul){
                                                if(isEditable){
                                                    $(h.li,{class:'delete icon-wrong',title:'Delete'}).on(fO.Click,function(){
                                                        delete fO.note[id];
                                                        db.update.note().then(e.remove());
                                                    }).appendTo(ul);
                                                }
                                            });
                                            f().doClick(function(evt){
                                                if(!$(evt.target).closest(editorContainer).length)editorContainer.children().eq(1).remove();
                                            });
                                        }
                                    })
                                )
                            );
                        });
                    }
                });
            }else{
                $(h.li).html('No records were found!').appendTo(ol);
            }
            // // NOTE: Insert Box
            $(h.li).append(
                $(h.ul).append(
                    $(h.li,{class:'icon-tag'}),
                    $(h.li,{contenteditable:true,'data-title':'Add'}).on('keydown',function(e){
                        if(e.keyCode === 13){
                            // e.preventDefault();
                            var label=$(this).text(), uniqueid=Math.random().toString().substr(2, 9);
                            if(label && !fO.note[uniqueid]){
                                fO.note[uniqueid]={name:label};
                                db.update.note().then(notelist);
                            }
                        } else if(e.keyCode === 27){
                            $(this).empty();
                        }
                    })
                )
            ).appendTo(ol);
        })();
    };
    this.search=function(callback){
        if(fO.note){
            $.each(fO.note,function(id,note){
                if(note.data){
                    if(note.data[q.bID]){
                        if(note.data[q.bID][q.cID]){
                            callback(true);
                        } else {
                            callback(false);
                        }
                        return;
                    }
                }
            });
        } else {
            callback(false);
        }
    }
};
/*
$(h.li,{class:isEditableIcon}).on(fO.Click,function(y){
    var x=$(this), editorMain=x.parent(), editor=editorMain.children().eq(1), label=editor.text();
    if(isEditable){
        if(editor.attr('contenteditable')){
            editor.removeAttr('contenteditable','autocomplete').html(label).bind(fO.Click);
            delete fO.todo.pause;
            editorMain.removeClass('editing');
        } else {
            editor.attr({'data-title':label,contenteditable:true}).focus().select().on('keydown',function(e){
                if(e.keyCode === 27){
                    $(this).removeAttr('contenteditable','autocomplete').html(label);
                    editorMain.removeClass('editing');
                    delete fO.todo.pause;
                }else if(e.keyCode === 13){
                    fO.note[id].name=$(this).removeAttr('contenteditable').text();
                    editorMain.removeClass('editing');
                    db.update.note();
                }
            });
            editorMain.addClass('editing');
        }
    } else {
        console.log('not editable');
    }
}),
*/
