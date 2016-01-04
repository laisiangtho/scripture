return $(h.ul).append(
    $(h.li).addClass(fO.query.bible).append(
        new Option(container).Parallel(function(li,i,ic,bID){
            var newChapter=container.children(ic), aP=container.children().length;
            if(newChapter.length){
                if(aP > 1){
                    var oldClass=f(container).get('class').element[3];
                    container.removeClass(oldClass).addClass(oldClass.charAt(0)+(aP-1));
                    newChapter.remove();
                    li.removeClass('has');
                    if(fO.previous.bible===i)fO.previous.bible=container.children().eq(0).attr('class');
                }
            }else{
                fO.todo.containerEmpty=true; li.addClass('has');
                new Content($.extend({},q,{bible:bID})).chapter(container);
            }
        })
    ),
    $(h.li).append(new Option(container).Note())
);
